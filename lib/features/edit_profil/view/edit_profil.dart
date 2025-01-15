import 'package:beehive/common/utils/app_colors.dart';
import 'package:beehive/features/edit_profil/controller/controller.dart';
import 'package:beehive/features/edit_profil/provider/provider.dart';
import 'package:beehive/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beehive/common/widgets/app_textfields.dart';
import 'package:beehive/common/widgets/botton_widgets.dart';
import 'package:get/get.dart';

class EditProfil extends ConsumerStatefulWidget {
  const EditProfil({super.key});

  @override
  EditProfilState createState() => EditProfilState();
}

class EditProfilState extends ConsumerState<EditProfil> {
  late EditProfilController _controller;

  @override
  void initState() {
    _controller = EditProfilController(ref: ref);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
    super.initState();
  }

  void _validateForm() {
    bool isFormValid = _controller.formKey.currentState?.validate() ?? false;
   
  }

  Future<void> _onUpdate() async {
    if (_controller.formKey.currentState!.validate()) {
      _controller.handleUpdateUserInfo();
    }
  }

  @override
  void dispose() {
    _controller.firstName.dispose();
    _controller.lastName.dispose();
    _controller.description.dispose();
    super.dispose();
  }

  void _loadUserData() {
    final userProfile = ref.read(profileControllerProvider);
    final notifier = ref.read(editProfilNotifierProvier.notifier);

    _controller.firstName.text = userProfile.firstname ?? '';
    _controller.lastName.text = userProfile.lastname ?? '';
    _controller.description.text = userProfile.description ?? '';
    notifier.onUserFirstNameChange(userProfile.firstname ?? '');
    notifier.onUserLastNameChange(userProfile.lastname ?? '');
    notifier.onUserDescriptionChange(userProfile.description ?? '');
    _validateForm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => {Get.back()},
        ),
        title: const Text(
          "Editer vos Infos",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryElement,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Form(
            key: _controller.formKey,
            onChanged: _validateForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                AppTextField(
                  controller: _controller.lastName,
                  text: "Nom",
                  hintText: "Entrez votre nom",
                  iconName: Icons.person,
                  onChanged: (lastName) => ref
                      .read(editProfilNotifierProvier.notifier)
                      .onUserLastNameChange(lastName),
                  validator: _controller.validateLastName,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: _controller.firstName,
                  text: "Prénom",
                  iconName: Icons.person,
                  hintText: "Entrez votre prénom",
                  validator: _controller.validateFirstName,
                  onChanged: (firstName) => ref
                      .read(editProfilNotifierProvier.notifier)
                      .onUserFirstNameChange(firstName),
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: _controller.description,
                  text: "Description",
                  iconName: Icons.edit,
                  hintText: "Parlez de vous...",
                  onChanged: (desciption) => ref
                      .read(editProfilNotifierProvier.notifier)
                      .onUserDescriptionChange(desciption),
                  maxLines: 3,
                ),
                const SizedBox(height: 30),
                Center(
                    child: AppButton(
                  buttonName: "Editer",
                  isLogin: true,
                  context: context,
                  func: _onUpdate,
                  //  isEnabled: _isButtonEnabled,
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
