
import 'package:appdriver/features/models/rating_model.dart';
import 'package:appdriver/features/profile/domain/repositories/profile_repository.dart';

class GetRating {

  GetRating( {
    required ProfileRepository repository,
  } )  :
    _repository = repository;

  final ProfileRepository _repository;

  /// Callable class method

  Future<RatingModel?> call() async {
    return await _repository.getRatings();
  }
  
}
