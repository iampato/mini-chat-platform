import 'dart:io';

import 'package:events_emitter/events_emitter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class PushNotificationService extends EventEmitter {
  // Setup a singleton
  static final PushNotificationService _notificationService =
      PushNotificationService._internal();
  factory PushNotificationService() {
    return _notificationService;
  }
  PushNotificationService._internal();

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationDetails? platformChannelSpecifics;

  Future<void> initialise() async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    // final initializationSettingsIOS = IOSInitializationSettings(
    //   onDidReceiveLocalNotification: (id, title, body, payload) {},
    // );
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      // iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    if (Platform.isIOS) {
      messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    } else {
      messaging.requestPermission();
    }
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    messaging.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      styleInformation: BigTextStyleInformation(""),
      groupKey: "majisafi",
    );

    platformChannelSpecifics = const NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Logger().wtf('Got a message whilst in the foreground!');
      Logger().wtf('Message data: ${message.data}');


      if (message.notification != null) {
        debugPrint(
            'Message also contained a notification: ${message.notification}');

        Logger().i("🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀");
        Logger().i(message.notification?.toMap());
        Logger().i("🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀");
        flutterLocalNotificationsPlugin.show(
          message.notification.hashCode,
          // 'Testing 1234',
          // '${message.data.keys.toList()}',
          message.notification?.title ?? 'title',
          message.notification?.body ?? 'body',
          platformChannelSpecifics,
        );
      }
      // }
    });
    FirebaseMessaging.onBackgroundMessage(
      messagingBackgroundHandler,
    );
  }

  static Future<void> messagingBackgroundHandler(RemoteMessage message) async {
    debugPrint("Handling a background message: ${message.messageId}");
    // const AndroidNotificationDetails androidPlatformChannelSpecifics =
    //     AndroidNotificationDetails(
    //   'your channel id',
    //   'your channel name',
    //   channelDescription: 'your channel description',
    //   importance: Importance.max,
    //   priority: Priority.high,
    //   ticker: 'ticker',
    //   groupKey: "nilipie",
    // );

    // const NotificationDetails platformChannelSpecifics = NotificationDetails(
    //   android: androidPlatformChannelSpecifics,
    // );
    // if (message.notification != null) {
    //   debugPrint(
    //       'Message also contained a notification: ${message.notification}');
    //   // flutterLocalNotificationsPlugin.show(
    //   //   message.notification.hashCode,
    //   //   message.notification?.title ?? 'title',
    //   //   message.notification?.body ?? 'body',
    //   //   platformChannelSpecifics,
    //   // );
    // }
  }

  Future<void> subscribeTopic(String topic) async {
    await messaging.subscribeToTopic(topic);
    Logger().i("Subscribed to $topic");
  }

  Future<void> unsubscribeTopic(String topic) async {
    await messaging.unsubscribeFromTopic(topic);
  }
}
