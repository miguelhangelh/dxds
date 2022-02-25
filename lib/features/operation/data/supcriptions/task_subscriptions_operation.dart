import 'dart:async';

class TaskSubscriptionsOperation {
  TaskSubscriptionsOperation._internal();
  static TaskSubscriptionsOperation _instance = TaskSubscriptionsOperation._internal();
  static TaskSubscriptionsOperation get instance => _instance;

  // ignore: close_sinks
  StreamController<bool> _streamController = StreamController.broadcast();
  Stream<bool> get stream => _streamController.stream;
  set streamAdd(bool task) => _streamController.sink.add(task);
}
