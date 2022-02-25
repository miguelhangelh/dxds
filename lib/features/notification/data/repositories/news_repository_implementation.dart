import 'package:appdriver/features/notification/data/models/notification_model.dart';
import 'package:appdriver/features/notification/domain/repositories/news_repository.dart';
import 'package:appdriver/features/models/new_model.dart';
import 'package:appdriver/features/notification/data/datasources/remote/news_datasource_remote.dart';

class NewsRepositoryImplementation extends NewsRepository {
  final NewsDataSourceRemote newsDataSourceRemote;
  NewsRepositoryImplementation({required this.newsDataSourceRemote});
  @override
  Future<List<NewModel>> getNewsAll({int? page}) async {
    return await newsDataSourceRemote.getNewsAll(page: page);
  }

  @override
  Future<List<NotificationModel>> getNotificationsAll({
    int? page,
    String? type,
  }) async {
    return await newsDataSourceRemote.getNotificationsAll(page: page, type: type);
  }
}
