import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning_app/common/routes/app_routes_names.dart';
import 'package:ulearning_app/common/utils/app_colors.dart';
import 'package:ulearning_app/common/utils/image_res.dart';
import 'package:ulearning_app/global.dart';

class Splash extends ConsumerStatefulWidget {
  const Splash({super.key});

  @override
  ConsumerState<Splash> createState() => _SplashState();
}

class _SplashState extends ConsumerState<Splash>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(const Duration(seconds: 3), () {
      bool deviceFirstTime = Global.storageService.getDeviceFirstOpen();
      if (deviceFirstTime) {
        bool isLoggedIn = Global.storageService.isLoggedIn();
        if (isLoggedIn) {
          Navigator.of(context)
              .pushReplacementNamed(AppRoutesNames.APPLICATION);
        } else {
          Navigator.of(context).pushReplacementNamed(AppRoutesNames.SIGN_IN);
        }
      } else {
        Navigator.of(context).pushReplacementNamed(AppRoutesNames.WELCOME);
      }
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Color.fromARGB(255, 163, 139, 210),
              Color.fromRGBO(123, 71, 225, 1),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              ImageRes.logo,
              fit: BoxFit.contain,
              height: 250.h,
              width: 250.w,
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              color: AppColors.primaryText,
            ),
          ],
        ),
      ),
    );
  }
}
