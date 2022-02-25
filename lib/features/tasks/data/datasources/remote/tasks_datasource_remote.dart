import 'package:appdriver/core/notifications_locale/local_notification.dart';
import 'package:dio/dio.dart';
import 'package:appdriver/features/offline/data/models/tasks_local.dart';
import 'package:appdriver/features/tasks/data/datasources/local/tasks_local.dart';
import 'package:appdriver/features/operation/data/models/operation_model.dart' as op;
import 'package:collection/collection.dart';

class TasksDataSourceRemote {
  final dbTask = new TasksLocalDB();
  final Dio? dio;
  TasksDataSourceRemote({required this.dio});
  Future<void> addTasksLocal({
    String? idTasks,
    String? idStage,
    String? comment,
    required List<String> file,
    required op.Task task,
    String? loadingOrderId,
    int? state,
  }) async {
    registerTask(idTasks, idStage, file, task, loadingOrderId, state, comment);

    print('DB Length Tasks: ${dbTask.getTasks()!.values.length} ');
  }

  registerTask(
    String? idTasks,
    String? idStage,
    List<String> file,
    op.Task task,
    String? loadingOrderId,
    int? state,
    String? comment,
  ) {
    var operation = userPreference.operation;
    var taskValidate = dbTask
        .getTasks()!
        .values
        .firstWhereOrNull((element) => task.id == element.id && element.loadingOrderId == operation!.loadingOrder!.loadingOrderId);
    if (taskValidate == null) {
      if (task.allowFiles!) {
        TaskLocal newTask = TaskLocal(
          id: task.id,
          allowFiles: task.allowFiles,
          changeStage: task.changeStage,
          emailNotification: task.emailNotification,
          name: task.name,
          order: task.order,
          allowCarrier: task.allow!.carrier,
          allowClient: task.allow!.client,
          allowOperator: task.allow!.operator,
          validationCarrier: task.validation!.carrier,
          validationClient: task.validation!.client,
          validationOperator: task.validation!.operator,
          pushNotification: task.pushNotification,
          smsNotification: task.pushNotification,
          viewCarrier: task.viewCarrier,
          viewClient: task.viewClient,
          taskId: task.taskId,
          idStage: idStage,
          file: file,
          comment: comment,
          loadingOrderId: loadingOrderId,
          dateRealized: DateTime.now().toUtc().toString(),
          state: state,
        );
        dbTask.addTasks(newTask);
      } else {
        TaskLocal newTask = TaskLocal(
          id: task.id,
          allowFiles: task.allowFiles,
          changeStage: task.changeStage,
          emailNotification: task.emailNotification,
          name: task.name,
          order: task.order,
          pushNotification: task.pushNotification,
          smsNotification: task.pushNotification,
          viewCarrier: task.viewCarrier,
          viewClient: task.viewClient,
          allowCarrier: task.allow!.carrier,
          allowClient: task.allow!.client,
          allowOperator: task.allow!.operator,
          validationCarrier: task.validation!.carrier,
          validationClient: task.validation!.client,
          validationOperator: task.validation!.operator,
          taskId: task.taskId,
          idStage: idStage,
          file: [],
          comment: comment,
          loadingOrderId: loadingOrderId,
          dateRealized: DateTime.now().toUtc().toString(),
          contentType: '',
          state: state,
        );
        dbTask.addTasks(newTask);
      }
    } else {
      taskValidate.comment = comment ?? null;
      taskValidate.file = file;
      taskValidate.state = state;
      taskValidate.save();
    }
  }

  Future<void> updateTasksLocal({
    String? idTasks,
    String? idStage,
    required List<String> file,
    String? comment,
    required op.Task task,
    String? loadingOrderId,
    int? state,
  }) async {
    var operation = userPreference.operation;

    if (task.allowFiles!) {
      var taskValidate = dbTask
          .getTasks()!
          .values
          .firstWhereOrNull((element) => task.id == element.id && element.loadingOrderId == operation!.loadingOrder!.loadingOrderId);
      if (taskValidate != null) {
        taskValidate.file = file;
        taskValidate.comment = comment;
        taskValidate.state = state;
        dbTask.updateTaskState(taskValidate);
      }
    } else {
      var taskValidate = dbTask
          .getTasks()!
          .values
          .firstWhereOrNull((element) => task.id == element.id && element.loadingOrderId == operation!.loadingOrder!.loadingOrderId);
      if (taskValidate != null) {
        taskValidate.comment = comment;
        taskValidate.state = state;
        dbTask.updateTaskState(taskValidate);
      }
    }
    print('DB Length Tasks: ${dbTask.getTasks()!.values.length} ');
  }
  // Future<void> addTasksLocal({
  //   String idTasks,
  //   String idStage,
  //   String file,
  //   double latitude,
  //   double longitude,
  //   int order,
  //   bool viewCarrier,
  //   bool viewClient,
  //   bool validation,
  //   bool allowFiles,
  //   String name,
  //   int state,
  // }) async {
  //   // TaskLocal newTask = new TaskLocal(
  //   //   idTasks: idTasks,
  //   //   idOperation: idStage,
  //   //   files: files,
  //   //   state: state,
  //   //   name: name,
  //   //   orden: orden,
  //   // );
  //   // dbTask.addTasks(newTask);
  //   if (allowFiles) {
  //     var type = lookupMimeType(file);
  //     var type1 = type.replaceAll('image/', '');
  //     Map<String, String> metadata = <String, String>{};
  //     metadata['stagesId'] = idStage;
  //     metadata['taskId'] = idTasks;
  //     metadata['latitude'] = latitude.toString();
  //     metadata['longitude'] = longitude.toString();
  //     metadata['type'] = type1;
  //     String idRandom = randomAlphaNumeric(15);
  //     S3UploadFileOptions options = S3UploadFileOptions(
  //       accessLevel: StorageAccessLevel.guest,
  //       metadata: metadata,
  //     );

  //     await Amplify.Storage.uploadFile(
  //         key: idRandom + 'deltax', local: File(file), options: options);
  //   } else {
  //     CognitoAuthSession res = await Amplify.Auth.fetchAuthSession(
  //         options: CognitoSessionOptions(getAWSCredentials: true));
  //     final token = res.userPoolTokens.idToken;
  //     dio.options.headers["Authorization"] = "Bearer $token";
  //     var response = await dio.post(
  //         'https://sj1nb8azpd.execute-api.us-east-2.amazonaws.com/dev/stages/$idStage/tasks/$idTasks',
  //         data: {"lat": latitude.toString(), "lng": longitude.toString()});
  //   }

  //   //  await Amplify.Storage.uploadFile( key: idTasks, local: File(files), options: options);
  //   //  await Amplify.Storage.uploadFile( key: idTasks, local: File(files), options: options);
  //   // final length = dbTask.getTasks().values.length;
  //   // return data;
  //   // print('DB Length Tasks: ${dbTask.getTasks().values.length} ');
  //   // return name;
  // }
}
