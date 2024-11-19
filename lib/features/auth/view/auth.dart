import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning_app/common/widgets/botton_widgets.dart';
import 'package:ulearning_app/common/utils/image_res.dart';
import 'package:ulearning_app/common/widgets/image_widgets.dart';

class Auth extends ConsumerWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo de l'application
                  SizedBox(height: 40.h),
                  AppImage(
                    width: 400.w,
                    height: 330.h,
                    imagePath: ImageRes.logo,
                  ),
                  SizedBox(height: 40.h),

                  // Bouton "Se connecter"
                  AppButton(
                    buttonName: "Se connecter",
                    isLogin: true,
                    context: context,
                    func: () => Navigator.of(context).pushNamed("/sign_in"),
                  ),
                  SizedBox(height: 20.h),

                  // Bouton "Créer un compte"
                  AppOutlinedButton(
                    buttonName: "Créer un compte",
                    context: context,
                    func: () => Navigator.of(context).pushNamed("/register"),
                  ),

                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
