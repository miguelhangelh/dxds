import 'package:appdriver/features/offline/domain/repositories/conectivity_repository.dart';

class SynchronizedConnectivityUseCase {
  SynchronizedConnectivityUseCase({
    required ConnectivityRepository repository,
  }) : _repository = repository;

  final ConnectivityRepository _repository;

  Future<bool> call() async {
    return await _repository.synchronizedServices();
  }
}
