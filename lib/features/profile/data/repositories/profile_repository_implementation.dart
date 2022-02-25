import 'dart:io';

import 'package:appdriver/features/models/rating_model.dart';
import 'package:appdriver/features/models/features_transport_unit_model.dart';
import 'package:appdriver/features/models/transport_unit_model.dart';
import 'package:appdriver/features/models/user_model.dart';
import 'package:appdriver/features/profile/data/datasources/remote/profile_datasource_remote.dart';
import 'package:appdriver/features/profile/data/models/profile_model.dart';
import 'package:appdriver/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImplementation implements ProfileRepository {
  final ProfileDataSourceRemote profileDataSourceRemote;

  ProfileRepositoryImplementation({
    required this.profileDataSourceRemote,
  });

  @override
  Future<String> addProfile(
      {String? firstName,
      String? lastName,
      String? documentId,
      String? birthDate}) async {
    return await profileDataSourceRemote.addProfile(
      firstName: firstName,
      lastName: lastName,
      documentId: documentId,
      birthDate: birthDate,
    );
  }

  @override
  Future<List<FeaturesTransportUnitModel>> getFeaturesTransportUnit() async {
    return await profileDataSourceRemote.getFeaturesTransportUnit();
  }

  @override
  Future<String> updateProfilePathPhoto({
    File? pathPhoto,
  }) async {
    return await profileDataSourceRemote.updateProfilePathPhoto(
      pathPhoto: pathPhoto!,
    );
  }

  @override
  List<ProfileModel> getProfile() {
    throw UnimplementedError();
  }
  @override
  Future<UserModel> updateProfileContractUseCase() async {
    return await profileDataSourceRemote.updateProfileContractUseCase();
  }
  @override
  Future<UserModel?> getUerById() async {
    return await profileDataSourceRemote.getUserById();
  }

  @override
  Future<TransportUnitModel?> getTransportUnitById() async {
    return await profileDataSourceRemote.getTransportUnitById();
  }

  @override
  Future<String> updateProfileDocumentBack({File? pathPhoto}) async {
    return await profileDataSourceRemote.updateProfileDocumentBack(
      pathPhoto: pathPhoto!,
    );
  }

  @override
  Future<String> updateProfileDocumentFront({File? pathPhoto}) async {
    return await profileDataSourceRemote.updateProfileDocumentFront(
      pathPhoto: pathPhoto!,
    );
  }

  @override
  Future<String> updateProfileDocumentLicence({File? pathPhoto}) async {
    return await profileDataSourceRemote.updateProfileDocumentLicence(
      pathPhoto: pathPhoto!,
    );
  }

  @override
  Future<UserModel> deleteProfileResource({String? type}) async {
    return await profileDataSourceRemote.deleteProfileResource(
      type: type,
    );
  }

  @override
  Future<UserModel> updateProfile({
    String? taxId,
    String? firstName,
    String? lastName,
    String? documentId,
    String? birthDate,
    String? personReference,
    String? phoneReference,
    String? postalCode,
    String? country,
    String? companyId,
    String? pathPhoto,
    String? timezone,
    String? city,
    String? states,
    String? street,
  }) async {

    return await profileDataSourceRemote.updateProfile(
      firstName: firstName,
      lastName: lastName,
      documentId: documentId,
      birthDate: birthDate,
      companyId:companyId,
      taxId: taxId,
      personReference: personReference,
      phoneReference: phoneReference,
      postalCode: postalCode,
      country: country,
      pathPhoto: pathPhoto,
      timezone: timezone,
      city: city,
      states: states,
      street: street,
    );
  }

  @override
  Future<RatingModel?> getRatings() async {
    return await profileDataSourceRemote.getRating();
  }
}
