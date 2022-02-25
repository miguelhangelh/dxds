part of 'phone_authentication1_bloc.dart';

abstract class PhoneAuthenticationEvent extends Equatable {
  const PhoneAuthenticationEvent();

  @override
  List<Object> get props => [];
}

class PhoneAuthLogin extends PhoneAuthenticationEvent {
  final String username;
  const PhoneAuthLogin({
    required this.username,
  });

  @override
  List<Object> get props => [username];
}

class PhoneAuthRegister extends PhoneAuthenticationEvent {}

class UserEspecial extends PhoneAuthenticationEvent {
  final String username;
  const UserEspecial({
    required this.username,
  });

  @override
  List<Object> get props => [username];
}

class PhoneAuthCodeResetError extends PhoneAuthenticationEvent {}

class PhoneAuthWrongNumber extends PhoneAuthenticationEvent {}

class PhoneAuthError extends PhoneAuthenticationEvent {}

class TimerStarted extends PhoneAuthenticationEvent {
  final int? duration;

  const TimerStarted({required this.duration});
}

class TimerReset extends PhoneAuthenticationEvent {}

class TimerTicked extends PhoneAuthenticationEvent {
  final int duration;

  const TimerTicked({required this.duration});

  @override
  List<Object> get props => [duration];
}

class PhoneDetectCode extends PhoneAuthenticationEvent {
  final String smsCode;
  PhoneDetectCode({
    required this.smsCode,
  });

  @override
  List<Object> get props => [smsCode];
}

class PhoneUpdateCode extends PhoneAuthenticationEvent {
  final String smsCode;
  PhoneUpdateCode({
    required this.smsCode,
  });

  @override
  List<Object> get props => [smsCode];
}

class PhoneAuthCodeVerified extends PhoneAuthenticationEvent {}

class PhoneAuthCodeAutoRetrevalTimeout extends PhoneAuthenticationEvent {
  final String verificationId;
  PhoneAuthCodeAutoRetrevalTimeout(this.verificationId);
  @override
  List<Object> get props => [verificationId];
}

class PhoneAuthCodeSent extends PhoneAuthenticationEvent {
  final String verificationId;
  final int token;
  PhoneAuthCodeSent({
    required this.verificationId,
    required this.token,
  });

  @override
  List<Object> get props => [verificationId, token];
}

class PhoneAuthVerificationFailed extends PhoneAuthenticationEvent {
  final String message;

  PhoneAuthVerificationFailed(this.message);
  @override
  List<Object> get props => [message];
}

class PhoneAuthVerificationCompleted extends PhoneAuthenticationEvent {
  final String uid;
  PhoneAuthVerificationCompleted(this.uid);
  @override
  List<Object> get props => [uid];
}

class ResendCode extends PhoneAuthenticationEvent {}
