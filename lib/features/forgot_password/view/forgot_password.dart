import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:beehive/common/utils/app_colors.dart';
import 'package:beehive/common/utils/image_res.dart';
import 'package:beehive/common/widgets/app_textfields.dart';
import 'package:beehive/common/widgets/botton_widgets.dart';
import 'package:beehive/features/forgot_password/controller/forgot_password_controller.dart';
import 'package:beehive/features/forgot_password/provider/forgot_password_provider.dart';

class ForgotPassword extends ConsumerStatefulWidget {
  const ForgotPassword({super.key});

  @override
  ForgotPasswordState createState() => ForgotPasswordState();
}

class ForgotPasswordState extends ConsumerState<ForgotPassword>
    with SingleTickerProviderStateMixin {
  final TextEditingController email = TextEditingController();
  late AnimationController _controller;

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
      backgroundColor: AppColors.primaryElement,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        SvgPicture.asset(
          ImageRes.beehivelogo,
          height: 200.h,
          fit: BoxFit.contain, // Essaye différents BoxFit si besoin
          alignment: Alignment.center, // Assure un bon centrage
        ),
        Text(
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildLogo(),
                  SizedBox(height: 20.h),
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
