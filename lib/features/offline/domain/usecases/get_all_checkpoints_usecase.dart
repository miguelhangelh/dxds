import 'package:appdriver/features/offline/domain/repositories/conectivity_repository.dart';

class GetAllCheckPointsUsecase {
  GetAllCheckPointsUsecase({
    required ConnectivityRepository repository,
  }) : _repository = repository;

  final ConnectivityRepository _repository;

  bool call() {
    return _repository.getAllCheckPointsExist();
  }
}
