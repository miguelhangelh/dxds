import 'package:appdriver/features/offline/domain/repositories/conectivity_repository.dart';

class GetAllTaskUsecase {
  GetAllTaskUsecase({
    required ConnectivityRepository repository,
  }) : _repository = repository;

  final ConnectivityRepository _repository;

  bool call() {
    return _repository.getAllTask();
  }
}
