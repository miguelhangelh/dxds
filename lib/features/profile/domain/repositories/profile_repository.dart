import 'dart:io';

import 'package:appdriver/features/models/features_transport_unit_model.dart';
import 'package:appdriver/features/models/rating_model.dart';
import 'package:appdriver/features/models/transport_unit_model.dart';
import 'package:appdriver/features/models/user_model.dart';
import 'package:appdriver/features/profile/data/models/profile_model.dart';

abstract class ProfileRepository {
  Future<String> addProfile({
    String? firstName,
    String? lastName,
    String? documentId,
    String? birthDate,
  });
  Future<UserModel> updateProfile({
    String? firstName,
    String? lastName,
    String? documentId,
    String? taxId,
    String? companyId,
    String? birthDate,
    String? personReference,
    String? phoneReference,
    String? postalCode,
    String? country,
    String? pathPhoto,
    String? timezone,
    String? city,
    String? states,
    String? street,
  });
  Future<RatingModel?> getRatings();
  List<ProfileModel> getProfile();
  Future<List<FeaturesTransportUnitModel>> getFeaturesTransportUnit();
  Future<UserModel?> getUerById();
  Future<TransportUnitModel?> getTransportUnitById();
  Future<String> updateProfilePathPhoto({
    File? pathPhoto,
  });
  Future<UserModel> updateProfileContractUseCase();
  Future<String> updateProfileDocumentBack({
    File? pathPhoto,
  });
  Future<String> updateProfileDocumentFront({
    File? pathPhoto,
  });
  Future<String> updateProfileDocumentLicence({
    File? pathPhoto,
  });
  Future<UserModel> deleteProfileResource({
    String? type,
  });
}
