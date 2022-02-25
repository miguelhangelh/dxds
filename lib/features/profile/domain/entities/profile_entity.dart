
import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {

  final String? firstName;
  final String? lastName;
  final String? documentId;
  final String? taxId;
  final String? pathPhoto;
  final String? company;
  final String? birthDate;

  ProfileEntity( {
    this.firstName,
    this.lastName,
    this.documentId,
    this.taxId,
    this.pathPhoto,
    this.company,
    this.birthDate
  } );

  @override
  List<Object?> get props => [
    firstName, lastName, documentId, taxId,
    pathPhoto, company, birthDate,
  ];
  
}
