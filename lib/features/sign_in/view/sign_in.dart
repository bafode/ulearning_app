import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning_app/common/global_loader/global_loader.dart';
import 'package:ulearning_app/common/routes/app_routes_names.dart';
import 'package:ulearning_app/common/utils/app_colors.dart';
import 'package:ulearning_app/common/utils/image_res.dart';
import 'package:ulearning_app/common/widgets/botton_widgets.dart';
import 'package:ulearning_app/common/widgets/image_widgets.dart';
import 'package:ulearning_app/features/registration/view/widgets/textFields.dart';
import 'package:ulearning_app/features/sign_in/provider/sign_in_notifier.dart';
import 'package:ulearning_app/features/sign_in/controller/sign_in_controller.dart';

class SignIn extends ConsumerStatefulWidget {
  const SignIn({super.key});

  @override
  ConsumerState<SignIn> createState() => _SignInState();
}

class _SignInState extends ConsumerState<SignIn> {
  late SignInController _controller;

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'L\'email est requis';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Veuillez entrer un email valide';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est requis';
    } else if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    return null;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller = SignInController(ref: ref);
     Future.delayed(Duration.zero, () {
      _controller.init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final loader = ref.watch(appLoaderProvider);
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: loader
              ? const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    color: AppColors.primaryElement,
                  ),
                )
              : SingleChildScrollView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 25.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppImage(
                        width: 200.w,
                        height: 100.h,
                        imagePath: ImageRes.logo,
                      ),
                      AppTextField(
                        controller: email,
                        text: "Email",
                        iconName: Icons.email_outlined,
                        hintText: "Entrez votre adresse email",
                        validator: validateEmail,
                        onChanged: (value) => ref
                            .watch(signInNotifierProvier.notifier)
                            .onUserEmailChange(value),
                      ),
                      SizedBox(height: 15.h),
                      AppTextField(
                        controller: password,
                        text: "Mot de passe",
                        hintText: "Entrez votre mot de passe",
                        iconName: Icons.lock_outline,
                        obscureText: true,
                        validator: validatePassword,
                        onChanged: (value) => ref
                            .watch(signInNotifierProvier.notifier)
                            .onUserPasswordChange(value),
                      ),
                      SizedBox(height: 10.h),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(AppRoutesNames.FORGOT_PASSWORD);
                          },
                          child: const Text(
                            "Mot de passe oublié ?",
                            style: TextStyle(
                              color: AppColors.primaryElement,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.primaryElement,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      AppButton(
                        buttonName: "Connexion",
                        isLogin: true,
                        context: context,
                        func: () => _controller.handleSignIn("email"),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20.h, bottom: 20.h),
                        child: Row(children: <Widget>[
                          Expanded(
                              child: Divider(
                            height: 2.h,
                            indent: 50,
                            color: AppColors.primarySecondaryElementText,
                          )),
                          const Text("  ou  "),
                          Expanded(
                              child: Divider(
                            height: 2.h,
                            endIndent: 50,
                            color: AppColors.primarySecondaryElementText,
                          )),
                        ]),
                      ),
                      _buildThirdPartyGoogleLogin(),
                      _buildThirdPartyFacebookLogin(),
                      Platform.isIOS ? _buildThirdPartyAppleLogin() : Container(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                              "Pas de compte?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.primaryText,
                                fontWeight: FontWeight.normal,
                                fontSize: 12.sp,
                              ),
                          ),
                          const SizedBox(height: 15,),
                          GestureDetector(
                                child: Text(
                                  "S'inscrire ici",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.primaryElement,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12.sp,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).pushNamed(AppRoutesNames.REGISTER);
                                },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildThirdPartyGoogleLogin() {
    return GestureDetector(
        child: Container(
          width: 295.w,
          height: 44.h,
          margin: EdgeInsets.only(bottom: 15.h),
          padding: EdgeInsets.all(10.h),
          decoration: BoxDecoration(
            color: AppColors.primaryBackground,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(left: 40.w, right: 30.w),
                  child: Image.asset("assets/icons/google.png")),
              Container(
                child: Text(
                  "Sign in with Google",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          _controller.handleSignIn("google");
        });
  }

  Widget _buildThirdPartyFacebookLogin() {
    return GestureDetector(
        child: Container(
          width: 295.w,
          height: 44.h,
          margin: EdgeInsets.only(bottom: 15.h),
          padding: EdgeInsets.all(10.h),
          decoration: BoxDecoration(
            color: AppColors.primaryBackground,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(left: 40.w, right: 30.w),
                  child: Image.asset("assets/icons/facebook.png")),
              Container(
                child: Text(
                  "Sign in with Facebook",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          _controller.handleSignIn("facebook");
        });
  }

  Widget _buildThirdPartyAppleLogin() {
    return GestureDetector(
        child: Container(
          width: 295.w,
          height: 44.h,
          margin: EdgeInsets.only(bottom: 15.h),
          padding: EdgeInsets.all(10.h),
          decoration: BoxDecoration(
            color: AppColors.primaryBackground,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(left: 40.w, right: 30.w),
                  child: Image.asset("assets/icons/apple.png")),
              Container(
                child: Text(
                  "Sign in with Apple",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          _controller.handleSignIn("apple");
        });
  }
}
