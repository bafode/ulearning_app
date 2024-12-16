import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning_app/common/utils/app_colors.dart';
import 'package:ulearning_app/common/utils/image_res.dart';
import 'package:ulearning_app/common/widgets/app_textfields.dart';
import 'package:ulearning_app/common/widgets/botton_widgets.dart';
import 'package:ulearning_app/common/widgets/image_widgets.dart';
import 'package:ulearning_app/features/forgot_password/controller/forgot_password_controller.dart';
import 'package:ulearning_app/features/forgot_password/provider/forgot_password_provider.dart';

class ForgotPassword extends ConsumerStatefulWidget {
  const ForgotPassword({super.key});

  @override
  ForgotPasswordState createState() => ForgotPasswordState();
}

class ForgotPasswordState extends ConsumerState<ForgotPassword>
    with SingleTickerProviderStateMixin {
  final TextEditingController email = TextEditingController();
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  late ForgotPasswordController controller;

  @override
  void initState() {
    super.initState();
    controller = ForgotPasswordController(ref: ref);
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
    super.dispose();
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'L\'email est requis';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Veuillez entrer un email valide';
    }
    return null;
  }

  void _onEmailChanged(String value) {
    ref.read(forgotPasswordProvider.notifier).onEmailChange(value);
    final isValid = validateEmail(value) == null;
    ref.read(sendEmailButtonEnabledProvider.notifier).state = isValid;
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
          width: 250.w, // Agrandir le logo
          height: 125.h,
          imagePath: ImageRes.logo,
        ),
        FadeTransition(
          opacity: _fadeAnimation,
          child: Text(
            "Mot de passe oublié",
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

  Widget _buildEmailField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: AppTextField(
        controller: email,
        text: "Email",
        iconName: Icons.email_outlined,
        hintText: "Entrez votre adresse email",
        validator: validateEmail,
        onChanged: _onEmailChanged,
      ),
    );
  }

  Widget _buildSendButton(BuildContext context) {
    final isEnabled = ref.watch(sendEmailButtonEnabledProvider);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: AppButton(
        buttonName: "Envoyer",
        isLogin: true,
        isEnabled: isEnabled,
        context: context,
        func: () {
          controller.sendResetPasswordToken();
        },
        // Ajout d'un dégradé pour le bouton
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
                  _buildEmailField(),
                  SizedBox(height: 20.h),
                  _buildSendButton(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
