
import 'package:appdriver/features/models/brand_model.dart';
import 'package:appdriver/features/models/features_transport_unit_model.dart';
import 'package:appdriver/features/profile/domain/repositories/transportunit_repository.dart';


class AddTransportUnit {
  AddTransportUnit( {
    required TransportUnitRepository repository,
  } )  :
  _repository = repository;

  final TransportUnitRepository _repository;

  Future<String> call( {
    String? plate,
    String? country,
    String? color,
    String? year,
    BrandModel? brand,
    int? numberOfShafts,
    int? storageCapacity,
    String? type,
    int? volumeCapacity,
    List<FeaturesTransportUnitModel>? features,

  } ) async  {
    return await _repository.addTransportUnit(
      plate: plate,
      color: color,
      brand: brand,
      country: country,
      year: year,
      numberOfShafts: numberOfShafts,
      storageCapacity: storageCapacity,
      type: type,
      volumeCapacity: volumeCapacity,
      features: features,
    );
  }

}
