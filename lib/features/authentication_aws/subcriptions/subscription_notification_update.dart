import 'dart:async';


class NotificationUpdateSubscription {
  NotificationUpdateSubscription._internal();
  static final NotificationUpdateSubscription _instance = NotificationUpdateSubscription._internal();
  static NotificationUpdateSubscription get instance => _instance;

  // ignore: close_sinks
  final StreamController<bool> _controllerNotification = StreamController.broadcast();
  Stream<bool> get stream => _controllerNotification.stream;
  set streamAdd(bool update) => _controllerNotification.sink.add(update);
}