import 'package:beehive/common/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beehive/features/sign_up/notifiers/step_notifier.dart';
import 'package:beehive/features/sign_up/view/steps/registration_form.dart';
import 'package:beehive/features/sign_up/view/steps/email_verification.dart';
import 'package:beehive/features/sign_up/view/steps/update_user_info_form.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';

class SignUp extends ConsumerStatefulWidget {
  const SignUp({super.key});

  @override
  ConsumerState<SignUp> createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUp> {
  @override
  Widget build(BuildContext context) {
    final currentStep = ref.watch(registrationCurrentStepProvider);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFAFAFA),
              Color(0xFFF5F5F5),
            ],
          ),
        ),
        child: SafeArea(
          child: Theme(
            data: ThemeData(
              primarySwatch: Colors.grey,
              canvasColor: Colors.transparent,
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: Colors.black87,
                    surface: Colors.transparent,
                  ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < 3; i++) ...[
                        Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            color: currentStep >= i ? AppColors.primaryElement : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: currentStep >= i ? Colors.black87 : Colors.black26,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: currentStep > i 
                              ? Icon(Icons.check, color: Colors.white, size: 20.sp)
                              : Text(
                                  '${i + 1}',
                                  style: TextStyle(
                                    color: currentStep >= i ? Colors.white : Colors.black54,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                          ),
                        ),
                        if (i < 2)
                          Container(
                            width: 60.w,
                            height: 2.h,
                            margin: EdgeInsets.symmetric(horizontal: 8.w),
                            color: currentStep > i ? Colors.black87 : Colors.black12,
                          ),
                      ],
                    ],
                  ),
                ),
                Expanded(
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 24.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildStepTitle("S'inscrire", 0, currentStep),
                                  _buildStepTitle("Vérifier", 1, currentStep),
                                  _buildStepTitle("Finaliser", 2, currentStep),
                                ],
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 10.h,
                                ),
                                child: [
                                  const RegistrationForm(),
                                  const EmailVerificationStep(),
                                  const UpdateUserInfoForm(),
                                ][currentStep],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepTitle(String title, int step, int currentStep) {
    return Text(
      title,
      style: TextStyle(
        fontSize: currentStep == step ? 18.sp : 14.sp,
        fontWeight: currentStep == step ? FontWeight.bold : FontWeight.normal,
        color: currentStep == step
            ? Colors.black87
            : Colors.black87.withOpacity(0.4),
      ),
    );
  }
}
