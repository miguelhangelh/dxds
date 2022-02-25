part of 'transport_unit_bloc.dart';

class TransportUnitState extends Equatable {
  final String? transportUnitId;
  final String? plate;
  final String? country;
  final String? color;
  final String? year;
  final List<FeaturesTransportUnitModel>? selectedFeatures;
  final List<BrandModel>? brands;
  final List<TransportUnitType>? transportUnitTypes;
  final bool? typeChange;
  final bool? dataChange;
  final bool? featureChange;
  final int? numberOfShafts;
  final int? storageCapacity;
  final String? type;
  final String? companyGps;
  final TransportUnitModel? transportUnit;
  final BrandModel? brand;
  final List<FeaturesTransportUnitModel>? featuresTransportUnit;
  final bool? loading;
  final bool? successPhoto;
  final bool? successPhotoRuat;
  final bool? successPhotoPolicy;
  final String? engine;
  final int? volumeCapacity;
  final bool? editingTransportUnit;
  final bool? editingTransportUnitFeatures;
  final bool? updateFeatures;
  final String? fuelType;
  final String? messages;
  final FormSubmissionStatus? formStatus;
  bool get isValidType => type!.length > 1;
  bool get isValidNumberOfShafts => numberOfShafts! > 0;
  bool get isValidStorageCapacity => storageCapacity! > 0;
  bool get isValidVolumeCapacity => volumeCapacity! > 0;
  bool get isValidPlate => plate!.isNotEmpty;
  bool get isValidColor => color!.isNotEmpty;
  bool get isValidBrand => brand != null ? true : false;

  bool get isValidYear => year!.length > 1;

  const TransportUnitState({
    this.transportUnitId,
    this.featuresTransportUnit,
    this.successPhotoPolicy,
    this.companyGps,
    this.plate,
    this.transportUnit,
    this.selectedFeatures = const [],
    this.loading,
    this.transportUnitTypes,
    this.messages,
    this.editingTransportUnitFeatures,
    this.country,
    this.editingTransportUnit,
    this.brands,
    this.updateFeatures,
    this.typeChange,
    this.successPhoto,
    this.successPhotoRuat,
    this.dataChange,
    this.featureChange,
    this.engine,
    this.color,
    this.year,
    this.numberOfShafts,
    this.fuelType,
    this.storageCapacity,
    this.type,
    this.volumeCapacity,
    this.formStatus,
    this.brand,
  });
  TransportUnitState copyWith({
    String? transportUnitId,
    String? plate,
    String? country,
    String? color,
    bool? successPhoto,
    bool? successPhotoRuat,
    bool? successPhotoPolicy,
    List<BrandModel>? brands,
    bool? editingTransportUnit,
    bool? dataChange,
    String? engine,
    String? companyGps,
    BrandModel? brand,
    List<FeaturesTransportUnitModel>? selectedFeatures,
    String? fuelType,
    bool? typeChange,
    TransportUnitModel? transportUnit,
    String? messages,
    List<TransportUnitType>? transportUnitTypes,
    bool? featureChange,
    bool? editingTransportUnitFeatures,
    List<FeaturesTransportUnitModel>? featuresTransportUnit,
    String? year,
    int? numberOfShafts,
    int? storageCapacity,
    bool? loading,
    bool? updateFeatures,
    String? type,
    int? volumeCapacity,
    FormSubmissionStatus? formStatus,
  }) {
    return TransportUnitState(
      transportUnitId: transportUnitId ?? this.transportUnitId,
      fuelType: fuelType ?? this.fuelType,
      successPhotoPolicy: successPhotoPolicy ?? this.successPhotoPolicy,
      companyGps: companyGps ?? this.companyGps,
      messages: messages ?? this.messages,
      transportUnitTypes: transportUnitTypes ?? this.transportUnitTypes,
      engine: engine ?? this.engine,
      selectedFeatures: selectedFeatures ?? this.selectedFeatures,
      updateFeatures: updateFeatures ?? this.updateFeatures,
      editingTransportUnitFeatures: editingTransportUnitFeatures ?? this.editingTransportUnitFeatures,
      successPhotoRuat: successPhotoRuat ?? this.successPhotoRuat,
      editingTransportUnit: editingTransportUnit ?? this.editingTransportUnit,
      successPhoto: successPhoto ?? this.successPhoto,
      brands: brands ?? this.brands,
      loading: loading ?? this.loading,
      brand: brand ?? this.brand,
      transportUnit: transportUnit ?? this.transportUnit,
      featuresTransportUnit: featuresTransportUnit ?? this.featuresTransportUnit,
      typeChange: typeChange ?? this.typeChange,
      dataChange: dataChange ?? this.dataChange,
      featureChange: featureChange ?? this.featureChange,
      plate: plate ?? this.plate,
      country: country ?? this.country,
      color: color ?? this.color,
      year: year ?? this.year,
      numberOfShafts: numberOfShafts ?? this.numberOfShafts,
      storageCapacity: storageCapacity ?? this.storageCapacity,
      type: type ?? this.type,
      volumeCapacity: volumeCapacity ?? this.volumeCapacity,
      formStatus: formStatus ?? this.formStatus,
    );
  }

  static TransportUnitState get initialState => const TransportUnitState(
        transportUnitId: '',
        editingTransportUnitFeatures: false,
        plate: '',
        typeChange: false,
        transportUnit: null,
        updateFeatures: false,
        selectedFeatures: [],
        companyGps: '',
        messages: '',
        fuelType: '',
        loading: false,
        successPhotoPolicy: false,
        dataChange: false,
        brands: [],
        editingTransportUnit: false,
        transportUnitTypes: [],
        country: '',
        engine: '',
        successPhoto: false,
        successPhotoRuat: false,
        brand: null,
        featuresTransportUnit: [],
        color: '',
        year: '',
        featureChange: false,
        numberOfShafts: 0,
        storageCapacity: 0,
        type: '',
        volumeCapacity: 0,
        formStatus: InitialFormStatus(),
      );
  @override
  List<Object?> get props => [
        transportUnitId,
        plate,
        country,
        color,
        companyGps,
        transportUnit,
        typeChange,
        successPhotoPolicy,
        fuelType,
        transportUnitTypes,
        selectedFeatures,
        brand,
        editingTransportUnit,
        messages,
        featuresTransportUnit,
        loading,
        dataChange,
        engine,
        featureChange,
        successPhoto,
        successPhotoRuat,
        year,
        editingTransportUnitFeatures,
        updateFeatures,
        brands,
        numberOfShafts,
        storageCapacity,
        type,
        volumeCapacity,
        formStatus,
      ];
}
