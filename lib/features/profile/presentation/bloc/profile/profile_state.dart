part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final String? firstName, lastName, documentId, personReference, phoneReference, taxId, birthDate;
  final String? country, city, states, street, postalCode;
  final String? pathPhoto;
  final String? company;
  final String? pathPDF;
  final UserModel? user;
  final TransportUnitModel? transportUnit;
  final Departments? extensionDocumentId;
  final String? photoLicenseDrivers;
  final String? photoDocumentIdReverse;
  final String? photoDocumentIdFront;
  final RatingModel? rating;
  final bool loading;
  final bool? editingProfile;
  final bool? editingAdress;
  final bool? signedContract;
  final FormSubmissionStatus? formStatus;
  final String? messages;
  bool get isValidFirstName => firstName!.length > 1;
  bool get isValidDocumentId => documentId!.length > 1;
  bool get isValidLastName => lastName!.length > 1;
  bool get isValidExtension => extensionDocumentId != null ? true : false;
  bool get isValidBirthDate => birthDate!.length > 1;

  const ProfileState({
    this.firstName,
    this.signedContract,
    this.country,
    this.states,
    this.city,
    this.pathPDF,
    this.phoneReference,
    this.rating,
    this.street,
    this.lastName,
    this.documentId,
    this.editingAdress,
    this.editingProfile,
    this.extensionDocumentId,
    this.messages,
    this.taxId,
    this.postalCode,
    this.personReference,
    this.transportUnit,
    this.pathPhoto,
    this.photoLicenseDrivers,
    this.photoDocumentIdReverse,
    this.photoDocumentIdFront,
    this.company,
    this.birthDate,
    this.user,
    this.loading = false,
    this.formStatus,
  });
  ProfileState copyWith({
    String? firstName,
    String? lastName,
    String? personReference,
    String? phoneReference,
    String? documentId,
    String? taxId,
    String? pathPDF,
    String? birthDate,
    String? street,
    String? country,
    String? states,
    bool? signedContract,
    String? city,
    String? messages,
    RatingModel? ratings,
    Departments? extensionDocumentId,
    TransportUnitModel? transportUnit,
    String? pathPhoto,
    String? postalCode,
    String? company,
    String? photoLicenseDrivers,
    String? photoDocumentIdReverse,
    String? photoDocumentIdFront,
    UserModel? user,
    bool? editingAdress,
    bool? editingProfile,
    bool? loading,
    FormSubmissionStatus? formStatus,
  }) {
    return ProfileState(
      street: street ?? this.street,
      signedContract: signedContract ?? this.signedContract,
      country: country ?? this.country,
      states: states ?? this.states,
      city: city ?? this.city,
      pathPDF: pathPDF ?? this.pathPDF,
      messages: messages ?? this.messages,
      postalCode: postalCode ?? this.postalCode,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      documentId: documentId ?? this.documentId,
      rating: ratings ?? this.rating,
      personReference: personReference ?? this.personReference,
      phoneReference: phoneReference ?? this.phoneReference,
      taxId: taxId ?? this.taxId,
      birthDate: birthDate ?? this.birthDate,
      pathPhoto: pathPhoto ?? this.pathPhoto,
      transportUnit: transportUnit ?? this.transportUnit,
      extensionDocumentId: extensionDocumentId ?? this.extensionDocumentId,
      photoLicenseDrivers: photoLicenseDrivers ?? this.photoLicenseDrivers,
      photoDocumentIdReverse: photoDocumentIdReverse ?? this.photoDocumentIdReverse,
      photoDocumentIdFront: photoDocumentIdFront ?? this.photoDocumentIdFront,
      company: company ?? this.company,
      formStatus: formStatus ?? this.formStatus,
      user: user ?? this.user,
      loading: loading ?? this.loading,
      editingAdress: editingAdress ?? this.editingAdress,
      editingProfile: editingProfile ?? this.editingProfile,
    );
  }

  static ProfileState get initialState => ProfileState(
        firstName: '',
        lastName: '',
        documentId: '',
        messages: '',
        phoneReference: '',
        signedContract: false,
        pathPDF: '',
        rating: RatingModel(
          average: 0,
          percentageFive: "0",
          percentageFour: "0",
          percentageOne: "0",
          percentageThree: "0",
          percentageTwo: "0",
          ratings: [],
          totalPage: 0,
        ),
        taxId: '',
        birthDate: '',
        extensionDocumentId: null,
        personReference: '',
        street: '',
        city: '',
        country: '',
        states: '',
        pathPhoto: '',
        company: '',
        postalCode: '',
        photoDocumentIdFront: '',
        photoDocumentIdReverse: '',
        photoLicenseDrivers: '',
        editingProfile: false,
        editingAdress: false,
        transportUnit: null,
        user: null,
        loading: false,
        formStatus: const InitialFormStatus(),
      );
  @override
  List<Object?> get props => [
        firstName,
        lastName,
        postalCode,
        signedContract,
        street,
        country,
        pathPDF,
        city,
        messages,
        states,
        documentId,
        photoLicenseDrivers,
        photoDocumentIdReverse,
        photoDocumentIdFront,
        taxId,
        rating,
        editingProfile,
        editingAdress,
        phoneReference,
        pathPhoto,
        personReference,
        transportUnit,
        extensionDocumentId,
        company,
        birthDate,
        formStatus,
        user,
        loading,
      ];
}
