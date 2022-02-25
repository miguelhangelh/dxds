// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:appdriver/core/database/amplify.dart';
import 'package:appdriver/core/error/api_helper.dart';
import 'package:appdriver/core/notifications_locale/local_notification.dart';
import 'package:appdriver/features/authentication_aws/subcriptions/subscription_notification_update.dart';
import 'package:appdriver/features/location/data/datasource/local/location.dart';
import 'package:appdriver/features/models/echange_rate_model.dart';
import 'package:appdriver/features/models/travel_model.dart';
import 'package:appdriver/features/offline/data/models/checkpoints_local.dart';
import 'package:appdriver/features/offline/data/models/tasks_local.dart';
import 'package:appdriver/features/operation/data/models/operation_model.dart' as op;
import 'package:appdriver/features/tasks/data/datasources/local/tasks_local.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:appdriver/core/share_prefs/user_pref.dart';
import 'package:appdriver/features/authentication_aws/presentation/bloc/authentication_bloc.dart';
import 'package:appdriver/features/authentication_aws/subcriptions/subcription_bloc_authentication.dart';
import 'package:appdriver/features/models/transport_unit_model.dart';
import 'package:appdriver/features/models/user_model.dart';
import 'package:random_string/random_string.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:appdriver/features/operation/data/supcriptions/task_subscriptions_operation.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;

bool isRegister = false;
bool isRegisterTask = false;
LocalNotification loca = LocalNotification();
final Dio dio = Dio();
final amplify = AmplifyConfigure();
ApiBaseHelper _helper = ApiBaseHelper();

Future<void> loadEnv() async {
  if (!dotenv.isInitialized) {
    await dotenv.load(fileName: "assets/.env_production");
  }
}

Future<bool> checkWhatsApp(String number) {
  return canLaunch('https://wa.me/591' + number).then((bool resp) {
    // print( resp );
    launch('https://wa.me/591:' + number);
    return resp;
  }).catchError((error) {
    print(error);
    return false;
  });
}

Future<bool> checkNumberPhone(int number) {
  return canLaunch('tel:' + number.toString()).then((bool resp) {
    // print( resp );
    launch('tel:' + number.toString());
    return resp;
  }).catchError((error) {
    print(error);
    return false;
  });
}

addLocalGeofenceGpsHeadLess(GeofenceEvent? event) async {
  UserPreference userPreference = UserPreference();
  await userPreference.initPrefs();
  var operation = userPreference.operation;
  if (operation != null) {
    await registerHive();
    final db = LocationDatabaseLocal();
    await db.initHiveDB();
    DateTime time = DateTime.now();
    CheckPointsLocal points = CheckPointsLocal(
      loadingOrderId: operation.loadingOrder!.loadingOrderId,
      transportUnitId: operation.loadingOrder!.assignment!.transportUnitId,
      checkPointId: event!.identifier,
      dateTime: time.toUtc().toString(),
      lat: event.location.coords.latitude,
      lng: event.location.coords.longitude,
      exit: event.action == 'EXIT' ? true : false,
    );
    db.addPosition(points);
  }
}

addLocalGpsHeadLess() async {
  UserPreference userPreference = UserPreference();
  await userPreference.initPrefs();

  var operation = userPreference.operation;
  if (operation != null) {
    try {
      await registerHive();

      final db = LocationDatabaseLocal();
      await db.initHiveDB();
      var status = await BackgroundGeolocation.requestPermission();
      if (status == ProviderChangeEvent.AUTHORIZATION_STATUS_ALWAYS || status == ProviderChangeEvent.AUTHORIZATION_STATUS_WHEN_IN_USE) {
        var location = await BackgroundGeolocation.getCurrentPosition(persist: false);

        print('[LOCATION $location]');
        DateTime time = DateTime.now();
        CheckPointsLocal points = CheckPointsLocal(
          checkPointId: '',
          dateTime: time.toUtc().toString(),
          loadingOrderId: operation.loadingOrder!.loadingOrderId,
          lat: location.coords.latitude,
          lng: location.coords.longitude,
          transportUnitId: operation.loadingOrder!.assignment!.transportUnitId,
          exit: false,
        );
        db.addPosition(points);
      }
    } catch (_) {}
  }
}

op.Stage? currentStage() {
  List<op.Stage> stages = userPreference.operation!.stages!;
  op.Stage? current;
  for (final stage in stages) {
    bool check = false;
    for (var i = 0; i < stage.tasks!.length; i++) {
      if (stage.tasks![i].action.isNotEmpty) {
        var lastAction = stage.tasks![i].action.last;
        if (lastAction.validation?.approve == false) {
          check = true;
          i = stage.tasks!.length;
          current = stage;
        }
      } else if (stage.tasks![i].action.isEmpty) {
        check = true;
        i = stage.tasks!.length;
        current = stage;
      }
    }
    if (check) {
      break;
    }
  }
  return current;
}

op.Task? getTask(op.Stage? stages) {
  if (stages != null) {
    var name = stages.tasks!.firstWhereOrNull((element) {
      if (element.action.isNotEmpty) {
        var last = element.action.last;
        if (last.validation?.approve == false) {
          return true;
        }
        return false;
      } else {
        return true;
      }
    });
    return name;
  }
  return null;
}

