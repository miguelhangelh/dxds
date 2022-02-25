import 'dart:io';

import 'package:appdriver/features/models/brand_model.dart';
import 'package:appdriver/features/models/features_transport_unit_model.dart';
import 'package:appdriver/features/models/transport_unit_model.dart';
import 'package:appdriver/features/profile/data/datasources/remote/transportunit_datasource_remote.dart';
import 'package:appdriver/features/profile/domain/repositories/transportunit_repository.dart';
import 'package:appdriver/features/profile/presentation/widgets/transport_type.dart';
class TransportUnitRepositoryImplementation implements TransportUnitRepository {
  final TransportUnitDataSourceRemote transportUnitDataSourceRemote;

  TransportUnitRepositoryImplementation({
    required this.transportUnitDataSourceRemote,
  });
  @override
  Future<String> updateTransportUnitPhotoUseCase({
    File? pathPhoto,
    String? type,
  }) async {
    return await transportUnitDataSourceRemote.updateTransportUnitPhotoUseCase(
      pathPhoto: pathPhoto!,
      type: type,
    );
  }

  @override
  Future<TransportUnitModel> registerUpdateTransportUnitData({
    String? plate,
    String? country,
    String? color,
    String? year,
    BrandModel? brand,
    String? type,
  }) async {
    return await transportUnitDataSourceRemote.registerUpdateTransportUnitData(
      plate: plate,
      color: color,
      brand: brand!,
      country: country,
      year: year,
      type: type,
    );
  }

  @override
  Future<TransportUnitModel?> registerUpdateTransportUnitFeatures({
    List<FeaturesTransportUnitModel>? features,
  }) async {
    return await transportUnitDataSourceRemote.registerUpdateTransportUnitFeatures(
      features: features!,
    );
  }

  @override
  Future<List<TransportUnitType>> getTransportUnitTypes() async {
    return await transportUnitDataSourceRemote.getTransportUnitTypes();
  }

  @override
  Future<TransportUnitModel?> updateTransportUnit({
    String? plate,
    String? country,
    String? color,
    String? year,
    BrandModel? brand,
    String? companyGps,
    String? type,
    String? fuelType,
    String? engine,
    List<FeaturesTransportUnitModel>? features,
  }) async {
    return await transportUnitDataSourceRemote.updateTransportUnit(
      plate: plate,
      color: color,
      brand: brand!,
      country: country,
      companyGps: companyGps,
      year: year,
      type: type,
      fuelType: fuelType,
      engine: engine,
      features: features!,
    );
  }

  @override
  Future<String> addTransportUnit({
    String? plate,
    String? country,
    String? color,
    List<FeaturesTransportUnitModel>? features,
    BrandModel? brand,
    String? year,
    int? numberOfShafts,
    int? storageCapacity,
    String? type,
    int? volumeCapacity,
  }) async {
    return await transportUnitDataSourceRemote.addTransportUnit(
      color: color,
      plate: plate,
      year: year,
      brand: brand,
      numberOfShafts: numberOfShafts,
      storageCapacity: storageCapacity,
      features: features,
      type: type,
      volumeCapacity: volumeCapacity,
    );
  }

  @override
  List<TransportUnitModel> getTransportUnit() {
    throw UnimplementedError();
  }

  @override
  Future<String> updateTransportUnitType({String? type}) {
    throw UnimplementedError();
  }

  @override
  Future<List<BrandModel>> getAllBrands() async {
    return await transportUnitDataSourceRemote.getAllBrands();
  }

  @override
  Future<TransportUnitModel> removeTransportUnitPhotoUseCase({String? type, String? photoId}) async {
    return await transportUnitDataSourceRemote.removeTransportUnitPhotoUseCase(type: type, photoId: photoId!);
  }
}
