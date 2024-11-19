import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning_app/common/global_loader/global_loader.dart';
import 'package:ulearning_app/common/utils/app_colors.dart';
import 'package:ulearning_app/common/widgets/app_textfields.dart';
import 'package:ulearning_app/common/widgets/botton_widgets.dart';
import 'package:ulearning_app/features/sign_up/provider/register_notifier.dart';
import 'package:ulearning_app/features/sign_up/controller/sign_up_controller.dart';

class SignUpSecond extends ConsumerStatefulWidget {
  const SignUpSecond({super.key});

  @override
  ConsumerState<SignUpSecond> createState() => _SignUpSecondState();
}

class _SignUpSecondState extends ConsumerState<SignUpSecond> {
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
            backgroundColor: Colors.white,
            body: loader == false
                ? SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30.h),
                        appTextField(
                          text: "Quelle est ta Ville?",
                          iconName: Icons.home,
                          hintText: "Entrer votre ville",
                          func: (value) => ref
                              .read(signUpNotifierProvier.notifier)
                              .onfirstNameChange(value),
                        ),
                        SizedBox(height: 20.h),
                        appTextField(
                          text: "Quelle est ton école?",
                          iconName: Icons.school,
                          hintText: "Entrez le nom de votre école",
                          func: (value) => ref
                              .read(signUpNotifierProvier.notifier)
                              .onlastNameChange(value),
                        ),
                        SizedBox(height: 20.h),
                        appTextField(
                          text: "Quelle est ta spécialisation ou domaine d'étude?",
                          iconName: Icons.work,
                          hintText: "Entrez votre domaine d'étude",
                          func: (value) => ref
                              .read(signUpNotifierProvier.notifier)
                              .onlastNameChange(value),
                        ),
                        SizedBox(height: 20.h),
                        appTextField(
                          text:
                              "Quelle est ton niveau d'étude?",
                          iconName: Icons.live_help,
                          hintText: "Niveau",
                          func: (value) => ref
                              .read(signUpNotifierProvier.notifier)
                              .onlastNameChange(value),
                        ),
                        SizedBox(height: 20.h),
                    
                        SizedBox(height: 60.h),
                        Center(
                          child: AppButton(
                            buttonName: "Sauvégarder mon Profil",
                            isLogin: true,
                            context: context,
                            func: () => _controller.handleSignUp("email"),
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
