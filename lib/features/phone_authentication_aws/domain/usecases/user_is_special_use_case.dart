import 'package:appdriver/features/phone_authentication_aws/domain/repositories/phone_authentication_repository.dart';

class UserIsSpecialUseCase {
  UserIsSpecialUseCase({
    required PhoneAuthenticationRepository repository,
  }) : _repository = repository;

  final PhoneAuthenticationRepository _repository;

  Future<bool> call({ required String username}) async {
    return await _repository.userIsSpecial(username: username);
  }
}
