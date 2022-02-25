
import 'package:appdriver/features/models/user_model.dart';

abstract class AuthenticationRepository {
  Future<void> signOut();
  Future<bool> attemptAutoLogin();
  Future<void> updateTokenNotification(UserModel user ,String token) ;
}
