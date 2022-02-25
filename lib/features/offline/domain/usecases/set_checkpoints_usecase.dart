import 'package:appdriver/features/offline/data/models/checkpoints_local.dart';
import 'package:appdriver/features/offline/domain/repositories/conectivity_repository.dart';

class SetCheckPointsUsecase {
  SetCheckPointsUsecase({
    required ConnectivityRepository repository,
  }) : _repository = repository;

  final ConnectivityRepository _repository;

  Future<bool> call(CheckPointsLocal checkPointsLocal) {
    return _repository.setCheckPoints(checkPointsLocal);
  }
}
