
import 'package:equatable/equatable.dart';
import 'package:appdriver/features/profile/data/models/account_model.dart';
import 'package:appdriver/features/profile/data/models/address_model.dart';
import 'package:appdriver/features/profile/data/models/auth_model.dart';
import 'package:appdriver/features/profile/data/models/device_model.dart';
import 'package:appdriver/features/profile/data/models/profile_model.dart';
import 'package:appdriver/features/profile/data/models/resource_model.dart';
import 'package:appdriver/features/profile/data/models/role_model.dart';

class UserEntity extends Equatable {

  final String? userId;
  final String? type;
  final AuthModel? auth;
  final List<DeviceModel>? devices;
  final ProfileModel? profile;
  final List<AddressModel>? address;
  final List<RoleModel>? roles;
  final List<ResourceModel>? resources;
  final AccountModel? account;

  UserEntity( {
    this.userId,
    this.type,
    this.auth,
    this.devices,
    this.profile,
    this.address,
    this.roles,
    this.resources,
    this.account
  } );

  @override
  List<Object?> get props => [
    userId,
    type,
    auth,
    devices,
    profile,
    address,
    roles,
    resources,
    account,
  ];
  
}
