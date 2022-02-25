
import 'package:appdriver/features/models/brand_model.dart';
import 'package:appdriver/features/models/transport_unit_model.dart';
import 'package:appdriver/features/profile/domain/repositories/transportunit_repository.dart';


class RegisterUpdateTransportUnit {
  RegisterUpdateTransportUnit( {
    required TransportUnitRepository repository,
  } )  :
  _repository = repository;

  final TransportUnitRepository _repository;

  Future<TransportUnitModel> call( {
    String? plate,
    String? country,
    String? color,
    String? year,
    BrandModel? brand,
    String? type,

  } ) async  {
    return await _repository.registerUpdateTransportUnitData(
      plate: plate,
      color: color,
      brand: brand,
      country: country,
      year: year,
      type :type,

    );
  }

}
