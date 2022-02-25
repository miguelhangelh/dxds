part of 'transport_unit_bloc.dart';

@immutable
abstract class TransportUnitEvent {}

class TransportUnitPlate extends TransportUnitEvent {
  final String? plate;

  TransportUnitPlate({this.plate});
}

class TransportUnitCountry extends TransportUnitEvent {
  final String? country;

  TransportUnitCountry({this.country});
}

class TransportUnitColor extends TransportUnitEvent {
  final String? color;

  TransportUnitColor({this.color});
}

class TransportUnitFuelType extends TransportUnitEvent {
  final String? fuelType;

  TransportUnitFuelType({this.fuelType});
}

class TransportUnitCompanies extends TransportUnitEvent {
  final String? companies;

  TransportUnitCompanies({this.companies});
}

class TransportUnitEngine extends TransportUnitEvent {
  final String? engine;

  TransportUnitEngine({this.engine});
}

class TransportUnitYear extends TransportUnitEvent {
  final String? year;

  TransportUnitYear({this.year});
}

class TransportUniType extends TransportUnitEvent {
  final String? type;

  TransportUniType({this.type});
}

class TransportUniTypeSubmit extends TransportUnitEvent {
  final String? type;

  TransportUniTypeSubmit({this.type});
}

class TransportUnitVolumeCapacity extends TransportUnitEvent {
  final int? volumeCapacity;

  TransportUnitVolumeCapacity({this.volumeCapacity});
}

class TransportUnitNumberOfShafts extends TransportUnitEvent {
  final int? numberOfShafts;

  TransportUnitNumberOfShafts({this.numberOfShafts});
}

class TransportUnitBrandEvent extends TransportUnitEvent {
  final BrandModel? brand;

  TransportUnitBrandEvent({this.brand});
}

class TransportUnitResetForm extends TransportUnitEvent {}

class TransportUnitSubmitted extends TransportUnitEvent {}

class TransportUnitGetAllFeatures extends TransportUnitEvent {}

class TransportUnitGetAllRegisterFeatures extends TransportUnitEvent {}

class TransportUnitUpdateTransportUnit extends TransportUnitEvent {}

class TransportUnitSubmittedEditing extends TransportUnitEvent {
  final List<FeaturesTransportUnitModel>? features;
  final BrandModel? brand;

  TransportUnitSubmittedEditing({this.features, this.brand});
}

class TransportUnitGet extends TransportUnitEvent {}

class TransportUnitTypesGet extends TransportUnitEvent {}

class TransportUnitGetBrandsEvent extends TransportUnitEvent {}

class TransportUnitGetBrandsTypesEvent extends TransportUnitEvent {}

class TransportUnitFeatureSubmitted extends TransportUnitEvent {
  final List<FeaturesTransportUnitModel>? features;

  TransportUnitFeatureSubmitted({this.features});
}

class TransportUnitTypeChangePage extends TransportUnitEvent {
  final bool? typeChange;

  TransportUnitTypeChangePage({this.typeChange});
}

class TransportUnitDataChangePage extends TransportUnitEvent {
  final bool? dataChange;

  TransportUnitDataChangePage({this.dataChange});
}

class TransportUnitFeatureChangePage extends TransportUnitEvent {
  final bool? featureChange;

  TransportUnitFeatureChangePage({this.featureChange});
}

class ProfileTransportEditing extends TransportUnitEvent {
  final bool? editing;

  ProfileTransportEditing({this.editing});
}

class TransportUnitFeaturesSelect extends TransportUnitEvent {}

class TransportUnitFeaturesEditing extends TransportUnitEvent {
  final bool? editing;

  TransportUnitFeaturesEditing({this.editing});
}

class TransportUnitUpdatePhoto extends TransportUnitEvent {
  final File? filePhoto;
  final String type;
  TransportUnitUpdatePhoto({this.filePhoto, required this.type});
}

class TransportUnitRemoveResource extends TransportUnitEvent {
  final String? type;
  final String? photoId;
  TransportUnitRemoveResource({this.type, this.photoId});
}
