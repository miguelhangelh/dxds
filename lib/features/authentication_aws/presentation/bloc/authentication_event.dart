part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationStarted extends AuthenticationEvent {}
class AppStarted extends AuthenticationEvent {}
class AuthenticationInitialSplash extends AuthenticationEvent {}
class PhoneAuthView extends AuthenticationEvent {}
class LoginMainViewEvent extends AuthenticationEvent {}
class AuthenticationStateChanged extends AuthenticationEvent {
  final dynamic hubEvent;
  const AuthenticationStateChanged({
    required this.hubEvent,
  });
  @override
  List<Object> get props => [hubEvent];
}
class UpdateTokenNotification extends AuthenticationEvent {
  final String token;

  const UpdateTokenNotification(this.token);
}
class AuthenticationGoogleStarted extends AuthenticationEvent {}

class AuthenticationExited extends AuthenticationEvent {}
class ProfileMainViewEvent extends AuthenticationEvent {}
class TruckViewEvent extends AuthenticationEvent {}
class OpportunityViewEvent extends AuthenticationEvent {}
class HomeViewEvent extends AuthenticationEvent {}
class GuestModeEvent extends AuthenticationEvent {}
class OperationPageEvent extends AuthenticationEvent {}

