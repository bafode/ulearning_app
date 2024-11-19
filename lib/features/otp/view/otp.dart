import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:ulearning_app/common/routes/app_routes_names.dart';
import 'package:ulearning_app/common/utils/app_colors.dart';
import 'package:ulearning_app/features/otp/controller/otp_controller.dart';
import 'package:ulearning_app/features/otp/provider/otp_provider.dart';

class Otp extends ConsumerStatefulWidget {
  const Otp({
    super.key,
    this.phoneNumber,
  });

  final String? phoneNumber;

  @override
  ConsumerState<Otp> createState() => _OtpState();
}

class _OtpState extends ConsumerState<Otp> {
  TextEditingController textEditingController = TextEditingController();
  late OtpController _controller;

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    _controller = OtpController(ref: ref);
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  // snackBar Widget
  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final emailVerificationResponseState =
        ref.watch(emailVerificationResponseProvier);
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: <Widget>[
          const SizedBox(height: 30),
          SizedBox(
            height: MediaQuery.of(context).size.height / 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: const Icon(Icons.lock,
                  size: 150, color: AppColors.primaryText),
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Email Verification',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
            child: RichText(
              text: const TextSpan(
                text: "Enter the code sent to ",
                children: [
                  TextSpan(
                    text: "bafode@gmail.com",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 30,
              ),
              child: PinCodeTextField(
                appContext: context,
                pastedTextStyle: TextStyle(
                  color: Colors.green.shade600,
                  fontWeight: FontWeight.bold,
                ),
                length: 6,
                obscureText: false,
                // obscuringCharacter: '*',
                // obscuringWidget: Icon(
                //   Icons.lock,
                //   size: 24,
                //   color: Colors.green.shade700,
                // ),
                // blinkWhenObscuring: true,
                animationType: AnimationType.fade,
                validator: (v) {
                  if (v!.length < 6) {
                    return "OTP must be of 6 digits";
                  } else {
                    return null;
                  }
                },
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  activeFillColor: Colors.white,
                ),
                cursorColor: Colors.black,
                animationDuration: const Duration(milliseconds: 300),
                enableActiveFill: true,
                errorAnimationController: errorController,
                controller: textEditingController,
                keyboardType: TextInputType.number,
                boxShadows: const [
                  BoxShadow(
                    offset: Offset(0, 1),
                    color: Colors.black12,
                    blurRadius: 10,
                  )
                ],
                onCompleted: (v) {
                  //  _controller.handleEmailVerification();
                  debugPrint("Completed");
                },
                // onTap: () {
                //   print("Pressed");
                // },
                onChanged: (value) {
                  debugPrint(value);
                  ref
                      .read(emailVerificationProvier.notifier)
                      .onTokenChange(value);
                  // setState(() {
                  //   currentText = value;
                  // });
                },
                beforeTextPaste: (text) {
                  debugPrint("Allowing to paste $text");
                  print('167843');
                  //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                  //but you can show anything you want here, like your pop up saying wrong paste format or etc
                  return true;
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              hasError ? "*Please fill up all the cells properly" : "",
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Didn't receive the code? ",
                style: TextStyle(color: Colors.black54, fontSize: 15),
              ),
              TextButton(
                onPressed: () => snackBar("OTP resend!!"),
                child: const Text(
                  "RESEND",
                  style: TextStyle(
                    color: Color(0xFF91D3B3),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
            decoration: BoxDecoration(
                color: Colors.green.shade300,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                      color: Colors.green.shade200,
                      offset: const Offset(1, -2),
                      blurRadius: 5),
                  BoxShadow(
                      color: Colors.green.shade200,
                      offset: const Offset(-1, 2),
                      blurRadius: 5)
                ]),
            child: ButtonTheme(
              height: 50,
              child: TextButton(
                onPressed: () {
                  formKey.currentState!.validate();
                  _controller.handleEmailVerification();
                  // conditions for validating
                  if (emailVerificationResponseState == true) {
                    setState(
                      () {
                        hasError = false;
                        snackBar("OTP Verified!!");
                      },
                    );
                    Navigator.of(context)
                        .popAndPushNamed(AppRoutesNames.SIGN_IN);
                  } else {
                    errorController!.add(ErrorAnimationType
                        .shake); // Triggering error shake animation
                    setState(() => hasError = true);
                  }
                },
                child: Center(
                  child: Text(
                    "VERIFY".toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          TextButton(
            child: const Text("Clear"),
            onPressed: () {
              textEditingController.clear();
            },
          ),
        ],
      ),
    );
  }
}
