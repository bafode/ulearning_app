import 'package:beehive/common/routes/names.dart';
import 'package:beehive/global.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

/// check if the user has logged in
class RouteAuthMiddleware extends GetMiddleware {
  // priority smaller the better
  @override
  int? priority = 0;

  RouteAuthMiddleware({required this.priority});

  @override
  RouteSettings? redirect(String? route) {
    if (Global.storageService.isLoggedIn() ||
        route == AppRoutes.AUTH ||
        route == AppRoutes.INITIAL||
        route == AppRoutes.TERMS ||
        route == AppRoutes.PRIVACY
        ) {
      return null;
    } else {
      Future.delayed(const Duration(seconds: 2),
          () => Get.snackbar("Tips", "Login expired, please login again!"));
      return const RouteSettings(name: AppRoutes.AUTH);
    }
  }
}
