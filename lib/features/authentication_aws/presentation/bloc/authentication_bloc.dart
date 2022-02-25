import 'dart:async';

import 'package:amplify_flutter/amplify.dart';
import 'package:appdriver/features/models/user_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:appdriver/core/share_prefs/user_pref.dart';
import 'package:appdriver/core/utils/functions.dart';
import 'package:appdriver/features/authentication_aws/domain/usecases/attempt_auto_login_usecase.dart';
import 'package:appdriver/features/authentication_aws/domain/usecases/sign_out_usecase.dart';
import 'package:appdriver/features/authentication_aws/domain/usecases/update_token_notification_usecase.dart';
import 'package:appdriver/features/profile/domain/usecases/profile/get_transportUnit_by_id_usecase.dart';
import 'package:appdriver/features/profile/domain/usecases/profile/get_user_by_id_usecase.dart';
import 'package:appdriver/features/authentication_aws/subcriptions/subcription_bloc_authentication.dart';
import 'package:appdriver/features/authentication_aws/subcriptions/subscription_notification_update.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AttemptAutoLoginUseCase attemptAutoLoginUsecase;
  final UpdateTokenNotificationUseCase updateTokenNotificationUseCase;
  final SignOutUseCase signOutUsecase;
  final GetUserByIdUsecase getUserByIdUsecase;
  final GetTransportUnitByIdUsecase getTransportUnitByIdUsecase;
  late StreamSubscription authStreamSub;
  UserPreference userPreference = UserPreference();

  AuthenticationBloc({
    required this.attemptAutoLoginUsecase,
    required this.updateTokenNotificationUseCase,
    required this.signOutUsecase,
    required this.getUserByIdUsecase,
    required this.getTransportUnitByIdUsecase,
  }) : super(AuthenticationUninitialized()) {
    NotificationUpdateSubscription.instance.stream.listen((event) async {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        add(UpdateTokenNotification(token));
      }
    });
  }
  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      FirebaseMessaging.instance.onTokenRefresh.listen((String? token) {
        if (token != null) {
          add(UpdateTokenNotification(token));
          FirebaseCrashlytics.instance.log("en algun momento cambio el token $token ");
        }
      });
      Amplify.Hub.listen([HubChannel.Auth], (hubEvent) async {
        try {
          UserModel? user = await getUserByIdUsecase();
          checkRegistrationNewUser(user!, hubEvent);
        } catch (e) {
          AuthenticationSubcriptions.instance.streamAdd = TypeRegister.opportunity;
        }
      });
      yield* _appStarted();
    }
    if (event is UpdateTokenNotification) {
      UserModel user = userPreference.getUser;
      await updateTokenNotificationUseCase(user, event.token);
    }
    if (event is AuthenticationInitialSplash) {
      yield AuthenticationLoading();
      if (userPreference.onBoarding) {
        final user = await attemptAutoLoginUsecase();
        if (user) {
          var exist = userPreference.transportUnit;
          if (exist != null) {
            yield AuthenticationAuthenticated();
          } else {
            yield ProfileMainViewState();
          }
        } else {
          yield AuthenticationUnauthenticated(message: 'Error occrued while fetching auth detail');
        }
      } else {
        yield AuthenticationInitial();
      }
    }
    if (event is AuthenticationStarted) {
      yield AuthenticationLoading();
      final user = await attemptAutoLoginUsecase();
      if (user) {
        var exist = userPreference.transportUnit;
        if (exist != null) {
          yield AuthenticationAuthenticated();
        } else {
          yield ProfileMainViewState();
        }
      } else {
        yield AuthenticationUnauthenticated(message: 'Error occrued while fetching auth detail');
      }
    } else if (event is AuthenticationStateChanged) {
      if (event.hubEvent == "SIGNED_IN") {
        var exist = userPreference.transportUnit;
        if (exist != null) {
          yield AuthenticationAuthenticated();
        } else {
          yield ProfileMainViewState();
        }
      } else if (event.hubEvent == "SIGNED_OUT") {
        yield AuthenticationUnauthenticated(message: 'User has logged out');
      } else {
        yield AuthenticationUnauthenticated(message: 'User has expired out');
      }
    } else if (event is AuthenticationExited) {
      yield AuthenticationLoading();
      await signOutUsecase();
      yield AuthenticationUnauthenticated(message: 'User has logged out');
    } else if (event is PhoneAuthView) {
      try {
        yield PhoneAuthViewState();
      } catch (error) {
        yield AuthenticationUnauthenticated(message: 'Unable to logout. Please try again.');
      }
    } else if (event is LoginMainViewEvent) {
      yield LoginMainViewState();
    } else if (event is ProfileMainViewEvent) {
      yield ProfileMainViewState();
    } else if (event is TruckViewEvent) {
      yield TruckViewState();
    } else if (event is OpportunityViewEvent) {
      yield OpportunityViewState();
    } else if (event is HomeViewEvent) {
      yield HomeViewState();
    } else if (event is GuestModeEvent) {
      userPreference.guestMode = true;
      yield GuestModeState();
    } else if (event is OperationPageEvent) {
      yield OperationPageState();
    }
  }

  Stream<AuthenticationState> _appStarted() async* {
    await _cleanIfFirstUseAfterUninstall();
    yield* _initStartup();
  }

  Stream<AuthenticationState> _initStartup() async* {
    try {
      final bool? user = await attemptAutoLoginUsecase();
      yield await checkRegistrationExistUser(user);
    } catch (e) {
      yield AuthenticationAuthenticated();
    }
  }

  Future<void> _cleanIfFirstUseAfterUninstall() async {
    if (userPreference.firstRun) {
      await userPreference.clear();
      userPreference.firstRun = false;
    }
  }
}
