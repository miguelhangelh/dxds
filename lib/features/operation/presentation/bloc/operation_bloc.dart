import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:appdriver/core/pusher/pusher.dart';
import 'package:appdriver/core/utils/functions.dart';
import 'package:appdriver/features/models/rating_model.dart';
import 'package:appdriver/features/operation/data/supcriptions/supcription_bloc_operation.dart';
import 'package:appdriver/features/operation/data/supcriptions/task_subscriptions_operation.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:appdriver/core/error/response.dart';
import 'package:appdriver/core/notifications_locale/local_notification.dart';
import 'package:appdriver/core/utils/extras.dart';
import 'package:appdriver/features/models/operation_past_model.dart';
import 'package:appdriver/features/models/travel_model.dart';
import 'package:appdriver/features/offline/data/models/tasks_local.dart';
import 'package:appdriver/features/offline/domain/usecases/get_task_all_pending_usecase.dart';
import 'package:appdriver/features/operation/data/models/operation_model.dart' as op;
import 'package:appdriver/features/operation/domain/usecases/get_operation_usecase.dart';
import 'package:appdriver/features/operation/domain/usecases/get_rating_operation_usecase.dart';
import 'package:appdriver/features/operation/domain/usecases/get_travels_past_all_usecase.dart';
import 'package:appdriver/features/tasks/domain/usecases/add_tasks_local.dart';
import 'package:appdriver/features/tasks/domain/usecases/update_tasks_local.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'operation_event.dart';
part 'operation_state.dart';

class OperationBloc extends HydratedBloc<OperationEvent, OperationState> {
  final AddTaskLocalUseCase addTaskLocalUseCase;
  final UpdateTaskLocalUseCase updateTaskLocalUseCase;
  final GetTravelsPastAllUseCase getTravelsPastAllUsecase;
  final GetAllTaskPendingUseCase getAllTaskPendingUseCase;
  final GetRatingOperationUseCase getRatingOperationUseCase;
  final GetOperationUseCase getOperationUseCase;
  TextEditingController textComments = TextEditingController();
  RefreshController refreshController = RefreshController(initialRefresh: false);
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;
  Completer<GoogleMapController> _completer = Completer();
  bool firstInitMaps = false;
  final Completer<Marker> _myPositionMarker = Completer();
  Map<PolylineId, Polyline> polylines = {};
  final PusherConfig _pusher = PusherConfig();
  OperationBloc({
    required this.addTaskLocalUseCase,
    required this.updateTaskLocalUseCase,
    required this.getAllTaskPendingUseCase,
    required this.getOperationUseCase,
    required this.getTravelsPastAllUsecase,
    required this.getRatingOperationUseCase,
  }) : super(OperationState.initialState) {
    bg.BackgroundGeolocation.onNotificationAction((buttonId) {
      switch (buttonId) {
        case 'notificationButtonFoo':
          op.Stage? current = state.currentStage;
          op.Task? currentTask = state.currentTask;
          if (currentTask != null && current != null) {
            if (!currentTask.allowFiles!) {
              add(AddFileEvent(
                file: [],
                idStage: current.id,
                idTask: currentTask.id,
                loadingOrderId: current.loadingOrderId,
                task: currentTask,
              ));
            }
          }
          break;
      }
    });
    textComments.addListener(_printLatestValue);
    TaskSubscriptionsOperation.instance.stream.listen((event) async {
      await Future.delayed(const Duration(seconds: 2));
      add(RefreshOperation());
      //add(AddTasksEvent());
    });
  }

