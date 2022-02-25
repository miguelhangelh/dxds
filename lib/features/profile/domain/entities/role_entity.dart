
import 'package:equatable/equatable.dart';

class RoleEntity extends Equatable {

  final String? module;
  final bool? create;
  final bool? read;
  final bool? update;
  final bool? delete;
  final bool? admin;

  RoleEntity( {
    this.module,
    this.create,
    this.read,
    this.update,
    this.delete,
    this.admin,
  } );

  @override
  List<Object?> get props => [
    module,
    create,
    read,
    update,
    delete,
    admin,
  ];
  
}
