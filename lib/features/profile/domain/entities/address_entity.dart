
import 'package:equatable/equatable.dart';

class AddresstEntity extends Equatable {

  final String? country;
  final String? city;
  final String? states;
  final String? street;
  final String? postalCode;

  AddresstEntity( {
    this.country,
    this.city,
    this.states,
    this.street,
    this.postalCode,
  } );

  @override
  List<Object?> get props => [
    country,
    city,
    states,
    street,
    postalCode,
  ];
  
}
