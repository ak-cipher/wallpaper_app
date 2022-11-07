import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutterdemo/main.dart';
import 'package:flutterdemo/wallpaper_app/fullscreen_imageview.dart';
import 'package:flutterdemo/wallpaper_app/services/local_notification/local_flutter_notification.dart';

class WallScreen extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  WallScreen({required this.analytics, required this.observer});
  @override
  State<WallScreen> createState() => _WallScreenState();
}

class _WallScreenState extends State<WallScreen> {
  StreamSubscription<QuerySnapshot>? wallpaperchangeSubscription;
  List<DocumentSnapshot>? wallpaperList;

  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("/wallpaper");

  Future<void> CurrentScreen() async {
    await widget.analytics.setCurrentScreen(
        screenName: "WallScreen", screenClassOverride: 'WallScreen');
  }

  Future<void> _sendAnalytics() async {
    print("Sending Analytics");
    await widget.analytics.logEvent(
      name: 'Tap_to_full_sccreen',
      parameters: <String, dynamic>{'string': 'string', 'int': 16},
    );
  }

  @override
  void initState() {
    super.initState();
    wallpaperchangeSubscription =
        collectionReference.snapshots().listen((datasnapshot) {
      setState(() {
        wallpaperList = datasnapshot.docs;
      });
    });

    //gives you the message of the notfication on which user taps
    //works on when app is in terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        final imgPath = message.data['imageurl'];
        Navigator.of(context).push(MaterialPageRoute(
            builder: ((context) => FullScreenImageView(imgPath))));
        print(imgPath);
      }
    });

    //foreground notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print(message.notification!.body);
        print(message.notification!.title);
      }

      LocalNotificationService.display(message);
    });

    // backfround notification -- app is in background and open in background
    // works only after clicking on the notifiation and then fetch the data from the notification
    //won't receive the data until clicked
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final imgPath = message.data['imageurl'];
      Navigator.of(context).push(MaterialPageRoute(
          builder: ((context) => FullScreenImageView(imgPath))));
      print(imgPath);
    });
    CurrentScreen();
  }

  @override
  void dispose() {
    wallpaperchangeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("WallPaper"),
          centerTitle: true,
        ),
        body: wallpaperList != null
            ? Stack(children: [
                GridView.custom(
                  padding: EdgeInsets.all(10.0),
                  scrollDirection: Axis.vertical,
                  gridDelegate: SliverQuiltedGridDelegate(
                      crossAxisCount: 4,
                      pattern: [
                        QuiltedGridTile(4, 4),
                        QuiltedGridTile(2, 2),
                        QuiltedGridTile(2, 2),
                        QuiltedGridTile(2, 4),
                      ],
                      repeatPattern: QuiltedGridRepeatPattern.inverted),
                  childrenDelegate:
                      SliverChildBuilderDelegate((context, index) {
                    print(index);
                    String imgPath = wallpaperList?[index].get('url');
                    print(imgPath);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        elevation: 8.0,
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        child: InkWell(
                          onTap: () {
                            _sendAnalytics();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        FullScreenImageView(imgPath)));
                          },
                          child: Hero(
                            tag: imgPath,
                            child: FadeInImage(
                              placeholder: AssetImage("assets/placeholder.jpg"),
                              image: NetworkImage(imgPath),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  }, childCount: wallpaperList!.length),
                ),
                ElevatedButton(onPressed: () {}, child: Text('Notification')),
              ])
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
