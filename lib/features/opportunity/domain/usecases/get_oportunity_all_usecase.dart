import 'package:appdriver/features/opportunity/presentation/bloc/opportunity_bloc.dart';
import 'package:appdriver/features/models/travel_model.dart';
import 'package:appdriver/features/opportunity/domain/repositories/oportunity_repository.dart';

class GetOportunityAllUseCase {
  GetOportunityAllUseCase({
    required OportunityRepository repository,
  })  :
        _repository = repository;

  final OportunityRepository _repository;

  Future<List<TravelModel>> call({
    int? page,
    DateTime? end,
    DateTime? start,
    String? category,
    TypeFilter? typeFilter,
  }) async {
    return await _repository.getOpportunityAll(page: page , end: end, start: start, category: category, typeFilter: typeFilter);
  }
}