  @override
  Stream<OperationState> mapEventToState(OperationEvent event) async* {
    if (event is GetTravelsPastEvent) {
      yield* _eventToStateGetTravelsPastEvent(event);
    }
    if (event is AddFileEvent) {
      yield* _eventToStateAddFileEvent(event);
    }
    if (event is AddFileEventPending) {
      yield* _eventToStateAddFileEventPending(event);
    }
    if (event is AddFileEventUpdate) {
      yield* _eventToStateAddFileEventUpdate(event);
    }
    if (event is RefreshOperation) {
      yield* _eventToStateRefreshOperation(event);
    }
    if (event is UpdateTaskLocal) {
      yield* _eventToStateUpdateTaskLocal(event);
    }
    if (event is AddTasksEvent) {
      yield* _eventToStateVerifyTask(event);
    }
    if (event is LoadOperationEvent) {
      yield* _eventToStateInitOperation(event);
    }
    if (event is ClosedSuccess) {
      yield state.copyWith(taskSuccess: false);
    }
    if (event is MarkedGeofence) {
      yield* _eventToStateVerifyGeofence(event);
    }
    if (event is MyLocationUpdateEvent) {
      yield* _eventToStateMyLocationUpdate(event);
    }
    if (event is GetRatingLoadingOrder) {
      yield state.copyWith(loadingRating: true);
      try {
        var operation = await getRatingOperationUseCase(travel: event.travel);
        var response = ApiResponse.completed(operation);
        yield state.copyWith(rating: response.data, loadingRating: false);
      } catch (e) {
        yield state.copyWith(loadingRating: false);
      }
    }
  }

  Stream<OperationState> _eventToStateRefreshOperation(RefreshOperation event) async* {
    try {
      if (event.isRefresh) {
        var operation = await getOperationUseCase();
        var response = ApiResponse.completed(operation);
        userPreference.setOperation = json.encode(response.data);
        if (operation == null) {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          await preferences.remove('operation');
          await bg.BackgroundGeolocation.stop();
          await bg.BackgroundGeolocation.stopSchedule();
          await BackgroundFetch.stop();
          await _pusher.disconnect();
          yield state.copyWith(
            operation: null,
            loading: false,
            loadingOrders: null,
            polylineCoordinates: null,
            stages: [],
            route: null,
            taskSuccess: false,
            finished: true,
          );
          return;
        }
        yield state.copyWith(
          loadingOrders: response.data!.loadingOrder,
          stages: response.data!.stages,
          operation: response.data,
          polylines: polylineCoordinates,
          loading: false,
          route: response.data!.route,
        );
        add(AddTasksEvent());
        refreshController.refreshCompleted(resetFooterState: true);
      } else {
        var operation = await getOperationUseCase();
        var response = ApiResponse.completed(operation);
        userPreference.setOperation = json.encode(response.data);
        if (operation == null) {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          await preferences.remove('operation');
          await bg.BackgroundGeolocation.stop();
          await bg.BackgroundGeolocation.stopSchedule();
          await BackgroundFetch.stop();
          yield state.copyWith(
            operation: null,
            loading: false,
            loadingOrders: null,
            polylineCoordinates: null,
            stages: [],
            route: null,
            taskSuccess: false,
            finished: true,
          );
          return;
        }
        yield state.copyWith(
          loadingOrders: response.data!.loadingOrder,
          stages: response.data!.stages,
          operation: response.data,
          route: response.data!.route,
        );
        add(AddTasksEvent());
      }
    } catch (e) {
      await initBackgroundGeolocation();
      await _init();
      op.MyPosition? myPosition;
      var origin = state.route!.checkPoints!.firstWhere((element) => element.type == 'A');
      var destino = state.route!.checkPoints!.firstWhere((element) => element.type == 'B');
      int status = await bg.BackgroundGeolocation.requestPermission();
      if (status == bg.ProviderChangeEvent.AUTHORIZATION_STATUS_ALWAYS || status == bg.ProviderChangeEvent.AUTHORIZATION_STATUS_WHEN_IN_USE) {
        var location = await bg.BackgroundGeolocation.getCurrentPosition(persist: true);
        myPosition = op.MyPosition(lat: location.coords.latitude, lng: location.coords.longitude);
      }
      await bg.BackgroundGeolocation.locations;
      final Uint8List bytes = await loadAsset(
        'assets/carguio.png',
        width: 100,
      );
      final Uint8List bytes1 = await loadAsset(
        'assets/descarguio.png',
        width: 100,
      );
      final customIcon = BitmapDescriptor.fromBytes(bytes);
      final customIcon1 = BitmapDescriptor.fromBytes(bytes1);
      var originMarker = Marker(
        infoWindow: const InfoWindow(
          title: 'Punto de carguío',
        ),
        markerId: const MarkerId('origin_marker'),
        icon: customIcon,
        anchor: const Offset(0.5, 0.5),
        position: LatLng(origin.lat!, origin.lng!),
      );

      var markerDestino = Marker(
        anchor: const Offset(0.5, 0.5),
        infoWindow: InfoWindow(snippet: 'Dirigite', title: 'Punto de descarguío', onTap: () {}),
        icon: customIcon1,
        markerId: const MarkerId('destino_marker'),
        position: LatLng(destino.lat!, destino.lng!),
      );
      final markers = Map<MarkerId, Marker>.from(state.markers!);
      markers[MarkerId(origin.id.toString())] = originMarker;
      markers[MarkerId(destino.id.toString())] = markerDestino;
      double rotation = 0;
      op.MyPosition? lastPosition = state.myLocation;
      if (lastPosition != null) {
        rotation = getCoordsRotation(LatLng(myPosition!.lat!, myPosition.lng!), LatLng(lastPosition.lat!, lastPosition.lng!));
      }
      final Marker myPositionMarker = (await _myPositionMarker.future).copyWith(
        positionParam: LatLng(myPosition!.lat!, myPosition.lng!),
        rotationParam: rotation,
      );
      markers[myPositionMarker.markerId] = myPositionMarker;
      refreshController.refreshCompleted(resetFooterState: true);
      yield state.copyWith(loading: false, markers: markers, myLocation: myPosition);
    }
  }

