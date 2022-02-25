  
import 'package:appdriver/features/profile/domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {

  ProfileModel( {
    String? firstName,
    String? lastName,
    String? documentId,
    String? taxId,
    String? pathPhoto,
    String? company,
    String? birthDate,
  } ) : super(
    firstName  : firstName,
    lastName   : lastName,
    documentId : documentId,
    taxId      : taxId,
    pathPhoto  : pathPhoto,
    company    : company,
    birthDate  : birthDate,
  ) ;

  ProfileModel copyWith({
    String? firstName,
    String? lastName,
    String? documentId,
    String? taxId,
    String? pathPhoto,
    String? company,
    String? birthDate,
  }) {
    return ProfileModel(
      firstName  : firstName ?? this.firstName,
      lastName   : lastName ?? this.lastName,
      documentId : documentId ?? this.documentId,
      taxId      : taxId ?? this.taxId,
      pathPhoto  : pathPhoto ?? this.pathPhoto,
      company    : company ?? this.company,
      birthDate  : birthDate ?? this.birthDate,
    );
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(

      firstName  : json.containsKey( 'firstName' )  ? json["firstName"] : '',
      lastName   : json.containsKey( 'lastName' )   ? json["lastName"] : '',
      documentId : json.containsKey( 'documentId' ) ? json["documentId"] : '',
      taxId      : json.containsKey( 'taxId' )      ? json["taxId"] : '',
      pathPhoto  : json.containsKey( 'pathPhoto' )  ? json["pathPhoto"] : '',
      company    : json.containsKey( 'company' )    ? json["company"] : '',
      birthDate  : json.containsKey( 'birthDate' )  ? json["birthDate"] : '',

  );

  Map<String, dynamic> toJson() => {
    "firstName" : firstName,
    "lastName"  : lastName,
    "documentId": documentId,
    "taxId"     : taxId,
    "pathPhoto" : pathPhoto,
    "company"   : company,
    "birthDate" : birthDate,
  };
  
}