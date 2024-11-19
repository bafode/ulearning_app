import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:ulearning_app/common/widgets/botton_widgets.dart';

class EmailVerificationStep extends StatefulWidget {
  final Function(String) onCompleted;

  const EmailVerificationStep({super.key, required this.onCompleted});

  @override
  EmailVerificationStepState createState() => EmailVerificationStepState();
}

class EmailVerificationStepState extends State<EmailVerificationStep> {
  final TextEditingController pinCodeController=TextEditingController();
  String? pinCodeError;
  bool isResendingEmail = false;

  String? validatePinCode(String? value) {
    if (value == null || value.length != 6) {
      return 'Le code doit contenir 6 chiffres';
    }
    return null;
  }

  void _validatePinCode() {
    setState(() {
      pinCodeError = validatePinCode(pinCodeController.text);
    });
    if (pinCodeError == null) {
      widget.onCompleted(pinCodeController.text);
    }
  }

  void resendVerificationEmail() {
    setState(() {
      isResendingEmail = true;
    });

    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        isResendingEmail = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Email de vérification renvoyé avec succès')),
      );
    });
  }

   @override
  void dispose() {
    pinCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.email_outlined, size: 100, color: Colors.blue),
              const SizedBox(height: 20),
              Text(
                "Vérifiez votre email",
                style: TextStyle(
                  fontSize: screenWidth > 600 ? 28 : 22, // Responsive text size
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
                appContext: context,
                length: 6,
                controller: pinCodeController,
                onChanged: (value) {
                  setState(() {
                    // Vérifie si la longueur du code est correcte
                    pinCodeError = validatePinCode(value);
                  });
                },
                keyboardType: TextInputType.number,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(8),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  activeColor: pinCodeError != null ? Colors.red : Colors.blue,
                  selectedColor:
                      pinCodeError != null ? Colors.red : Colors.blue,
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
                  child: Text(pinCodeError!,
                      style: const TextStyle(color: Colors.red)),
                ),
              const SizedBox(height: 30),
              isResendingEmail
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      onPressed: resendVerificationEmail,
                      icon: const Icon(Icons.refresh),
                      label: const Text("Renvoyer l'email"),
                      style: ElevatedButton.styleFrom(
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
                  func: () async {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

 
}
