

import 'package:appdriver/features/profile/domain/entities/auth_entity.dart';

class AuthModel extends AuthEntity {

  AuthModel( {
    String? phone,
    String? email,
    bool? confirmed,
    String? countryCode,
    String? token,
  } ) : super(
    phone: phone,
    email: email,
    confirmed: confirmed,
    countryCode: countryCode,
    token: token,
  );

  AuthModel copyWith({
    String? phone,
    String? email,
    bool? confirmed,
    String? countryCode,
    String? token,
  }) {
    return AuthModel(
      phone        : phone ?? this.phone,
      email        : email ?? this.email,
      confirmed    : confirmed ?? this.confirmed,
      countryCode  : countryCode ?? this.countryCode,
      token        : token ?? this.token,
    );
  }


  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
    phone        : json.containsKey( 'phone' )       ? json["phone"] : '',
    email        : json.containsKey( 'email' )       ? json["email"] : '',
    confirmed    : json.containsKey( 'confirmed' )   ? json["confirmed"] : '' as bool?,
    countryCode  : json.containsKey( 'countryCode' ) ? json["countryCode"] : '',
    token        : json.containsKey( 'token' )       ? json["token"] : '',
  );

  Map<String, dynamic> toJson() => {
    "phone"        : phone,
    "email"        : email,
    "confirmed"    : confirmed,
    "countryCode"  : countryCode,
    "token"        : token,
  };
}