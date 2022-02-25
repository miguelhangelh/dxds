import 'dart:async';
import 'dart:io';

import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:appdriver/core/utils/functions.dart';
import 'package:appdriver/features/models/rating_model.dart';
import 'package:appdriver/features/profile/domain/usecases/profile/update_profile_contract.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:appdriver/core/error/response.dart';
import 'package:appdriver/core/notifications_locale/local_notification.dart';
import 'package:appdriver/features/models/transport_unit_model.dart';
import 'package:appdriver/features/models/user_model.dart';
import 'package:appdriver/features/profile/domain/usecases/profile/add_profile.dart';
import 'package:appdriver/features/profile/domain/usecases/profile/update_profile.dart';
import 'package:appdriver/features/profile/domain/usecases/profile/update_profile_path_photo.dart';
import 'package:appdriver/features/profile/domain/usecases/profile/get_transportUnit_by_id_usecase.dart';
import 'package:appdriver/features/profile/domain/usecases/profile/get_user_by_id_usecase.dart';
import 'package:appdriver/features/profile/presentation/bloc/form_submission_status.dart';
import 'package:appdriver/features/profile/presentation/widgets/departments.dart';

import 'package:appdriver/features/profile/domain/usecases/profile/update_photo_document_back.dart';
import 'package:appdriver/features/profile/domain/usecases/profile/update_photo_document_front.dart';
import 'package:appdriver/features/profile/domain/usecases/profile/update_photo_document_licence.dart';
import 'package:appdriver/features/profile/domain/usecases/profile/delete_profile_resource.dart';
import 'package:appdriver/features/profile/domain/usecases/profile/get_rating.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AddProfileUseCase addProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final GetUserByIdUsecase getUserByIdUsecase;
  final GetTransportUnitByIdUsecase getTransportUnitByIdUsecase;
  final UpdateProfilePathPhotoUseCase updateProfilePathPhotoUseCase;
  final UpdateProfileDocumentLicenceUseCase updateProfileDocumentLicenceUseCase;
  final UpdateProfileDocumentFrontUseCase updateProfileDocumentFrontUseCase;
  final UpdateProfileDocumentBackUseCase updateProfileDocumentBackUseCase;
  final DeleteProfileResourceUseCase deleteProfileResourceUseCase;
  final UpdateProfileContractUseCase updateProfileContractUseCase;
  final GetRating getRating;
  RefreshController refreshController = RefreshController(initialRefresh: false);

  ProfileBloc({
    required this.addProfileUseCase,
    required this.updateProfileUseCase,
    required this.getUserByIdUsecase,
    required this.getTransportUnitByIdUsecase,
    required this.updateProfilePathPhotoUseCase,
    required this.updateProfileDocumentLicenceUseCase,
    required this.updateProfileDocumentFrontUseCase,
    required this.updateProfileDocumentBackUseCase,
    required this.deleteProfileResourceUseCase,
    required this.updateProfileContractUseCase,
    required this.getRating,
  }) : super(ProfileState.initialState);

  void onRefresh() async {
    add(ProfileRefreshGetUser());
  }

  void onLoading() async {
    add(ProfileRefreshGetUser());
  }

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is ProfileGetRating) {
      yield state.copyWith(loading: true);
      try {
        var user = await getRating();
        var response = ApiResponse.completed(user);
        yield state.copyWith(loading: false, ratings: response.data);
      } catch (e) {
        yield state.copyWith(loading: false);
      }
    }

    if (event is ProfileGetUser) {
      try {
        yield state.copyWith(loading: true);
        var user = await getUserByIdUsecase();
        var transportUnit = userPreference.transportUnit;
        var response = ApiResponse.completed(user);
        var response2 = ApiResponse.completed(transportUnit);
        yield state.copyWith(loading: false, user: response.data, transportUnit: response2.data);
      } catch (e) {
        UserModel? user = userPreference.getUserMenu;
        if (user != null) {
          var transportUnit = userPreference.transportUnit;
          refreshController.refreshCompleted(resetFooterState: true);
          yield state.copyWith(loading: false, user: user, transportUnit: transportUnit);
          return;
        }
        refreshController.refreshCompleted(resetFooterState: true);
        yield state.copyWith(loading: false);
      }
    }
    if (event is DownloadPDF) {
      yield state.copyWith(
        loading: true,
      );
      String? pathPDF = await createFileOfPdfUrl();
      if (pathPDF != null) {
        yield state.copyWith(loading: false, pathPDF: pathPDF);
      } else {
        yield state.copyWith(
          loading: false,
        );
      }
    }
    if (event is ProfileRefreshGetUser) {
      try {
        var user = await getUserByIdUsecase();
        var transportUnit = await getTransportUnitByIdUsecase();
        var response = ApiResponse.completed(user);
        var response2 = ApiResponse.completed(transportUnit);
        yield state.copyWith(loading: false, user: response.data, transportUnit: response2.data);
        refreshController.refreshCompleted(resetFooterState: true);
      } catch (e) {
        UserModel? user = userPreference.getUserMenu;
        if (user != null) {
          var transportUnit = userPreference.transportUnit;
          refreshController.refreshCompleted(resetFooterState: true);
          yield state.copyWith(loading: false, user: user, transportUnit: transportUnit);
          return;
        }
        refreshController.refreshCompleted(resetFooterState: true);
        yield state.copyWith(loading: false);
      }
    }
    if (event is ProfileSignedContract) {
      yield state.copyWith(signedContract: event.signedContract);
    }
    if (event is ProfileContractSubmitted) {
      yield state.copyWith(formStatus: FormSubmitting());
      try {
        await updateProfileContractUseCase();
        yield state.copyWith(formStatus: SubmissionSuccess());
      } catch (e) {
        yield state.copyWith(formStatus: SubmissionFailed(Exception(e)));
      }
    }
    if (event is ProfileSubmitted) {
      yield state.copyWith(formStatus: FormSubmitting());
      try {
        await addProfileUseCase(
          firstName: state.firstName,
          lastName: state.lastName,
          documentId: state.documentId! + "_" + state.extensionDocumentId!.id,
          birthDate: state.birthDate,
        );
        yield state.copyWith(formStatus: SubmissionSuccess());
      } catch (e) {
        yield state.copyWith(formStatus: SubmissionFailed(Exception(e)));
      }
    } else if (event is ProfileUpdateProfileSubmitted) {
      yield state.copyWith(formStatus: FormSubmitting());
      try {
        final UserModel? submit = await updateProfileUseCase(
          personReference: state.personReference!.isNotEmpty ? state.personReference : state.user!.profile?.personReference ?? '',
          phoneReference: state.phoneReference!.isNotEmpty ? state.phoneReference : state.user!.profile?.phoneReference ?? '',
          country: state.country!.isNotEmpty ? state.country : state.user!.address?.country ?? '',
          city: state.city!.isNotEmpty ? state.city : state.user!.address?.city ?? '',
          states: state.states!.isNotEmpty ? state.states : state.user!.address?.states ?? '',
          postalCode: state.postalCode!.isNotEmpty ? state.postalCode : state.user!.address?.postalCode ?? '',
          street: state.street!.isNotEmpty ? state.street : state.user!.address?.street ?? '',
          taxId: state.taxId!.isNotEmpty ? state.taxId : state.user!.profile?.taxId ?? '',
          firstName: state.firstName!.isNotEmpty ? state.firstName : state.user!.profile!.firstName,
          companyId: state.user!.profile?.companyId ?? '',
          timezone: state.user!.profile?.timeZone ?? '',
          pathPhoto: state.user!.profile?.pathPhoto ?? '',
          lastName: state.lastName!.isNotEmpty ? state.lastName : state.user!.profile?.lastName ?? '',
          documentId: state.documentId!.isNotEmpty ? state.documentId! + "_" + state.extensionDocumentId!.id : state.user!.profile?.documentId ?? '',
          birthDate: state.birthDate!.isNotEmpty
              ? state.birthDate
              : state.user!.profile?.birthDate != null
                  ? DateFormat('yyyy-MM-dd').format(state.user!.profile!.birthDate ?? DateTime.now())
                  : '',
        );
        var response = ApiResponse.completed(submit);

        yield state.copyWith(formStatus: SubmissionSuccess(), user: response.data, editingProfile: false, editingAdress: false);
      } catch (e) {
        yield state.copyWith(editingProfile: false, editingAdress: false);
      }
    } else if (event is ProfileFirstNameChanged) {
      yield state.copyWith(firstName: event.firstName);
    } else if (event is ProfileLastNameChanged) {
      yield state.copyWith(lastName: event.lastName);
    } else if (event is ProfileDocumentIdChanged) {
      yield state.copyWith(documentId: event.documentId);
    } else if (event is ProfileBirthDateChanged) {
      yield state.copyWith(birthDate: event.birthDate);
    } else if (event is ProfileExtensionDniChanged) {
      yield state.copyWith(extensionDocumentId: event.departments);
    } else if (event is ProfilePersonReference) {
      yield state.copyWith(personReference: event.personReference);
    } else if (event is ProfilePhoneReference) {
      yield state.copyWith(phoneReference: event.phoneReference);
    } else if (event is ProfileLastTaxId) {
      yield state.copyWith(taxId: event.taxId);
    } else if (event is ProfileCountyChanged) {
      yield state.copyWith(country: event.country);
    } else if (event is ProfileStreetChanged) {
      yield state.copyWith(street: event.street);
    } else if (event is ProfileStatesChanged) {
      yield state.copyWith(states: event.states);
    } else if (event is ProfileCityChanged) {
      yield state.copyWith(city: event.city);
    } else if (event is ProfilePostalCodeChanged) {
      yield state.copyWith(postalCode: event.postalCode);
    } else if (event is ProfileUpdatePathPhoto) {
      var data = await updateProfilePathPhotoUseCase(pathPhoto: event.filePhoto);
      GetUrlOptions options = GetUrlOptions(
        accessLevel: StorageAccessLevel.guest,
      );
      GetUrlResult result = await Amplify.Storage.getUrl(key: data, options: options);
      UserModel model = state.user!;
      model.profile!.pathPhoto = result.url;
      yield state.copyWith(user: model, pathPhoto: result.url);
    } else if (event is ProfileUpdateDocumentBack) {
      var data = await updateProfileDocumentBackUseCase(pathPhoto: event.filePhoto);
      GetUrlOptions options = GetUrlOptions(
        accessLevel: StorageAccessLevel.guest,
      );
      UserModel model = state.user!;
      GetUrlResult result = await Amplify.Storage.getUrl(key: data, options: options);
      model.resources!.photoDocumentIdReverse = result.url;
      yield state.copyWith(user: model, photoDocumentIdReverse: result.url);
    } else if (event is ProfileUpdateDocumentFront) {
      var data = await updateProfileDocumentFrontUseCase(pathPhoto: event.filePhoto);
      GetUrlOptions options = GetUrlOptions(
        accessLevel: StorageAccessLevel.guest,
      );
      UserModel model = state.user!;
      GetUrlResult result = await Amplify.Storage.getUrl(key: data, options: options);
      model.resources!.photoDocumentIdFront = result.url;
      yield state.copyWith(user: model, photoDocumentIdFront: result.url);
    } else if (event is ProfileUpdateDocumentLicence) {
      var data = await updateProfileDocumentLicenceUseCase(pathPhoto: event.filePhoto);
      GetUrlOptions options = GetUrlOptions(
        accessLevel: StorageAccessLevel.guest,
      );
      UserModel model = state.user!;
      GetUrlResult result = await Amplify.Storage.getUrl(key: data, options: options);
      model.resources!.photoLicenseDrivers = result.url;
      yield state.copyWith(user: model, photoLicenseDrivers: result.url);
    } else if (event is ProfileRemoveResource) {
      if (event.type == 'pathPhoto') {
        UserModel usermodel = state.user!;
        usermodel.profile!.pathPhoto = '';
        yield state.copyWith(user: usermodel);
        UserModel? data = await deleteProfileResourceUseCase(type: event.type);
        var response = ApiResponse.completed(data);
        yield state.copyWith(user: response.data);
      }
      if (event.type == 'photoDocumentIdFront') {
        UserModel usermodel = state.user!;
        usermodel.resources!.photoDocumentIdFront = '';
        yield state.copyWith(user: usermodel);
        UserModel? data = await deleteProfileResourceUseCase(type: event.type);
        var response = ApiResponse.completed(data);
        yield state.copyWith(user: response.data);
      }
      if (event.type == 'photoDocumentIdReverse') {
        UserModel usermodel = state.user!;
        usermodel.resources!.photoDocumentIdReverse = '';
        yield state.copyWith(user: usermodel);
        UserModel? data = await deleteProfileResourceUseCase(type: event.type);
        var response = ApiResponse.completed(data);
        yield state.copyWith(user: response.data);
      }
      if (event.type == 'photoLicenseDrivers') {
        UserModel usermodel = state.user!;
        usermodel.resources!.photoLicenseDrivers = '';
        yield state.copyWith(user: usermodel);
        UserModel? data = await deleteProfileResourceUseCase(type: event.type);
        var response = ApiResponse.completed(data);
        yield state.copyWith(user: response.data);
      }
    } else if (event is ProfileEditing) {
      if (event.editing == false) {
        yield state.copyWith(
          editingProfile: event.editing,
          firstName: '',
          lastName: '',
          documentId: '',
          birthDate: '',
          personReference: '',
          phoneReference: '',
          taxId: '',
        );
      } else {
        yield state.copyWith(editingProfile: event.editing);
      }
    } else if (event is ProfileAdressEditing) {
      yield state.copyWith(editingAdress: event.editing);
    }
  }
}
