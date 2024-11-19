import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ulearning_app/common/services/storage.dart';
import 'package:ulearning_app/common/utils/loading.dart';
import 'firebase_options.dart';

class Global {
  static late StorageService storageService;
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
      await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
       setSystemUi();
       Loading();
       await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    storageService = await StorageService().init();
  }

   static void setSystemUi() {
    if (Platform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      );
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  }
}
