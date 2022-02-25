
import 'package:appdriver/features/profile/domain/repositories/transportunit_repository.dart';
import 'package:appdriver/features/profile/presentation/widgets/transport_type.dart';

class GetTransportUnitTypes {

  GetTransportUnitTypes( {
    required TransportUnitRepository repository,
  } )  :
    _repository = repository;

  final TransportUnitRepository _repository;

  /// Callable class method

  Future<List<TransportUnitType>> call()  async{
    return await _repository.getTransportUnitTypes();
  }
  
}
