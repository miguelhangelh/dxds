import 'package:appdriver/features/models/features_transport_unit_model.dart';
import 'package:appdriver/features/profile/domain/repositories/profile_repository.dart';

class GetFeatureTransportUnitUsecase {
  GetFeatureTransportUnitUsecase({
    required ProfileRepository repository,
  })  :
        _repository = repository;

  final ProfileRepository _repository;

  /// Callable class method

  Future<List<FeaturesTransportUnitModel>> call() async {
    return await _repository.getFeaturesTransportUnit();
  }
}
