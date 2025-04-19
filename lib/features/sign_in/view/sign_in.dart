import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:beehive/common/routes/routes.dart';
import 'package:beehive/common/utils/app_colors.dart';
import 'package:beehive/common/utils/image_res.dart';
import 'package:beehive/common/widgets/app_textfields.dart';
import 'package:beehive/common/widgets/botton_widgets.dart';
import 'package:beehive/features/sign_in/provider/sign_in_notifier.dart';
import 'package:beehive/features/sign_in/controller/sign_in_controller.dart';

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
      ref.watch(signInNotifierProvier.notifier).setIsEmailValidity(false);
      return 'L\'email est requis';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      ref.watch(signInNotifierProvier.notifier).setIsEmailValidity(false);
      return 'Veuillez entrer un email valide';
    }
    ref.watch(signInNotifierProvier.notifier).setIsEmailValidity(true);
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      ref.watch(signInNotifierProvier.notifier).setIsPasswordValidity(false);
      return 'Le mot de passe est requis';
    } else if (value.length < 8) {
      ref.watch(signInNotifierProvier.notifier).setIsPasswordValidity(false);
      return 'Le mot de passe doit contenir au moins 8 caractères';
    }
    ref.watch(signInNotifierProvier.notifier).setIsPasswordValidity(true);
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
    var state = ref.watch(signInNotifierProvier);
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 25.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.zero,
                  child: TweenAnimationBuilder(
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
                  iconName: (state.passwordVisibility!)
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  obscureText: state.passwordVisibility!,
                  validator: validatePassword,
                  onChanged: (value) => ref
                      .watch(signInNotifierProvier.notifier)
                      .onUserPasswordChange(value),
                  onChangeVisibility: () {
                    ref
                        .watch(signInNotifierProvier.notifier)
                        .onPasswordVisibilityChange(
                            !(state.passwordVisibility!));
                  },
                ),
                SizedBox(height: 15.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(AppRoutes.FORGOT_PASSWORD);
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
                SizedBox(height: 15.h),
                AppButton(
                  buttonName: "Connexion",
                  isLogin: true,
                  isEnabled: state.isEmailValid! && state.isPasswordValid!,
                  context: context,
                  func: () => _controller.handleSignIn("email"),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20.h, bottom: 20.h),
                  child: Row(children: <Widget>[
                    Expanded(
                        child: Divider(
                      height: 3.h,
                      indent: 50,
                      color: AppColors.primarySecondaryElementText,
                    )),
                    const Text("  ou  "),
                    Expanded(
                        child: Divider(
                      height: 3.h,
                      endIndent: 50,
                      color: AppColors.primarySecondaryElementText,
                    )),
                  ]),
                ),
                _buildThirdPartyGoogleLogin(),
                SizedBox(height: 15.h),
                // _buildThirdPartyFacebookLogin(),
                // SizedBox(height: 15.h),
                Platform.isIOS ? _buildThirdPartyAppleLogin() : Container(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Tu n'as pas encore de compte?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 12.sp,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    GestureDetector(
                      child: Text(
                        "s'inscrire",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.primaryElement,
                          fontWeight: FontWeight.normal,
                          fontSize: 12.sp,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoutes.SIGN_UP);
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
                  "Se Connecter avec Google",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 12.sp,
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
