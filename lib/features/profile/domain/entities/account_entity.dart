
import 'package:equatable/equatable.dart';

class AccountEntity extends Equatable {

  final String? disableDate;
  final String? createDate;
  final String? updateDate;

  AccountEntity( {
    this.disableDate,
    this.createDate,
    this.updateDate,
  } );

  @override
  List<Object?> get props => [
    disableDate,
    createDate,
    updateDate,
  ];
  
}
