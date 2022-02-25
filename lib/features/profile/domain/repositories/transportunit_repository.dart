import 'dart:io';

import 'package:appdriver/features/models/brand_model.dart';
import 'package:appdriver/features/models/features_transport_unit_model.dart';
import 'package:appdriver/features/models/transport_unit_model.dart';
import 'package:appdriver/features/profile/presentation/widgets/transport_type.dart';

abstract class TransportUnitRepository {
  Future<String> addTransportUnit({
    String? plate,
    String? country,
    String? color,
    String? year,
    BrandModel? brand,
    int? numberOfShafts,
    int? storageCapacity,
    String? type,
    int? volumeCapacity,
    List<FeaturesTransportUnitModel>? features,
  });
  Future<List<TransportUnitType>> getTransportUnitTypes();
  Future<TransportUnitModel?> updateTransportUnit({
    String? plate,
    String? country,
    String? companyGps,
    String? color,
    String? year,
    BrandModel? brand,
    String? type,
    String? fuelType,
    String? engine,
    List<FeaturesTransportUnitModel>? features,
  });
  Future<TransportUnitModel> removeTransportUnitPhotoUseCase({
    String? type,
    String? photoId,
  });
  Future<TransportUnitModel> registerUpdateTransportUnitData({
    String? plate,
    String? country,
    String? color,
    String? year,
    BrandModel? brand,
    String? type,
  });
  Future<TransportUnitModel?> registerUpdateTransportUnitFeatures({
    List<FeaturesTransportUnitModel>? features,
  }) ;
  Future<String> updateTransportUnitPhotoUseCase({
    String? type,
    File? pathPhoto,
  });
  Future<String> updateTransportUnitType({
    String? type,
  });
  List<TransportUnitModel> getTransportUnit();

  Future<List<BrandModel>> getAllBrands();
}
