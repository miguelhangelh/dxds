import 'package:appdriver/features/phone_authentication_aws/data/datasources/remote/phone_authentication_remote_data_source.dart';
import 'package:appdriver/features/phone_authentication_aws/domain/repositories/phone_authentication_repository.dart';

class PhoneAuthenticationRepositoryImplementation implements PhoneAuthenticationRepository {
  final PhoneAuthenticationRemoteDataSource remoteDataSource;

  PhoneAuthenticationRepositoryImplementation({
    required this.remoteDataSource,
  });

  @override
  Future<bool> confirmSignUp(String? username, String? confirmationCode) async {
    return await remoteDataSource.confirmSignUp(username: username!, confirmationCode: confirmationCode!);
  }

  @override
  Future<bool> login(String? username, String? password) async {
    return await remoteDataSource.login(username: username!, password: password);
  }

  @override
  Future<bool> signUp(String? username, String? email, String? password) async {
    return await remoteDataSource.signUp(username: username!, email: email, password: password);
  }

  @override
  Future<void> resendCodeSMS(String? username) async {
    return await remoteDataSource.resendCodeSMS(username!);
  }

  @override
  Future<bool> userIsSpecial({required String username}) async {
    return await remoteDataSource.userIsSpecial(username: username);
  }
}
