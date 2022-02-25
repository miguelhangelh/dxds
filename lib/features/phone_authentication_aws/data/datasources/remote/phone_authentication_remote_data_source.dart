import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PhoneAuthenticationRemoteDataSource {
  final Dio _dio =  Dio();

  Future<bool> login({
    required String username,
    required String? password,
  }) async {
    final SignInResult result = await Amplify.Auth.signIn(
      username: username.trim(),
      password: '12345678',
    );
    return result.isSignedIn;
  }
  Future<bool> userIsSpecial({required String username} ) async {
    username = username.replaceAll("+591", "");
    String url = dotenv.env['URL_VIP']! + "/users/phone/$username";
    Response response = await _dio.get(url);
    bool responseData = response.data['isSpecial'];
    var isUserIsSpecial = responseData;
    if (isUserIsSpecial) {
      return true;
    }
    return false;
  }
  Future<bool> signUp({
    required String username,
    required String? email,
    required String? password,
  }) async {
    String? token = await FirebaseMessaging.instance.getToken();
    Map<String, String> userAttributes = {
      'phone_number': username.trim(),
      'custom:token': token!,
    };
    final result = await Amplify.Auth.signUp(
      username: username.trim(),
      password: '12345678',
      options: CognitoSignUpOptions(userAttributes: userAttributes),
    );
    return result.isSignUpComplete;
  }

  Future<void> resendCodeSMS(String username) async {
    await Amplify.Auth.resendSignUpCode(username: username);
  }

  Future<bool> confirmSignUp({
    required String username,
    required String confirmationCode,
  }) async {
    final result = await Amplify.Auth.confirmSignUp(
      username: username.trim(),
      confirmationCode: confirmationCode.trim(),
    );
    return result.isSignUpComplete;
  }
}
