// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

import 'package:appdriver/features/profile/data/models/account_model.dart';
import 'package:appdriver/features/profile/data/models/address_model.dart';
import 'package:appdriver/features/profile/data/models/device_model.dart';
import 'package:appdriver/features/profile/data/models/profile_model.dart';
import 'package:appdriver/features/profile/data/models/resource_model.dart';
import 'package:appdriver/features/profile/data/models/role_model.dart';
import 'package:appdriver/features/profile/domain/entities/user_entity.dart';

import 'auth_model.dart';

UserModel userFromJson(String str) => UserModel.fromJson(json.decode(str));

String userToJson(UserModel data) => json.encode(data.toJson());

class UserModel extends UserEntity {
  
  UserModel( {
    String? userId,
    String? type,
    AuthModel? auth,
    List<DeviceModel>? devices,
    ProfileModel? profile,
    List<AddressModel>? address,
    List<RoleModel>? roles,
    List<ResourceModel>? resources,
    AccountModel? account,
  } );

  UserModel copyWith({
    String? userId,
    String? type,
    AuthModel? auth,
    List<DeviceModel>? devices,
    ProfileModel? profile,
    List<AddressModel>? address,
    List<RoleModel>? roles,
    List<ResourceModel>? resources,
    AccountModel? account,
  }) {
    return UserModel(
      userId     : userId ?? this.userId,
      type       : type ?? this.type,
      auth       : auth ?? this.auth,
      devices    : devices ?? this.devices,
      profile    : profile ?? this.profile,
      address    : address ?? this.address,
      roles      : roles ?? this.roles,
      resources  : resources ?? this.resources,
      account    : account ?? this.account,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      userId     : json.containsKey( 'userId' ) ? json["userId"] : '',
      type       : json.containsKey( 'type' ) ? json["type"] : '',
      auth       : json.containsKey( 'auth' ) ? AuthModel.fromJson(json["auth"]) : null,
      devices    : json.containsKey( 'devices' ) ? List<DeviceModel>.from(json["devices"].map((x) => DeviceModel.fromJson(x))) : [],
      profile    : json.containsKey( 'profile' ) ? ProfileModel.fromJson(json["profile"]) : null,
      address    : json.containsKey( 'address' ) ? List<AddressModel>.from(json["address"].map((x) => AddressModel.fromJson(x))) : [],
      roles      : json.containsKey( 'roles' ) ? List<RoleModel>.from(json["roles"].map((x) => RoleModel.fromJson(x))) : [],
      resources  : json.containsKey( 'resources' ) ? List<ResourceModel>.from(json["resources"].map((x) => ResourceModel.fromJson(x))) : [],
      account    : json.containsKey( 'account' ) ? AccountModel.fromJson(json["account"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "userId"     : userId,
    "type"       : type,
    "auth"       : auth!.toJson(),
    "devices"    : List<dynamic>.from(devices!.map((x) => x.toJson())),
    "profile"    : profile!.toJson(),
    "address"    : List<dynamic>.from(address!.map((x) => x.toJson())),
    "roles"      : List<dynamic>.from(roles!.map((x) => x.toJson())),
    "resources"  : List<dynamic>.from(resources!.map((x) => x.toJson())),
    "account"    : account!.toJson(),
  };
}

