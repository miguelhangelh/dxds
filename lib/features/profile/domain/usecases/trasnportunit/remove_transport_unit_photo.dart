
import 'package:appdriver/features/models/transport_unit_model.dart';
import 'package:appdriver/features/profile/domain/repositories/transportunit_repository.dart';

class RemoveTransportUnitPhotoUseCase {
  RemoveTransportUnitPhotoUseCase({
    required TransportUnitRepository repository,
  })  :
        _repository = repository;

  final TransportUnitRepository _repository;

  Future<TransportUnitModel> call({
    String? type,
    String? photoId,
  }) async {
    return await _repository.removeTransportUnitPhotoUseCase(
      type: type,
      photoId : photoId
    );
  }
}
