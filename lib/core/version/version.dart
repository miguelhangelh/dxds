import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Version {
  static final Version _instance = Version._();
  final Dio _dio = Dio();
  factory Version() {
    return _instance;
  }
  Version._();
  Future<bool> version() async {
    var packageInfo = await PackageInfo.fromPlatform();
    String url = dotenv.env['URL_VERSION']!;
    Response response = await _dio.get(url);
    var responseData = response.data['versions'];
    var version = responseData[0]['versionApp'];
    var currentVersion = packageInfo.version;
    // var currentVersion = "3.0.46";
    if (currentVersion != version ) {
      return true;
    }
    return false;
  }
}
