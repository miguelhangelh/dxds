import 'package:appdriver/features/notification/data/models/notification_model.dart';
import 'package:appdriver/features/notification/domain/repositories/news_repository.dart';

class GetNotificationsAllUseCase {
  GetNotificationsAllUseCase({
    required NewsRepository repository,
  }) : _repository = repository;

  final NewsRepository _repository;

  Future<List<NotificationModel>> call({
    int? page,
    String? type,
  }) async {
    return await _repository.getNotificationsAll(page: page, type: type);
  }
}
