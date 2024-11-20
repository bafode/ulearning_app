import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning_app/features/sign_up/controller/sign_up_controller.dart';

class ThirdPartyLogin extends ConsumerWidget {
   final SignUpController controller;
   
   const ThirdPartyLogin({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 60.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _loginButton("assets/icons/google.png",()=> controller.handleSignUp("google")),
          Platform.isIOS
              ? _loginButton("assets/icons/apple.png",
                  () => controller.handleSignUp("apple"))
              : Container(),
          _loginButton("assets/icons/facebook.png",
              () => controller.handleSignUp("facebook")),
        ],
      ),
    );
  }
}

Widget _loginButton(String iconPath, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Image.asset(
        iconPath,
        width: 40.w,
        height: 40.w,
        fit: BoxFit.contain,
      ),
    ),
  );
}
