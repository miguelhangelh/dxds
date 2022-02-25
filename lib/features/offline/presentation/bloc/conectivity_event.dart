
part of 'conectivity_bloc.dart';

abstract class ConnectivityEvent {}

class OnOnline extends ConnectivityEvent {}

class OnOffline extends ConnectivityEvent {}

class OnConnecting extends ConnectivityEvent {}

class SuccessTask extends ConnectivityEvent {}

class CancelTask extends ConnectivityEvent {}

