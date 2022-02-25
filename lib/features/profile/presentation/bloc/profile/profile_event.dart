part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

class ProfileFirstNameChanged extends ProfileEvent {
  final String? firstName;

  ProfileFirstNameChanged({this.firstName});
}

class ProfileCountyChanged extends ProfileEvent {
  final String? country;

  ProfileCountyChanged({this.country});
}

class ProfileSignedContract extends ProfileEvent {
  final bool signedContract;

  ProfileSignedContract({required this.signedContract});
}

class DownloadPDF extends ProfileEvent {}

class ProfileStreetChanged extends ProfileEvent {
  final String? street;

  ProfileStreetChanged({this.street});
}

class ProfileStatesChanged extends ProfileEvent {
  final String? states;

  ProfileStatesChanged({this.states});
}

class ProfileCityChanged extends ProfileEvent {
  final String? city;

  ProfileCityChanged({this.city});
}

class ProfilePostalCodeChanged extends ProfileEvent {
  final String? postalCode;

  ProfilePostalCodeChanged({this.postalCode});
}

class ProfileLastNameChanged extends ProfileEvent {
  final String? lastName;

  ProfileLastNameChanged({this.lastName});
}

class ProfileLastTaxId extends ProfileEvent {
  final String? taxId;

  ProfileLastTaxId({this.taxId});
}

class ProfilePhoneReference extends ProfileEvent {
  final String? phoneReference;

  ProfilePhoneReference({this.phoneReference});
}

class ProfilePersonReference extends ProfileEvent {
  final String? personReference;

  ProfilePersonReference({this.personReference});
}

class ProfileDocumentIdChanged extends ProfileEvent {
  final String? documentId;

  ProfileDocumentIdChanged({this.documentId});
}

class ProfileBirthDateChanged extends ProfileEvent {
  final String? birthDate;

  ProfileBirthDateChanged({this.birthDate});
}

class ProfileExtensionDniChanged extends ProfileEvent {
  final Departments? departments;

  ProfileExtensionDniChanged({this.departments});
}

class ProfileSubmitted extends ProfileEvent {}
class ProfileContractSubmitted extends ProfileEvent {}

class ProfileUpdateSubmitted extends ProfileEvent {}

class ProfileUpdateProfileSubmitted extends ProfileEvent {
  final Departments? departments;

  ProfileUpdateProfileSubmitted({this.departments});
}

class ProfileGetUser extends ProfileEvent {}

class ProfileGetRating extends ProfileEvent {}

class ProfileRefreshGetUser extends ProfileEvent {}

class ProfileUpdatePathPhoto extends ProfileEvent {
  final File? filePhoto;

  ProfileUpdatePathPhoto({this.filePhoto});
}

class ProfileUpdateDocumentBack extends ProfileEvent {
  final File? filePhoto;

  ProfileUpdateDocumentBack({this.filePhoto});
}

class ProfileUpdateDocumentFront extends ProfileEvent {
  final File? filePhoto;
  ProfileUpdateDocumentFront({this.filePhoto});
}

class ProfileUpdateDocumentLicence extends ProfileEvent {
  final File? filePhoto;
  ProfileUpdateDocumentLicence({this.filePhoto});
}

class ProfileRemoveResource extends ProfileEvent {
  final String? type;
  ProfileRemoveResource({this.type});
}

class ProfilePersonReferenceChanged extends ProfileEvent {
  final String? personReference;

  ProfilePersonReferenceChanged({this.personReference});
}

class ProfileEditing extends ProfileEvent {
  final bool? editing;

  ProfileEditing({this.editing});
}

class ProfileAdressEditing extends ProfileEvent {
  final bool? editing;

  ProfileAdressEditing({this.editing});
}
