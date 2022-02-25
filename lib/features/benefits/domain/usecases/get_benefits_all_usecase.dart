import 'package:appdriver/features/benefits/data/models/benefit_model.dart';
import 'package:appdriver/features/benefits/domain/repositories/benefits_repository.dart';

class GetBenefitsAllUseCase {
  GetBenefitsAllUseCase({
    required BenefitsRepository repository,
  }) : _repository = repository;

  final BenefitsRepository _repository;

  Future<List<BenefitModel>> call() async {
    return await _repository.getBenefitsAll();
  }
}
