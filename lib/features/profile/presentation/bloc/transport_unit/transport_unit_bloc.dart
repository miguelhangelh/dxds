import 'dart:async';
import 'dart:io';

import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:bloc/bloc.dart';
import 'package:collection/src/iterable_extensions.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:appdriver/core/error/response.dart';
import 'package:appdriver/core/notifications_locale/local_notification.dart';
import 'package:appdriver/features/models/brand_model.dart';
import 'package:appdriver/features/models/features_transport_unit_model.dart';
import 'package:appdriver/features/models/transport_unit_model.dart';
import 'package:appdriver/features/profile/domain/usecases/profile/get_feature_transport_unit_usecase.dart';
import 'package:appdriver/features/profile/domain/usecases/profile/get_transportUnit_by_id_usecase.dart';
import 'package:appdriver/features/profile/domain/usecases/trasnportunit/add_transportunit.dart';
import 'package:appdriver/features/profile/domain/usecases/trasnportunit/update_transportunit.dart';
import 'package:appdriver/features/profile/domain/usecases/trasnportunit/register_update_transportunit_data.dart';
import 'package:appdriver/features/profile/domain/usecases/trasnportunit/register_update_transportunit_features.dart';
import 'package:appdriver/features/profile/domain/usecases/trasnportunit/update_transport_unit_photo.dart';
import 'package:appdriver/features/profile/domain/usecases/trasnportunit/remove_transport_unit_photo.dart';
import 'package:appdriver/features/profile/domain/usecases/trasnportunit/get_transportunit_brands.dart';
import 'package:appdriver/features/profile/domain/usecases/trasnportunit/get_transportunit_types.dart';
import 'package:appdriver/features/profile/presentation/bloc/form_submission_status.dart';
import 'package:appdriver/features/profile/presentation/widgets/transport_type.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'transport_unit_event.dart';
part 'transport_unit_state.dart';

class TransportUnitBloc extends Bloc<TransportUnitEvent, TransportUnitState> {
  final AddTransportUnit addTransportUnit;
  final UpdateTransportUnit updateTransportUnit;
  final RegisterUpdateTransportUnit registerUpdateTransportUnit;
  final RegisterUpdateTransportUnitFeatures registerUpdateTransportUnitFeatures;
  final GetTransportUnitBrands getTransportUnitBrands;
  final GetTransportUnitTypes getTransportUnitTypes;
  final GetFeatureTransportUnitUsecase getFeatureTransportUnitUsecase;
  final GetTransportUnitByIdUsecase getTransportUnitByIdUsecase;
  final UpdateTransportUnitPhotoUseCase updateTransportUnitPhotoUseCase;
  final RemoveTransportUnitPhotoUseCase removeTransportUnitPhotoUseCase;
  RefreshController refreshController = RefreshController(initialRefresh: false);

  TransportUnitBloc({
    required this.addTransportUnit,
    required this.registerUpdateTransportUnit,
    required this.registerUpdateTransportUnitFeatures,
    required this.getTransportUnitByIdUsecase,
    required this.getTransportUnitTypes,
    required this.updateTransportUnitPhotoUseCase,
    required this.getTransportUnitBrands,
    required this.updateTransportUnit,
    required this.getFeatureTransportUnitUsecase,
    required this.removeTransportUnitPhotoUseCase,
  }) : super(TransportUnitState.initialState);
  void onRefresh() async {
    add(TransportUnitUpdateTransportUnit());
  }