setUpdateStageTask(idStage, idTask) {
  op.Operation operation = userPreference.operation!;
  var taskModified = operation.stages!.indexWhere((element) => element.id == idStage);
  var task = operation.stages![taskModified].tasks!.indexWhere((element) => element.id == idTask);
  operation.stages![taskModified].tasks![task].action.add(op.Action(dateAction: DateTime.now()));
  userPreference.setOperation = json.encode(operation);
}

updateNotification() async {
  await registerHive();
  final db = TasksLocalDB();
  await db.initHiveDB();
  Iterable<TaskLocal> taks = db.getTasks()!.values.toList();
  op.Task? taskCurrent;
  op.Stage? current;
  List<op.Stage> stages = userPreference.operation!.stages!;
  var user = userPreference.getUser;
  if (stages.isNotEmpty) {
    current = currentStage();
    taskCurrent = getTask(current);
    print("NEXT STAGE ${current?.name}");
    print("NEXT TASK ${taskCurrent?.name}");
    if (taskCurrent != null && current != null) {
      if (!taskCurrent.allowFiles!) {
        await bg.BackgroundGeolocation.reset(bg.Config(
          locationUpdateInterval: 60000,
          persistMode: bg.Config.PERSIST_MODE_GEOFENCE,
          desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
          distanceFilter: 10000.0,
          enableHeadless: true,
          stopOnTerminate: false,
          startOnBoot: true,
          notification: bg.Notification(
            smallIcon: "drawable/ic_launcher_notification",
            priority: bg.Config.NOTIFICATION_PRIORITY_HIGH,
            sticky: true,
            title:
                user.profile?.firstName?.trim() != null ? '${user.profile?.firstName?.trim()} tienes una operación en curso' : "Operación en curso",
            strings: {'notificationButtonFoo': taskCurrent.name.toString()},
            layout: "my_notification_layout",
            actions: ["notificationButtonFoo"],
            text: 'Recuerda completar todas tus tareas.',
          ),
          showsBackgroundLocationIndicator: true,
          backgroundPermissionRationale: bg.PermissionRationale(
            title: "Permitir que DeltaX acceda a la ubicación de este dispositivo incluso cuando esté cerca o no esté en uso?",
            message: "DeltaX recopila datos de tu ubicación, para realizar seguimiento a las cargas que transportas",
            positiveAction: "Cambiar a 'Permitir todo el tiempo'",
            negativeAction: "Cancelar",
          ),
          locationAuthorizationRequest: 'Always',
          debug: false,
        ));
      } else {
        await bg.BackgroundGeolocation.reset(bg.Config(
          locationUpdateInterval: 60000,
          persistMode: bg.Config.PERSIST_MODE_GEOFENCE,
          desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
          distanceFilter: 10000.0,
          enableHeadless: true,
          stopOnTerminate: false,
          startOnBoot: true,
          showsBackgroundLocationIndicator: true,
          backgroundPermissionRationale: bg.PermissionRationale(
            title: "Permitir que DeltaX acceda a la ubicación de este dispositivo incluso cuando esté cerca o no esté en uso?",
            message: "DeltaX recopila datos de tu ubicación, para realizar seguimiento a las cargas que transportas",
            positiveAction: "Cambiar a 'Permitir todo el tiempo'",
            negativeAction: "Cancelar",
          ),
          locationAuthorizationRequest: 'Always',
          debug: false,
          notification: bg.Notification(
            smallIcon: "drawable/ic_launcher_notification",
            priority: bg.Config.NOTIFICATION_PRIORITY_HIGH,
            sticky: true,
            title:
                user.profile?.firstName?.trim() != null ? '${user.profile?.firstName?.trim()} tienes una operación en curso' : "Operación en curso",
            strings: {},
            layout: "",
            actions: [],
            text: 'Recuerda completar todas tus tareas.',
          ),
        ));
      }
      print('addTaskHeadless.length ${taks.length}');
    } else {
      await bg.BackgroundGeolocation.reset(bg.Config(
        locationUpdateInterval: 60000,
        persistMode: bg.Config.PERSIST_MODE_GEOFENCE,
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
        distanceFilter: 10000.0,
        enableHeadless: true,
        stopOnTerminate: false,
        startOnBoot: true,
        showsBackgroundLocationIndicator: true,
        backgroundPermissionRationale: bg.PermissionRationale(
          title: "Permitir que DeltaX acceda a la ubicación de este dispositivo incluso cuando esté cerca o no esté en uso?",
          message: "DeltaX recopila datos de tu ubicación, para realizar seguimiento a las cargas que transportas",
          positiveAction: "Cambiar a 'Permitir todo el tiempo'",
          negativeAction: "Cancelar",
        ),
        locationAuthorizationRequest: 'Always',
        debug: false,
        notification: bg.Notification(
          smallIcon: "drawable/ic_launcher_notification",
          priority: bg.Config.NOTIFICATION_PRIORITY_HIGH,
          sticky: true,
          title: user.profile?.firstName?.trim() != null ? '${user.profile?.firstName?.trim()} tienes una operación en curso' : "Operación en curso",
          strings: {},
          layout: "",
          actions: [],
          text: 'Recuerda completar todas tus tareas.',
        ),
      ));
    }
  }
}

