import 'package:appdriver/features/models/new_model.dart';
import 'package:appdriver/features/notification/domain/repositories/news_repository.dart';

class GetNewsAllUseCase {
  GetNewsAllUseCase({
    required NewsRepository repository,
  }) : _repository = repository;

  final NewsRepository _repository;

  Future<List<NewModel>> call({int? page}) async {
    return await _repository.getNewsAll(page: page);
  }
}
