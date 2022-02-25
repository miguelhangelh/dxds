// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:appdriver/core/pusher/pusher.dart';
import 'package:appdriver/core/utils/functions.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:appdriver/core/error/api_helper.dart';
import 'package:appdriver/core/share_prefs/user_pref.dart';
import 'package:appdriver/features/models/transport_unit_model.dart';
import 'package:appdriver/features/models/travel_model.dart';
import 'package:appdriver/features/operation/data/supcriptions/supcription_bloc_operation.dart';
import 'package:appdriver/features/opportunity/data/supcriptions/supcription_oportunity.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:appdriver/core/utils/notifications_type.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

/// Create a [AndroidNotificationChannel] for heads up notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.', // description
  importance: Importance.high,
);
UserPreference userPreference = UserPreference();
ApiBaseHelper _helper = ApiBaseHelper();
final PusherConfig _pusher = PusherConfig();

class LocalNotification {
  Future setupFirebase() async {
    await Firebase.initializeApp();
    getToken();
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@drawable/ic_launcher_notification');
    final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {
          print('payload $payload');
        });
    const MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings(requestAlertPermission: false, requestBadgePermission: false, requestSoundPermission: false);
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS, macOS: initializationSettingsMacOS);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (String? payload) async {
      var data = json.decode(payload!);
      if (data!['type'] == notificationType(NOTIFICATION.TRAVEL_NEW) || data!['type'] == notificationType(NOTIFICATION.POSTULATION_ACCEPTED) ) {
        postulationNewOnMessageOpenedApp(data);
        return;
      }

      OperationSubcriptions.instance.streamAdd = data;
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print('onMessageOpenedApp ${message.data}');
      print('onMessageOpenedApp ${message.notification}');
      if (message.data['type'] == notificationType(NOTIFICATION.POSTULATION_ACCEPTED)) {
        await postulationAcceptedOnMessageOpenedApp(message);
      }
      if (message.data['type'] == notificationType(NOTIFICATION.ASSIGNED_LOAD_ORDER)) {
        OperationSubcriptions.instance.streamAdd = message.data;
      }
      if (message.data['type'] == notificationType(NOTIFICATION.UPDATE_USER)) {
        updateUser();
      }
      if (message.data['type'] == notificationType(NOTIFICATION.TRAVEL_NEW)) {
        OperationSubcriptions.instance.streamAdd = message.data;
      }
      if (message.data['type'] == notificationType(NOTIFICATION.NEWS)) {
        OperationSubcriptions.instance.streamAdd = message.data;
      }
      if (message.data['type'] == notificationType(NOTIFICATION.BENEFITS)) {
        OperationSubcriptions.instance.streamAdd = message.data;
      }
      if (message.data['type'] == notificationType(NOTIFICATION.LOCATION)) {
        sendCheckPointsOnline();
      }
      if (message.data['type'] == notificationType(NOTIFICATION.TRAVEL_PAID)) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.remove('operation');
        await bg.BackgroundGeolocation.stop();
        await bg.BackgroundGeolocation.stopSchedule();
        await BackgroundFetch.stop();
        await _pusher.disconnect();
        taskdeleteAll();

        OperationSubcriptions.instance.streamAdd = message.data;
      }
      if (message.data['type'] == notificationType(NOTIFICATION.CANCEL_LOAD_ORDER)) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.remove('operation');
        await bg.BackgroundGeolocation.stop();
        await bg.BackgroundGeolocation.stopSchedule();
        await BackgroundFetch.stop();
        await _pusher.disconnect();
        taskdeleteAll();
        OperationSubcriptions.instance.streamAdd = message.data;
      }
      if (message.data['type'] == notificationType(NOTIFICATION.REJECT_TASK)) {
        taskRejected(message.data['taskId']);
      }
      if (message.data['type'] == notificationType(NOTIFICATION.VALIDATE_TASK)) {
        taskValidate(message.data['taskId']);
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('onMessage ${message.data}');
      print('onMessage ${message.notification}');
      if (message.data['type'] == notificationType(NOTIFICATION.POSTULATION_ACCEPTED)) {
        postulationAcceptedOnMessage(message);
        return;
      }
      if (message.data['type'] == notificationType(NOTIFICATION.LOCATION)) {
        locationOnMessage(message);
        return;
      }
      if (message.data['type'] == notificationType(NOTIFICATION.UPDATE_USER)) {
        updateUser();
        showNotifyLocal(message);
        return;
      }
      if (message.data['type'] == notificationType(NOTIFICATION.TRAVEL_PAID)) {
        taskdeleteAll();
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.remove('operation');
        await bg.BackgroundGeolocation.stop();
        await bg.BackgroundGeolocation.stopSchedule();
        await BackgroundFetch.stop();
        await _pusher.disconnect();
        OperationSubcriptions.instance.streamAdd = message.data;
      }
      if (message.data['type'] == notificationType(NOTIFICATION.CANCEL_LOAD_ORDER)) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.remove('operation');
        await bg.BackgroundGeolocation.stop();
        await bg.BackgroundGeolocation.stopSchedule();
        await BackgroundFetch.stop();
        await _pusher.disconnect();
        taskdeleteAll();
        OperationSubcriptions.instance.streamAdd = message.data;
        showNotifyLocal(message);
        return;
      }
      if (message.data['type'] == notificationType(NOTIFICATION.REJECT_TASK)) {
        taskRejected(message.data['taskId']);
        showNotifyLocal(message);
        return;
      }
      if (message.data['type'] == notificationType(NOTIFICATION.VALIDATE_TASK)) {
        // await initPlatformState();
        taskValidate(message.data['taskId']);
        showNotifyLocal(message);
        return;
      }
      if (message.data['type'] == notificationType(NOTIFICATION.ASSIGNED_LOAD_ORDER)) {
        OperationSubcriptions.instance.streamAdd = message.data;
        showNotifyLocal(message);
        return;
      }
      if (message.data['type'] == notificationType(NOTIFICATION.TRAVEL_NEW)) {
        OpportunitySubcriptions.instance.streamAdd = OpportunityStream(
          travel: null,
          notify: true,
        );
        showNotifyLocal(message);
        return;
      }
      showNotifyLocal(message);
    });
  }

  showNotifyLocal(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            ticker: 'ticker',
            icon: android.smallIcon,
          ),
        ),
        payload: json.encode(message.data),
      );
    }
  }

  Future<void> showNotification({int id = 0, String? title, String? body}) async {
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
        ),
      ),
    );
  }

  Future<void> showNotificationHeadless({int id = 0, String? title, String? body}) async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@drawable/ic_launcher_notification');

    InitializationSettings initializationSettings = const InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (String? payload) async {});
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
        ),
      ),
    );
  }

  postulationAcceptedOnMessageOpenedApp(RemoteMessage message) async {
    TransportUnitModel transportUnit = userPreference.transportUnit!;
    var url = dotenv.env['URL_OPPORTUNITY']! + "/" + message.data['travelId'] + "/transportUnitId/" + transportUnit.id!;
    var response = await _helper.get(url);
    TravelModel travel = TravelModel.fromJson(response['travel']);
    OpportunitySubcriptions.instance.streamAdd = OpportunityStream(
      travel: travel,
      notify: true,
    );
  }
  postulationNewOnMessageOpenedApp(dynamic data) async {
    TransportUnitModel transportUnit = userPreference.transportUnit!;
    var url = dotenv.env['URL_OPPORTUNITY']! + "/" + data['travelId'] + "/transportUnitId/" + transportUnit.id!;
    var response = await _helper.get(url);
    TravelModel travel = TravelModel.fromJson(response['travel']);
    OpportunitySubcriptions.instance.streamAdd = OpportunityStream(
      travel: travel,
      notify: true,
    );
  }
  void locationOnMessage(RemoteMessage message) async {
    Map<String, dynamic>? notificationData;
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (message.data['type'] == notificationType(NOTIFICATION.LOCATION)) {
      sendCheckPointsOnline();
    }
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            ticker: 'ticker',
            icon: android.smallIcon,
          ),
        ),
        payload: json.encode(notificationData),
      );
    }
  }

  void postulationAcceptedOnMessage(RemoteMessage message) async {
    Map<String, dynamic>? notificationData;
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (message.data['type'] == notificationType(NOTIFICATION.POSTULATION_ACCEPTED)) {
      TransportUnitModel transportUnit = userPreference.transportUnit!;
      var url = dotenv.env['URL_OPPORTUNITY']! + "/" + message.data['travelId'] + "/transportUnitId/" + transportUnit.id!;
      var response = await _helper.get(url);
      TravelModel travel = TravelModel.fromJson(response['travel']);
      OpportunitySubcriptions.instance.streamAdd = OpportunityStream(
        travel: travel,
        notify: false,
      );
      notificationData = {"travel": travel, "data": message.data};
    }
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            ticker: 'ticker',
            icon: android.smallIcon,
          ),
        ),
        payload:  json.encode(message.data),
      );
    }
  }
}

