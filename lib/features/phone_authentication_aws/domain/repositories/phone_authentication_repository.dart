abstract class PhoneAuthenticationRepository {
  Future<bool> login(String? username, String? password);
  Future<bool> signUp(String? username, String? email, String? password);
  Future<bool> confirmSignUp(String? username, String? confirmationCode);
  Future<void> resendCodeSMS(String? username);
  Future<bool> userIsSpecial({required String username});
}
