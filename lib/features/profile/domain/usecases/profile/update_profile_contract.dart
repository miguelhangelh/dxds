import 'dart:io';

import 'package:appdriver/features/models/user_model.dart';
import 'package:appdriver/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfileContractUseCase {
  UpdateProfileContractUseCase({
    required ProfileRepository repository,
  }) : _repository = repository;

  final ProfileRepository _repository;

  Future<UserModel> call() async {
    return await _repository.updateProfileContractUseCase();
  }
}
