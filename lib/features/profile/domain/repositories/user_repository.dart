

import 'package:appdriver/features/profile/data/models/account_model.dart';
import 'package:appdriver/features/profile/data/models/address_model.dart';
import 'package:appdriver/features/profile/data/models/auth_model.dart';
import 'package:appdriver/features/profile/data/models/device_model.dart';
import 'package:appdriver/features/profile/data/models/profile_model.dart';
import 'package:appdriver/features/profile/data/models/resource_model.dart';
import 'package:appdriver/features/profile/data/models/role_model.dart';
import 'package:appdriver/features/profile/data/models/user_model.dart';

abstract class UserRepository {

  void addUser( {
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

  List<UserModel> getUser();

}
