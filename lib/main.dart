import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beehive/common/routes/routes.dart';
import 'package:beehive/common/utils/FirebaseMessageHandler.dart';
import 'package:beehive/common/utils/app_styles.dart';
import 'package:beehive/global.dart';
import 'package:get/get.dart';

void main() async {
  await Global.init();
  runApp(const MyApp());
  firebaseInit().whenComplete(() {
    FirebaseMassagingHandler.config();
  });
}

Future firebaseInit() async {
  FirebaseMessaging.onBackgroundMessage(
    FirebaseMassagingHandler.firebaseMessagingBackground,
  );
  if (Platform.isAndroid) {
    FirebaseMassagingHandler.flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .createNotificationChannel(FirebaseMassagingHandler.channel_call);
    FirebaseMassagingHandler.flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .createNotificationChannel(FirebaseMassagingHandler.channel_message);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
        child: ScreenUtilInit(
            designSize: const Size(375, 812),
            builder: (context, child) => GetMaterialApp(
                  title: 'Beehive',
                  theme: AppTheme.appThemeData,
                  navigatorKey: Global.navigatorKey,
                  scaffoldMessengerKey: Global.rootScaffoldMessengerKey,
                  debugShowCheckedModeBanner: false,
                  navigatorObservers: [AppPages.observer],
                 initialRoute: AppRoutes.INITIAL,
                  getPages: AppPages.routes,
                  builder: EasyLoading.init(),
                )));
  }
}
