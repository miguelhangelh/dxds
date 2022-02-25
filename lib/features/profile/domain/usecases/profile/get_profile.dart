
import 'package:appdriver/features/profile/data/models/profile_model.dart';
import 'package:appdriver/features/profile/domain/repositories/profile_repository.dart';

class GetProfile {

  GetProfile( {
    required ProfileRepository repository,
  } )  :
    _repository = repository;

  final ProfileRepository _repository;

  /// Callable class method

  List<ProfileModel> call()  {
    return _repository.getProfile();
  }
  
}
