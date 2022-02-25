import 'package:appdriver/features/models/travel_model.dart';
import 'package:appdriver/features/opportunity/domain/repositories/oportunity_repository.dart';

class GetOpportunityAllRoundTripUseCase {
  GetOpportunityAllRoundTripUseCase({
    required OportunityRepository repository,
  }) : _repository = repository;

  final OportunityRepository _repository;

  Future<List<TravelModel>> call(TravelModel travel) async {
    return await _repository.getOpportunityAllRoundTrip(travel);
  }
}
