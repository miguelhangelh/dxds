import 'package:appdriver/features/profile/domain/repositories/profile_repository.dart';

class AddProfileUseCase {
  AddProfileUseCase({
    required ProfileRepository repository,
  })  :
        _repository = repository;

  final ProfileRepository _repository;

  Future<String> call({
    String? firstName,
    String? lastName,
    String? documentId,
    String? birthDate,
  }) async {
    return await _repository.addProfile(
      firstName: firstName,
      lastName: lastName,
      documentId: documentId,
      birthDate: birthDate,
    );
  }
}
