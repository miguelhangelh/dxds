import 'package:appdriver/features/phone_authentication_aws/domain/repositories/phone_authentication_repository.dart';

class SignUpUseCase {
  SignUpUseCase({
    required PhoneAuthenticationRepository repository,
  }) : _repository = repository;

  final PhoneAuthenticationRepository _repository;

  /// Callable class method
  Future<bool> call({String? username, String? email, String? password}) async => await _repository.signUp(username, email, password);
}
