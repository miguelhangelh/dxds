import 'package:appdriver/features/models/user_model.dart';
import 'package:appdriver/features/profile/domain/repositories/profile_repository.dart';

class GetUserByIdUsecase {
  GetUserByIdUsecase({
    required ProfileRepository repository,
  })  :
        _repository = repository;

  final ProfileRepository _repository;

  /// Callable class method

  Future<UserModel?> call() async {
    return await _repository.getUerById();
  }
}
