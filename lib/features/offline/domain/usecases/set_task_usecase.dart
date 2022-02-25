import 'package:appdriver/features/offline/data/models/tasks_local.dart';
import 'package:appdriver/features/offline/domain/repositories/conectivity_repository.dart';

class SetTaskUsecase {
  SetTaskUsecase({
    required ConnectivityRepository repository,
  }) : _repository = repository;

  final ConnectivityRepository _repository;

  Future<bool> call(TaskLocal task) {
    return _repository.setTask(task);
  }
}
