import 'package:appdriver/features/models/category_model.dart';
import 'package:appdriver/features/opportunity/domain/repositories/oportunity_repository.dart';

class GetCategoryAllUseCase {
  GetCategoryAllUseCase({
    required OportunityRepository repository,
  }) : _repository = repository;

  final OportunityRepository _repository;

  Future<List<CategoryModel>> call() async {
    return await _repository.getCategoryAll();
  }
}
