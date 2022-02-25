import 'dart:io';

import 'package:appdriver/features/profile/domain/repositories/transportunit_repository.dart';

class UpdateTransportUnitPhotoUseCase {
  UpdateTransportUnitPhotoUseCase({
    required TransportUnitRepository repository,
  })  :
        _repository = repository;

  final TransportUnitRepository _repository;

  Future<String> call({
    File? pathPhoto,
    String? type,
  }) async {
    return await _repository.updateTransportUnitPhotoUseCase(
      type: type,
      pathPhoto: pathPhoto,
    );
  }
}
