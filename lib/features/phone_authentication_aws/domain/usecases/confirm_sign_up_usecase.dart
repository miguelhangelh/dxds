import 'package:appdriver/features/phone_authentication_aws/domain/repositories/phone_authentication_repository.dart';

class ConfirmSignUpUseCase {
  ConfirmSignUpUseCase({
    required PhoneAuthenticationRepository repository,
  }) : _repository = repository;

  final PhoneAuthenticationRepository _repository;

  /// Callable class method
  Future<bool> call({String? username, String? confirmationCode}) async => await _repository.confirmSignUp(username, confirmationCode);
}
