import 'package:appdriver/features/notification/data/models/notification_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:appdriver/core/error/api_helper.dart';
import 'package:appdriver/core/share_prefs/user_pref.dart';
import 'package:appdriver/features/models/new_model.dart';

class NewsDataSourceRemote {
  final ApiBaseHelper _helper =  ApiBaseHelper();
  UserPreference userPreference =  UserPreference();
  Future<List<NotificationModel>> getNotificationsAll({int? page = 0, String? type}) async {
    var user = userPreference.getUser;
    var url = dotenv.env['URL_NOTIFICATION']! + "/user/" + user.id!;
    var response = await _helper.getPages(url, {'page': page, 'size': 10});
    var data = response['notifications'] as List;
    List<NotificationModel> notifications = data.map<NotificationModel>((e) => NotificationModel.fromJson(e)).toList();
    return notifications;
  }

  Future<List<NewModel>> getNewsAll({int? page = 0}) async {
    var url = dotenv.env['URL_NEW'];
    var response = await _helper.getPages(url, {'page': page, 'size': 10, 'app': true});
    var data = response['news'] as List;
    List<NewModel> notifications = data.map<NewModel>((e) => NewModel.fromJson(e)).toList();
    return notifications;
  }
}
