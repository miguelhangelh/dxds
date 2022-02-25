import 'dart:ui';

import 'package:appdriver/features/opportunity/domain/usecases/get_all_exchange_rate_usecase.dart';
import 'package:appdriver/features/profile/domain/usecases/profile/update_profile_contract.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:appdriver/features/benefits/presentation/bloc/benefits_bloc.dart';
import 'package:appdriver/features/notification/presentation/bloc/notifications_bloc.dart';
import 'package:appdriver/features/offline/domain/usecases/get_all_checkpoints_usecase.dart';
import 'package:appdriver/features/offline/domain/usecases/get_task_all_pending_usecase.dart';
import 'package:appdriver/features/offline/domain/usecases/set_checkpoints_usecase.dart';
import 'package:appdriver/features/offline/domain/usecases/sincronized_checkpoints_usecases.dart';
import 'package:appdriver/features/operation/data/datasources/operation_datasource_remote.dart';
import 'package:appdriver/features/operation/data/repositories/opereation_repository_implementation.dart';
import 'package:appdriver/features/operation/domain/repositories/operation_repository.dart';
import 'package:appdriver/features/operation/domain/usecases/get_operation_usecase.dart';
import 'package:appdriver/features/operation/presentation/bloc/operation_bloc.dart';
import 'package:appdriver/features/opportunity/data/datasources/remote/oportunity_datasource_remote.dart';
import 'package:appdriver/features/opportunity/data/repositories/oportunity_repository_implementation.dart';
import 'package:appdriver/features/opportunity/domain/repositories/oportunity_repository.dart';
import 'package:appdriver/features/opportunity/domain/usecases/add_postulation_usecase.dart';
import 'package:appdriver/features/opportunity/domain/usecases/confirm_postulation_usecase.dart';
import 'package:appdriver/features/opportunity/domain/usecases/cancelled_postulation_usecase.dart';
import 'package:appdriver/features/opportunity/domain/usecases/get_oportunity_all_usecase.dart';
import 'package:appdriver/features/opportunity/domain/usecases/get_postulation_truck_usecase.dart';
import 'package:appdriver/features/opportunity/domain/usecases/get_oportunity_by_id_usecase.dart';
import 'package:appdriver/features/opportunity/presentation/bloc/opportunity_bloc.dart';
import 'package:appdriver/features/phone_authentication_aws/presentation/bloc/phone_authentication1_bloc.dart';
import 'package:appdriver/features/phone_authentication_aws/presentation/bloc/ticker.dart';
import 'package:appdriver/features/profile/data/datasources/remote/profile_datasource_remote.dart';
import 'package:appdriver/features/profile/data/datasources/remote/transportunit_datasource_remote.dart';
import 'package:appdriver/features/profile/data/repositories/profile_repository_implementation.dart';
import 'package:appdriver/features/profile/data/repositories/transportunit_repository_implementation.dart';
import 'package:appdriver/features/profile/domain/repositories/profile_repository.dart';
import 'package:appdriver/features/profile/domain/repositories/transportunit_repository.dart';
import 'package:appdriver/features/profile/domain/usecases/profile/add_profile.dart';
import 'package:appdriver/features/profile/domain/usecases/profile/get_feature_transport_unit_usecase.dart';
import 'package:appdriver/features/profile/domain/usecases/profile/get_transportUnit_by_id_usecase.dart';
import 'package:appdriver/features/profile/domain/usecases/profile/get_user_by_id_usecase.dart';
import 'package:appdriver/features/profile/domain/usecases/profile/update_profile.dart';
import 'package:appdriver/features/profile/domain/usecases/trasnportunit/add_transportunit.dart';
import 'package:appdriver/features/profile/domain/usecases/trasnportunit/get_transportunit_brands.dart';
import 'package:appdriver/features/opportunity/domain/usecases/get_category_all_usecase.dart';
import 'package:appdriver/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:appdriver/features/profile/presentation/bloc/transport_unit/transport_unit_bloc.dart';
import 'package:appdriver/features/tasks/data/datasources/remote/tasks_datasource_remote.dart';
import 'package:appdriver/features/tasks/data/repositories/tasks_repository_implementation.dart';
import 'package:appdriver/features/tasks/domain/repositories/task_repository.dart';
import 'package:appdriver/features/tasks/domain/usecases/add_tasks_local.dart';
import 'features/authentication_aws/domain/repositories/preferences_repository.dart';
import 'features/authentication_aws/domain/usecases/attempt_auto_login_usecase.dart';
import 'features/authentication_aws/domain/usecases/sign_out_usecase.dart';
import 'features/notification/domain/usecases/get_notifications_all_usecase.dart';
import 'features/offline/data/repositories/conectivity_repository_implementacion.dart';
import 'features/offline/domain/usecases/set_task_usecase.dart';
import 'features/phone_authentication_aws/domain/usecases/confirm_sign_up_usecase.dart';
import 'features/phone_authentication_aws/domain/usecases/login_usecase.dart';
import 'features/phone_authentication_aws/domain/usecases/re_send_sms.dart';
import 'features/phone_authentication_aws/domain/usecases/sign_up_usecase.dart';
import 'features/phone_authentication_aws/domain/usecases/user_is_special_use_case.dart';
import 'features/preferences/presentation/bloc/preferences_bloc.dart';

