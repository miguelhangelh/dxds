import 'package:appdriver/features/models/user_model.dart';
import 'package:appdriver/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfileUseCase {
  UpdateProfileUseCase({
    required ProfileRepository repository,
  })  :
        _repository = repository;

  final ProfileRepository _repository;

  Future<UserModel> call({
    String? firstName,
    String? lastName,
    String? documentId,
    String? birthDate,
    String? pathPhoto,
    String? timezone,
    String? taxId,
    String? personReference,
    String? phoneReference,
    String? companyId,
    String? postalCode,
    String? country,
    String? city,
    String? states,
    String? street,
  }) async {
    return await _repository.updateProfile(
      firstName: firstName,
      lastName: lastName,
      documentId: documentId,
      birthDate: birthDate,
      taxId: taxId,
      pathPhoto: pathPhoto,
      timezone: timezone,
      companyId: companyId,
      personReference: personReference,
      phoneReference: phoneReference,
      postalCode: postalCode,
      country: country,
      city: city,
      states: states,
      street: street,
    );
  }
}
