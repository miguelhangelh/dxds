import 'package:appdriver/features/models/new_model.dart';
import 'package:appdriver/features/notification/data/models/notification_model.dart';

abstract class NewsRepository {
  Future<List<NewModel>> getNewsAll({int? page});
  Future<List<NotificationModel>> getNotificationsAll({
    int? page,
    String? type,
  });
}
