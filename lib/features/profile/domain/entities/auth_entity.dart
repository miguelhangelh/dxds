
import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {

  final String? phone;
  final String? email;
  final bool? confirmed;
  final String? countryCode;
  final String? token;

  AuthEntity( {
    this.phone,
    this.email,
    this.confirmed,
    this.countryCode,
    this.token,
  } );

  @override
  List<Object?> get props => [
    phone,
    email,
    confirmed,
    countryCode,
    token,
  ];
  
}
