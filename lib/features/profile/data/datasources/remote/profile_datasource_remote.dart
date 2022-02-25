import 'dart:convert';
import 'dart:io';

import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:appdriver/features/models/rating_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mime/mime.dart';
import 'package:appdriver/core/error/api_helper.dart';
import 'package:appdriver/core/share_prefs/user_pref.dart';
import 'package:appdriver/core/utils/archives.dart';
import 'package:appdriver/features/models/features_transport_unit_model.dart';
import 'package:appdriver/features/models/transport_unit_model.dart';
import 'package:appdriver/features/models/user_model.dart';
import 'package:random_string/random_string.dart';

class ProfileDataSourceRemote {
  final Dio? dio;
  final ApiBaseHelper _helper = ApiBaseHelper();
  UserPreference userPreference = UserPreference();
  ProfileDataSourceRemote({required this.dio});
  Future<List<FeaturesTransportUnitModel>> getFeaturesTransportUnit() async {
    var url = dotenv.env['URL_FEATURES_TRANSPORT_UNIT'];
    var response = await _helper.get(url);
    var data = response['featuresTransportUnits'];
    List<FeaturesTransportUnitModel> data2 = [];
    data.forEach((element) {
      var newElement = FeaturesTransportUnitModel.fromJson(element);
      data2.add(newElement);
    });
    return data2;
  }

  Future<RatingModel?> getRating() async {
    var user = userPreference.getUser;
    var url = dotenv.env['URL_RATING']! + "/user/" + user.id!;
    var response = await _helper.get(url);
    if (response != null) {
      RatingModel data2 = RatingModel.fromJson(response);
      return data2;
    } else {
      return null;
    }
  }

  Future<UserModel> updateProfileContractUseCase() async {
    final userId = userPreference.getUser.id!;
    var url = dotenv.env['URL_USER']! + "/update/signed/contract/" + userId;
    var response = await _helper.put(url, {});
    var userData = response['user'];
    userPreference.setUser = json.encode(userData);
    UserModel userModelData = UserModel.fromJson(userData);
    return userModelData;
  }
  Future<UserModel?> getUserById() async {
    UserPreference userPreference = UserPreference();
    var id = await _getUserIdFromAttributes();
    var url = dotenv.env['URL_USER_COGNITO']! + "/" + id;
    var response = await _helper.get(url);
    if (response != null) {
      Map<String, dynamic> dataUser = Map<String, dynamic>.from(response['user']);
      if (response['transportUnit']["_id"] != null) {
        dataUser['transportUnit'] = response['transportUnit'];
        var data3 = TransportUnitModel.fromJson(response['transportUnit']);
        userPreference.setTransportUnit = json.encode(data3);
      }
      var data2 = UserModel.fromJson(dataUser);
      userPreference.setUser = json.encode(data2);
      return data2;
    } else {
      return null;
    }
  }

