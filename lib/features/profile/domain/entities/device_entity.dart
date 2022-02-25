
import 'package:equatable/equatable.dart';

class DeviceEntity extends Equatable {

  final String? pushToken;
  final String? phone;
  final String? registerDate;
  final String? lastAccessDate;
  final String? countryCode;

  DeviceEntity( {
    this.pushToken,
    this.phone,
    this.registerDate,
    this.lastAccessDate,
    this.countryCode,
  } );

  @override
  List<Object?> get props => [
    pushToken,
    phone,
    registerDate,
    lastAccessDate,
    countryCode,
  ];
  
}
