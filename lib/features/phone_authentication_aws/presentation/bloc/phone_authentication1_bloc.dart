import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:appdriver/features/phone_authentication_aws/domain/usecases/user_is_special_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:appdriver/core/share_prefs/user_pref.dart';
import 'package:appdriver/features/phone_authentication_aws/domain/usecases/confirm_sign_up_usecase.dart';
import 'package:appdriver/features/phone_authentication_aws/domain/usecases/login_usecase.dart';
import 'package:appdriver/features/phone_authentication_aws/domain/usecases/re_send_sms.dart';
import 'package:appdriver/features/phone_authentication_aws/domain/usecases/sign_up_usecase.dart';
import 'package:appdriver/features/phone_authentication_aws/presentation/bloc/ticker.dart';
import 'package:appdriver/features/profile/domain/usecases/profile/get_transportUnit_by_id_usecase.dart';
import 'package:appdriver/features/profile/domain/usecases/profile/get_user_by_id_usecase.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

part 'phone_authentication1_event.dart';
part 'phone_authentication1_state.dart';

class PhoneAuthenticationBloc extends Bloc<PhoneAuthenticationEvent, PhoneAuthenticationState> {
  final ConfirmSignUpUseCase confirmSignUpUsecase;
  final LoginUseCase loginUsecase;
  final UserIsSpecialUseCase userIsSpecialUseCase;
  final SignUpUseCase signUpUsecase;
  final ResendSmsCodeUseCase resendSMSCodeUsecase;
  final Ticker ticker;
  final GetUserByIdUsecase getUserByIdUsecase;
  final GetTransportUnitByIdUsecase getTransportUnitByIdUsecase;
  UserPreference userPreference = UserPreference();
  final TextEditingController textEditingController = TextEditingController();
  static const int _duration = 60;
  StreamSubscription<int>? _tickerSubscription;

  PhoneAuthenticationBloc({
    required this.ticker,
    required this.confirmSignUpUsecase,
    required this.loginUsecase,
    required this.userIsSpecialUseCase,
    required this.signUpUsecase,
    required this.resendSMSCodeUsecase,
    required this.getUserByIdUsecase,
    required this.getTransportUnitByIdUsecase,
  }) : super(PhoneAuthenticationState.initialState);

  @override
  Stream<PhoneAuthenticationState> mapEventToState(PhoneAuthenticationEvent event) async* {
    if (event is PhoneUpdateCode) {
      yield state.copyWith(smsCode: event.smsCode);
    }
    if (event is PhoneAuthCodeResetError) {
      yield state.copyWith(error: !state.error!);
    }
    if (event is ResendCode) {
      add(const TimerStarted(duration: _duration));
      await resendSMSCodeUsecase(username: state.username);
      yield state.copyWith(completedTicker: false);
    } else if (event is PhoneDetectCode) {
      add(TimerReset());
      yield state.copyWith(smsCode: event.smsCode);
      add(PhoneAuthCodeVerified());
    } else if (event is PhoneAuthLogin) {
      yield* _phoneAuthNumberVerifiedToState(event);
    } else if (event is PhoneAuthCodeVerified) {
      yield state.copyWith(loading: true);
      try {
        final confirm = await confirmSignUpUsecase(username: state.username, confirmationCode: state.smsCode);
        if (confirm) {
          await loginUsecase(username: state.username);
          yield state.copyWith(loginSuccess: true);
        } else {
          yield state.copyWith(error: true, loading: false);
        }
      } on NotAuthorizedException catch (_) {
        await loginUsecase(username: state.username);
      } on CodeMismatchException catch (_) {
        yield state.copyWith(loading: false, error: true);
      } catch (e) {
        yield state.copyWith(loading: false);
      }
    } else if (event is TimerStarted) {
      yield* _mapTimerStartedToState(event);
    } else if (event is TimerReset) {
      yield* _mapTimerResetToState(event);
    } else if (event is TimerTicked) {
      yield* _mapTimerTickedToState(event);
    } else if (event is PhoneAuthRegister) {
      final isSignUpComplete = await signUpUsecase(username: state.username);
      if (isSignUpComplete) {
        add(TimerStarted(duration: state.duration));
        yield state.copyWith(verifiedNumber: true, loading: false);
      }
    } else if (event is PhoneAuthWrongNumber) {
      add(TimerReset());
      yield state.copyWith(
        username: '',
        smsCode: '',
        loading: false,
        loginSuccess: false,
        registerSuccess: false,
        verifiedNumber: false,
        error: false,
        duration: 60,
        errorCreate: false,
        completedTicker: false,
        messageError: '',
      );
    }
    if (event is UserEspecial) {
      try {
        yield state.copyWith(loading: true, errorCreate: false);
        bool user = await userIsSpecialUseCase(username: event.username);
        if (user) {
          await loginUsecase(username: event.username);
        } else {
          yield state.copyWith(loading: false);
        }
      } catch (e) {
        yield state.copyWith(loading: false, errorCreate: true);
      }
    }
    if (event is PhoneAuthError) {
      yield state.copyWith(errorCreate: false);
    }
  }

  Stream<PhoneAuthenticationState> _phoneAuthNumberVerifiedToState(PhoneAuthLogin event) async* {
    try {
      yield state.copyWith(loading: true, errorCreate: false);
      await signUpUsecase(username: event.username);
      add(TimerStarted(duration: state.duration));
      yield state.copyWith(verifiedNumber: true, loading: false, username: event.username, errorCreate: false);
      add(UserEspecial(username: event.username));
    } on UsernameExistsException catch (_) {
      add(TimerStarted(duration: state.duration));
      yield state.copyWith(verifiedNumber: true, loading: false, username: event.username);
      await resendSMSCodeUsecase(username: event.username);
      add(UserEspecial(username: event.username));
    } on UserNotConfirmedException catch (_) {
      yield state.copyWith(verifiedNumber: true, loading: false, username: event.username);
      add(ResendCode());
    } on LimitExceededException catch (_) {
      FirebaseCrashlytics.instance.log("Número bloqueado ${event.username}");
      yield state.copyWith(verifiedNumber: false, loading: false, username: event.username, errorCreate: true);
      // add(ResendCode());
    } catch (e) {
      yield state.copyWith(verifiedNumber: false, loading: false, username: event.username, errorCreate: true);
    }
  }

  Stream<PhoneAuthenticationState> _mapTimerStartedToState(TimerStarted start) async* {
    yield state.copyWith(duration: start.duration);
    _tickerSubscription?.cancel();
    _tickerSubscription = ticker.tick(ticks: start.duration!).listen((duration) => add(TimerTicked(duration: duration)));
  }

  Stream<PhoneAuthenticationState> _mapTimerResetToState(TimerReset reset) async* {
    _tickerSubscription?.cancel();
    yield state.copyWith(duration: -1, completedTicker: true);
  }

  Stream<PhoneAuthenticationState> _mapTimerTickedToState(TimerTicked tick) async* {
    yield tick.duration > 0 ? state.copyWith(duration: tick.duration) : state.copyWith(duration: 0, completedTicker: true);
  }
}