  Future<TransportUnitModel?> getTransportUnitById() async {
    UserPreference userPreference = UserPreference();
    var transport = userPreference.transportUnit;
    if (transport != null) {
      var url = dotenv.env['URL_TRANSPORT_UNIT']! + "/" + transport.id!;
      var response = await _helper.get(url);
      if (response != null) {
        var data = response['transportUnit'];
        var data2 = TransportUnitModel.fromJson(data);
        userPreference.setTransportUnit = json.encode(data2);
        return data2;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<UserModel> updateProfile({
    String? taxId,
    String? firstName,
    String? lastName,
    String? documentId,
    String? birthDate,
    String? personReference,
    String? phoneReference,
    String? postalCode,
    String? companyId,
    String? pathPhoto,
    String? timezone,
    String? country,
    String? city,
    String? states,
    String? street,
  }) async {
    final userId = await _getUserIdFromAttributes();
    final user = jsonEncode({
      "profile": {
        "firstName": firstName,
        "lastName": lastName,
        "documentId": documentId,
        "birthDate": birthDate,
        "taxId": taxId,
        "pathPhoto": pathPhoto,
        "timeZone": timezone,
        "personReference": personReference,
        "phoneReference": phoneReference,
      },
      "address": {
        "country": country,
        "city": city,
        "states": states,
        "street": street,
        "postalCode": postalCode,
      },
    });
    var url = dotenv.env['URL_USER']! + "/profile/" + userId;
    var response = await _helper.put(url, user);
    var userData = response['user'];
    userPreference.setUser = json.encode(userData);
    UserModel userModelData = UserModel.fromJson(userData);
    return userModelData;
  }

  Future<String> updateProfilePathPhoto({
    required File pathPhoto,
  }) async {
    Map<String, String>? metadata = <String, String>{};
    metadata['type'] = 'user';
    metadata['userid'] = userPreference.getUser.id!;
    metadata['data'] = 'pathPhoto';
    File newFile = await compressAndGetFile(pathPhoto, pathPhoto.path);
    String? type = lookupMimeType(pathPhoto.path);
    S3UploadFileOptions options = S3UploadFileOptions(
      contentType: type,
      accessLevel: StorageAccessLevel.guest,
      metadata: metadata,
    );
    String idRandom = randomAlphaNumeric(15);
    var resp = await Amplify.Storage.uploadFile(key: idRandom + 'deltaxProfile', local: newFile, options: options);
    return resp.key;
  }

  Future<String> updateProfileDocumentBack({
    required File pathPhoto,
  }) async {
    Map<String, String>? metadata = <String, String>{};
    metadata['type'] = 'user';
    metadata['userid'] = userPreference.getUser.id!;
    metadata['data'] = 'photoDocumentIdReverse';
    File newFile = await compressAndGetFile(pathPhoto, pathPhoto.path);
    String? type = lookupMimeType(pathPhoto.path);
    S3UploadFileOptions options = S3UploadFileOptions(
      contentType: type,
      accessLevel: StorageAccessLevel.guest,
      metadata: metadata,
    );
    String idRandom = randomAlphaNumeric(15);

    var resp = await Amplify.Storage.uploadFile(key: idRandom + 'deltaxDocumentBack', local: newFile, options: options);
    return resp.key;
  }

  Future<UserModel> deleteProfileResource({String? type}) async {
    UserPreference userPreference = UserPreference();
    var user = userPreference.getUser;
    var data = {'type': type};
    var url = dotenv.env['URL_USER']! + "/" + user.id! + "/photo";
    var response = await _helper.put(url, data);
    UserModel userData = UserModel.fromJson(response['user']);
    return userData;
  }

  Future<String> updateProfileDocumentFront({
    required File pathPhoto,
  }) async {
    Map<String, String>? metadata = <String, String>{};
    metadata['type'] = 'user';
    metadata['userid'] = userPreference.getUser.id!;
    metadata['data'] = 'photoDocumentIdFront';
    File newFile = await compressAndGetFile(pathPhoto, pathPhoto.path);
    String? type = lookupMimeType(pathPhoto.path);
    S3UploadFileOptions options = S3UploadFileOptions(
      contentType: type,
      accessLevel: StorageAccessLevel.guest,
      metadata: metadata,
    );
    String idRandom = randomAlphaNumeric(15);
    var resp = await Amplify.Storage.uploadFile(key: idRandom + 'deltaxDocumentFront', local: newFile, options: options);
    return resp.key;
  }

  Future<String> updateProfileDocumentLicence({
    required File pathPhoto,
  }) async {
    Map<String, String>? metadata = <String, String>{};
    metadata['type'] = 'user';
    metadata['userid'] = userPreference.getUser.id!;
    metadata['data'] = 'photoLicenseDrivers';
    File newFile = await compressAndGetFile(pathPhoto, pathPhoto.path);
    String? type = lookupMimeType(pathPhoto.path);
    S3UploadFileOptions options = S3UploadFileOptions(
      contentType: type,
      accessLevel: StorageAccessLevel.guest,
      metadata: metadata,
    );
    String idRandom = randomAlphaNumeric(15);

    var resp = await Amplify.Storage.uploadFile(key: idRandom + 'deltaxDocumentLicence', local: newFile, options: options);
    return resp.key;
  }

  Future<String> addProfile({
    String? firstName,
    String? lastName,
    String? documentId,
    String? birthDate,
  }) async {
    final userId = await _getUserIdFromAttributes();
    final user = jsonEncode({
      "profile": {
        "firstName": firstName,
        "lastName": lastName,
        "documentId": documentId,
        "birthDate": birthDate,
        "timeZone": "America/La_Paz",
        "address": {}
      }
    });
    var url = dotenv.env['URL_USER']! + "/profile/" + userId;
    var response = await _helper.put(url, user);
    var userData = response['user'];
    userPreference.setUser = json.encode(userData);
    return "ok";
  }

  Future<String> _getUserIdFromAttributes() async {
    try {
      final attributes = await Amplify.Auth.fetchUserAttributes();
      final userId = attributes.firstWhere((element) => element.userAttributeKey == 'sub').value;
      return userId;
    } catch (e) {
      throw e;
    }
  }
}
