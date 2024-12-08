import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ulearning_app/common/utils/app_colors.dart';
import 'package:ulearning_app/features/application/provider/application_nav_notifier.dart';

class Contact extends ConsumerStatefulWidget {
  const Contact({super.key});

  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends ConsumerState<Contact> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  bool _isButtonEnabled = false;

  void _validateForm() {
    setState(() {
      _isButtonEnabled = _formKey.currentState?.validate() ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => {
            ref.read(appZoomControllerProvider).toggle?.call(),
          },
        ),
        title: const Text("Contact",style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryText),),
        backgroundColor: AppColors.primaryElement,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          onChanged: _validateForm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Nous aimerions avoir votre avis !",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Nom Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Nom",
                  labelStyle: const TextStyle(color: AppColors.primaryElement),
                  prefixIcon: const Icon(Icons.person,color: AppColors.primaryElement),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.primaryElement), 
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Le nom est obligatoire.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Email Field
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: const TextStyle(color: AppColors.primaryElement),
                  prefixIcon: const Icon(Icons.email,color: AppColors.primaryElement),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.primaryElement),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "L'email est obligatoire.";
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return "Veuillez entrer un email valide.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Message Field
              TextFormField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: "Écrivez votre message ou avis ici...",
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[200],
                 
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.primaryElement),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Le message est obligatoire.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              // Submit Button
              ElevatedButton(
                onPressed: _isButtonEnabled
                    ? () {
                        final name = _nameController.text;
                        final email = _emailController.text;
                        final message = _messageController.text;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "Merci $name, votre message a été envoyé avec succès !"),
                          ),
                        );

                        _nameController.clear();
                        _emailController.clear();
                        _messageController.clear();
                        _validateForm(); // Recheck form state
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  backgroundColor: AppColors.primaryElement,
                  disabledBackgroundColor: Colors.grey[400],
                ),
                child: const Text(
                  "Envoyer",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
