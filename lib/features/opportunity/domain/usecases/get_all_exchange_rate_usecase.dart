import 'package:appdriver/features/models/echange_rate_model.dart';
import 'package:appdriver/features/opportunity/domain/repositories/oportunity_repository.dart';

class GetAllExchangeRateUseCase {
  GetAllExchangeRateUseCase({
    required OportunityRepository repository,
  }) : _repository = repository;

  final OportunityRepository _repository;

  Future<List<ExchangeRate>> call() async {
    return await _repository.getAllExchangeRate();
  }
}
