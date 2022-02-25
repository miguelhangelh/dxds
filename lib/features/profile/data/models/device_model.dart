

import 'package:appdriver/features/profile/domain/entities/device_entity.dart';

class DeviceModel extends DeviceEntity {

  DeviceModel( {
    String? pushToken,
    String? phone,
    String? registerDate,
    String? lastAccessDate,
    String? countryCode,
  } ) : super(
    pushToken: pushToken,
    phone: phone,
    registerDate: registerDate,
    lastAccessDate: lastAccessDate,
    countryCode: countryCode,
  );

  DeviceModel copyWith({
    String? pushToken,
    String? phone,
    String? registerDate,
    String? lastAccessDate,
    String? countryCode,
  }) {
    return DeviceModel(
      pushToken      : pushToken ?? this.pushToken,
      phone          : phone ?? this.phone,
      registerDate   : registerDate ?? this.registerDate,
      lastAccessDate : lastAccessDate ?? this.lastAccessDate,
      countryCode    : countryCode ?? this.countryCode,
    );
  }

  

  factory DeviceModel.fromJson(Map<String, dynamic> json) => DeviceModel(
      pushToken      : json.containsKey( 'pushToken' ) ? json["pushToken"] : '',
      phone          : json.containsKey( 'phone' ) ? json["phone"] : '',
      registerDate   : json.containsKey( 'registerDate' ) ? json["registerDate"] : '',
      lastAccessDate : json.containsKey( 'lastAccessDate' ) ? json["lastAccessDate"] : '',
      countryCode    : json.containsKey( 'countryCode' ) ? json["countryCode"] : '',
  );

  Map<String, dynamic> toJson() => {
      "pushToken"      : pushToken,
      "phone"          : phone,
      "registerDate"   : registerDate,
      "lastAccessDate" : lastAccessDate,
      "countryCode"    : countryCode,
  };
}
