import 'package:appdriver/features/models/postulationRequest.dart';
import 'package:appdriver/features/opportunity/domain/repositories/oportunity_repository.dart';

class ConfirmPostulationUseCase {
  ConfirmPostulationUseCase({
    required OportunityRepository repository,
  }) : _repository = repository;

  final OportunityRepository _repository;

  Future<PostulationRequest?> call({PostulationRequest? postulation}) async {
    return await _repository.confirmPostulation(postulation);
  }
}
