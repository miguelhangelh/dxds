import 'dart:io';

import 'package:appdriver/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfilePathPhotoUseCase {
  UpdateProfilePathPhotoUseCase({
    required ProfileRepository repository,
  }) : _repository = repository;

  final ProfileRepository _repository;

  Future<String> call({
    File? pathPhoto,
  }) async {
    return await _repository.updateProfilePathPhoto(
      pathPhoto: pathPhoto,
    );
  }
}
