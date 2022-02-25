
import 'package:appdriver/features/models/user_model.dart';
import 'package:appdriver/features/profile/domain/repositories/profile_repository.dart';

class DeleteProfileResourceUseCase {
  DeleteProfileResourceUseCase({
    required ProfileRepository repository,
  })  :
        _repository = repository;

  final ProfileRepository _repository;

  Future<UserModel> call({
    String? type,
  }) async {
    return await _repository.deleteProfileResource(
      type: type,
    );
  }
}
