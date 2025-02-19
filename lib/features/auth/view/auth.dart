import 'package:beehive/common/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beehive/common/widgets/botton_widgets.dart';
import 'package:beehive/common/utils/image_res.dart';

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
                  SizedBox(height: 40.h),
                  SvgPicture.asset(
                    ImageRes.beehivelogo,
                    height: 200.h,
                    fit: BoxFit.contain, // Essaye différents BoxFit si besoin
                    alignment: Alignment.center, // Assure un bon centrage
                  ),
                  SizedBox(height: 40.h),

                  // Bouton "Se connecter"
                  AppButton(
                    buttonName: "Se connecter",
                    isLogin: true,
                    context: context,
                    func: () =>
                        Navigator.of(context).pushNamed(AppRoutes.SIGN_IN),
                  ),
                  SizedBox(height: 20.h),

                  // Bouton "Créer un compte"
                  AppOutlinedButton(
                    buttonName: "Créer un compte",
                    context: context,
                    func: () =>
                        Navigator.of(context).pushNamed(AppRoutes.SIGN_UP),
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
