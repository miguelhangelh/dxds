import 'package:appdriver/features/offline/data/models/tasks_local.dart';
import 'package:appdriver/features/offline/domain/repositories/conectivity_repository.dart';

class GetAllTaskPendingUseCase {
  GetAllTaskPendingUseCase({
    required ConnectivityRepository repository,
  }) : _repository = repository;

  final ConnectivityRepository _repository;

  List<TaskLocal> call() {
    return _repository.getAllTaskPending();
  }
}
