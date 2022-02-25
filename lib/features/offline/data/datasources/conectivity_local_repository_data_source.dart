import 'dart:async';
import 'dart:io';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:appdriver/core/error/api_helper.dart';
import 'package:dio/dio.dart';
import 'package:appdriver/core/notifications_locale/local_notification.dart';
import 'package:appdriver/features/location/data/datasource/local/location.dart';
import 'package:appdriver/features/offline/data/models/checkpoints_local.dart';
import 'package:appdriver/features/offline/data/models/tasks_local.dart';
import 'package:appdriver/features/offline/data/supcriptions/supcription_conectivity.dart';
import 'package:appdriver/features/tasks/data/datasources/local/tasks_local.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:random_string/random_string.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class ConnectivityRepositoryDataSource {
  final Dio? dio;
  final TasksLocalDB dbTask = TasksLocalDB();
  final dbCheckPoints = LocationDatabaseLocal();
  final ApiBaseHelper _helper = ApiBaseHelper();
  ConnectivityRepositoryDataSource({this.dio});

  bool getAllTask() {
    var operation = userPreference.operation;
    List<TaskLocal> taks = dbTask
        .getTasks()!
        .values
        .where((element) => element.state == 1 && element.loadingOrderId == operation!.loadingOrder!.loadingOrderId)
        .toList();
    return (taks.isNotEmpty) ? true : false;
  }

  bool getAllCheckPointsExistData() {
    List<CheckPointsLocal> checkpoints = dbCheckPoints.getAllPositions()!.values.toList();
    return (checkpoints.isNotEmpty) ? true : false;
  }

  List<TaskLocal> getAllTaskPending() {
    var operation = userPreference.operation;
    List<TaskLocal> taks = dbTask
        .getTasks()!
        .values
        .where((element) => element.loadingOrderId == operation!.loadingOrder!.loadingOrderId && element.state != 4)
        .toList();
    return taks;
  }

  List<CheckPointsLocal> getAllCheckPoints() {
    List<CheckPointsLocal> taks = dbCheckPoints.getAllPositions()!.values.toList();
    return taks;
  }

  Future<bool> synchronizedServices() async {
    var operation = userPreference.operation;
    Iterable<TaskLocal> taks = dbTask
        .getTasks()!
        .values
        .where((element) => element.state == 1 && element.loadingOrderId == operation!.loadingOrder!.loadingOrderId)
        .toList();
    try {
      await Future.forEach<TaskLocal>(taks, (TaskLocal element) async {
        await Future.delayed(const Duration(
          seconds: 1,
        ));
        await sendTask(element);
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> synchronizedServicesCheckPoints() async {
    Iterable<CheckPointsLocal> taks = dbCheckPoints.getAllPositions()!.values.toList();
    try {
      Future<bool> data = Future.forEach<CheckPointsLocal>(taks, (CheckPointsLocal element) {
        return Future.delayed(const Duration(
          seconds: 2,
        )).then((value) => SubscriptionConnectivity.instance.streamAddCheckPoints = element);
      }).then((value) => true).catchError((onerror) => false);
      return data;
    } catch (e) {
      return false;
    }
  }

  Future<bool> setCheckPoints(CheckPointsLocal checkPointsLocal) async {
    var url = dotenv.env['URL_CHECKPOINTS']!;
    var response = _helper.post(url, {
      "dateTime": checkPointsLocal.dateTime,
      "exit": checkPointsLocal.exit,
      "lat": checkPointsLocal.lat,
      "lng": checkPointsLocal.lng,
      "loadingOrderId": checkPointsLocal.loadingOrderId,
      "transportUnitId": checkPointsLocal.transportUnitId,
    }).then((value) {
      checkPointsLocal.delete();
      return true;
    }).catchError((value) {
      checkPointsLocal.delete();
      return false;
    });
    return response;
  }

  File createFile(String path) {
    final file = File(path);
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }

    return file;
  }

  Future<bool> sendTask(TaskLocal task) async {
    int order = 0;
    if (task.allowFiles!) {
      if (task.file.isNotEmpty) {
        var files = List<String>.from(task.file);
        try {
          await Future.forEach(files, (String image) async {
            order++;
            String idRandom = randomAlphaNumeric(15);
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
              metadata['userid'] = user.id!;
              if (task.comment != null) {
                metadata['comment'] = task.comment ?? "";
              }
              metadata['loadingorderid'] = task.loadingOrderId!;
              metadata['order'] = order.toString();
              metadata['type'] = 'task';
              S3UploadFileOptions options = S3UploadFileOptions(
                contentType: task.contentType,
                accessLevel: StorageAccessLevel.guest,
                metadata: metadata,
              );
              await Amplify.Storage.uploadFile(key: idRandom + 'deltax', local: result!, options: options);
            }
          });
          task.state = 0;
          task.save();
          return true;
        } catch (e) {
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
}
