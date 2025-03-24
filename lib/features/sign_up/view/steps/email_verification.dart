import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:beehive/common/utils/app_colors.dart';
import 'package:beehive/common/widgets/botton_widgets.dart';
import 'package:beehive/features/otp/controller/otp_controller.dart';
import 'package:beehive/features/otp/provider/otp_provider.dart';

class EmailVerificationStep extends ConsumerStatefulWidget {
  const EmailVerificationStep({super.key});

  @override
  EmailVerificationStepState createState() => EmailVerificationStepState();
}

class EmailVerificationStepState extends ConsumerState<EmailVerificationStep> {
  final TextEditingController pinCodeController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode(); // Add a FocusNode
  late OtpController _controller;
  String? pinCodeError;
  bool isResendingEmail = false;

  @override
  void initState() {
    super.initState();
    _controller = OtpController(ref: ref);

    // Add listener to focus node
    _pinFocusNode.addListener(() {
      if (_pinFocusNode.hasFocus) {
        // Explicitly show keyboard when focus is gained
        FocusScope.of(context).requestFocus(_pinFocusNode);
      }
    });
  }

  String? validatePinCode(String? value) {
    if (value == null || value.length != 6) {
      return 'Le code doit contenir 6 chiffres';
    }
    return null;
  }

  void resendVerificationEmail() {
    setState(() {
      isResendingEmail = true;
    });

    Future.delayed(const Duration(seconds: 5), () {
      _controller.sendEmailVerificationToken();
      setState(() {
        isResendingEmail = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email de vérification renvoyé avec succès'),
        ),
      );
    });
  }

  @override
  void dispose() {
    pinCodeController.dispose();
    _pinFocusNode.dispose(); // Dispose the focus node
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.email_outlined,
                    size: 100, color: AppColors.primaryElement),
                const SizedBox(height: 20),
                Text(
                  "Vérifiez votre email",
                  style: TextStyle(
                    fontSize: screenWidth > 600 ? 28 : 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[800],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Un code a été envoyé à votre adresse email. Veuillez le saisir ci-dessous.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth > 600 ? 18 : 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 30),
                PinCodeTextField(
                  // Explicitly set the focus node
                  focusNode: _pinFocusNode,
                  autoFocus: true, // Force auto focus
                  autoDisposeControllers: false,
                  appContext: context,
                  length: 6,
                  controller: pinCodeController,
                  onChanged: (value) {
                    setState(() {
                      pinCodeError = validatePinCode(value);
                    });
                    ref
                        .read(emailVerificationProvier.notifier)
                        .onTokenChange(value);
                  },
                  onTap: () {
                    // Explicitly request focus when tapped
                    FocusScope.of(context).requestFocus(_pinFocusNode);
                  },
                  keyboardType: TextInputType.number,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeColor: pinCodeError != null
                        ? Colors.red
                        : AppColors.primaryElement,
                    selectedColor: pinCodeError != null
                        ? Colors.red
                        : AppColors.primaryElement,
                    inactiveColor: Colors.grey[300],
                    errorBorderColor: Colors.red,
                    activeFillColor: Colors.blue[50],
                    selectedFillColor: Colors.blue[100],
                    inactiveFillColor: Colors.white,
                  ),
                  animationType: AnimationType.fade,
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true,
                ),
                if (pinCodeError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      pinCodeError!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(height: 30),
                isResendingEmail
                    ? const CircularProgressIndicator()
                    : ElevatedButton.icon(
                        onPressed: resendVerificationEmail,
                        icon: const Icon(Icons.refresh),
                        label: const Text(
                          "Renvoyer l'email",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 120, 106, 62),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                const SizedBox(height: 30),
                Center(
                  child: AppButton(
                    buttonName: "Verifier Email",
                    isLogin: true,
                    context: context,
                    func: () async {
                      _controller.handleEmailVerification();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
