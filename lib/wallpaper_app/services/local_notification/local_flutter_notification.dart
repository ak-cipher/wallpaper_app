import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutterdemo/main.dart';
import 'package:flutterdemo/wallpaper_app/fullscreen_imageview.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    const InitializationSettings _initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings('@mipmap/ic_launcher'));

    _notificationsPlugin.initialize(
      _initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        print('called');
        if (navigatorKey.currentContext != null) {
          Navigator.of(navigatorKey.currentContext!).push(MaterialPageRoute(
              builder: ((context) => FullScreenImageView(details.payload!))));
        }
      },
    );
  }

  static void display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      const NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
        'akash',
        'Akash Channel',
        channelDescription: 'my channel',
        importance: Importance.max,
        priority: Priority.high,
      ));

      await _notificationsPlugin.show(id, message.notification!.title,
          message.notification!.title, notificationDetails,
          payload: message.data['imageurl']);
    } on Exception catch (e) {
      print(e);
    }
  }
}
