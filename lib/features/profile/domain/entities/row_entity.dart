
import 'package:equatable/equatable.dart';

class RowEntity extends Equatable {

  final String? createDate;
  final String? updateDate;
  final String? disableDate;

  RowEntity( {
    this.createDate,
    this.updateDate,
    this.disableDate,
  } );

  @override
  List<Object?> get props => [
    createDate,
    updateDate,
    disableDate,
  ];
  
}
