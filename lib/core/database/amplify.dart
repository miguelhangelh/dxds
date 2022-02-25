import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:appdriver/amplifyconfiguration.dart';

class AmplifyConfigure {
  static final AmplifyConfigure _instance = AmplifyConfigure._();
  StreamSubscription? authStreamSub;

  factory AmplifyConfigure() {
    return _instance;
  }
  AmplifyConfigure._();
  Future<void> initAmplifyConfigure() async {
    AmplifyAuthCognito authPlugin = AmplifyAuthCognito();
    AmplifyStorageS3 amplifyStorageS3 = AmplifyStorageS3();
    await Amplify.addPlugins([authPlugin, amplifyStorageS3]);
    try {
      await Amplify.configure(amplifyconfig);
    } catch (_) {}
  }
}

// flutter packages pub run build_runner build
