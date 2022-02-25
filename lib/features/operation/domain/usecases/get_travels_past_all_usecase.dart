import 'package:appdriver/features/models/operation_past_model.dart';
import 'package:appdriver/features/operation/domain/repositories/operation_repository.dart';

class GetTravelsPastAllUseCase {
  GetTravelsPastAllUseCase({
    required OperationRepository repository,
  })  :
        _repository = repository;

  final OperationRepository _repository;

  Future<TravelsPastModel?> call() async {
    return await _repository.getTravelsPastAll();
  }
}
