import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning_app/common/global_loader/global_loader.dart';
import 'package:ulearning_app/common/utils/app_colors.dart';
import 'package:ulearning_app/common/widgets/app_bar.dart';
import 'package:ulearning_app/common/widgets/app_textfields.dart';
import 'package:ulearning_app/common/widgets/botton_widgets.dart';
import 'package:ulearning_app/common/widgets/text_widgets.dart';
import 'package:ulearning_app/features/sign_up/provider/register_notifier.dart';
import 'package:ulearning_app/features/sign_up/controller/sign_up_controller.dart';

class SignUp extends ConsumerStatefulWidget {
  const SignUp({super.key});

  @override
  ConsumerState<SignUp> createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUp> {
  late SignUpController _controller;

  @override
  void initState() {
    _controller = SignUpController(ref: ref);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loader = ref.watch(appLoaderProvider);
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
            appBar: buildAppbar(title: "Sign Up"),
            backgroundColor: Colors.white,
            body: loader == false
                ? SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30.h),
                        const Center(
                          child: Text14Normal(
                            text: "Inscription Gratuite",
                          ),
                        ),
                        SizedBox(height: 30.h),
                        appTextField(
                          text: "Prenom",
                          iconName: Icons.person,
                          hintText: "Entrer votre prenom",
                          func: (value) => ref
                              .read(signUpNotifierProvier.notifier)
                              .onfirstNameChange(value),
                        ),
                        SizedBox(height: 20.h),
                        appTextField(
                          text: "Nom de famille",
                          iconName: Icons.person,
                          hintText: "Entrez votre nom de famille",
                          func: (value) => ref
                              .read(signUpNotifierProvier.notifier)
                              .onlastNameChange(value),
                        ),
                        SizedBox(height: 20.h),
                        appTextField(
                          text: "Email",
                          iconName: Icons.email,
                          hintText: "Entrez votre adresse mail",
                          func: (value) => ref
                              .read(signUpNotifierProvier.notifier)
                              .onUserEmailChange(value),
                        ),
                        SizedBox(height: 20.h),
                        appTextField(
                          text: "Mot de passe",
                          iconName: Icons.lock,
                          hintText: "Entrez votre mot de passe",
                          obscureText: true,
                          func: (value) => ref
                              .read(signUpNotifierProvier.notifier)
                              .onUserPasswordChange(value),
                        ),
                        SizedBox(height: 20.h),
                        appTextField(
                          text: "Confirmez Mot de passe",
                          iconName: Icons.lock,
                          hintText: "Confirmez votre mot de passe",
                          obscureText: true,
                          func: (value) => ref
                              .read(signUpNotifierProvier.notifier)
                              .onUserRePasswordChange(value),
                        ),
                        SizedBox(height: 20.h),
                        Container(
                          margin: EdgeInsets.only(left: 25.w),
                          child: const Text14Normal(
                              text:
                                  "En créant un compte, vous acceptez nos termes et conditions"),
                        ),
                        SizedBox(height: 60.h),
                        Center(
                          child: AppButton(
                            buttonName: "Register",
                            isLogin: true,
                            context: context,
                            func: () => _controller.handleSignUp(),
                          ),
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      color: AppColors.primaryElement,
                    ),
                  )),
      ),
    );
  }
}
