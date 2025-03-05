import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beehive/common/routes/routes.dart';
import 'package:beehive/common/utils/app_colors.dart';
import 'package:beehive/common/widgets/app_textfields.dart';
import 'package:beehive/features/sign_in/view/widgets/sign_in_widgets.dart';
import 'package:beehive/features/sign_up/controller/sign_up_controller.dart';
import 'package:beehive/features/sign_up/provider/register_notifier.dart';

class RegistrationForm extends ConsumerStatefulWidget {
  const RegistrationForm({super.key});

  @override
  RegistrationFormState createState() => RegistrationFormState();
}

class RegistrationFormState extends ConsumerState<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  late SignUpController _controller;

  @override
  void initState() {
    _controller = SignUpController(ref: ref);
    super.initState();
  }

  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  bool _isChecked = false;

  String? validateFirstName(String? value) {
    if (value == null || value.isEmpty) {
      ref.read(signUpNotifierProvier.notifier).setFirstNameValidity(false);
      return 'Le prénom est requis';
    } else if (value.length < 3) {
      ref.read(signUpNotifierProvier.notifier).setFirstNameValidity(false);
      return 'Le prénom doit contenir au moins 3 lettres';
    }
    ref.read(signUpNotifierProvier.notifier).setFirstNameValidity(true);
    return null;
  }

  String? validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      ref.read(signUpNotifierProvier.notifier).setLastNameValidity(false);
      return 'Le nom est requis';
    } else if (value.length < 3) {
      ref.read(signUpNotifierProvier.notifier).setLastNameValidity(false);
      return 'Le nom doit contenir au moins 3 lettres';
    }
    ref.read(signUpNotifierProvier.notifier).setLastNameValidity(true);
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      ref.read(signUpNotifierProvier.notifier).setEmailValidity(false);
      return 'L\'email est requis';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      ref.read(signUpNotifierProvier.notifier).setEmailValidity(false);
      return 'Veuillez entrer un email valide';
    }
    ref.read(signUpNotifierProvier.notifier).setEmailValidity(true);
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      ref.read(signUpNotifierProvier.notifier).setPasswordValidity(false);
      return 'Le mot de passe est requis';
    } else if (value.length < 6) {
      ref.read(signUpNotifierProvier.notifier).setPasswordValidity(false);
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    ref.read(signUpNotifierProvier.notifier).setPasswordValidity(true);
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      ref.read(signUpNotifierProvier.notifier).setRePasswordValidity(false);
      return 'La confirmation du mot de passe est requise';
    } else if (value != password.text) {
      ref.read(signUpNotifierProvier.notifier).setRePasswordValidity(false);
      return 'Les mots de passe ne correspondent pas';
    }
    ref.read(signUpNotifierProvier.notifier).setRePasswordValidity(true);
    return null;
  }

  String? validateTerms() {
    return _isChecked ? null : "Vous devez accepter les conditions";
  }

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signUpNotifierProvier);
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Text(
              "Créez votre compte",
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "Remplissez les informations ci-dessous",
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 30.h),
            AppTextField(
              controller: lastName,
              text: "Nom",
              hintText: "Entrez votre nom",
              iconName: Icons.person_outline,
              validator: validateLastName,
              onChanged: (value) => ref
                  .read(signUpNotifierProvier.notifier)
                  .onlastNameChange(value),
            ),
            SizedBox(height: 16.h),
            AppTextField(
              controller: firstName,
              text: "Prénom",
              iconName: Icons.person_outline,
              hintText: "Entrez votre prénom",
              validator: validateFirstName,
              onChanged: (value) => ref
                  .read(signUpNotifierProvier.notifier)
                  .onfirstNameChange(value),
            ),
            SizedBox(height: 16.h),
            AppTextField(
              controller: email,
              text: "Email",
              iconName: Icons.email_outlined,
              hintText: "Entrez votre adresse email",
              validator: validateEmail,
              onChanged: (value) => ref
                  .read(signUpNotifierProvier.notifier)
                  .onUserEmailChange(value),
            ),
            SizedBox(height: 16.h),
            AppTextField(
              controller: password,
              text: "Mot de passe",
              hintText: "Entrez votre mot de passe",
              iconName: Icons.lock_outline,
              obscureText: !state.passwordVisibility!,
              validator: validatePassword,
              onChanged: (value) => ref
                  .read(signUpNotifierProvier.notifier)
                  .onUserPasswordChange(value),
              onChangeVisibility: () {
                ref
                    .read(signUpNotifierProvier.notifier)
                    .onPasswordVisibilityChange(!(state.passwordVisibility!));
              },
            ),
            SizedBox(height: 16.h),
            AppTextField(
              controller: confirmPassword,
              text: "Confirmez le mot de passe",
              hintText: "Confirmez votre mot de passe",
              iconName: Icons.lock_outline,
              obscureText: !state.rePasswordVisibility!,
              validator: validateConfirmPassword,
              onChanged: (value) => ref
                  .read(signUpNotifierProvier.notifier)
                  .onUserRePasswordChange(value),
              onChangeVisibility: () {
                ref
                    .read(signUpNotifierProvier.notifier)
                    .onRePasswordVisibilityChange(!(state.rePasswordVisibility ?? true));
              },
            ),
            SizedBox(height: 30.h),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.black87.withOpacity(0.1),
                ),
              ),
              padding: EdgeInsets.all(16.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Transform.scale(
                    scale: 0.9,
                    child: Checkbox(
                      value: _isChecked,
                      onChanged: (value) {
                        setState(() {
                          _isChecked = value ?? false;
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      side: BorderSide(
                        color: Colors.black87.withOpacity(0.5),
                      ),
                    ),
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: "En vous inscrivant, vous acceptez nos ",
                        style: const TextStyle(color: Colors.black, fontSize: 16.0),
                        children: [
                          TextSpan(
                            text: "Politique de confidentialité",
                            style: const TextStyle(
                              color: AppColors.primaryText,
                              decoration: TextDecoration.underline,
                              fontSize: 16.0
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).pushNamed(
                                  AppRoutes.WEBVIEW,
                                  arguments: {"url": "https://beehiveapp.fr/privacy-policy"},
                                );
                              },
                          ),
                          const TextSpan(
                            text: " et notre ",
                            style: TextStyle(
                              fontSize: 16.0
                            )
                          ),
                          TextSpan(
                            text: "Conditions Générales d'Utilisation.",
                            style: const TextStyle(
                              color: AppColors.primaryText,
                              decoration: TextDecoration.underline,
                              fontSize: 16.0
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).pushNamed(
                                  AppRoutes.WEBVIEW,
                                  arguments: {"url": "https://beehiveapp.fr/terms-and-conditions"},
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (validateTerms() != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  validateTerms()!,
                  style: TextStyle(color: Colors.red, fontSize: 12.sp),
                ),
              ),
            SizedBox(height: 30.h),
            SizedBox(
              width: double.infinity,
              height: 55.h,
              child: ElevatedButton(
                onPressed: (state.isFirstnameValid! &&
                        state.isLastnameValid! &&
                        state.isEmailValid! &&
                        state.isPasswordValid! &&
                        state.isRePasswordValid! &&
                        _isChecked)
                    ? () => _controller.handleSignUp("email")
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryElement,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.black12,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  "S'inscrire",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20.h),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      height: 1.h,
                      color: Colors.black12,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      "ou",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      height: 1.h,
                      color: Colors.black12,
                    ),
                  ),
                ],
              ),
            ),
            ThirdPartyLogin(controller: _controller),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Vous avez déjà un compte? ",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 12.sp,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed(AppRoutes.SIGN_IN),
                  child: Text(
                    "Se connecter",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
