
import 'package:equatable/equatable.dart';

class CompanyEntity extends Equatable {

  final String? companyId;
  final String? assignationDate;
  final bool? active;

  CompanyEntity( {
    this.companyId,
    this.assignationDate,
    this.active,
  } );

  @override
  List<Object?> get props => [
    companyId,
    assignationDate,
    active,
  ];
  
}
