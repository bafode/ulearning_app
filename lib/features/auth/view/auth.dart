import 'package:beehive/common/routes/routes.dart';
import 'package:beehive/common/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beehive/common/utils/image_res.dart';
import 'dart:ui';

class Auth extends ConsumerWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFAFAFA),
              Color(0xFFF5F5F5),
              Color(0xFFE0E0E0),
              Color(0xFFD6D6D6),
              Color(0xFFC0C0C0),
              Color(0xFFB0B0B0),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo avec animation de scale
                  TweenAnimationBuilder(
                    duration: const Duration(milliseconds: 800),
                    tween: Tween<double>(begin: 0.5, end: 1.0),
                    curve: Curves.easeOutBack,
                    builder: (context, double value, child) {
                      return Transform.scale(
                        scale: value,
                        child: child,
                      );
                    },
                    child: SvgPicture.asset(
                      ImageRes.beehivelogo,
                      height: 180.h,
                    ),
                  ),
                  SizedBox(height: 60.h),
                  
                  // Card contenant les boutons
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: EdgeInsets.all(24.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          children: [
                            // Bouton "Se connecter"
                            // Bouton "Se connecter"
                            SizedBox(
                              width: double.infinity,
                              height: 55.h,
                              child: ElevatedButton(
                                onPressed: () => Navigator.of(context).pushNamed(AppRoutes.SIGN_IN),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppColors.primaryElement,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: Text(
                                  "Se connecter",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            
                            // Bouton "Créer un compte"
                            SizedBox(
                              width: double.infinity,
                              height: 55.h,
                              child: OutlinedButton(
                                onPressed: () => Navigator.of(context).pushNamed(AppRoutes.SIGN_UP),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.white, width: 1),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: Text(
                                  "Créer un compte",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
