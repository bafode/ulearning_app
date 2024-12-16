import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ulearning_app/common/utils/app_colors.dart';
import 'package:ulearning_app/features/sign_up/notifiers/step_notifier.dart';
import 'package:ulearning_app/features/sign_up/view/steps/registration_form.dart';
import 'package:ulearning_app/features/sign_up/view/steps/email_verification.dart';
import 'package:ulearning_app/features/sign_up/view/steps/update_user_info_form.dart';

class SignUp extends ConsumerStatefulWidget {
  const SignUp({super.key});

  @override
  ConsumerState<SignUp> createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUp> {
  @override
  Widget build(BuildContext context) {
    final currentStep = ref.watch(registrationCurrentStepProvider);
    return SafeArea(
      child: Theme(
        data: ThemeData(
          primarySwatch: Colors.orange,
          canvasColor: AppColors.primaryElement,
          cardColor: Colors.orange,
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: Colors.orange,
                surface: Colors.red,
              ),
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stepper(
            type: StepperType.horizontal,
            currentStep: currentStep,
            steps: getSteps(currentStep),
            // onStepTapped: (step) => ref
            //     .read(registrationCurrentStepProvider.notifier)
            //     .setCurrentStep(step),
            controlsBuilder: (BuildContext context, ControlsDetails details) {
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  List<Step> getSteps(int currentStep) {
    return [
      Step(
        title: Center(
          child: Text(
            "S'inscrire",
            style: TextStyle(
              fontSize: currentStep == 0 ? 18 : 14,
              fontWeight:
                  currentStep == 0 ? FontWeight.bold : FontWeight.normal,
              color: currentStep == 0
                  ? Colors.orange
                  : Colors.white.withOpacity(0.6),
            ),
          ),
        ),
        isActive: currentStep >= 0,
        state: currentStep > 0 ? StepState.complete : StepState.indexed,
        content: const RegistrationForm(),
      ),
      Step(
        title: Center(
          child: Text(
            'Vérifier',
            style: TextStyle(
              fontSize: currentStep == 1 ? 18 : 14,
              fontWeight:
                  currentStep == 1 ? FontWeight.bold : FontWeight.normal,
              color: currentStep == 1
                  ? Colors.orange
                  : Colors.white.withOpacity(0.6),
            ),
          ),
        ),
        isActive: currentStep >= 1,
        state: currentStep > 1 ? StepState.complete : StepState.indexed,
        content: const EmailVerificationStep(),
      ),
      Step(
        title: Center(
          child: Text(
            'Finaliser',
            style: TextStyle(
              fontSize: currentStep == 2 ? 18 : 14,
              fontWeight:
                  currentStep == 2 ? FontWeight.bold : FontWeight.normal,
              color: currentStep == 2
                  ? Colors.orange
                  : Colors.white.withOpacity(0.6),
            ),
          ),
        ),
        isActive: currentStep >= 2,
        content: const UpdateUserInfoForm(),
      ),
    ];
  }
}
