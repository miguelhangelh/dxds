
import 'package:appdriver/features/models/rating_model.dart';
import 'package:appdriver/features/models/travel_model.dart';
import 'package:appdriver/features/operation/domain/repositories/operation_repository.dart';

class GetRatingOperationUseCase {
  GetRatingOperationUseCase({
    required OperationRepository repository,
  })  :
        _repository = repository;

  final OperationRepository _repository;

  /// Callable class method
  Future<Rating?> call({TravelModel? travel}) async {
    return await  _repository.getRating(travel:travel);
  }
}
