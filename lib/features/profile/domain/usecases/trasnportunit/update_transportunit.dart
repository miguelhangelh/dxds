
import 'package:appdriver/features/models/brand_model.dart';
import 'package:appdriver/features/models/features_transport_unit_model.dart';
import 'package:appdriver/features/models/transport_unit_model.dart';
import 'package:appdriver/features/profile/domain/repositories/transportunit_repository.dart';


class UpdateTransportUnit {
  UpdateTransportUnit( {
    required TransportUnitRepository repository,
  } )  :
  _repository = repository;

  final TransportUnitRepository _repository;

  Future<TransportUnitModel?> call( {
    String? plate,
    String? country,
    String? color,
    String? companyGps,
    String? year,
    BrandModel? brand,
    String? type,
    String? fuelType,
    String? engine,
    List<FeaturesTransportUnitModel>? features,

  } ) async  {
    return await _repository.updateTransportUnit(
      plate: plate,
      color: color,
      brand: brand,
      companyGps:companyGps,
      country: country,
      year: year,
      type :type,
      fuelType: fuelType,
      engine: engine,
      features: features,
    );
  }

}
