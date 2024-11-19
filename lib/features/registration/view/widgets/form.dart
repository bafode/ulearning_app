import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning_app/features/registration/view/widgets/textFields.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  RegistrationFormState createState() => RegistrationFormState();
}

class RegistrationFormState extends State<RegistrationForm> {
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

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

  bool _isChecked = false; // État de la case à cocher

  String? validateTerms() {
    return _isChecked ? null : "Vous devez accepter les conditions";
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),
          AppTextField(
            controller: firstName,
            text: "Prénom",
            iconName: Icons.person,
            hintText: "Entrez votre prénom",
            validator: (value) => validateFirstName(value),
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: lastName,
            text: "Nom",
            hintText: "Entrez votre nom",
            iconName: Icons.person,
            validator: (value) => validateLastName(value),
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: email,
            text: "Email",
            iconName: Icons.email_outlined,
            hintText: "Entrez votre adresse email",
            validator: (value) => validateEmail(value),
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: password,
            text: "Mot de passe",
            hintText: "Entrez votre mot de passe",
            iconName: Icons.lock_clock_outlined,
            obscureText: true,
            validator: (value) => validatePassword(value),
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: confirmPassword,
            text: "Confirmez le mot de passe",
            hintText: "Confirmez votre mot de passe",
            obscureText: true,
            iconName: Icons.lock_clock_outlined,
            validator: (value) => validateConfirmPassword(value),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Checkbox(
                value: _isChecked,
                onChanged: (value) {
                  setState(() {
                    _isChecked = value!;
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
          if (validateTerms() !=
              null) // Affichage du message d'erreur si nécessaire
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                validateTerms()!,
                style: TextStyle(color: Colors.red, fontSize: 12.sp),
              ),
            ),
        ],
      ),
    );
  }
}
