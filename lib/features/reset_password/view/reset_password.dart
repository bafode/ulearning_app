import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning_app/common/utils/app_colors.dart';
import 'package:ulearning_app/common/utils/image_res.dart';
import 'package:ulearning_app/common/widgets/app_textfields.dart';
import 'package:ulearning_app/common/widgets/botton_widgets.dart';
import 'package:ulearning_app/common/widgets/image_widgets.dart';
import 'package:ulearning_app/features/reset_password/controller/reset_password_controller.dart';
import 'package:ulearning_app/features/reset_password/provider/reset_password_provider.dart';

class ResetPassword extends ConsumerStatefulWidget {
  const ResetPassword({super.key});

  @override
  ResetPasswordState createState() => ResetPasswordState();
}

class ResetPasswordState extends ConsumerState<ResetPassword>
    with SingleTickerProviderStateMixin {
  final TextEditingController verificationCodeController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late ResetPasswordController controller;

  @override
  void initState() {
    super.initState();
    controller = ResetPasswordController(ref: ref);
    controller.init();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    verificationCodeController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est requis';
    } else if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    return null;
  }

  String? validateToken(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le code de vérification est requis';
    } else if (value.length < 6) {
      return 'Le code de vérification doit contenir 6 caractères';
    }
    return null;
  }

  String? validateConfirmationPassword(String? value) {
    if (value != newPasswordController.text) {
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }

  void _onTokenChange(String value) {
    ref.read(resetPasswordProvider.notifier).onTokenChange(value);
    final isValid = validateToken(value)== null;
    ref.read(resetPasswordButtonEnabledProvider.notifier).state = isValid;
  }

  void _onPasswordChange(String value) {
    ref.read(resetPasswordProvider.notifier).onPasswordChange(value);
    final isValid = validatePassword(value) == null;
    ref.read(resetPasswordButtonEnabledProvider.notifier).state = isValid;
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.primaryText),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        SizedBox(height: 20.h),
        AppImage(
          width: 250.w,
          height: 125.h,
          imagePath: ImageRes.logo,
        ),
        FadeTransition(
          opacity: _fadeAnimation,
          child: Text(
            "Réinitialiser le mot de passe",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.primaryText,
              fontWeight: FontWeight.bold,
              fontSize: 22.sp,
              shadows: [
                Shadow(
                  offset: const Offset(0, 2),
                  blurRadius: 4.0,
                  color: Colors.grey.withOpacity(0.5),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationCodeField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: AppTextField(
        controller: verificationCodeController,
        text: "Code de vérification",
        iconName: Icons.verified_outlined,
        hintText: "Entrez le code de vérification",
        validator: validateToken,
        onChanged: _onTokenChange,
      ),
    );
  }

  Widget _buildNewPasswordField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: AppTextField(
        controller: newPasswordController,
        text: "Nouveau mot de passe",
        iconName: Icons.lock_outline,
        hintText: "Entrez le nouveau mot de passe",
        validator: validatePassword,
        obscureText: true,
        onChanged: _onPasswordChange,
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: AppTextField(
        controller: confirmPasswordController,
        text: "Confirmer le mot de passe",
        iconName: Icons.lock_outline,
        hintText: "Confirmez le nouveau mot de passe",
        validator: validateConfirmationPassword,
        obscureText: true,
        onChanged: _onPasswordChange,
      ),
    );
  }

  Widget _buildResetButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: AppButton(
        buttonName: "Réinitialiser",
        isLogin: true,
        isEnabled: ref.watch(resetPasswordButtonEnabledProvider),
        context: context,
        func: () {
          controller.resetPassword();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.white.withOpacity(0.1)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildLogo(),
                  SizedBox(height: 40.h),
                  _buildVerificationCodeField(),
                  SizedBox(height: 20.h),
                  _buildNewPasswordField(),
                  SizedBox(height: 20.h),
                  _buildConfirmPasswordField(),
                  SizedBox(height: 20.h),
                  _buildResetButton(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
