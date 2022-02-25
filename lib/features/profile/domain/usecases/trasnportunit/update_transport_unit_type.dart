
import 'package:appdriver/features/profile/domain/repositories/transportunit_repository.dart';


class UpdateTransportUnitType {
  UpdateTransportUnitType( {
    required TransportUnitRepository repository,
  } )  :
  _repository = repository;

  final TransportUnitRepository _repository;

  Future<String> call( {
   
    String? type,

  } ) async  {
    return await _repository.updateTransportUnitType(
      type: type,
    );
  }

}
