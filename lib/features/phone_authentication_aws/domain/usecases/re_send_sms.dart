import 'package:appdriver/features/phone_authentication_aws/domain/repositories/phone_authentication_repository.dart';

class ResendSmsCodeUseCase {
  ResendSmsCodeUseCase({
    required PhoneAuthenticationRepository repository,
  }) : _repository = repository;

  final PhoneAuthenticationRepository _repository;

  /// Callable class method
  Future<void> call({String? username}) async => await _repository.resendCodeSMS(username);
}