addTaskNewHeadless() async {
  await registerHive();
  final db = TasksLocalDB();
  await db.initHiveDB();
  op.Task? taskCurrent;
  op.Stage? current;
  List<op.Stage> stages = userPreference.operation!.stages!;
  if (stages.isNotEmpty) {
    current = currentStage();
    taskCurrent = getTask(current);
    print("CURRENT STATE ${current?.name}");
    print("CURRENT TASK ${taskCurrent?.name}");
    if (taskCurrent != null && current != null) {
      if (!taskCurrent.allowFiles!) {
        TaskLocal newTask = TaskLocal(
          id: taskCurrent.id,
          allowFiles: taskCurrent.allowFiles,
          changeStage: taskCurrent.changeStage,
          emailNotification: taskCurrent.emailNotification,
          name: taskCurrent.name,
          order: taskCurrent.order,
          pushNotification: taskCurrent.pushNotification,
          smsNotification: taskCurrent.pushNotification,
          viewCarrier: taskCurrent.viewCarrier,
          viewClient: taskCurrent.viewClient,
          allowCarrier: taskCurrent.allow!.carrier,
          allowClient: taskCurrent.allow!.client,
          allowOperator: taskCurrent.allow!.operator,
          validationCarrier: taskCurrent.validation!.carrier,
          validationClient: taskCurrent.validation!.client,
          validationOperator: taskCurrent.validation!.operator,
          taskId: taskCurrent.taskId,
          idStage: current.id,
          file: [],
          loadingOrderId: current.loadingOrderId,
          dateRealized: DateTime.now().toUtc().toString(),
          contentType: '',
          state: 1,
        );
        db.addTasks(newTask);
        setUpdateStageTask(current.id, taskCurrent.id);
        await updateNotification();
      }
    }
  }
}

addTaskHeadless() async {
  UserPreference userPreference = UserPreference();
  await userPreference.initPrefs();
  var operation = userPreference.operation;
  if (operation != null) {
    try {
      await addTaskNewHeadless();
      await updateNotification();
    } catch (_) {}
  }
}

