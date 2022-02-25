import 'package:appdriver/features/phone_authentication_aws/domain/repositories/phone_authentication_repository.dart';

class LoginUseCase {
  LoginUseCase({
    required PhoneAuthenticationRepository repository,
  }) : _repository = repository;

  final PhoneAuthenticationRepository _repository;

  /// Callable class method
  Future<bool> call({String? username, String? password}) async {
    return await _repository.login(username, password);
  }
}
