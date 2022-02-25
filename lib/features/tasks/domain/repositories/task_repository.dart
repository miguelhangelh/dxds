import 'package:appdriver/features/operation/data/models/operation_model.dart' as op;
abstract class TasksRepository {

  Future<void> updateTasksLocal({
    String? idTasks,
    String? idStage,
    String? comment,
    required List<String> file,
    op.Task? task,
    String? loadingOrderId,
    int? state,
  });
  Future<void> addTasksLocal({
    String? idTasks,
    String? comment,
    String? idStage,
    required List<String> file,
    op.Task? task,
    String? loadingOrderId,
    int? state,
  });
}
