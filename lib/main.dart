import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutterdemo/firebase_sign_app/google_authentication.dart';
import 'package:flutterdemo/firebase_sign_app/userdetails.dart';
import 'package:flutterdemo/wallpaper_app/services/local_notification/local_flutter_notification.dart';
import 'package:flutterdemo/wallpaper_app/wallscreen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

//background handler can fetch the data before clickin on Notification
// app is in background but and opened not terminated
Future<void> onBackgrounNotification(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(onBackgrounNotification);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  @override
  Widget build(BuildContext context) {
    LocalNotificationService.initialize();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      home: WallScreen(analytics: analytics, observer: observer),
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      routes: {
        "/userdetails": (context) => UserDetails(),
      },
      navigatorObservers: <NavigatorObserver>[observer],
    );
  }
}
