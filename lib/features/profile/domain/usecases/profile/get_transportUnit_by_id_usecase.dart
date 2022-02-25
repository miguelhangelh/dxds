import 'package:appdriver/features/models/transport_unit_model.dart';
import 'package:appdriver/features/profile/domain/repositories/profile_repository.dart';

class GetTransportUnitByIdUsecase {
  GetTransportUnitByIdUsecase({
    required ProfileRepository repository,
  })  :
        _repository = repository;

  final ProfileRepository _repository;

  /// Callable class method

  Future<TransportUnitModel?> call() async {
    return await _repository.getTransportUnitById();
  }
}
