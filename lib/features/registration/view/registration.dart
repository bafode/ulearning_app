import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ulearning_app/common/utils/app_colors.dart';
import 'package:ulearning_app/features/registration/view/widgets/email_verification.dart';
import 'package:ulearning_app/features/registration/view/widgets/form.dart';
import 'package:ulearning_app/features/registration/view/widgets/update_info.dart';

class Registration extends ConsumerStatefulWidget {
  const Registration({super.key});

  @override
  ConsumerState<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends ConsumerState<Registration> {
  int currentStep = 0;
  bool isCompleted = false;

  final _formKey = GlobalKey<FormState>();
  final _updateInfoFormKey = GlobalKey<FormState>();
  final town = TextEditingController();
  final school = TextEditingController();
  final fieldOfStudy = TextEditingController();
  final levelOfStudy = TextEditingController();

  String? townError;
  String? schoolError;
  String? fieldOfStudyError;
  String? levelOfStudyError;

  void _validateFormField(String fieldName) {
    
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.primaryElementText,
          body: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: AppColors.primaryElement,
                onPrimary: Colors.white,
                secondary: AppColors.primaryText,
              ),
              textTheme: Theme.of(context).textTheme.copyWith(
                    bodyMedium: const TextStyle(
                      color: AppColors.primaryElementText,
                    ),
                  ),
              iconTheme: const IconThemeData(
                color: AppColors.primaryElementText,
              ),
            ),
            child: Stepper(
              type: StepperType.horizontal,
              currentStep: currentStep,
              steps: getSteps(),
              onStepTapped: (step) => setState(() => currentStep = step),
              controlsBuilder: (context, ControlsDetails controls) {
                final isLastStep = currentStep == getSteps().length - 1;
                return Container(
                  margin: const EdgeInsets.only(top: 50),
                  child: Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                              onPressed: controls.onStepContinue,
                              child:
                                  Text(isLastStep ? "Confirmer" : "Suivant"))),
                      const SizedBox(width: 12),
                      if (currentStep != 0)
                        Expanded(
                            child: ElevatedButton(
                                onPressed: controls.onStepCancel,
                                child: const Text('Retour'))),
                    ],
                  ),
                );
              },
              onStepContinue: () {
                final isLastStep = currentStep == getSteps().length - 1;
                if (currentStep == 0 && _formKey.currentState!.validate()) {
                  setState(() {
                    currentStep += 1;
                  });
                } else if (currentStep == 1) {
                  setState(() {
                    currentStep += 1;
                  });
                } else if (isLastStep) {
                  setState(() {
                    isCompleted = true;
                  });
                  print('completed');
                }
              },
              onStepCancel: currentStep == 0
                  ? null
                  : () => setState(() => currentStep -= 1),
            ),
          ),
        ),
      ),
    );
  }

  List<Step> getSteps() => [
        Step(
          title: const Text('Créer'),
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          content: const RegistrationForm(),
        ),
        Step(
          title: const Text("Vérifier"),
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          content: EmailVerificationStep(
            onCompleted: (pinCode) {
              print('Code PIN vérifié : $pinCode');
              // Vous pouvez faire d'autres actions ici, comme valider le code
            },
          ),
          isActive: currentStep >= 1,
        ),
        Step(
          title: const Text('Finaliser'),
          content: const UpdateUserInfoForm(),
          isActive: currentStep >= 2,
        ),
      ];
}
