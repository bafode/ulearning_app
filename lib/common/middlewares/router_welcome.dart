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
    print("RouteWelcomeMiddleware: route=$route, firstOpen=${Global.storageService.getDeviceFirstOpen()}");
    
    // Si la route actuelle est déjà WELCOME ou AUTH, ne pas rediriger pour éviter une boucle
    if (route == AppRoutes.WELCOME || route == AppRoutes.AUTH) {
      return null;
    }
    
    if (Global.storageService.getDeviceFirstOpen()) {
      // Already seen welcome screen
      if (Global.storageService.isLoggedIn()) {
        return const RouteSettings(name: AppRoutes.APPLICATION);
      } else {
        return const RouteSettings(name: AppRoutes.AUTH);
      }
    } else {
      // First time opening app
      return const RouteSettings(name: AppRoutes.WELCOME);
    }
  }
}
