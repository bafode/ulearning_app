import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning_app/common/global_loader/global_loader.dart';
import 'package:ulearning_app/common/routes/app_routes_names.dart';
import 'package:ulearning_app/common/utils/app_colors.dart';
import 'package:ulearning_app/common/widgets/botton_widgets.dart';
import 'package:ulearning_app/features/registration/view/widgets/textFields.dart';
import 'package:ulearning_app/features/sign_in/view/widgets/sign_in_widgets.dart';
import 'package:ulearning_app/features/sign_up/controller/sign_up_controller.dart';
import 'package:ulearning_app/features/sign_up/provider/register_notifier.dart';

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
      return 'Le prénom est requis';
    } else if (value.length < 3) {
      return 'Le prénom doit contenir au moins 3 lettres';
    }
    return null;
  }

  String? validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le nom est requis';
    } else if (value.length < 3) {
      return 'Le nom doit contenir au moins 3 lettres';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'L\'email est requis';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Veuillez entrer un email valide';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est requis';
    } else if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La confirmation du mot de passe est requise';
    } else if (value != password.text) {
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }

  String? validateTerms() {
    return _isChecked ? null : "Vous devez accepter les conditions";
  }

  Future<void> _onRegister() async {
    final isFormValid = _formKey.currentState?.validate() ?? false;
    if (isFormValid && _isChecked) {
      await _controller.handleSignUp("email");
    } else {
      setState(() {}); // Pour déclencher la validation des cases
    }
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
    final loader = ref.watch(appLoaderProvider);
    return !loader?SingleChildScrollView(
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
              iconName: Icons.lock_clock_outlined,
              obscureText: true,
              validator: validatePassword,
              onChanged: (value) => ref
                        .read(signUpNotifierProvier.notifier)
                        .onUserPasswordChange(value),
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: confirmPassword,
              text: "Confirmez le mot de passe",
              hintText: "Confirmez votre mot de passe",
              obscureText: true,
              iconName: Icons.lock_clock_outlined,
              validator: validateConfirmPassword,
              onChanged: (value) => ref
                        .read(signUpNotifierProvier.notifier)
                        .onUserRePasswordChange(value),
            ),
            const SizedBox(height: 25),
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
                const Expanded(
                  child: Text(
                    "En cochant cette case, vous acceptez les conditions de notre application.",
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
                context: context,
                func: _onRegister,
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
                                  Navigator.of(context).pushNamed(AppRoutesNames.SIGN_IN);
                                },
                          ),
                        ],
                      )
          ],
        ),
      ),
    ): const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
              color: AppColors.primaryElement,
            ),
          );
  }
}
