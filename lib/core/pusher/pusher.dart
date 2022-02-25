import 'dart:developer';

import 'package:appdriver/core/notifications_locale/local_notification.dart';
import 'package:appdriver/core/share_prefs/user_pref.dart';
import 'package:appdriver/core/utils/functions.dart';
import 'package:appdriver/features/operation/data/supcriptions/task_subscriptions_operation.dart';
import 'package:pusher_client/pusher_client.dart';

class PusherConfig {
  static final PusherConfig _instance = PusherConfig._();
  final PusherClient _pusher = PusherClient(
    "f8f1c4d725ab089521d6",
    PusherOptions(cluster: "us2", encrypted: false),
    enableLogging: true,
  );
  late Channel _channel;
  factory PusherConfig() {
    return _instance;
  }

  PusherConfig._();

  Future<void> connect() async {
    UserPreference userPreference = UserPreference();
    var operation = userPreference.operation;
    _channel = _pusher.subscribe("loading-${operation!.id}");
    _pusher.onConnectionStateChange((state) {
      log("previousState: ${state?.previousState}, currentState: ${state?.currentState}");
    });
    _pusher.onConnectionError((error) {
      log("error: ${error?.message}");
    });
    _channel.bind('perform-tasks', (event) {
      log(event?.data ?? "");
      TaskSubscriptionsOperation.instance.streamAdd = true;
    });
    _channel.bind('location', (event) {
      log(event?.data ?? "");
      sendCheckPointsOnline();
    });
    await _pusher.connect();
  }

  Future<void> disconnect() async {
    await _pusher.disconnect();
  }
}
