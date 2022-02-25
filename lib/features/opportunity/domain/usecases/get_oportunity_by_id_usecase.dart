import 'package:appdriver/features/models/travel_model.dart';
import 'package:appdriver/features/opportunity/domain/repositories/oportunity_repository.dart';

class GetOportunityByIdUseCase {
  GetOportunityByIdUseCase({
    required OportunityRepository repository,
  })  :
        _repository = repository;

  final OportunityRepository _repository;

  Future<TravelModel> call({
    String? travelId,
  }) async {
    return await _repository.getOpportunityById(travelId: travelId);
  }
}