import 'package:appdriver/features/profile/domain/usecases/profile/update_profile_path_photo.dart';
import 'package:appdriver/features/profile/domain/usecases/profile/update_photo_document_back.dart';
import 'package:appdriver/features/profile/domain/usecases/profile/update_photo_document_front.dart';
import 'package:appdriver/features/profile/domain/usecases/profile/update_photo_document_licence.dart';
import 'package:appdriver/features/profile/domain/usecases/profile/delete_profile_resource.dart';
import 'package:appdriver/features/profile/domain/usecases/profile/get_rating.dart';
import 'package:appdriver/features/opportunity/domain/usecases/get_oportunity_all_payments_usecase.dart';
import 'package:appdriver/features/profile/domain/usecases/trasnportunit/update_transport_unit_photo.dart';
import 'package:appdriver/features/profile/domain/usecases/trasnportunit/remove_transport_unit_photo.dart';
import 'package:appdriver/features/profile/domain/usecases/trasnportunit/update_transportunit.dart';
import 'package:appdriver/features/profile/domain/usecases/trasnportunit/register_update_transportunit_data.dart';
import 'package:appdriver/features/opportunity/domain/usecases/get_oportunitys_round_trip_usecase.dart';
import 'core/notifications_locale/local_notification.dart';
import 'features/authentication_aws/data/datasources/remote/authentication_remote_data_source.dart';
import 'features/authentication_aws/data/repositories/authentication_repository_implementation.dart';
import 'features/authentication_aws/data/repositories/preferences_repository_impl.dart';
import 'features/authentication_aws/domain/repositories/authentication_repository.dart';
import 'package:appdriver/features/authentication_aws/domain/usecases/update_token_notification_usecase.dart';

import 'features/authentication_aws/presentation/bloc/authentication_bloc.dart';
import 'features/offline/domain/usecases/get_task_all_usecase.dart';
import 'features/phone_authentication_aws/data/datasources/remote/phone_authentication_remote_data_source.dart';
import 'features/phone_authentication_aws/data/repositories/phone_authentication_repository_implementation.dart';
import 'features/phone_authentication_aws/domain/repositories/phone_authentication_repository.dart';

import 'features/offline/presentation/bloc/conectivity_bloc.dart';
import 'features/offline/domain/usecases/sincronized_usecases.dart';
import 'features/offline/domain/repositories/conectivity_repository.dart';
import 'features/offline/data/datasources/conectivity_local_repository_data_source.dart';

import 'package:appdriver/features/benefits/domain/usecases/get_benefits_all_usecase.dart';
import 'package:appdriver/features/benefits/data/repositories/benefits_repository_implementation.dart';
import 'package:appdriver/features/benefits/domain/repositories/benefits_repository.dart';
import 'package:appdriver/features/benefits/data/datasources/remote/benefits_datasource_remote.dart';

import 'package:appdriver/features/notification/domain/usecases/get_news_all_usecase.dart';
import 'package:appdriver/features/notification/data/repositories/news_repository_implementation.dart';
import 'package:appdriver/features/notification/domain/repositories/news_repository.dart';
import 'package:appdriver/features/notification/data/datasources/remote/news_datasource_remote.dart';
import 'package:appdriver/features/operation/domain/usecases/get_travels_past_all_usecase.dart';
import 'package:appdriver/features/profile/domain/usecases/trasnportunit/get_transportunit_types.dart';
import 'package:appdriver/features/profile/domain/usecases/trasnportunit/register_update_transportunit_features.dart';
import 'package:appdriver/features/tasks/domain/usecases/update_tasks_local.dart';
import 'package:appdriver/features/operation/domain/usecases/get_rating_operation_usecase.dart';

final sl = GetIt.instance;

