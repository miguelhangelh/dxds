import 'package:appdriver/features/models/travel_model.dart';
import 'package:appdriver/features/opportunity/domain/repositories/oportunity_repository.dart';

class GetOpportunityAllPaymentsUseCase {
  GetOpportunityAllPaymentsUseCase({
    required OportunityRepository repository,
  }) : _repository = repository;

  final OportunityRepository _repository;

  Future<List<TravelModel>> call({
    int? page,
    String? typeFilter,
  }) async {
    return await _repository.getOpportunityAllPayments(page: page, typeFilter: typeFilter);
  }
}
