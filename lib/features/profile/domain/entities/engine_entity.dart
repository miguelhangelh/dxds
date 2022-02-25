
import 'package:equatable/equatable.dart';

class EngineEntity extends Equatable {

  final int? engine;
  final String? fuelType;

  EngineEntity( {
    this.engine,
    this.fuelType,
  } );

  @override
  List<Object?> get props => [
    engine,
    fuelType,
  ];
  
}
