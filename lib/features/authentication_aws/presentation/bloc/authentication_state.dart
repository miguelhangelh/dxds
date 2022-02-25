part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}
class AuthenticationUninitialized extends AuthenticationState {}
class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationUnauthenticated extends AuthenticationState {
  final String message;
  const AuthenticationUnauthenticated({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class AuthenticationAuthenticated extends AuthenticationState {
  
}
class PhoneAuthViewState extends AuthenticationState {}
class LoginMainViewState extends AuthenticationState {}
class ProfileMainViewState extends AuthenticationState {}
class ProfileSignatureViewState extends AuthenticationState {}
class TransportUnitTypeMainViewState extends AuthenticationState {}
class TransportUnitDataMainViewState extends AuthenticationState {}
class TransportUnitFeaturesMainViewState extends AuthenticationState {}
class TruckViewState extends AuthenticationState {}
class OpportunityViewState extends AuthenticationState {}
class HomeViewState extends AuthenticationState {}
class GuestModeState extends AuthenticationState {}
class OperationPageState extends AuthenticationState {}
class OperationContractState extends AuthenticationState {}
class AuthenticatedOnBoardingIncompleteState extends AuthenticationState {}