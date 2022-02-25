import 'package:appdriver/features/offline/domain/repositories/conectivity_repository.dart';

class SynchronizedCheckPointsUseCase {
  SynchronizedCheckPointsUseCase({
    required ConnectivityRepository repository,
  }) : _repository = repository;

  final ConnectivityRepository _repository;

  Future<bool> call() {
    return _repository.synchronizedServicesCheckPoints();
  }
}
