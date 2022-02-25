
import 'dart:async';

import 'package:appdriver/features/offline/data/models/checkpoints_local.dart';
import 'package:appdriver/features/offline/data/models/tasks_local.dart';

class SubscriptionConnectivity {
  
  SubscriptionConnectivity._internal();
  static final SubscriptionConnectivity _instance = SubscriptionConnectivity._internal();
  static SubscriptionConnectivity get instance => _instance;

  final StreamController<TaskLocal> _controller = StreamController.broadcast();
  Stream<TaskLocal> get stream => _controller.stream;
  set streamAdd(TaskLocal task) => _controller.sink.add(task);

  final StreamController<CheckPointsLocal> _controllerCheckPoint = StreamController.broadcast();
  Stream<CheckPointsLocal> get streamCheckPoints => _controllerCheckPoint.stream;
  set streamAddCheckPoints(CheckPointsLocal value) => _controllerCheckPoint.sink.add(value);

}
