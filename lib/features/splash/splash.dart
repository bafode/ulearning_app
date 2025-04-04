import 'package:beehive/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beehive/common/routes/names.dart';
import 'package:beehive/common/utils/app_colors.dart';
import 'package:beehive/common/utils/image_res.dart';

class Splash extends ConsumerStatefulWidget {
  const Splash({super.key});

  @override
  ConsumerState<Splash> createState() => _SplashState();
}

class _SplashState extends ConsumerState<Splash>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();

    Future.delayed(const Duration(seconds: 3), () {
      bool isFirstTime = Global.storageService.getDeviceFirstOpen();
      if (isFirstTime) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.WELCOME);
      } else {
        bool isLoggedIn = Global.storageService.isLoggedIn();
        if (isLoggedIn) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.APPLICATION);
        } else {
          Navigator.of(context).pushReplacementNamed(AppRoutes.AUTH);
        }
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 690));
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Colors.white,
              Colors.white,
            ],
            radius: 1.5,
            center: Alignment.center,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _fadeAnimation,
              child: Image.asset(
                ImageRes.logo,
                fit: BoxFit.contain,
                height: 200.h,
                width: 200.w,
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              color: AppColors.primaryText,
              strokeWidth: 3,
            ),
            SizedBox(height: 15.h),
            Text(
              "Chargement en cours...",
              style: TextStyle(
                color: AppColors.primaryText,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
