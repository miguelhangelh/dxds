
import 'package:appdriver/features/models/brand_model.dart';
import 'package:appdriver/features/profile/domain/repositories/transportunit_repository.dart';

class GetTransportUnitBrands {

  GetTransportUnitBrands( {
    required TransportUnitRepository repository,
  } )  :
    _repository = repository;

  final TransportUnitRepository _repository;

  /// Callable class method

  Future<List<BrandModel>> call()  async{
    return await _repository.getAllBrands();
  }
  
}
