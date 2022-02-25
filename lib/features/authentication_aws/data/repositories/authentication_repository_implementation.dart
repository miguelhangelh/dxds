import 'package:appdriver/features/models/user_model.dart';
import 'package:appdriver/features/authentication_aws/data/datasources/remote/authentication_remote_data_source.dart';
import 'package:appdriver/features/authentication_aws/domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImplementation implements AuthenticationRepository {
  final AuthenticationRemoteDataSource remoteDataSource;

  AuthenticationRepositoryImplementation({
    required this.remoteDataSource,
  });

  @override
  Future<bool> attemptAutoLogin() async {
    return await remoteDataSource.attemptAutoLogin();
  }

  @override
  Future<void> updateTokenNotification(UserModel user, String token) async => await remoteDataSource.updateTokenNotification(user, token);

  @override
  Future<void> signOut() async {
    return await remoteDataSource.signOut();
  }
}
