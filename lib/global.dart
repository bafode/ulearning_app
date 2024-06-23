import 'package:flutter/material.dart';
import 'package:ulearning_app/common/services/storage.dart';

class Global {
  static late StorageService storageService;
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    storageService = await StorageService().init();
  }
}
