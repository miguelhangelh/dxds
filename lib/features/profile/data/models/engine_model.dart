
import 'package:appdriver/features/profile/domain/entities/engine_entity.dart';

class EngineModel extends EngineEntity {

  EngineModel( {
    int? engine,
    String? fuelType,
  } ) : super(
    engine: engine,
    fuelType: fuelType,
  );

  EngineModel copyWith({
    int? engine,
    String? fuelType,
  }) {
    return EngineModel(
      engine   : engine ?? this.engine,
      fuelType : fuelType ?? this.fuelType,
    );
  }

  factory EngineModel.fromJson(Map<String, dynamic> json) => EngineModel(
      engine   : json.containsKey( 'engine' ) ? json["engine"] : '' as int?,
      fuelType : json.containsKey( 'fuelType' ) ? json["fuelType"] : '',
  );

  Map<String, dynamic> toJson() => {
      "engine"   : engine,
      "fuelType" : fuelType,
  };
}
