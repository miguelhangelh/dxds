import 'package:appdriver/features/tasks/data/datasources/remote/tasks_datasource_remote.dart';
import 'package:appdriver/features/tasks/domain/repositories/task_repository.dart';
import 'package:appdriver/features/operation/data/models/operation_model.dart' as op;

class TasksRepositoryImplementation implements TasksRepository {
  final TasksDataSourceRemote? tasksDataSourceRemote;

  TasksRepositoryImplementation({
    required this.tasksDataSourceRemote,
  });


  @override
  Future<void> updateTasksLocal({
    String? idTasks,
    String? idStage,
    String? comment,
    List<String> file = const [],
    op.Task? task,
    String? loadingOrderId,
    int? state,
  }) async {
    return await tasksDataSourceRemote!.updateTasksLocal(
      idTasks: idTasks,
      idStage: idStage,
      comment: comment,
      file: file,
      state: state,
      loadingOrderId: loadingOrderId,
      task: task!,
    );
  }

  @override
  Future<void> addTasksLocal({
    String? idTasks,
    String? idStage,
    List<String> file = const [],
    op.Task? task,
    String? comment,
    String? loadingOrderId,
    int? state,
  }) async {
    return await tasksDataSourceRemote!.addTasksLocal(
      idTasks: idTasks,
      idStage: idStage,
      file: file,
      comment: comment,
      state: state,
      loadingOrderId: loadingOrderId,
      task: task!,
    );
  }
}
