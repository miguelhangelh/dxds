import 'package:appdriver/features/tasks/domain/repositories/task_repository.dart';
import 'package:appdriver/features/operation/data/models/operation_model.dart' as op;

class UpdateTaskLocalUseCase {
  UpdateTaskLocalUseCase({
    required TasksRepository repository,
  })  :
        _repository = repository;

  final TasksRepository _repository;

  /// Callable class method

  Future<void> call({
    String? idTasks,
    String? loadingOrderId,
    String? idStage,
    String? comment,
     List<String> file = const [],
    int? state,
    op.Task? task,
  }) async {
    return await _repository.updateTasksLocal(
      idTasks: idTasks,
      idStage: idStage,
      file: file,
      state: state,
      comment: comment,
      task:task,
      loadingOrderId: loadingOrderId,
    );
  }
}
