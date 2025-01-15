import 'package:beehive/common/routes/names.dart';
import 'package:beehive/global.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class RouteWelcomeMiddleware extends GetMiddleware {
 
  @override
  int? priority = 0;

  RouteWelcomeMiddleware({required this.priority});

  @override
  RouteSettings? redirect(String? route) {
    print(Global.storageService.getDeviceFirstOpen());
    if (Global.storageService.getDeviceFirstOpen() == false) {
      return const RouteSettings(name: AppRoutes.WELCOME);
    } else {
      if (Global.storageService.isLoggedIn()) {
        return const RouteSettings(name: AppRoutes.APPLICATION);
      } else {
        return const RouteSettings(name: AppRoutes.AUTH);
      }
    }
  }
}
