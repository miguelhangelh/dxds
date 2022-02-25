import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:appdriver/core/error/api_helper.dart';
import 'package:appdriver/features/models/user_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthenticationRemoteDataSource {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();
  Future<String?> _getUserIdFromAttributes() async {
    try {
      final attributes = await Amplify.Auth.fetchUserAttributes();
      final userId = attributes.firstWhere((element) => element.userAttributeKey == 'sub').value;
      return userId;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTokenNotification(UserModel user, String token) async {
    String? userId = await _getUserIdFromAttributes();
    var data = {
      "userId": userId,
      "pushToken": token,
      "phone": user.auth!.phone,
      "countryCode": user.auth!.countryCode,
    };
    var url = dotenv.env['URL_USER']! + "/pushTokenNotification";
    await _apiBaseHelper.post(url, data);
  }

  Future<void> signOut() async {
    await Amplify.Auth.signOut();
  }

  Future<bool> attemptAutoLogin() async {
    try {
      final AuthSession session = await Amplify.Auth.fetchAuthSession();
      return session.isSignedIn;
    } catch (e) {
      return false;
    }
  }
}
