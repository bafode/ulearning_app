import 'dart:convert';
import 'package:beehive/common/api/chat.dart';
import 'package:beehive/common/models/chat.dart';
import 'package:beehive/common/routes/routes.dart';
import 'package:beehive/common/utils/app_colors.dart';
import 'package:beehive/common/utils/constants.dart';
import 'package:beehive/firebase_options.dart';
import 'package:beehive/global.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseMassagingHandler {
  FirebaseMassagingHandler._();
  // Channels pour les différents types de notifications
  static AndroidNotificationChannel channel_voice =
      const AndroidNotificationChannel(
    'com.beehiveapp.beehivevoice', // id - correspond au backend
    'Appels vocaux', // title
    importance: Importance.max,
    enableLights: true,
    playSound: false, // Désactivation du son pour les appels vocaux
    enableVibration: true,
  );

  static AndroidNotificationChannel channel_video =
      const AndroidNotificationChannel(
    'com.beehiveapp.beehivevideo', // id - correspond au backend
    'Appels vidéo', // title
    importance: Importance.max,
    enableLights: true,
    playSound: false, // Désactivation du son pour les appels vidéo
    enableVibration: true,
  );

  static AndroidNotificationChannel channel_text =
      const AndroidNotificationChannel(
    'com.beehiveapp.beehivetext', // id - correspond au backend
    'Messages texte', // title
    importance: Importance.defaultImportance,
    enableLights: true,
    playSound: true,
  );

  static AndroidNotificationChannel channel_cancel =
      const AndroidNotificationChannel(
    'com.beehiveapp.beehivecancel', // id - correspond au backend
    'Appels annulés', // title
    importance: Importance.defaultImportance,
    enableLights: true,
    playSound: true,
  );

  static AndroidNotificationChannel channel_accept =
      const AndroidNotificationChannel(
    'com.beehiveapp.beehiveaccept', // id - correspond au backend
    'Appels acceptés', // title
    importance: Importance.defaultImportance,
    enableLights: true,
    playSound: true,
  );

  static AndroidNotificationChannel channel_notification =
      const AndroidNotificationChannel(
    'com.beehiveapp.beehive.notification', // id - correspond au backend
    'Notifications générales', // title
    importance: Importance.defaultImportance,
    enableLights: true,
    playSound: true,
  );

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final AudioPlayer player = AudioPlayer();

  static Future<void> config() async {
    // Initialiser le player pour la sonnerie
    await player.setAsset("assets/voice/Sound_Horizon.mp3");

    FirebaseMessaging messaging = FirebaseMessaging.instance;
    try {
      RemoteMessage newMessage = const RemoteMessage();
      await messaging.requestPermission(
        sound: true,
        badge: true,
        alert: true,
        announcement: false,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
      );

      // Create notification channels for Android
      // if (Platform.isAndroid) {
      //   // Créer tous les canaux de notification
      //   final androidPlugin = flutterLocalNotificationsPlugin
      //       .resolvePlatformSpecificImplementation<
      //           AndroidFlutterLocalNotificationsPlugin>();

      //   await androidPlugin?.createNotificationChannel(channel_voice);
      //   await androidPlugin?.createNotificationChannel(channel_video);
      //   await androidPlugin?.createNotificationChannel(channel_text);
      //   await androidPlugin?.createNotificationChannel(channel_cancel);
      //   await androidPlugin?.createNotificationChannel(channel_accept);
      //   await androidPlugin?.createNotificationChannel(channel_notification);
      // }

      RemoteMessage? initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        print("initialMessage------");
        print(initialMessage);
        // Check if it's a call notification
        if (initialMessage.data["call_type"] != null) {
          _handleInitialMessage(initialMessage);
        }
      }

      var initializationSettingsAndroid =
          const AndroidInitializationSettings("ic_launcher");
      var darwinInitializationSettings = const DarwinInitializationSettings();
      var initializationSettings = InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: darwinInitializationSettings);

      flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onDidReceiveNotificationResponse: (value) {
        print("----------onDidReceiveNotificationResponse");
        print("value: $value");
        print("value: ${value.payload}");
        // Try to parse payload if it exists
        if (value.payload != null) {
          try {
            Map<String, dynamic> data = jsonDecode(value.payload!);
            if (data["call_type"] != null) {
              _handleNotificationTap( jsonDecode(value.payload!));
            }
          } catch (e) {
            print("Error parsing notification payload: $e");
          }
        }
      });

      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
              alert: true, badge: true, sound: true);

      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        print("\n notification on onMessage function \n");
        print(message);

        // Afficher la notification même si l'application est en premier plan
        if (message.notification != null) {
          _showNotification(message: message);
        }

        // Traiter les notifications d'appel
        _receiveNotification(message);
      });

      // Listen for when the app is opened from a background state
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print("App opened from background via notification: ${message.data}");
        if (message.data["call_type"] != null) {
          _handleNotificationTap(message.data);
        }
      });

      // Check for any pending calls
      _checkPendingCalls();
    } on Exception catch (e) {
      print("$e");
    }
  }

  static Future<void> _handleInitialMessage(RemoteMessage message) async {
    if (message.data["call_type"] != null) {
      if (message.data["call_type"] == "voice" ||
          message.data["call_type"] == "video") {
        _handleNotificationTap(message.data);
      }
    }
  }

  static Future<void> _handleNotificationTap(Map<String, dynamic> data) async {
    // Stop the player when the user answers the call
    // await player.pause();
    // await player.stop();
    print("click notification");

    if (data["call_type"] == "voice") {
      Get.toNamed(AppRoutes.VoiceCall, parameters: {
        "to_token": data["to_token"] ?? data["token"],
        "to_firstname": data["to_firstname"] ?? data["firstname"],
        "to_lastname": data["to_lastname"] ?? data["lastname"] ?? "",
        "to_avatar": data["to_avatar"] ?? data["avatar"],
        "doc_id": data["doc_id"] ?? "",
        "call_role": "audience"
      });
    } else if (data["call_type"] == "video") {
      Get.toNamed(AppRoutes.VideoCall, parameters: {
        "to_token": data["to_token"] ?? data["token"],
        "to_firstname": data["to_firstname"] ?? data["firstname"],
        "to_lastname": data["to_lastname"] ?? data["lastname"] ?? "",
        "to_avatar": data["to_avatar"] ?? data["avatar"],
        "doc_id": data["doc_id"] ?? "",
        "call_role": "audience"
      });
    } else {
      Get.toNamed(AppRoutes.APPLICATION);
    }
  }

  static Future<void> _checkPendingCalls() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      String? callData = prefs.getString("CallVocieOrVideo")??"";

      if (callData.isNotEmpty) {
        Map<String, dynamic> data = jsonDecode(callData);

        // Check if the call is still valid (not expired)
        DateTime expireTime =
            DateTime.parse(data["expire_time"] ?? DateTime.now().toString());
        if (DateTime.now().difference(expireTime).inMinutes < 1) {
          // Call is still valid, handle it
          _handleNotificationTap(data);
        } else {
          // Call is expired, clear it
          await prefs.setString("CallVocieOrVideo", "");
        }
      }
    } catch (e) {
      print("Error checking pending calls: $e");
    }
  }

  static Future<void> _receiveNotification(RemoteMessage message) async {
    if (message.data["call_type"] != null) {
      //  ////1. voice 2. video 3. text, 4.cancel
      if (message.data["call_type"] == "voice") {
        //  FirebaseMassagingHandler.flutterLocalNotificationsPlugin.cancelAll();
        var data = message.data;
        var toToken = data["token"];
        var toFirstname = data["firstname"];
        var toLastname = data["lastname"];
        var toAvatar = data["avatar"];
        var docId = data["doc_id"] ?? "";
        // var call_role= data["call_type"];
        if (toToken != null && toFirstname != null && toAvatar != null) {
          Get.snackbar(
              icon: Container(
                width: 40.w,
                height: 40.w,
                padding: EdgeInsets.all(0.w),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill, image: NetworkImage(toAvatar)),
                  borderRadius: BorderRadius.all(Radius.circular(20.w)),
                ),
              ),
              "${toFirstname ?? ""} ${toLastname ?? ""}",
              "Voice call",
              duration: const Duration(seconds: 30),
              isDismissible: false,
              mainButton: TextButton(
                  onPressed: () {},
                  child: SizedBox(
                      width: 90.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (Get.isSnackbarOpen) {
                                Get.closeAllSnackbars();
                              }
                              FirebaseMassagingHandler.sendNotifications(
                                  "cancel",
                                  toToken,
                                  toAvatar,
                                  toFirstname,
                                  toLastname,
                                  docId);
                            },
                            child: Container(
                              width: 40.w,
                              height: 40.w,
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                color: AppColors.primaryElementBg,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.w)),
                              ),
                              child: Image.asset("assets/icons/a_phone.png"),
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                if (Get.isSnackbarOpen) {
                                  Get.closeAllSnackbars();
                                }
                                Get.toNamed(AppRoutes.VoiceCall, parameters: {
                                  "to_token": toToken,
                                  "to_firstname": toFirstname,
                                  "to_lastname": toLastname,
                                  "to_avatar": toAvatar,
                                  "doc_id": docId,
                                  "call_role": "audience"
                                });
                              },
                              child: Container(
                                width: 40.w,
                                height: 40.w,
                                padding: EdgeInsets.all(10.w),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryElementStatus,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.w)),
                                ),
                                child:
                                    Image.asset("assets/icons/a_telephone.png"),
                              ))
                        ],
                      ))));
        }
      } else if (message.data["call_type"] == "video") {
        //    FirebaseMassagingHandler.flutterLocalNotificationsPlugin.cancelAll();
        //  ////1. voice 2. video 3. text, 4.cancel
        var data = message.data;
        var toToken = data["token"];
        var toFirstname = data["firstname"];
        var toLastname = data["lastname"];
        var toAvatar = data["avatar"];
        var docId = data["doc_id"] ?? "";
        // var call_role= data["call_type"];
        if (toToken != null &&
            toFirstname != null &&
            toLastname != null &&
            toAvatar != null) {
          Global.storageService.setBool(AppConstants.isCallVocie, true);
          Get.snackbar(
              icon: Container(
                width: 40.w,
                height: 40.w,
                padding: EdgeInsets.all(0.w),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill, image: NetworkImage(toAvatar)),
                  borderRadius: BorderRadius.all(Radius.circular(20.w)),
                ),
              ),
              "$toFirstname $toLastname",
              "Video call",
              duration: const Duration(seconds: 30),
              isDismissible: false,
              mainButton: TextButton(
                  onPressed: () {},
                  child: SizedBox(
                      width: 90.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (Get.isSnackbarOpen) {
                                Get.closeAllSnackbars();
                              }
                              FirebaseMassagingHandler.sendNotifications(
                                  "cancel",
                                  toToken,
                                  toAvatar,
                                  toFirstname,
                                  toLastname,
                                  docId);
                            },
                            child: Container(
                              width: 40.w,
                              height: 40.w,
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                color: AppColors.primaryElementBg,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.w)),
                              ),
                              child: Image.asset("assets/icons/a_phone.png"),
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                if (Get.isSnackbarOpen) {
                                  Get.closeAllSnackbars();
                                }
                                Get.toNamed(AppRoutes.VideoCall, parameters: {
                                  "to_token": toToken,
                                  "to_firstname": toFirstname,
                                  "to_lastname": toLastname,
                                  "to_avatar": toAvatar,
                                  "doc_id": docId,
                                  "call_role": "audience"
                                });
                              },
                              child: Container(
                                width: 40.w,
                                height: 40.w,
                                padding: EdgeInsets.all(10.w),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryElementStatus,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.w)),
                                ),
                                child:
                                    Image.asset("assets/icons/a_telephone.png"),
                              ))
                        ],
                      ))));
        }
      } else if (message.data["call_type"] == "cancel") {
        FirebaseMassagingHandler.flutterLocalNotificationsPlugin.cancelAll();

        if (Get.isSnackbarOpen) {
          Get.closeAllSnackbars();
        }

        if (Get.currentRoute.contains(AppRoutes.VoiceCall) ||
            Get.currentRoute.contains(AppRoutes.VideoCall)) {
          Get.back();
        }

        var prefs = await SharedPreferences.getInstance();
        await prefs.setString("CallVocieOrVideo", "");
      }
    }
  }
  static Future<void> sendNotifications(
      String callType,
      String toToken,
      String toAvatar,
      String toFirstname,
      String toLastname,
      String docId) async {
    CallRequestEntity callRequestEntity = CallRequestEntity();
    callRequestEntity.call_type = callType;
    callRequestEntity.to_token = toToken;
    callRequestEntity.to_avatar = toAvatar;
    callRequestEntity.doc_id = docId;
    callRequestEntity.to_firstname = toFirstname;
    callRequestEntity.to_lastname = toLastname;
    var res = await ChatAPI.call_notifications(params: callRequestEntity);
    print("sendNotifications");
    print(callRequestEntity.toJson());
    print(res);
    if (res.code == 0) {
      print("sendNotifications success");
    } else {
      // Get.snackbar("Tips", "Notification error!");
      // Get.offAllNamed(AppRoutes.Message);
    }
  }

  static Future<void> _showNotification({RemoteMessage? message}) async {
    RemoteNotification? notification = message!.notification;
    AndroidNotification? androidNotification = message.notification!.android;
    AppleNotification? appleNotification = message.notification!.apple;

    if (notification != null &&
        (androidNotification != null || appleNotification != null)) {
      // Déterminer le canal à utiliser en fonction du type de notification
      AndroidNotificationChannel channelToUse = channel_notification;

      if (message.data["call_type"] != null) {
        switch (message.data["call_type"]) {
          case "voice":
            channelToUse = channel_voice;
            break;
          case "video":
            channelToUse = channel_video;
            break;
          case "text":
            channelToUse = channel_text;
            break;
          case "cancel":
            channelToUse = channel_cancel;
            break;
          case "accept":
            channelToUse = channel_accept;
            break;
          default:
            channelToUse = channel_notification;
        }
      }

      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channelToUse.id,
            channelToUse.name,
            icon: "@mipmap/ic_launcher",
            // Respecter les paramètres du canal pour le son
            playSound: channelToUse.id == channel_voice.id ||
                    channelToUse.id == channel_video.id
                ? false
                : true,
            enableVibration: true,
            priority: Priority.defaultPriority,
            importance: Importance.defaultImportance,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: message.data.toString(),
      );
    }
  }

  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackground(RemoteMessage message) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("message data: ${message.data}");
    print("message data: $message");
    print("message data: ${message.notification}");

    if (message.data["call_type"] != null) {
      if (message.data["call_type"] == "cancel") {
        // Ne rien faire ici, nous traiterons l'annulation quand l'app sera ouverte
        var prefs = await SharedPreferences.getInstance();
        await prefs.setString("CallVocieOrVideo", "");
      } else if (message.data["call_type"] == "accept") {
        // Stop the player when the call is accepted
        await player.pause();
      } else if (message.data["call_type"] == "voice" ||
          message.data["call_type"] == "video") {
        // Stocker les informations d'appel pour quand l'app sera ouverte
        var data = {
          "to_token": message.data["token"],
          "to_firstname": message.data["firstname"],
          "to_lastname": message.data["lastname"],
          "to_avatar": message.data["avatar"],
          "doc_id": message.data["doc_id"] ?? "",
          "call_type": message.data["call_type"],
          "expire_time": DateTime.now().toString(),
        };
        print(data);
        var prefs = await SharedPreferences.getInstance();
        await prefs.setString("CallVocieOrVideo", jsonEncode(data));
      }
    }
  }
}