  Stream<OperationState> _eventToStateGetTravelsPastEvent(GetTravelsPastEvent event) async* {
    if (!refreshController.isRefresh) {
      yield state.copyWith(loading: true);
    }

    try {
      var operation = await getTravelsPastAllUsecase();
      var response = ApiResponse.completed(operation);
      yield state.copyWith(travelsPast: response.data, loading: false);
      if (refreshController.isRefresh) {
        refreshController.refreshCompleted(resetFooterState: true);
      }
    } catch (e) {
      yield state.copyWith(loading: false);
    }
  }

  Stream<OperationState> _eventToStateAddFileEvent(AddFileEvent event) async* {
    var taskModified = state.stages!.indexWhere((element) => element.id == event.idStage);
    var task = state.stages![taskModified].tasks!.indexWhere((element) => element.id == event.idTask);
    state.stages![taskModified].tasks![task].action.add(op.Action(dateAction: DateTime.now()));
    addTaskLocalUseCase(
      idTasks: event.idTask,
      task: event.task,
      idStage: event.idStage,
      comment: textComments.text.isNotEmpty ? textComments.text : null,
      loadingOrderId: event.loadingOrderId,
      file: event.file,
      state: 1,
    );
    textComments.clear();
    addLocalGps();
    add(UpdateTaskLocal());
    OperationSubcriptions.instance.streamTaskAdd = true;
  }

  Stream<OperationState> _eventToStateAddFileEventPending(AddFileEventPending event) async* {
    var taskModified = state.stages!.indexWhere((element) => element.id == event.idStage);
    var task = state.stages![taskModified].tasks!.indexWhere((element) => element.id == event.idTask);
    state.stages![taskModified].tasks![task].action.add(op.Action(dateAction: DateTime.now()));
    addTaskLocalUseCase(
      idTasks: event.idTask,
      idStage: event.idStage,
      comment: textComments.text.isNotEmpty ? textComments.text : null,
      task: event.task,
      loadingOrderId: event.loadingOrderId,
      file: [],
      state: 2,
    );
    textComments.clear();
    addLocalGps();
    add(UpdateTaskLocal());
  }

