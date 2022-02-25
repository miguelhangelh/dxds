
import 'package:appdriver/features/models/transport_unit_model.dart';
import 'package:appdriver/features/profile/domain/repositories/transportunit_repository.dart';

class GetTransportUnit {

  GetTransportUnit( {
    required TransportUnitRepository repository,
  } )  :
    _repository = repository;

  final TransportUnitRepository _repository;

  /// Callable class method

  List<TransportUnitModel> call()  {
    return _repository.getTransportUnit();
  }
  
}
