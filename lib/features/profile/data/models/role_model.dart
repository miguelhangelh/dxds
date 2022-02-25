


import 'package:appdriver/features/profile/domain/entities/role_entity.dart';

class RoleModel extends RoleEntity {

  RoleModel( {
    String? module,
    bool? create,
    bool? read,
    bool? update,
    bool? delete,
    bool? admin,
  } ) : super(
    module: module,
    create: create,
    read: read,
    update: update,
    delete: delete,
    admin: admin,
  );

  RoleModel copyWith({
    String? module,
    bool? create,
    bool? read,
    bool? update,
    bool? delete,
    bool? admin,
  }) {
    return RoleModel(
      module  : module ?? this.module,
      create  : create ?? this.create,
      read    : read ?? this.read,
      update  : update ?? this.update,
      delete  : delete ?? this.delete,
      admin   : admin ?? this.admin,
    );
  }

  factory RoleModel.fromJson(Map<String, dynamic> json) => RoleModel(
      module  : json.containsKey( 'module' ) ? json["module"] : '',
      create  : json.containsKey( 'create' ) ? json["create"] : '' as bool?,
      read    : json.containsKey( 'read' ) ? json["read"] : '' as bool?,
      update  : json.containsKey( 'update' ) ? json["update"] : '' as bool?,
      delete  : json.containsKey( 'delete' ) ? json["delete"] : '' as bool?,
      admin   : json.containsKey( 'admin' ) ? json["admin"] : '' as bool?,
  );

  Map<String, dynamic> toJson() => {
      "module"  : module,
      "create"  : create,
      "read"    : read,
      "update"  : update,
      "delete"  : delete,
      "admin"   : admin,
  };
}