getToken() async {
  String? token = await FirebaseMessaging.instance.getToken();
  print('TOKEN-> : $token');
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // print( message.notification.);
  print('_firebaseMessagingBackgroundHandler ${message.data}');
  print('_firebaseMessagingBackgroundHandler');
  if (message.data['type'] == notificationType(NOTIFICATION.REJECT_TASK)) {
    taskRejectedHeadLess(message.data['taskId']);
  }
  if (message.data['type'] == notificationType(NOTIFICATION.TRAVEL_PAID)) {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    taskdeleteAllHeadless();
    await preferences.remove('operation');
    await bg.BackgroundGeolocation.stop();
    await bg.BackgroundGeolocation.stopSchedule();
    await BackgroundFetch.stop();
    await _pusher.disconnect();
  }
  if (message.data['type'] == notificationType(NOTIFICATION.LOCATION)) {
    sendCheckPointsOnlineHeadless();
  }
  if (message.data['type'] == notificationType(NOTIFICATION.UPDATE_USER)) {
    updateUserHeadLess();
  }
  if (message.data['type'] == notificationType(NOTIFICATION.VALIDATE_TASK)) {
    taskValidateHeadless(message.data['taskId']);
  }
  if (message.data['type'] == notificationType(NOTIFICATION.CANCEL_LOAD_ORDER)) {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('operation');
    await bg.BackgroundGeolocation.stop();
    await bg.BackgroundGeolocation.stopSchedule();
    await BackgroundFetch.stop();
    await _pusher.disconnect();
    taskdeleteAllHeadless();
  }
}
