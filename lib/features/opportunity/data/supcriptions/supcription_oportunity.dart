import 'dart:async';

import 'package:appdriver/features/models/travel_model.dart';

class OpportunitySubcriptions {
  OpportunitySubcriptions._internal();
  static final OpportunitySubcriptions _instance = OpportunitySubcriptions._internal();
  static OpportunitySubcriptions get instance => _instance;

  // ignore: close_sinks
  final StreamController<OpportunityStream> _controllerNotification =
      StreamController.broadcast();
  Stream<OpportunityStream> get stream => _controllerNotification.stream;
  set streamAdd(OpportunityStream task) =>
      _controllerNotification.sink.add(task);
}

class OpportunityStream {
  final TravelModel? travel;
  final notify;

  OpportunityStream({required this.travel, this.notify = false});
}
