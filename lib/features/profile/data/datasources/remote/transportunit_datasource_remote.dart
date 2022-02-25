import 'dart:convert';
import 'dart:io';

import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:appdriver/features/models/user_model.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mime/mime.dart';
import 'package:appdriver/core/error/api_helper.dart';
import 'package:appdriver/core/share_prefs/user_pref.dart';
import 'package:appdriver/core/utils/archives.dart';
import 'package:appdriver/features/models/brand_model.dart';
import 'package:appdriver/features/models/features_transport_unit_model.dart';
import 'package:appdriver/features/models/transport_unit_model.dart';
import 'package:appdriver/features/profile/presentation/widgets/transport_type.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransportUnitDataSourceRemote {
  final Dio? dio;
  TransportUnitDataSourceRemote({required this.dio});
  final ApiBaseHelper _helper = ApiBaseHelper();
  UserPreference userPreference = UserPreference();
  Future<String> updateTransportUnitPhotoUseCase({
    required File pathPhoto,
    String? type,
  }) async {
    File newFile = await compressAndGetFile(pathPhoto, pathPhoto.path);
    String? contentType = lookupMimeType(pathPhoto.path);
    S3UploadFileOptions options = S3UploadFileOptions(
      contentType: contentType,
      accessLevel: StorageAccessLevel.guest,
      metadata: <String, String>{
        'type': 'transportUnit',
        'transportunitid': userPreference.transportUnit!.id!,
        'data': type!,
      },
    );
    String idRandom = randomAlphaNumeric(15);
    var resp = await Amplify.Storage.uploadFile(key: idRandom + 'deltax$type', local: newFile, options: options);
    return resp.key;
  }

  Future<List<TransportUnitType>> getTransportUnitTypes() async {
    var url = dotenv.env['URL_BASIC_TYPE_TRANSPORT_UNIT'];
    var response = await _helper.get(url, queryParameters: {
      'filter': true,
    });
    if (response != null) {
      Map<String, dynamic> array = response;
      var data = array['basicTransportUnit'] as List;
      List<TransportUnitType> data2 = [];
      for (var element in data) {
        var newElement = TransportUnitType.fromJson(element);
        data2.add(newElement);
      }
      return data2;
    } else {
      return [];
    }
  }

  Future<TransportUnitModel?> updateTransportUnit({
    String? plate,
    String? country,
    String? companyGps,
    String? color,
    String? year,
    required BrandModel brand,
    String? type,
    String? fuelType,
    String? engine,
    required List<FeaturesTransportUnitModel> features,
  }) async {
    try {
      List featuresNew = [];
      for (var element in features) {
        var value = element.values!.firstWhereOrNull((element) => element.selected!);
        if (element.qualitative == false && element.quantitative == false) {
          if (value!.selected!) {
            featuresNew.add({
              'name': element.name,
              'featuresTransportUnitId': element.id,
              '_id': value.id,
            });
          }
        } else if (element.qualitative == true && element.quantitative == false) {
          if (value!.selected!) {
            featuresNew.add({
              'name': element.name,
              'featuresTransportUnitId': element.id,
              'valueQualitative': value.valueQualitative,
              '_id': value.id,
            });
          }
        } else {
          if (value!.selected!) {
            featuresNew.add({
              'name': element.name,
              'featuresTransportUnitId': element.id,
              '_id': value.id,
              'valueQuantitative': value.valueQuantitative,
            });
          }
        }
      }
      Map<String, dynamic> user = ({
        "plate": plate,
        "color": color,
        "year": year,
        "companyGps": companyGps,
        "country": country,
        "engine": {
          "fuelType": fuelType,
          "engine": engine,
        },
        "brandId": brand.id,
        "brand": brand.brand,
        "typeTransportUnit": type,
        "features": featuresNew,
      });
      var url = dotenv.env['URL_TRANSPORT_UNIT']! + "/" + userPreference.transportUnit!.id!;
      var response = await _helper.put(url, user);
      var transportUnit = response['transportUnit'];
      TransportUnitModel transportUnitModelData = TransportUnitModel.fromJson(transportUnit);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('transportUnit', json.encode(transportUnitModelData));
      return transportUnitModelData;
    } catch (e) {
      return null;
    }
  }

  Future<TransportUnitModel> removeTransportUnitPhotoUseCase({String? type, required String photoId}) async {
    UserPreference userPreference = UserPreference();
    var user = userPreference.transportUnit!;
    if (photoId.isEmpty) {
      photoId = user.id!;
    }
    var data = {'type': type};
    var url = dotenv.env['URL_TRANSPORT_UNIT']! + "/" + user.id! + "/photo/" + photoId;
    var response = await _helper.put(url, data);
    TransportUnitModel userData = TransportUnitModel.fromJson(response['transportUnit']);
    return userData;
  }

  Future<String> addTransportUnit({
    String? plate,
    String? country,
    BrandModel? brand,
    String? color,
    String? year,
    int? numberOfShafts,
    int? storageCapacity,
    String? type,
    List<FeaturesTransportUnitModel>? features,
    int? volumeCapacity,
  }) async {
    final date = DateTime.now().toUtc();
    UserModel userData = userPreference.getUser;
    final user = jsonEncode(
      {
        "typeTransportUnit": type,
        "drivers": [
          {
            "userId": userData.id,
            "assignationDate": date.toString(),
            "active": true,
          },
        ],
      },
    );
    var url = dotenv.env['URL_TRANSPORT_UNIT']!;
    var responseTransport = await _helper.post(url, user);
    var transportUnit = responseTransport['transportUnit'];
    TransportUnitModel transportUnitModelData = TransportUnitModel.fromJson(transportUnit);
    userPreference.setTransportUnit = json.encode(transportUnitModelData);
    return "ok";
  }

  Future<TransportUnitModel> registerUpdateTransportUnitData({
    String? plate,
    String? country,
    String? color,
    String? year,
    required BrandModel brand,
    String? type,
  }) async {
    final user = jsonEncode({
      "plate": plate,
      "color": color,
      "year": year,
      "brandId": brand.id,
      "brand": brand.brand,
    });
    var url = dotenv.env['URL_TRANSPORT_UNIT']! + "/" + userPreference.transportUnit!.id!;
    var responseTransport = await _helper.put(url, user);
    var transportUnit = responseTransport['transportUnit'];
    TransportUnitModel transportUnitModelData = TransportUnitModel.fromJson(transportUnit);
    userPreference.setTransportUnit = json.encode(transportUnitModelData);
    return transportUnitModelData;
  }

  Future<TransportUnitModel?> registerUpdateTransportUnitFeatures({
    required List<FeaturesTransportUnitModel> features,
  }) async {
    try {
      List featuresNew = [];
      for (var element in features) {
        var value = element.values!.firstWhere((element) => element.selected!);
        if (element.qualitative == false && element.quantitative == false) {
          if (value.selected!) {
            featuresNew.add({
              'name': element.name,
              'featuresTransportUnitId': element.id,
              '_id': value.id,
            });
          }
        } else if (element.qualitative == true && element.quantitative == false) {
          if (value.selected!) {
            featuresNew.add({
              'name': element.name,
              'featuresTransportUnitId': element.id,
              'valueQualitative': value.valueQualitative,
              '_id': value.id,
            });
          }
        } else {
          if (value.selected!) {
            featuresNew.add({
              'name': element.name,
              'featuresTransportUnitId': element.id,
              '_id': value.id,
              'valueQuantitative': value.valueQuantitative,
            });
          }
        }
      }
      final user = jsonEncode({
        "features": featuresNew,
      });
      var url = dotenv.env['URL_TRANSPORT_UNIT']! + "/" + userPreference.transportUnit!.id!;
      var responseTransport = await _helper.put(url, user);
      var transportUnit = responseTransport['transportUnit'];
      TransportUnitModel transportUnitModelData = TransportUnitModel.fromJson(transportUnit);
      userPreference.setTransportUnit = json.encode(transportUnitModelData);
      return transportUnitModelData;
    } catch (e) {
      return null;
    }
  }

  Future<List<BrandModel>> getAllBrands() async {
    var url = dotenv.env['URL_BRAND'];
    var response = await _helper.get(url);
    if (response != null) {
      Map<String, dynamic> array = response;
      var data = array['brand'] as List;
      List<BrandModel> data2 = [];
      for (var element in data) {
        var newElement = BrandModel.fromJson(element);
        data2.add(newElement);
      }
      return data2;
    } else {
      return [];
    }
  }
}