  void onLoading() async {
    // add(ProfileRefreshGetUser());
  }
  @override
  Stream<TransportUnitState> mapEventToState(
    TransportUnitEvent event,
  ) async* {
    if (event is TransportUnitTypesGet) {
      yield state.copyWith(loading: true);
      List<TransportUnitType>? transport = await getTransportUnitTypes();
      var response = ApiResponse.completed(transport);
      yield state.copyWith(
        transportUnitTypes: response.data,
        loading: false,
      );
    }
    if (event is TransportUnitGet) {
      try {
        yield state.copyWith(loading: true);
        var transport = await getTransportUnitByIdUsecase();

        var response = ApiResponse.completed(transport);
        yield state.copyWith(
          transportUnit: response.data,
          loading: false,
        );
        if (transport != null) {
          add(TransportUnitGetBrandsEvent());
          add(TransportUnitGetAllFeatures());
        }
      } catch (_) {
        var transports = userPreference.transportUnit;
        yield state.copyWith(
          transportUnit: transports,
          loading: false,
        );
      }
      //add(TransportUnitTypesGet());
    }
    if (event is TransportUnitUpdateTransportUnit) {
      // yield state.copyWith(loading: true);
      var transport = await getTransportUnitByIdUsecase();

      //var transport =  userPreference.transportUnit;
      var response = ApiResponse.completed(transport);
      yield state.copyWith(transportUnit: response.data, loading: false);
      refreshController.refreshCompleted(resetFooterState: true);
      // add(TransportUnitGetBrandsEvent());
      // add(TransportUnitGetAllFeatures());
    }

    if (event is TransportUnitGetAllFeatures) {
      // yield state.copyWith(loading: true);

      List<FeaturesTransportUnitModel>? features = await getFeatureTransportUnitUsecase();
      var responseFeatures = ApiResponse.completed(features);
      List<FeaturesTransportUnitModel> _selectedFeatures = [];
      // var features = state.featuresTransportUnit!;
      List<Feature>? featuresCarrier = state.transportUnit!.features;
      for (var element in features) {
        var feature = featuresCarrier!.firstWhereOrNull((elementCarrier) => elementCarrier.featuresTransportUnitId == element.id);
        if (feature != null) {
          for (var element12 in element.values!) {
            if (element12.id == feature.id) {
              element12.selected = true;
            }
          }
          _selectedFeatures.add(element);
        }
      }
      yield state.copyWith(featuresTransportUnit: responseFeatures.data, selectedFeatures: _selectedFeatures);
    }
    if (event is TransportUnitGetAllRegisterFeatures) {
      yield state.copyWith(loading: true);

      List<FeaturesTransportUnitModel>? features = await getFeatureTransportUnitUsecase();
      var responseFeatures = ApiResponse.completed(features);
      yield state.copyWith(featuresTransportUnit: responseFeatures.data, loading: false);
      // yield state.copyWith(featuresTransportUnit: responseFeatures.data);
    }

    if (event is TransportUnitGetBrandsEvent) {
      // yield state.copyWith(loading: true);
      List<BrandModel>? brands = await getTransportUnitBrands();
      List<TransportUnitType>? transport = await getTransportUnitTypes();
      var response2 = ApiResponse.completed(transport);
      var response = ApiResponse.completed(brands);
      // yield state.copyWith(brands: response.data, transportUnitTypes: response2.data, loading: false);
      yield state.copyWith(brands: response.data, transportUnitTypes: response2.data);
    }
    if (event is TransportUnitGetBrandsTypesEvent) {
      yield state.copyWith(loading: true);
      List<BrandModel>? brands = await getTransportUnitBrands();
      List<TransportUnitType>? transport = await getTransportUnitTypes();
      var response2 = ApiResponse.completed(transport);
      var response = ApiResponse.completed(brands);
      yield state.copyWith(brands: response.data, transportUnitTypes: response2.data, loading: false);
      //yield state.copyWith(brands: response.data, transportUnitTypes: response2.data);
    }
    if (event is TransportUnitFeatureSubmitted) {
      yield state.copyWith(formStatus: FormSubmitting());
      try {
        await registerUpdateTransportUnitFeatures(
          features: event.features,
        );
        yield state.copyWith(
          formStatus: SubmissionSuccess(),
        );
      } catch (e) {
        yield state.copyWith(formStatus: SubmissionFailed(Exception('failed')));
      }
    } else if (event is TransportUnitUpdatePhoto) {
      if (event.type == 'photo') {
        var data = await updateTransportUnitPhotoUseCase(pathPhoto: event.filePhoto, type: event.type);
        GetUrlOptions options = GetUrlOptions(
          accessLevel: StorageAccessLevel.guest,
        );
        GetUrlResult result = await Amplify.Storage.getUrl(key: data, options: options);
        TransportUnitModel transportUnitModel = state.transportUnit!;
        transportUnitModel.resources!.photo!.add(Photo(id: '', path: result.url));
        yield state.copyWith(transportUnit: transportUnitModel, successPhoto: !state.successPhoto!);
      }
      if (event.type == 'photoPolicy') {
        var data = await updateTransportUnitPhotoUseCase(pathPhoto: event.filePhoto, type: event.type);
        GetUrlOptions options = GetUrlOptions(
          accessLevel: StorageAccessLevel.guest,
        );
        GetUrlResult result = await Amplify.Storage.getUrl(key: data, options: options);
        TransportUnitModel transportUnitModel = state.transportUnit!;
        transportUnitModel.resources!.photoPolicy = result.url;
        yield state.copyWith(transportUnit: transportUnitModel, successPhoto: !state.successPhoto!);
      } else {
        var data = await updateTransportUnitPhotoUseCase(pathPhoto: event.filePhoto, type: event.type);
        GetUrlOptions options = GetUrlOptions(
          accessLevel: StorageAccessLevel.guest,
        );
        GetUrlResult result = await Amplify.Storage.getUrl(key: data, options: options);
        TransportUnitModel transportUnitModel = state.transportUnit!;
        transportUnitModel.resources!.photoRuat = result.url;

        yield state.copyWith(transportUnit: transportUnitModel, successPhotoRuat: !state.successPhotoRuat!);
      }
    }
    if (event is TransportUnitFeaturesEditing) {
      yield state.copyWith(editingTransportUnitFeatures: event.editing);
    }
    if (event is TransportUnitFeaturesSelect) {
      yield state.copyWith(updateFeatures: !state.updateFeatures!);
    }
    if (event is TransportUnitRemoveResource) {
      TransportUnitModel? data = await removeTransportUnitPhotoUseCase(type: event.type, photoId: event.photoId ?? '');
      var response = ApiResponse.completed(data);
      yield state.copyWith(transportUnit: response.data, successPhoto: !state.successPhoto!);
    }
    if (event is ProfileTransportEditing) {
      yield state.copyWith(editingTransportUnit: event.editing);
    }
    if (event is TransportUnitSubmittedEditing) {
      yield state.copyWith(formStatus: FormSubmitting());
      try {
        final submit = await updateTransportUnit(
          plate: state.plate!.isNotEmpty ? state.plate : state.transportUnit!.plate,
          color: state.color!.isNotEmpty ? state.color : state.transportUnit!.color,
          country: state.country!.isNotEmpty ? state.country : state.transportUnit!.country,
          companyGps: state.companyGps!.isNotEmpty ? state.companyGps : state.transportUnit!.companyGps,
          year: state.year!.isNotEmpty ? state.year : state.transportUnit!.year,
          brand: state.brand == null ? BrandModel(brand: state.transportUnit!.brand, id: state.transportUnit!.brandId) : state.brand!,
          type: state.type!.isNotEmpty ? state.type : state.transportUnit!.typeTransportUnit,
          engine: state.engine!.isNotEmpty ? state.engine : state.transportUnit!.engine!.engine,
          fuelType: state.fuelType!.isNotEmpty ? state.fuelType : state.transportUnit!.engine!.fuelType,
          features: state.selectedFeatures,
        );
        var response = ApiResponse.completed(submit);
        yield state.copyWith(
          editingTransportUnitFeatures: false,
          editingTransportUnit: false,
          transportUnit: response.data,
          formStatus: SubmissionSuccess(),
        );
      } catch (e) {
        var response = ApiResponse.error(e.toString());
        yield state.copyWith(formStatus: SubmissionFailed(Exception(response.message)));
      }
    }
    if (event is TransportUnitResetForm) {
      yield state.copyWith(formStatus: const InitialFormStatus());
    }
    if (event is TransportUnitSubmitted) {
      yield state.copyWith(formStatus: FormSubmitting());
      try {
        await registerUpdateTransportUnit(
          plate: state.plate,
          color: state.color,
          year: state.year,
          brand: state.brand,
        );
        yield state.copyWith(
          formStatus: SubmissionSuccess(),
        );
      } catch (e) {
        var response = ApiResponse.error(e.toString());
        yield state.copyWith(formStatus: SubmissionFailed(Exception(response.message)), messages: response.message);
      }
    } else if (event is TransportUnitPlate) {
      yield state.copyWith(plate: event.plate);
    } else if (event is TransportUnitColor) {
      yield state.copyWith(color: event.color);
    } else if (event is TransportUnitCountry) {
      yield state.copyWith(country: event.country);
    } else if (event is TransportUnitYear) {
      yield state.copyWith(year: event.year);
    } else if (event is TransportUnitNumberOfShafts) {
      yield state.copyWith(numberOfShafts: event.numberOfShafts);
    } else if (event is TransportUnitBrandEvent) {
      yield state.copyWith(brand: event.brand);
    } else if (event is TransportUnitVolumeCapacity) {
      yield state.copyWith(volumeCapacity: event.volumeCapacity);
    } else if (event is TransportUniTypeSubmit) {
      yield state.copyWith(formStatus: FormSubmitting());
      try {
        await addTransportUnit(
          type: event.type,
        );
        yield state.copyWith(
          formStatus: SubmissionSuccess(),
        );
      } catch (e) {
        yield state.copyWith(formStatus: SubmissionFailed(Exception('failed')));
      }
      yield state.copyWith(type: event.type, typeChange: true);
    } else if (event is TransportUniType) {
      // yield state.copyWith(formStatus: FormSubmitting());
      // try {
      //   final submit = await addTransportUnit(
      //     type: event.type,
      //   );
      //   var response = ApiResponse.completed(submit);
      //   yield state.copyWith(
      //     formStatus: SubmissionSuccess(),
      //   );
      // } catch (e) {
      //   print(e.toString());
      //   yield state.copyWith(formStatus: SubmissionFailed(Exception('failed')));
      // }
      yield state.copyWith(type: event.type);
    } else if (event is TransportUnitTypeChangePage) {
      yield state.copyWith(typeChange: event.typeChange);
    } else if (event is TransportUnitDataChangePage) {
      List<FeaturesTransportUnitModel>? features = await getFeatureTransportUnitUsecase();
      var response = ApiResponse.completed(features);
      yield state.copyWith(dataChange: event.dataChange, featuresTransportUnit: response.data);
    } else if (event is TransportUnitFuelType) {
      yield state.copyWith(fuelType: event.fuelType);
    } else if (event is TransportUnitEngine) {
      yield state.copyWith(engine: event.engine);
    } else if (event is TransportUnitCompanies) {
      yield state.copyWith(companyGps: event.companies);
    }
  }
}