Future<void> init() async {
  /// Blocs
  sl.registerLazySingleton<LocalNotification>(() => LocalNotification());

  sl.registerLazySingleton<PreferencesRepository>(() => PreferencesRepositoryImpl());

  sl.registerFactory(
    () => PreferencesBloc(
      preferencesRepository: sl<PreferencesRepository>(),
      initialLocale: const Locale('es', 'ES'),
    ),
  );

  sl.registerFactory(
    () => ProfileBloc(
        updateProfileContractUseCase: sl(),
        addProfileUseCase: sl(),
        getRating: sl(),
        getUserByIdUsecase: sl(),
        getTransportUnitByIdUsecase: sl(),
        updateProfilePathPhotoUseCase: sl(),
        updateProfileDocumentBackUseCase: sl(),
        updateProfileDocumentFrontUseCase: sl(),
        updateProfileDocumentLicenceUseCase: sl(),
        deleteProfileResourceUseCase: sl(),
        updateProfileUseCase: sl()),
  );
  sl.registerFactory(
    () => OpportunityBloc(
      getAllExchangeRateUseCase: sl(),
      getOportunityByIdUseCase: sl(),
      confirmPostulationUsecase: sl(),
      getCategoryAllUseCase: sl(),
      cancelledPostulationUsecase: sl(),
      getPostulationTruckUsecase: sl(),
      getOportunityAllUsecase: sl(),
      getOpportunityAllPaymentsUseCase: sl(),
      addPostulationUsecase: sl(),
      getOportunityAllRoundTripUsecase: sl(),
    ),
  );
  sl.registerFactory(
    () => OperationBloc(
      getOperationUseCase: sl(),
      updateTaskLocalUseCase: sl(),
      getRatingOperationUseCase: sl(),
      getTravelsPastAllUsecase: sl(),
      addTaskLocalUseCase: sl(),
      getAllTaskPendingUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => TransportUnitBloc(
        getTransportUnitBrands: sl(),
        updateTransportUnitPhotoUseCase: sl(),
        getTransportUnitTypes: sl(),
        getTransportUnitByIdUsecase: sl(),
        addTransportUnit: sl(),
        registerUpdateTransportUnit: sl(),
        getFeatureTransportUnitUsecase: sl(),
        removeTransportUnitPhotoUseCase: sl(),
        registerUpdateTransportUnitFeatures: sl(),
        updateTransportUnit: sl()),
  );
  sl.registerFactory(
    () => AuthenticationBloc(
      updateTokenNotificationUseCase: sl(),
      attemptAutoLoginUsecase: sl(),
      signOutUsecase: sl(),
      getTransportUnitByIdUsecase: sl(),
      getUserByIdUsecase: sl(),
    ),
  );

  sl.registerFactory(
    () => PhoneAuthenticationBloc(
      ticker: Ticker(),
      getTransportUnitByIdUsecase: sl(),
      getUserByIdUsecase: sl(),
      resendSMSCodeUsecase: sl(),
      confirmSignUpUsecase: sl(),
      loginUsecase: sl(),
      userIsSpecialUseCase: sl(),
      signUpUsecase: sl(),
    ),
  );

  sl.registerFactory(
    () => ConnectivityBloc(
        setCheckPointsUsecase: sl(),
        getAllCheckPointsUsecase: sl(),
        setTaskUsecase: sl(),
        sincronizedConectivityUseCase: sl(),
        sincronizedCheckPointsUseCase: sl(),
        getAllTaskUsecse: sl()),
  );
  sl.registerFactory(
    () => BenefitsBloc(getBenefitsAllUseCase: sl()),
  );
  sl.registerFactory(
    () => NotificationsBloc(
      getNotificationsAllUseCase: sl(),
      getNewsAllUseCase: sl(),
    ),
  );

  /// Use cases
  ///
  /// OPERATION
  sl.registerLazySingleton(() => GetRatingOperationUseCase(repository: sl()));

  /// END OPERATION
  sl.registerLazySingleton(() => AttemptAutoLoginUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetCategoryAllUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateTaskLocalUseCase(repository: sl()));

  sl.registerLazySingleton(() => UpdateTokenNotificationUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetTravelsPastAllUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetBenefitsAllUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetTransportUnitBrands(repository: sl()));
  sl.registerLazySingleton(() => SignOutUseCase(repository: sl()));
  sl.registerLazySingleton(() => ConfirmSignUpUseCase(repository: sl()));
  sl.registerLazySingleton(() => SignUpUseCase(repository: sl()));
  sl.registerLazySingleton(() => ResendSmsCodeUseCase(repository: sl()));
  sl.registerLazySingleton(() => LoginUseCase(repository: sl()));
  sl.registerLazySingleton(() => UserIsSpecialUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetTransportUnitTypes(repository: sl()));
  sl.registerLazySingleton(() => AddProfileUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetRating(repository: sl()));
  sl.registerLazySingleton(() => AddTransportUnit(repository: sl()));
  sl.registerLazySingleton(() => AddTaskLocalUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetAllTaskPendingUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetOperationUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetFeatureTransportUnitUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetOportunityAllUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetAllExchangeRateUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetOportunityByIdUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetOpportunityAllPaymentsUseCase(repository: sl()));
  sl.registerLazySingleton(() => AddPostulationUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetPostulationTruckUseCase(repository: sl()));
  sl.registerLazySingleton(() => ConfirmPostulationUseCase(repository: sl()));
  sl.registerLazySingleton(() => CancelledPostulationUseCase(repository: sl()));
  sl.registerLazySingleton(() => SynchronizedConnectivityUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetOpportunityAllRoundTripUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetAllTaskUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetUserByIdUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetTransportUnitByIdUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetAllCheckPointsUsecase(repository: sl()));
  sl.registerLazySingleton(() => SetTaskUsecase(repository: sl()));
  sl.registerLazySingleton(() => SetCheckPointsUsecase(repository: sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateProfilePathPhotoUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateTransportUnit(repository: sl()));
  sl.registerLazySingleton(() => RegisterUpdateTransportUnit(repository: sl()));
  sl.registerLazySingleton(() => RegisterUpdateTransportUnitFeatures(repository: sl()));
  sl.registerLazySingleton(() => UpdateProfileDocumentFrontUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateProfileDocumentBackUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateProfileDocumentLicenceUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateProfileContractUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateTransportUnitPhotoUseCase(repository: sl()));
  sl.registerLazySingleton(() => DeleteProfileResourceUseCase(repository: sl()));
  sl.registerLazySingleton(() => RemoveTransportUnitPhotoUseCase(repository: sl()));
  sl.registerLazySingleton(() => SynchronizedCheckPointsUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetNewsAllUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetNotificationsAllUseCase(repository: sl()));

  /// Repositorys

  sl.registerLazySingleton<BenefitsRepository>(
    () => BenefitsRepositoryImplementation(benefitsDataSourceRemote: sl()),
  );
  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImplementation(newsDataSourceRemote: sl()),
  );
  sl.registerLazySingleton<TasksRepository>(
    () => TasksRepositoryImplementation(
      tasksDataSourceRemote: sl(),
    ),
  );

  sl.registerLazySingleton<OportunityRepository>(
    () => OpportunityRepositoryImplementation(
      opportunityDataSourceRemote: sl(),
    ),
  );
  sl.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImplementation(
      remoteDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<OperationRepository>(
    () => OperationRepositoryImplementation(
      operationDasourceRemote: sl(),
    ),
  );
  sl.registerLazySingleton<TransportUnitRepository>(
    () => TransportUnitRepositoryImplementation(
      transportUnitDataSourceRemote: sl(),
    ),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImplementation(
      profileDataSourceRemote: sl(),
    ),
  );
  sl.registerLazySingleton<PhoneAuthenticationRepository>(
    () => PhoneAuthenticationRepositoryImplementation(
      remoteDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<ConnectivityRepository>(
    () => ConnectivityRepositoryImplementation(
      connectivityLocalRepository: sl(),
    ),
  );

  /// Data sources
  sl.registerLazySingleton<TasksDataSourceRemote>(
    () => TasksDataSourceRemote(dio: sl()),
  );
  sl.registerLazySingleton<BenefitsDataSourceRemote>(
    () => BenefitsDataSourceRemote(),
  );
  sl.registerLazySingleton<NewsDataSourceRemote>(
    () => NewsDataSourceRemote(),
  );
  sl.registerLazySingleton<OpportunityDataSourceRemote>(
    () => OpportunityDataSourceRemote(dio: sl()),
  );
  sl.registerLazySingleton<OperationDatasourceRemote>(
    () => OperationDatasourceRemote(dio: sl()),
  );
  sl.registerLazySingleton<ProfileDataSourceRemote>(
    () => ProfileDataSourceRemote(dio: sl()),
  );
  sl.registerLazySingleton<TransportUnitDataSourceRemote>(
    () => TransportUnitDataSourceRemote(dio: sl()),
  );
  sl.registerLazySingleton<AuthenticationRemoteDataSource>(
    () => AuthenticationRemoteDataSource(),
  );
  sl.registerLazySingleton<PhoneAuthenticationRemoteDataSource>(
    () => PhoneAuthenticationRemoteDataSource(),
  );

  sl.registerLazySingleton<ConnectivityRepositoryDataSource>(
    () => ConnectivityRepositoryDataSource(dio: sl()),
  );

  /// External
  sl.registerLazySingleton(() => Dio());
}
