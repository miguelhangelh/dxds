import 'dart:async';

enum TypeRegister { profileRegister, transportUnitType, transportUnitData, transportUnitFeatures, opportunity, login, operation }

class AuthenticationSubcriptions {
  AuthenticationSubcriptions._internal();
  static final AuthenticationSubcriptions _instance = AuthenticationSubcriptions._internal();
  static AuthenticationSubcriptions get instance => _instance;

  // ignore: close_sinks
  final StreamController<TypeRegister> _controllerNotification = StreamController.broadcast();
  Stream<TypeRegister> get stream => _controllerNotification.stream;
  set streamAdd(TypeRegister typeRegister) => _controllerNotification.sink.add(typeRegister);
}
