import 'package:beehive/common/utils/app_colors.dart';
import 'package:beehive/features/edit_profil/controller/controller.dart';
import 'package:beehive/features/edit_profil/provider/provider.dart';
import 'package:beehive/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          onChanged: onChanged,
          style: TextStyle(
            fontSize: 15.sp,
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 15.sp,
            ),
            prefixIcon: Icon(icon, color: Colors.grey[600], size: 22.sp),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: maxLines > 1 ? 16.h : 0,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () => Get.back(),
          ),
          title: Text(
            "Modifier le profil",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Form(
                key: _controller.formKey,
                onChanged: _validateForm,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30.h),
                    _buildSectionTitle("Informations personnelles"),
                    SizedBox(height: 20.h),
                    _buildTextField(
                      controller: _controller.firstName,
                      label: "Prénom",
                      hint: "Entrez votre prénom",
                      icon: Icons.person_outline,
                      onChanged: (firstName) => ref
                          .read(editProfilNotifierProvier.notifier)
                          .onUserFirstNameChange(firstName),
                      validator: _controller.validateFirstName,
                    ),
                    SizedBox(height: 16.h),
                    _buildTextField(
                      controller: _controller.lastName,
                      label: "Nom",
                      hint: "Entrez votre nom",
                      icon: Icons.person_outline,
                      onChanged: (lastName) => ref
                          .read(editProfilNotifierProvier.notifier)
                          .onUserLastNameChange(lastName),
                      validator: _controller.validateLastName,
                    ),
                    SizedBox(height: 30.h),
                    _buildSectionTitle("À propos de vous"),
                    SizedBox(height: 20.h),
                    _buildTextField(
                      controller: _controller.description,
                      label: "Description",
                      hint: "Parlez de vous...",
                      icon: Icons.edit_outlined,
                      maxLines: 4,
                      onChanged: (description) => ref
                          .read(editProfilNotifierProvier.notifier)
                          .onUserDescriptionChange(description),
                    ),
                    SizedBox(height: 40.h),
                    SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: ElevatedButton(
                        onPressed: _onUpdate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryElement,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          "Enregistrer",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
