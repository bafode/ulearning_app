import 'dart:io';
import 'package:beehive/features/message/controller.dart';
import 'package:beehive/features/message/videocall/index.dart';
import 'package:beehive/features/message/voicecall/index.dart';
import 'package:beehive/features/unotification/controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:beehive/common/services/storage.dart';
import 'package:beehive/common/utils/loading.dart';
import 'package:beehive/common/utils/topSnackbar.dart';
import 'package:beehive/features/message/state.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';

class Global {
  static late StorageService storageService;
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  static GlobalKey<TopSnackbarState> topSnakbarKey =
      GlobalKey<TopSnackbarState>();
  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    setSystemUi();
    Loading();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    storageService = await StorageService().init();
    await initializeDateFormatting('fr', null);

    // Initialize MessageState
    Get.put(MessageState());
    Get.put(VoiceCallState());
    Get.put(VideoCallState());
    Get.put(NotificationController());
    Get.lazyPut(() => MessageController());
    Get.lazyPut(() => VoiceCallController());
    Get.lazyPut(() => VideoCallController());
  }

 static bool _isOverlayAdded = false;

  static TransitionBuilder MaterialAppBuilder({
    TransitionBuilder? builder,
  }) {
    return (BuildContext context, Widget? child) {
      if (_isOverlayAdded) {
        return builder != null ? builder(context, child) : child!;
      }

      _isOverlayAdded = true; // Marquer l'overlay comme ajouté une seule fois

      return Overlay(
        initialEntries: [
          OverlayEntry(builder: (BuildContext context) {
            return FlutterEasyLoading(child: child); // ✅ Supprimé la GlobalKey
          }),
          OverlayEntry(builder: (BuildContext context) {
            return TopSnackbar(key: topSnakbarKey);
          })
        ],
      );
    };
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