syncHeadlessTasks() async {
  UserPreference userPreference = UserPreference();
  await userPreference.initPrefs();

  var operation = userPreference.operation;
  if (operation != null) {
    try {
      await registerHive();
      final db = TasksLocalDB();
      await db.initHiveDB();

      Iterable<TaskLocal> taks = db.getTasks()!.values.where((element) => element.state == 1).toList();
      print('syncHeadlessTasks.length ${taks.length}');
      if (taks.isNotEmpty) {
        await Future.forEach<TaskLocal>(taks, (TaskLocal element) async {
          await sendTaskHeadless(element);
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

syncTasks() async {
  UserPreference userPreference = UserPreference();
  await userPreference.initPrefs();

  var operation = userPreference.operation;
  if (operation != null) {
    try {
      final db = TasksLocalDB();
      await db.initHiveDB();
      Iterable<TaskLocal> taks = db.getTasks()!.values.where((element) => element.state == 1).toList();
      print('taks.length ${taks.length}');
      if (taks.isNotEmpty) {
        await Future.forEach<TaskLocal>(taks, (TaskLocal element) async {
          await sendTaskHeadless(element);
        });
        TaskSubscriptionsOperation.instance.streamAdd = true;
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

taskRejected(taskId) async {
  UserPreference userPreference = UserPreference();
  await userPreference.initPrefs();
  print('task rejected');
  var operation = userPreference.operation;
  if (operation != null) {
    try {
      // Hive.close().then((value) => Hive.init(appDocumentDir.path));
      // await registerHive();
      final db = TasksLocalDB();
      await db.initHiveDB();
      var operation = userPreference.operation;
      TaskLocal? taks = db.getTasks()!.values.firstWhereOrNull(
          (element) => element.id == taskId && element.loadingOrderId == operation!.loadingOrder!.loadingOrderId && element.state != 4);
      if (taks != null) {
        // taks.delete();
        TaskSubscriptionsOperation.instance.streamAdd = true;
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

taskdeleteAll() async {
  UserPreference userPreference = UserPreference();
  await userPreference.initPrefs();
  try {
    // Hive.close().then((value) => Hive.init(appDocumentDir.path));
    // await registerHive();
    final db = TasksLocalDB();
    // await db.initHiveDB();
    List<TaskLocal> taks = db.getTasks()!.values.toList();
    taks.forEach((element) {
      element.delete();
    });
  } catch (e) {
    print(e.toString());
  }
}

taskdeleteAllHeadless() async {
  UserPreference userPreference = UserPreference();
  await userPreference.initPrefs();
  try {
    // Hive.close().then((value) => Hive.init(appDocumentDir.path));
    await registerHive();
    final db = TasksLocalDB();
    await db.initHiveDB();
    List<TaskLocal> taks = db.getTasks()!.values.toList();
    taks.forEach((element) {
      element.delete();
    });
  } catch (e) {
    print(e.toString());
  }
}

taskValidate(taskId) async {
  UserPreference userPreference = UserPreference();
  await userPreference.initPrefs();
  print('task ');
  var operation = userPreference.operation;
  if (operation != null) {
    try {
      // Hive.close().then((value) => Hive.init(appDocumentDir.path));
      // await registerHive();
      final db = TasksLocalDB();
      await db.initHiveDB();
      var operation = userPreference.operation;
      TaskLocal? taks = db
          .getTasks()!
          .values
          .firstWhereOrNull((element) => element.id == taskId && element.loadingOrderId == operation!.loadingOrder!.loadingOrderId);
      if (taks != null) {
        taks.state = 4;
        taks.save();
        TaskSubscriptionsOperation.instance.streamAdd = true;
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

taskValidateHeadless(taskId) async {
  UserPreference userPreference = UserPreference();
  await userPreference.initPrefs();
  var operation = userPreference.operation;
  if (operation != null) {
    try {
      await registerHive();
      final db = TasksLocalDB();
      await db.initHiveDB();
      var operation = userPreference.operation;
      TaskLocal? taks = db
          .getTasks()!
          .values
          .firstWhereOrNull((element) => element.id == taskId && element.loadingOrderId == operation!.loadingOrder!.loadingOrderId);
      if (taks != null) {
        taks.state = 4;
        taks.save();
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

taskRejectedHeadLess(taskId) async {
  UserPreference userPreference = UserPreference();
  await userPreference.initPrefs();
  var operation = userPreference.operation;
  if (operation != null) {
    try {
      await registerHive();
      final db = TasksLocalDB();
      await db.initHiveDB();
      var operation = userPreference.operation;
      TaskLocal? taks = db
          .getTasks()!
          .values
          .firstWhereOrNull((element) => element.id == taskId && element.loadingOrderId == operation!.loadingOrder!.loadingOrderId);
      if (taks != null) {
        // taks.delete();
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

syncCheckPoints() async {
  UserPreference userPreference = UserPreference();
  await userPreference.initPrefs();

  var operation = userPreference.operation;
  if (operation != null) {
    try {
      final db = LocationDatabaseLocal();
      await db.initHiveDB();
      List<CheckPointsLocal> taks = db.getAllPositions()!.values.toList();
      print('CheckPointsLocal.length ${taks.length}');
      if (taks.isNotEmpty) {
        await Future.forEach<CheckPointsLocal>(taks, (CheckPointsLocal element) async {
          await sendCheckPointsHeadless(element);
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

syncHeadlessCheckPoints() async {
  UserPreference userPreference = UserPreference();
  await userPreference.initPrefs();

  var operation = userPreference.operation;
  if (operation != null) {
    try {
      await registerHive();
      final db = LocationDatabaseLocal();
      await db.initHiveDB();
      List<CheckPointsLocal> taks = db.getAllPositions()!.values.toList();
      print('syncHeadlessCheckPoints.length ${taks.length}');
      if (taks.isNotEmpty) {
        await Future.forEach<CheckPointsLocal>(taks, (CheckPointsLocal element) async {
          await sendCheckPointsHeadless(element);
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

Future<void> registerHive() async {
  if (!isRegister) {
    await amplify.initAmplifyConfigure();
    final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    isRegister = true;
  }
  if (!Hive.isAdapterRegistered(25)) {
    Hive.registerAdapter(CheckPointsLocalAdapter());
  }
  if (!Hive.isAdapterRegistered(10)) {
    Hive.registerAdapter(TaskLocalAdapter());
  }
}

Future<bool> sendTaskHeadless(TaskLocal task) async {
  await loadEnv();
  int order = 0;
  print(task.dateRealized);
  if (task.allowFiles!) {
    if (task.file.isNotEmpty) {
      var files = List<String>.from(task.file);
      try {
        await Future.forEach(files, (String image) async {
          order++;
          String idRandom = randomAlphaNumeric(15);
          try {
            File file = File(image);
            if (await file.exists()) {
              File newFile = file;
              final dir = await path_provider.getTemporaryDirectory();
              final targetPath = dir.absolute.path + "/temp.jpg";
              File? result = await FlutterImageCompress.compressAndGetFile(
                newFile.absolute.path,
                targetPath,
                quality: 50,
              );
              var user = userPreference.getUser;
              Map<String, String>? metadata = <String, String>{};
              metadata['stagesid'] = task.idStage!;
              metadata['tasksid'] = task.id!;
              metadata['loadingorderid'] = task.loadingOrderId!;
              metadata['order'] = order.toString();
              metadata['userid'] = user.id!;
              if (task.comment != null) {
                metadata['comment'] = task.comment ?? "";
              }
              metadata['type'] = 'task';
              S3UploadFileOptions options = S3UploadFileOptions(
                contentType: task.contentType,
                accessLevel: StorageAccessLevel.guest,
                metadata: metadata,
              );
              UploadFileResult resp = await Amplify.Storage.uploadFile(key: idRandom + 'deltax', local: result!, options: options);

              print("CORRECT UPLOAD FILE -> " + resp.key);
            }
            task.state = 0;
            task.save();
          } catch (e) {
            task.delete();
            return false;
          }
        });

        return true;
      } catch (e) {
        task.delete();
        return false;
      }
    } else {
      task.delete();
      return true;
    }
  } else {
    try {
      var user = userPreference.getUser;
      var url = dotenv.env['URL_STAGES']! + "/" + task.idStage! + "/tasks/" + task.id!;
      if (task.comment == null) {
        await _helper.put(url, {"loadingOrderId": task.loadingOrderId}, {'userId': user.id});
      } else {
        await _helper.put(url, {"loadingOrderId": task.loadingOrderId, "comment": task.comment}, {'userId': user.id});
      }
      task.state = 0;
      task.save();
      return true;
    } catch (e) {
      task.delete();
      return false;
    }
  }
}

String photoHasToken(String photo) {
  if (photo.isNotEmpty) {
    var newPhoto = photo.split('?');
    return newPhoto.first;
  }
  return '';
}

Future<void> launchInBrowser(String url, context) async {
  await launch(url);
}


String nameOrigin(TravelModel travelItem) {
  return travelItem.route?.origin?.cityOrigin ?? "";
}

String nameDestination(TravelModel travelItem) {
  // try {
  //   var newName = travelItem.route?.destination?.cityDestination?.split(',') ?? [];
  //   var pais = newName.first;
  //   var ciudad = newName.last;
  //   return ciudad.trim() + ", " + pais.trim();
  // } catch (e) {
  return travelItem.route?.destination?.cityDestination ?? "";
  // }
}

Future<bool> sendCheckPointsOnline() async {
  var operation = userPreference.operation;
  if (operation != null) {
    try {
      int status = await BackgroundGeolocation.requestPermission();
      if (status == ProviderChangeEvent.AUTHORIZATION_STATUS_ALWAYS || status == ProviderChangeEvent.AUTHORIZATION_STATUS_WHEN_IN_USE) {
        Location location = await BackgroundGeolocation.getCurrentPosition(persist: false);
        dio.options.connectTimeout = 15000; //5s
        dio.options.receiveTimeout = 15000;
        UserPreference userPreference = UserPreference();
        await userPreference.initPrefs();
        var operation = userPreference.operation!;
        var body = {
          "dateTime": DateTime.now().toUtc().toString(),
          "exit": false,
          "lat": location.coords.latitude,
          "lng": location.coords.longitude,
          "loadingOrderId": operation.loadingOrder!.loadingOrderId,
          "transportUnitId": operation.loadingOrder!.assignment!.transportUnitId,
        };
        var url = dotenv.env['URL_CHECKPOINTS']! + "/travel/" + operation.id!;
        var data = await _helper.post(url, body);
        FirebaseCrashlytics.instance.log("GPS OBTENIDO");

        return true;
      }
    } catch (e, s) {
      await FirebaseCrashlytics.instance.recordError(e, s, reason: 'error obtener gps');
      return false;
    }
  }
  return true;
}

Future<bool> sendCheckPointsOnlineHeadless() async {
  await loadEnv();
  var operation = userPreference.operation;
  if (operation != null) {
    await registerHive();
    try {
      int status = await BackgroundGeolocation.requestPermission();
      if (status == ProviderChangeEvent.AUTHORIZATION_STATUS_ALWAYS || status == ProviderChangeEvent.AUTHORIZATION_STATUS_WHEN_IN_USE) {
        // CognitoAuthSession res = await Amplify.Auth.fetchAuthSession(options: CognitoSessionOptions(getAWSCredentials: true));
        // final token = res.userPoolTokens.idToken;
        // dio.options.headers["Authorization"] = "Bearer $token";
        Location location = await BackgroundGeolocation.getCurrentPosition(persist: false);
        dio.options.connectTimeout = 15000; //5s
        dio.options.receiveTimeout = 15000;
        UserPreference userPreference = UserPreference();
        await userPreference.initPrefs();
        var operation = userPreference.operation!;
        var body = {
          "dateTime": DateTime.now().toUtc().toString(),
          "exit": false,
          "lat": location.coords.latitude,
          "lng": location.coords.longitude,
          "loadingOrderId": operation.loadingOrder!.loadingOrderId,
          "transportUnitId": operation.loadingOrder!.assignment!.transportUnitId,
        };
        var url = dotenv.env['URL_CHECKPOINTS']! + "/travel/" + operation.id!;
        await _helper.post(url, body);
      }
    } catch (_) {}
  }
  return true;
}

Future<bool> sendCheckPointsHeadless(CheckPointsLocal checkPointsLocal) async {
  await loadEnv();
  try {
    var url = dotenv.env['URL_CHECKPOINTS']!;
    await _helper.post(url, {
      "dateTime": checkPointsLocal.dateTime,
      "exit": checkPointsLocal.exit,
      "lat": checkPointsLocal.lat,
      "lng": checkPointsLocal.lng,
      "loadingOrderId": checkPointsLocal.loadingOrderId,
      "transportUnitId": checkPointsLocal.transportUnitId,
    });
    print("checkPointsLocal success");
    checkPointsLocal.delete();
    return true;
  } catch (e) {
    return false;
  }
}

Future<void> updateUser() async {
  await loadEnv();
  try {
    UserPreference userPreference = UserPreference();
    var id = await _getUserIdFromAttributes();
    var url = dotenv.env['URL_USER_COGNITO']! + "/" + id;
    var response = await _helper.get(url);
    Map<String, dynamic> dataUser = Map<String, dynamic>.from(response['user']);
    if (response['transportUnit']["_id"] != null) {
      dataUser['transportUnit'] = response['transportUnit'];
      var data3 = TransportUnitModel.fromJson(response['transportUnit']);
      userPreference.setTransportUnit = json.encode(data3);
    }
    var data2 = UserModel.fromJson(dataUser);
    userPreference.setUser = json.encode(data2);
    checkUser(data2);
    var idTransport = data2.transportUnit?.id;
    if (idTransport != null) {
      var urlTransportUnit = dotenv.env['URL_TRANSPORT_UNIT']! + "/" + idTransport + "/synchronizeddata";
      _helper.put(urlTransportUnit, {}).then((value) => value);
    }
  } catch (_) {}
}

Future<void> updateUserData() async {
  await loadEnv();
  UserPreference userPreference = UserPreference();
  var id = await _getUserIdFromAttributes();
  var url = dotenv.env['URL_USER_COGNITO']! + "/" + id;
  var response = await _helper.get(url).timeout(const Duration(seconds: 10));
  Map<String, dynamic> dataUser = Map<String, dynamic>.from(response['user']);
  if (response['transportUnit']["_id"] != null) {
    dataUser['transportUnit'] = response['transportUnit'];
    var data3 = TransportUnitModel.fromJson(response['transportUnit']);
    userPreference.setTransportUnit = json.encode(data3);
  }
  var data2 = UserModel.fromJson(dataUser);
  userPreference.setUser = json.encode(data2);
  var idTransport = data2.transportUnit?.id;
  if (idTransport != null) {
    var urlTransportUnit = dotenv.env['URL_TRANSPORT_UNIT']! + "/" + idTransport + "/synchronizeddata";
    _helper.put(urlTransportUnit, {}).then((value) => value);
  }
}

Future<void> updateUserHeadLess() async {
  UserPreference userPreference = UserPreference();
  await userPreference.initPrefs();
  await loadEnv();
  try {
    await registerHive();
    var id = await _getUserIdFromAttributes();
    var url = dotenv.env['URL_USER_COGNITO']! + "/" + id;
    var urlTransportUnit = dotenv.env['URL_TRANSPORT_UNIT']! + "/" + id + "/synchronizeddata";
    var response = await _helper.get(url);
    Map<String, dynamic> dataUser = Map<String, dynamic>.from(response['user']);
    if (response['transportUnit']["_id"] != null) {
      dataUser['transportUnit'] = response['transportUnit'];
      var data3 = TransportUnitModel.fromJson(response['transportUnit']);
      userPreference.setTransportUnit = json.encode(data3);
    }
    var data2 = UserModel.fromJson(dataUser);
    userPreference.setUser = json.encode(data2);
    var idTransport = data2.transportUnit?.id;
    if (idTransport != null) {
      _helper.put(urlTransportUnit, {}).then((value) => value);
    }
  } catch (e) {
    print('ERROR $e');
  }
}

addLocalGps({bool exit = false}) async {
  UserPreference userPreference = UserPreference();
  final db = LocationDatabaseLocal();
  var operation = userPreference.operation;
  if (operation != null) {
    try {
      var status = await BackgroundGeolocation.requestPermission();
      if (status == ProviderChangeEvent.AUTHORIZATION_STATUS_ALWAYS || status == ProviderChangeEvent.AUTHORIZATION_STATUS_WHEN_IN_USE) {
        var location = await BackgroundGeolocation.getCurrentPosition(persist: false);
        DateTime time = DateTime.now();
        CheckPointsLocal points = CheckPointsLocal(
          checkPointId: '',
          dateTime: time.toUtc().toString(),
          loadingOrderId: operation.loadingOrder!.loadingOrderId,
          lat: location.coords.latitude,
          lng: location.coords.longitude,
          transportUnitId: operation.loadingOrder!.assignment!.transportUnitId,
          exit: exit,
        );
        db.addPosition(points);
      }
    } catch (_) {}
  }
}

Future<AuthenticationState> checkRegistrationExistUser(bool? user) async {
  UserPreference userPreference = UserPreference();
  if (userPreference.onBoarding) {
    if (!user!) {
      return const AuthenticationUnauthenticated(message: 'Error occrued while fetching auth detail');
    } else {
      try {
        await updateUserData();
        UserModel user = userPreference.getUser;
        TransportUnitModel? transport = userPreference.transportUnit;
        op.Operation? operation = userPreference.operation;
        NotificationUpdateSubscription.instance.streamAdd = true;
        if (user.profile?.birthDate == null ||
            user.profile?.firstName == null ||
            user.profile?.lastName == null ||
            user.profile?.documentId == null) {
          return ProfileMainViewState();
        } else if ((transport?.typeTransportUnit == null) &&
            transport?.plate == null &&
            transport?.year == null &&
            transport?.color == null &&
            transport?.brand == null &&
            (transport?.features == null)) {
          return TransportUnitTypeMainViewState();
        } else if ((transport?.typeTransportUnit != null) &&
            (transport?.plate == null &&
                transport?.year == null &&
                transport?.color == null &&
                transport?.brand == null &&
                (transport?.features != null))) {
          return TransportUnitDataMainViewState();
        } else {
          final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
          final Uri? deepLink = data?.link;
          if (deepLink != null) {
            var c = deepLink.path;
            var j = c.replaceAll("/", "");
            if (j == "operation_page") {
              UserModel user = userPreference.getUser;
              if (!user.signedContract) {
                return OperationContractState();
              }
              return OperationPageState();
            }
          }
          if (operation != null) {
            addLocalGps();
            return OperationPageState();
          }

          return AuthenticationAuthenticated();
        }
      } catch (_) {
        op.Operation? operation = userPreference.operation;
        UserModel user = userPreference.getUser;
        if (operation != null) {
          addLocalGps();
          return OperationPageState();
        }
        return await checkUserError(user);
      }
    }
  } else {
    return AuthenticatedOnBoardingIncompleteState();
  }
}

Future<String> _getUserIdFromAttributes() async {
  try {
    final attributes = await Amplify.Auth.fetchUserAttributes();
    final userId = attributes.firstWhere((element) => element.userAttributeKey == 'sub').value;
    return userId;
  } catch (e) {
    rethrow;
  }
}

Future<UserModel?> getUserById() async {
  UserPreference userPreference = UserPreference();
  var id = await _getUserIdFromAttributes();
  String url;
  url = dotenv.env['URL_USER_COGNITO']! + "/" + id;
  var response = await _helper.get(url);
  if (response != null) {
    Map<String, dynamic> dataUser = Map<String, dynamic>.from(response['user']);
    if (response['transportUnit']["_id"] != null) {
      dataUser['transportUnit'] = response['transportUnit'];
      var data3 = TransportUnitModel.fromJson(response['transportUnit']);
      userPreference.setTransportUnit = json.encode(data3);
    }
    var data2 = UserModel.fromJson(dataUser);
    userPreference.setUser = json.encode(data2);
    return data2;
  } else {
    return null;
  }
}

String greetingMessage() {
  var timeNow = DateTime.now().hour;
  if (timeNow <= 12) {
    return 'Buenos días';
  } else if ((timeNow > 12) && (timeNow <= 16)) {
    return 'Buenas tardes';
  } else if ((timeNow > 16) && (timeNow < 20)) {
    return 'Buenas noches';
  } else {
    return 'Buenas noches';
  }
}

checkUserLinks(Uri deepLink) async {
  UserPreference userPreference = UserPreference();
  TransportUnitModel? transport = userPreference.transportUnit;
  UserModel? user = await getUserById();
  if (user?.transportUnit != null) {
    userPreference.setTransportUnit = json.encode(user?.transportUnit);
    transport = user?.transportUnit!;
  }
  userPreference.setUser = json.encode(user);
  if (user?.profile?.birthDate == null || user?.profile?.firstName == null || user?.profile?.lastName == null || user?.profile?.documentId == null) {
    AuthenticationSubcriptions.instance.streamAdd = TypeRegister.profileRegister;
  } else if (transport?.typeTransportUnit == null &&
      transport?.plate == null &&
      transport?.year == null &&
      transport?.color == null &&
      transport?.brand == null &&
      (transport?.features == null)) {
    AuthenticationSubcriptions.instance.streamAdd = TypeRegister.transportUnitType;
  } else if ((transport?.typeTransportUnit != null) &&
      (transport?.plate == null &&
          transport?.year == null &&
          transport?.color == null &&
          transport?.brand == null &&
          (transport?.features != null))) {
    AuthenticationSubcriptions.instance.streamAdd = TypeRegister.transportUnitData;
  } else {
    var c = deepLink.path;
    var j = c.replaceAll("/", "");
    if (j == "operation_page") {
      AuthenticationSubcriptions.instance.streamAdd = TypeRegister.operation;
    }
  }
}

Future<AuthenticationState> checkUserError(UserModel user) async {
  TransportUnitModel? transport;
  transport = userPreference.transportUnit;

  if (user.profile?.birthDate == null || user.profile?.firstName == null || user.profile?.lastName == null || user.profile?.documentId == null) {
    return ProfileMainViewState();
  } else if ((transport?.typeTransportUnit == null) &&
      transport?.plate == null &&
      transport?.year == null &&
      transport?.color == null &&
      transport?.brand == null &&
      (transport?.features == null)) {
    return TransportUnitTypeMainViewState();
  } else if ((transport?.typeTransportUnit != null) &&
      (transport?.plate == null &&
          transport?.year == null &&
          transport?.color == null &&
          transport?.brand == null &&
          (transport?.features != null))) {
    return TransportUnitDataMainViewState();
  } else {
    final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;
    // FirebaseDynamicLinks.instance.onLink(onSuccess: (PendingDynamicLinkData? dynamicLink) async {
    //   final Uri? deepLink = dynamicLink?.link;
    //   if (deepLink != null) {
    //     var c = deepLink.path;
    //     var j = c.replaceAll("/", "");
    //     if (j == "operation_page") {
    //       return OperationPageState();
    //     }
    //   }
    // }, onError: (OnLinkErrorException e) async {
    //   print('onLinkError');
    //   print(e.message);
    // });
    if (deepLink != null) {
      var c = deepLink.path;
      var j = c.replaceAll("/", "");
      if (j == "operation_page") {
        return OperationPageState();
      }
    }
    return AuthenticationAuthenticated();
  }
}

checkUser(UserModel user) {
  UserPreference userPreference = UserPreference();
  TransportUnitModel? transport;
  if (user.transportUnit != null) {
    userPreference.setTransportUnit = json.encode(user.transportUnit);
    transport = user.transportUnit;
  }
  userPreference.setUser = json.encode(user);
  NotificationUpdateSubscription.instance.streamAdd = true;
  if (user.profile!.birthDate == null || user.profile!.firstName == null || user.profile!.lastName == null || user.profile!.documentId == null) {
    AuthenticationSubcriptions.instance.streamAdd = TypeRegister.profileRegister;
  } else if (transport?.typeTransportUnit == null &&
      transport?.plate == null &&
      transport?.year == null &&
      transport?.color == null &&
      transport?.brand == null &&
      (transport?.features == null)) {
    AuthenticationSubcriptions.instance.streamAdd = TypeRegister.transportUnitType;
  } else if ((transport?.typeTransportUnit != null) &&
      (transport?.plate == null &&
          transport?.year == null &&
          transport?.color == null &&
          transport?.brand == null &&
          (transport?.features != null))) {
    AuthenticationSubcriptions.instance.streamAdd = TypeRegister.transportUnitData;
  } else {
    var idTransport = transport?.id;
    if (idTransport != null) {
      var urlTransportUnit = dotenv.env['URL_TRANSPORT_UNIT']! + "/" + "${transport?.id}" + "/synchronizeddata";
      _helper.put(urlTransportUnit, {}).then((value) => value);
    }

    AuthenticationSubcriptions.instance.streamAdd = TypeRegister.opportunity;
  }
}

Future<TypeRegister> checkUserPostulation() async {
  AuthSession res = await Amplify.Auth.fetchAuthSession();
  UserPreference userPreference = UserPreference();
  UserModel? user = userPreference.getUserMenu;
  TransportUnitModel? transport = userPreference.transportUnit;
  if (res.isSignedIn) {
    if (user?.profile?.birthDate == null ||
        user?.profile?.firstName == null ||
        user?.profile?.lastName == null ||
        user?.profile?.documentId == null) {
      return TypeRegister.profileRegister;
    } else if (transport?.typeTransportUnit == null &&
        transport?.plate == null &&
        transport?.year == null &&
        transport?.color == null &&
        transport?.brand == null &&
        (transport?.features == null)) {
      return TypeRegister.transportUnitType;
    } else if ((transport?.typeTransportUnit != null) &&
        (transport?.plate == null &&
            transport?.year == null &&
            transport?.color == null &&
            transport?.brand == null &&
            (transport?.features != null))) {
      return TypeRegister.transportUnitData;
    } else {
      return TypeRegister.opportunity;
    }
  } else {
    return TypeRegister.login;
  }
}

checkRegistrationNewUser(UserModel user, dynamic hubEvent) {
  if (hubEvent.eventName == "SIGNED_IN") {
    checkUser(user);
  }
  if (hubEvent.eventName == "SIGNED_OUT") {
    AuthenticationSubcriptions.instance.streamAdd = TypeRegister.login;
  }
}

Future<XFile?> openCamera() async {
  final ImagePicker picker = ImagePicker();
  XFile? image = await picker.pickImage(source: ImageSource.camera);
  return image!;
}

Future<String> getFilePath(uniqueFileName) async {
  String path = '';

  Directory dir = await path_provider.getApplicationDocumentsDirectory();

  path = '${dir.path}/$uniqueFileName';

  return path;
}

Future<File> writeToFile(ByteData data) async {
  final buffer = data.buffer;
  Directory tempDir = await path_provider.getTemporaryDirectory();
  String tempPath = tempDir.path;
  var filePath = tempPath + '/file_01.png'; // file_01.tmp is dump file, can be anything
  return File(filePath).writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
}

Future<TravelModel?> postulationNewOnMessageOpenedApp(RemoteMessage message) async {
  TransportUnitModel transportUnit = userPreference.transportUnit!;
  var url = dotenv.env['URL_OPPORTUNITY']! + "/" + message.data['travelId'] + "/transportUnitId/" + transportUnit.id!;
  var response = await _helper.get(url);
  TravelModel? travel = TravelModel.fromJson(response['travel']);
  return travel;
}

Future<String?> createFileOfPdfUrl() async {
  Dio dio = Dio();
  String pathPDF;
  try {
    const url = "https://stages-filestasks-buh71gbydkc3.s3.amazonaws.com/public/contrato.pdf";
    final fileName = url.substring(url.lastIndexOf("/") + 1);
    pathPDF = await getFilePath(fileName);
    await dio.download(url, pathPDF, onReceiveProgress: (rec, total) {});
    return pathPDF;
  } catch (e) {
    return null;
  }
}