  Stream<OperationState> _eventToStateAddFileEventUpdate(AddFileEventUpdate event) async* {
    updateTaskLocalUseCase(
      idTasks: event.idTask,
      idStage: event.idStage,
      comment: textComments.text.isNotEmpty ? textComments.text : null,
      loadingOrderId: event.loadingOrderId,
      file: event.file,
      task: event.task,
      state: 1,
    );
    textComments.clear();
    addLocalGps();
    add(UpdateTaskLocal());
  }

  Stream<OperationState> _eventToStateUpdateTaskLocal(UpdateTaskLocal event) async* {
    var user = userPreference.getUser;
    List<TaskLocal> taskLocal = getAllTaskPendingUseCase();
    List<op.Task> newTaskCurrent = [];
    List<op.Task> newTaskPending = [];
    List<op.Task> newTaskFinalized = [];
    List<op.Task> newTaskRealized = [];
    List<op.Task> taskAllData = [];
    op.Stage? current = currentStage(state.stages!);
    op.Task? currentTask = getTask(current);
    List<op.Task>? tasks = taskAll(state.stages!);
    if (currentTask != null) {
      newTaskCurrent.add(currentTask);
      tasks!.removeWhere((element) => element.id == currentTask.id);
    }
    for (var task in tasks!) {
      var taskValidate = taskLocal.firstWhereOrNull((element) => task.id == element.id);
      if (taskValidate != null) {
        if (taskValidate.state == 2) {
          newTaskPending.add(task);
        }
        if (taskValidate.state == 1) {
          newTaskRealized.add(task);
        }
        if (taskValidate.state == 0) {
          newTaskFinalized.add(task);
        }
      } else {
        if (task.action.isNotEmpty) {
          op.Action action = task.action.last;
          if (task.validation!.operator == true && action.dateAction != null && action.validation?.approve == true) {
            newTaskFinalized.add(task);
          }
          if (task.validation!.operator == true && action.dateAction != null && action.validation == null) {
            newTaskFinalized.add(task);
          } else if (task.validation?.operator == false && action.dateAction != null && action.validation == null) {
            newTaskFinalized.add(task);
          } else if ((task.validation?.operator == true || task.validation?.operator == false) &&
              action.dateAction != null &&
              action.validation?.approve == false) {
            newTaskPending.add(task);
          }
        }
      }
    }
    taskAllData.addAll(newTaskCurrent);
    taskAllData.addAll(newTaskPending);
    newTaskRealized.sort((a, b) {
      var lastA = a.action.isNotEmpty;
      var lastB = b.action.isNotEmpty;
      if (lastA && lastB) {
        var lastAc = a.action.last;
        var lastBc = b.action.last;
        var ac = lastAc.dateAction!.compareTo(lastBc.dateAction!) >= 0;
        if (ac) {
          return -1;
        } else {
          return 1;
        }
      }
      return -1;
    });
    taskAllData.addAll(newTaskRealized);
    newTaskFinalized.sort((a, b) {
      var lastA = a.action.isNotEmpty;
      var lastB = b.action.isNotEmpty;
      if (lastA && lastB) {
        var lastAc = a.action.last;
        var lastBc = b.action.last;
        var ac = lastAc.dateAction!.compareTo(lastBc.dateAction!) >= 0;
        if (ac) {
          return -1;
        } else {
          return 1;
        }
      }
      return -1;
    });
    taskAllData.addAll(newTaskFinalized);
    if (currentTask == null) {
      await bg.BackgroundGeolocation.setConfig(bg.Config(
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
      await BackgroundFetch.stop('com.deltaxlat.appdriver');
      await _pusher.disconnect();
    } else {
      if (!currentTask.allowFiles!) {
        await bg.BackgroundGeolocation.setConfig(bg.Config(
          notification: bg.Notification(
            smallIcon: "drawable/ic_launcher_notification",
            priority: bg.Config.NOTIFICATION_PRIORITY_HIGH,
            sticky: true,
            title:
                user.profile?.firstName?.trim() != null ? '${user.profile?.firstName?.trim()} tienes una operación en curso' : "Operación en curso",
            strings: {'notificationButtonFoo': currentTask.name.toString()},
            layout: "my_notification_layout",
            actions: ["notificationButtonFoo"],
            text: 'Recuerda completar todas tus tareas.',
          ),
        ));
      } else {
        await bg.BackgroundGeolocation.setConfig(bg.Config(
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
    }
    yield state.copyWith(tasksLocal: taskLocal, currentStage: () => current, currentTask: () => currentTask, tasks: taskAllData);
  }

  Stream<OperationState> _eventToStateVerifyTask(AddTasksEvent event) async* {
    List<TaskLocal>? taskLocal = getAllTaskPendingUseCase();
    List<op.Stage> stages = List<op.Stage>.from(state.stages!);
    for (var stage in stages) {
      for (var task in stage.tasks!) {
        var taskValidate = taskLocal.firstWhereOrNull((element) => task.id == element.id);
        if (taskValidate != null) {
          if (task.action.isNotEmpty) {
            taskFinalized(task, taskValidate);
          } else {
            task.action.add(op.Action(dateAction: DateTime.now()));
          }
        } else {
          if (task.action.isNotEmpty) {
            taskFinalized(task, null);
          }
        }
      }
    }
    add(UpdateTaskLocal());
    yield state.copyWith(stages: stages);
  }

  taskFinalized(op.Task task, TaskLocal? taskValidate) {
    op.Action action = task.action.last;
    if (taskValidate != null) {
      if (task.validation!.operator == true && action.dateAction != null && action.validation?.approve == true) {
        taskValidate.state = 0;
        taskValidate.save();
      } else if (task.validation?.operator == false && action.dateAction != null) {
        taskValidate.state = 0;
        taskValidate.save();
      } else if ((task.validation?.operator == true || task.validation?.operator == false) &&
          action.dateAction != null &&
          action.validation?.approve == false) {
        if (taskValidate.state == 2 || taskValidate.state == 1) {
          task.action.add(op.Action(dateAction: DateTime.now()));
        } else {
          taskValidate.delete();
        }
      }
    } else {}
  }

  setUpdateStageTask(idStage, idTask) {
    op.Operation operation = userPreference.operation!;
    var taskModified = operation.stages!.indexWhere((element) => element.id == idStage);
    var task = operation.stages![taskModified].tasks!.indexWhere((element) => element.id == idTask);
    operation.stages![taskModified].tasks![task].action.add(op.Action(dateAction: DateTime.now()));
    userPreference.setOperation = json.encode(operation);
  }

  Stream<OperationState> _eventToStateInitOperation(LoadOperationEvent event) async* {
    try {
      yield state.copyWith(loading: true);
      var operation = await getOperationUseCase();
      var response = ApiResponse.completed(operation);
      bool finished = false;
      op.MyPosition? myPosition;
      if (response.data != null) {
        userPreference.setOperation = json.encode(response.data);
        _pusher.connect();
        await _init();
        final markers = Map<MarkerId, Marker>.from(state.markers!);

        var origin = response.data?.route?.checkPoints!.firstWhere((element) => element.type == 'A');
        var destino = response.data?.route?.checkPoints!.firstWhere((element) => element.type == 'B');
        if (origin != null && destino != null) {
          await _createPolylines(origin.lat!, origin.lng!, destino.lat!, destino.lng!);
          final Uint8List bytes = await loadAsset(
            'assets/carguio.png',
            width: 100,
          );
          final Uint8List bytes1 = await loadAsset(
            'assets/descarguio.png',
            width: 100,
          );
          final customIcon = BitmapDescriptor.fromBytes(bytes);
          final customIcon1 = BitmapDescriptor.fromBytes(bytes1);
          var originMarker = Marker(
              infoWindow: const InfoWindow(title: 'Punto de carguío'),
              markerId: const MarkerId('origin_marker'),
              icon: customIcon,
              anchor: const Offset(0.5, 0.5),
              position: LatLng(origin.lat!, origin.lng!));
          var markerDestino = Marker(
              anchor: const Offset(0.5, 0.5),
              infoWindow: InfoWindow(snippet: 'Dirigite', title: 'Punto de descarguío', onTap: () {}),
              icon: customIcon1,
              markerId: const MarkerId('destino_marker'),
              position: LatLng(destino.lat!, destino.lng!));
          markers[MarkerId(origin.id.toString())] = originMarker;
          markers[MarkerId(destino.id.toString())] = markerDestino;
        }

        var data = await bg.BackgroundGeolocation.providerState;
        if ((data.status == bg.ProviderChangeEvent.AUTHORIZATION_STATUS_ALWAYS ||
                data.status == bg.ProviderChangeEvent.AUTHORIZATION_STATUS_WHEN_IN_USE) &&
            data.gps) {
          var location = await bg.BackgroundGeolocation.getCurrentPosition(persist: true, desiredAccuracy: 5000);
          myPosition = op.MyPosition(lat: location.coords.latitude, lng: location.coords.longitude);
        }
        await bg.BackgroundGeolocation.locations;

        List<bg.Geofence> geofence = [];
        bg.BackgroundGeolocation.removeGeofences();
        for (var e in response.data!.route!.checkPoints!) {
          geofence.add(bg.Geofence(
            radius: 100,
            identifier: e.id!,
            latitude: e.lat!,
            longitude: e.lng!,
            notifyOnEntry: true,
            notifyOnExit: true,
          ));
        }
        await bg.BackgroundGeolocation.addGeofences(geofence);
        add(AddTasksEvent());
        if (!finished) {
          op.Stage? current = currentStage(response.data!.stages!);
          op.Task? currentTask = getTask(current);
          List<op.Task>? tasks = taskAll(response.data!.stages!);
          yield state.copyWith(
              loading: false,
              loadingOrders: response.data!.loadingOrder,
              stages: response.data!.stages,
              tasks: tasks,
              currentTask: () => currentTask,
              finished: false,
              polylines: polylineCoordinates,
              currentStage: () => current,
              myLocation: myPosition,
              operation: response.data,
              markers: markers,
              taskSuccess: false,
              route: response.data!.route);
        }
        await initBackgroundGeolocation();
      } else {
        await userPreference.deleteKey('operation');
        await bg.BackgroundGeolocation.stop();
        await bg.BackgroundGeolocation.stopSchedule();
        await BackgroundFetch.stop();
        await _pusher.disconnect();
        yield state.copyWith(
            operation: null,
            loading: false,
            loadingOrders: null,
            polylineCoordinates: null,
            stages: [],
            route: null,
            taskSuccess: false,
            finished: true);
      }
    } catch (e) {
      var operation = userPreference.operation;
      if (operation == null) {
        yield state.copyWith(
            operation: null,
            loading: false,
            loadingOrders: null,
            polylineCoordinates: null,
            stages: [],
            route: null,
            taskSuccess: false,
            finished: true);
        return;
      }
      await initBackgroundGeolocation();
      await _init();
      op.MyPosition? myPosition;
      final markers = Map<MarkerId, Marker>.from(state.markers!);

      var origin = state.route?.checkPoints?.firstWhere((element) => element.type == 'A');
      var destiny = state.route?.checkPoints?.firstWhere((element) => element.type == 'B');
      if (origin != null && destiny != null) {
        var providerState = await bg.BackgroundGeolocation.providerState;
        bg.Location location;
        if ((providerState.status == bg.ProviderChangeEvent.AUTHORIZATION_STATUS_ALWAYS ||
                providerState.status == bg.ProviderChangeEvent.AUTHORIZATION_STATUS_WHEN_IN_USE) &&
            providerState.gps) {
          location = await bg.BackgroundGeolocation.getCurrentPosition(persist: true, timeout: 10, desiredAccuracy: 5000);
          myPosition = op.MyPosition(lat: location.coords.latitude, lng: location.coords.longitude);
        }
        await bg.BackgroundGeolocation.locations;
        final Uint8List bytes = await loadAsset('assets/carguio.png', width: 100);
        final Uint8List bytes1 = await loadAsset('assets/descarguio.png', width: 100);
        final customIcon = BitmapDescriptor.fromBytes(bytes);
        final customIcon1 = BitmapDescriptor.fromBytes(bytes1);
        var originMarker = Marker(
            infoWindow: const InfoWindow(title: 'Punto de carguío'),
            markerId: const MarkerId('origin_marker'),
            icon: customIcon,
            anchor: const Offset(0.5, 0.5),
            position: LatLng(origin.lat!, origin.lng!));
        var markerDestiny = Marker(
            anchor: const Offset(0.5, 0.5),
            infoWindow: InfoWindow(snippet: 'Dirigite', title: 'Punto de descarguío', onTap: () {}),
            icon: customIcon1,
            markerId: const MarkerId('destino_marker'),
            position: LatLng(destiny.lat!, destiny.lng!));
        markers[MarkerId(origin.id.toString())] = originMarker;
        markers[MarkerId(destiny.id.toString())] = markerDestiny;
        double rotation = 0;
        op.MyPosition? lastPosition = state.myLocation;
        if (lastPosition != null && myPosition != null) {
          rotation = getCoordsRotation(LatLng(myPosition.lat!, myPosition.lng!), LatLng(lastPosition.lat!, lastPosition.lng!));
        }
        if (myPosition != null) {
          final Marker myPositionMarker = (await _myPositionMarker.future).copyWith(
            positionParam: LatLng(myPosition.lat!, myPosition.lng!),
            rotationParam: rotation,
          );
          markers[myPositionMarker.markerId] = myPositionMarker;
        }
      }
      yield state.copyWith(loading: false, markers: markers, myLocation: myPosition);
    }
  }

  Stream<OperationState> _eventToStateVerifyGeofence(MarkedGeofence event) async* {
    var exit = event.event.action == 'EXIT' ? true : false;
    addLocalGps(exit: exit);
  }

  Stream<OperationState> _eventToStateMyLocationUpdate(MyLocationUpdateEvent event) async* {
    final markers = Map<MarkerId, Marker>.from(state.markers!);
    double rotation = 0;
    op.MyPosition? lastPosition = state.myLocation;
    if (lastPosition != null) {
      rotation = getCoordsRotation(event.location!, LatLng(lastPosition.lat!, lastPosition.lng!));
    }
    final Marker myPositionMarker = (await _myPositionMarker.future).copyWith(
      positionParam: event.location,
      rotationParam: rotation,
    );
    markers[myPositionMarker.markerId] = myPositionMarker;
    yield state.copyWith(
      markers: markers,
      myLocation: op.MyPosition(
        lat: event.location!.latitude,
        lng: event.location!.longitude,
      ),
    );
  }

  @override
  OperationState fromJson(Map<String, dynamic> json) {
    return OperationState.fromMap(json);
  }

  @override
  Map<String, dynamic> toJson(OperationState state) {
    return state.toMap();
  }

  Future<void> initBackgroundGeolocation() async {
    try {
      var user = userPreference.getUser;
      op.Stage? current = state.currentStage;
      op.Task? currentTask = state.currentTask;
      if (currentTask != null && current != null) {
        if (!currentTask.allowFiles!) {
          await bg.BackgroundGeolocation.ready(
            bg.Config(
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
                title: user.profile?.firstName?.trim() != null
                    ? '${user.profile?.firstName?.trim()} tienes una operación en curso'
                    : "Operación en curso",
                strings: {'notificationButtonFoo': currentTask.name.toString()},
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
            ),
          );
        } else {
          await bg.BackgroundGeolocation.ready(
            bg.Config(
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
                title: user.profile?.firstName?.trim() != null
                    ? '${user.profile?.firstName?.trim()} tienes una operación en curso'
                    : "Operación en curso",
                strings: {},
                layout: "",
                actions: [],
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
            ),
          );
        }
      } else {
        await bg.BackgroundGeolocation.ready(
          bg.Config(
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
              strings: {},
              layout: "",
              actions: [],
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
          ),
        );
      }
      await bg.BackgroundGeolocation.start();

      // bg.BackgroundGeolocation.setConfig(config)
      await BackgroundFetch.start();
    } catch (error) {
      // print("[requestPermission] DENIED: $error");
    }
  }

  Future<GoogleMapController> get _mapController async {
    return await _completer.future;
  }

  Future<void> setMapController(GoogleMapController controller) async {
    if (_completer.isCompleted) {
      _completer = Completer();
    }
    _completer.complete(controller);
  }

  void goTo() async {
    List<double> lngs1 = [];
    List<double> lats1 = [];
    state.markers!.forEach((key, value) {
      lngs1.add(value.position.longitude);
    });
    state.markers!.forEach((key, value) {
      lats1.add(value.position.latitude);
    });
    double topMost = lngs1.reduce(max);
    double leftMost = lats1.reduce(min);
    double rightMost = lats1.reduce(max);
    double bottomMost = lngs1.reduce(min);

    LatLngBounds bounds = LatLngBounds(
      northeast: LatLng(rightMost, topMost),
      southwest: LatLng(leftMost, bottomMost),
    );
    await (await _mapController).animateCamera(
      CameraUpdate.newLatLngBounds(
        bounds,
        100,
      ),
    );
    // await (await _mapController).moveCamera(cameraUpdate);
  }

  op.Stage? currentStage(List<op.Stage> stages) {
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

  List<op.Task>? taskAll(List<op.Stage> stages) {
    List<op.Task> taskAll = [];
    for (var element in stages) {
      for (var task in element.tasks!) {
        taskAll.add(task);
      }
    }
    return taskAll;
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

  _createPolylines(
    double startLatitude,
    double startLongitude,
    double destinationLatitude,
    double destinationLongitude,
  ) async {
    polylinePoints = PolylinePoints();
    polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyAE8QygNNc0lhFs5oY0KtIJZoR17LDSJWM',
      PointLatLng(startLatitude, startLongitude),
      PointLatLng(destinationLatitude, destinationLongitude),
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }

    PolylineId id = const PolylineId('poly');

    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );

    polylines[id] = polyline;
  }

  _printLatestValue() {}

  Future<void> _init() async {
    _loadCarPin();
    bg.BackgroundGeolocation.onConnectivityChange((bg.ConnectivityChangeEvent event) {});
    bg.BackgroundGeolocation.onProviderChange((bg.ProviderChangeEvent event) {
      switch (event.status) {
        case bg.ProviderChangeEvent.AUTHORIZATION_STATUS_DENIED:
          break;
        case bg.ProviderChangeEvent.AUTHORIZATION_STATUS_ALWAYS:
          break;
        case bg.ProviderChangeEvent.AUTHORIZATION_STATUS_WHEN_IN_USE:
          break;
      }
    });

    bg.BackgroundGeolocation.onGeofence((bg.GeofenceEvent event) {
      add(MarkedGeofence(event));
    });
    bg.BackgroundGeolocation.removeGeofences();
    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      add(MyLocationUpdateEvent(location: LatLng(location.coords.latitude, location.coords.longitude)));
    });
    bg.BackgroundGeolocation.onMotionChange((bg.Location location) {
      if (location.isMoving) {
      } else {}
    });
  }

  _loadCarPin() async {
    try {
      final Uint8List bytes = await loadAsset('assets/pin1.png', width: 100);
      final marker = Marker(
        markerId: const MarkerId('my_position_marker'),
        icon: BitmapDescriptor.fromBytes(bytes),
        anchor: const Offset(0.5, 0.5),
      );
      _myPositionMarker.complete(marker);
    } catch (_) {}
  }
}
