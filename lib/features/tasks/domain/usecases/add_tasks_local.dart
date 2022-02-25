import 'package:appdriver/features/tasks/domain/repositories/task_repository.dart';
import 'package:appdriver/features/operation/data/models/operation_model.dart' as op;

class AddTaskLocalUseCase {
  AddTaskLocalUseCase({
    required TasksRepository repository,
  }) : _repository = repository;

  final TasksRepository _repository;
  Future<void> call({
    String? idTasks,
    String? loadingOrderId,
    String? comment,
    String? idStage,
    required List<String> file,
    op.Task? task,
    int? state,
  }) async {
    return await _repository.addTasksLocal(
      idTasks: idTasks,
      idStage: idStage,
      file: file,
      comment: comment,
      state: state,
      loadingOrderId: loadingOrderId,
      task: task,
    );
  }
}
