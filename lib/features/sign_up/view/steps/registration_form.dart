import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beehive/common/routes/routes.dart';
import 'package:beehive/common/utils/app_colors.dart';
import 'package:beehive/common/widgets/app_textfields.dart';
import 'package:beehive/common/widgets/botton_widgets.dart';
import 'package:beehive/features/sign_in/view/widgets/sign_in_widgets.dart';
import 'package:beehive/features/sign_up/controller/sign_up_controller.dart';
import 'package:beehive/features/sign_up/provider/register_notifier.dart';
import 'package:get/get.dart';

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

 


ondispose() {
    firstName.dispose();
    lastName.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state= ref.watch(signUpNotifierProvier);
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 10),
            AppTextField(
                    controller: lastName,
                    text: "Nom",
                    hintText: "Entrez votre nom",
                    iconName: Icons.person,
                    validator: validateLastName,
                    onChanged: (value) => ref
                        .read(signUpNotifierProvier.notifier)
                        .onlastNameChange(value),
                  ),
            const SizedBox(height: 12),
            AppTextField(
                    controller: firstName,
                    text: "Prénom",
                    iconName: Icons.person,
                    hintText: "Entrez votre prénom",
                    validator: validateFirstName,
                    onChanged: (value) => ref
                        .read(signUpNotifierProvier.notifier)
                        .onfirstNameChange(value),
                  ),
            const SizedBox(height: 12),
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
            const SizedBox(height: 12),
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
                        .read(signUpNotifierProvier.notifier)
                        .onUserPasswordChange(value),
              onChangeVisibility: () {
                ref
                    .read(signUpNotifierProvier.notifier)
                    .onPasswordVisibilityChange(
                        !(state.passwordVisibility!));
              },
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: confirmPassword,
              text: "Confirmez le mot de passe",
              hintText: "Confirmez votre mot de passe",
              obscureText: state.rePasswordVisibility!,
              iconName: (state.rePasswordVisibility!)
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              validator: validateConfirmPassword,
              onChanged: (value) => ref
                        .read(signUpNotifierProvier.notifier)
                        .onUserRePasswordChange(value),
               onChangeVisibility: () {
                ref
                    .watch(signUpNotifierProvier.notifier)
                    .onRePasswordVisibilityChange(
                        !(state.rePasswordVisibility ?? true));
              },
            ),
            const SizedBox(height: 25),
             // Vos champs de formulaire existants ici

            const SizedBox(height: 16),
            
            Row(
              children: [
                Checkbox(
                  value: _isChecked,
                  onChanged: (value) {
                    setState(() {
                      _isChecked = value ?? false;
                    });
                  },
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: "En vous inscrivant, vous acceptez nos ",
                      style: const TextStyle(color: Colors.black,fontSize: 16.0),
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
                              // Remplacez par le lien vers vos termes et conditions
                            //  Get.toNamed(AppRoutes.WEBVIEW);
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
                              // Remplacez par le lien vers votre politique de confidentialité
                            //  Get.toNamed(AppRoutes.PRIVACY);
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
            if (validateTerms() != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  validateTerms()!,
                  style: TextStyle(color: Colors.red, fontSize: 12.sp),
                ),
              ),
            const SizedBox(height: 25),
            Center(
              child: AppButton(
                buttonName: "S'inscrire",
                isLogin: true,
                isEnabled: state.isFirstnameValid! &&
                    state.isLastnameValid! &&
                    state.isEmailValid! &&
                    state.isPasswordValid! &&
                    state.isRePasswordValid! &&
                    _isChecked,
                context: context,
                func:()=> _controller.handleSignUp("email"),
              ),
            ),
            Container(
                    margin: EdgeInsets.symmetric(vertical: 12.h),
                    child: Row(children: <Widget>[
                      Expanded(
                          child: Divider(
                        height: 2.h,
                        indent: 50,
                        color: AppColors.primarySecondaryElementText,
                      )),
                      const Text("  ou  "),
                      Expanded(
                          child: Divider(
                        height: 2.h,
                        endIndent: 50,
                        color: AppColors.primarySecondaryElementText,
                      )),
                    ]),
                  ),

                  ThirdPartyLogin(controller: _controller,),
                  const SizedBox(height: 10),
                   Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                           Text(
                              "Vous avez déjà un compte?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.primaryText,
                                fontWeight: FontWeight.normal,
                                fontSize: 12.sp,
                              ),
                            ),
                          const SizedBox(width: 10,),
                           GestureDetector(
                                child: Text(
                                  "se connecter",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.primaryElement,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12.sp,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).pushNamed(AppRoutes.SIGN_IN);
                                },
                          ),
                        ],
                      )
          ],
        ),
      ),
    );
  }
}
