import 'package:appdriver/features/models/postulationRequest.dart';
import 'package:appdriver/features/opportunity/domain/repositories/oportunity_repository.dart';

class GetPostulationTruckUseCase {
  GetPostulationTruckUseCase({
    required OportunityRepository repository,
  }) : _repository = repository;

  final OportunityRepository _repository;

  Future<PostulationRequest?> call({String? travelId}) async {
    return await _repository.getPostulationTruck(travelId);
  }
}
