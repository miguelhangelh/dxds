import 'package:appdriver/features/models/features_transport_unit_model.dart';
import 'package:appdriver/features/models/transport_unit_model.dart';
import 'package:appdriver/features/profile/domain/repositories/transportunit_repository.dart';

class RegisterUpdateTransportUnitFeatures {
  RegisterUpdateTransportUnitFeatures({
    required TransportUnitRepository repository,
  })  :
        _repository = repository;

  final TransportUnitRepository _repository;

  Future<TransportUnitModel?> call({
    List<FeaturesTransportUnitModel>? features,
  }) async {
    return await _repository.registerUpdateTransportUnitFeatures(
      features: features,
    );
  }
}
