import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ulearning_app/common/routes/routes.dart';
import 'package:ulearning_app/firebase_options.dart';
import 'package:ulearning_app/global.dart';

class FirebaseMassagingHandler {
  FirebaseMassagingHandler._();
  static AndroidNotificationChannel channel_call =
      const AndroidNotificationChannel(
    'com.dbestech.ulearning.call', // id
    'ulearning_call', // title
    importance: Importance.max,
    enableLights: true,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('alert'),
  );
  static AndroidNotificationChannel channel_message =
      const AndroidNotificationChannel(
    'com.dbestech.ulearning.message', // id
    'ulearning_message', // title
    importance: Importance.defaultImportance,
    enableLights: true,
    playSound: true,
  );

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> config() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    try {
      await messaging.requestPermission(
        sound: true,
        badge: true,
        alert: true,
        announcement: false,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
      );

      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
              alert: true, badge: true, sound: true);

      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        print("FirebaseMessaging.onMessage.listen--->$message");
        _receiveNotification(message);
            });
    } on Exception catch (e) {
      print("FirebaseMessaging.onMessage.listen--->$e");
    }
  }

  static Future<void> _receiveNotification(RemoteMessage message) async {
    if (message.data["call_type"] != null) {
      //  ////1. voice 2. video 3. text, 4.cancel
      if (message.data["call_type"] == "voice") {
        var data = message.data;
        var toToken = data["token"];
        var toName = data["name"];
        var toAvatar = data["avatar"];
        var docId = data["doc_id"] ?? "";
        if (toToken != null && toName != null && toAvatar != null) {
          Global.TopSnakbarKey.currentState?.show(toName, toToken, toAvatar,
              docId, "audience", "Voice call", AppRoutes.VoiceCall);
        }
      } else if (message.data["call_type"] == "video") {
        //  ////1. voice 2. video 3. text, 4.cancel
        var data = message.data;
        var toToken = data["token"];
        var toName = data["name"];
        var toAvatar = data["avatar"];
        var docId = data["doc_id"] ?? "";
        if (toToken != null && toName != null && toAvatar != null) {
          Global.TopSnakbarKey.currentState?.show(toName, toToken, toAvatar,
              docId, "audience", "Video call", AppRoutes.VideoCall);
        }
      } else if (message.data["call_type"] == "cancel") {
        FirebaseMassagingHandler.flutterLocalNotificationsPlugin.cancelAll();
        Global.TopSnakbarKey.currentState?.hide();
        var prefs = await SharedPreferences.getInstance();
        await prefs.setString("CallVocieOrVideo", "");
      }
    }
  }

  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackground(RemoteMessage message) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("firebaseMessagingBackground--message-----$message");
    if (message.data["call_type"] != null) {
      if (message.data["call_type"] == "cancel") {
        FirebaseMassagingHandler.flutterLocalNotificationsPlugin.cancelAll();
        var prefs = await SharedPreferences.getInstance();
        await prefs.setString("CallVocieOrVideo", "");
      }
      if (message.data["call_type"] == "voice" ||
          message.data["call_type"] == "video") {
        var data = {
          "to_token": message.data["token"],
          "to_name": message.data["name"],
          "to_avatar": message.data["avatar"],
          "doc_id": message.data["doc_id"] ?? "",
          "call_type": message.data["call_type"],
          "expire_time": DateTime.now().toString(),
        };
        print("firebaseMessagingBackground-----${jsonEncode(data)}");
        var prefs = await SharedPreferences.getInstance();
        await prefs.setString("CallVocieOrVideo", jsonEncode(data));
      }
    }
    }
}
