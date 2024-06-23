import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ulearning_app/common/data/di/repository_module.dart';
import 'package:ulearning_app/common/global_loader/global_loader.dart';
import 'package:ulearning_app/common/widgets/popup_messages.dart';
import 'package:ulearning_app/features/sign_up/provider/register_notifier.dart';
import 'package:ulearning_app/main.dart';

class SignUpController {
  final WidgetRef ref;
  SignUpController({
    required this.ref,
  });

  Future<void> handleSignUp() async {
    var state = ref.read(signUpNotifierProvier);
    final authRepository = ref.read(authRepositoryProvider);
    print(state);
    String firstname = state.firstname ?? "";
    String lastname = state.firstname ?? "";
    String email = state.email ?? "";
    String password = state.password ?? "";

    if (firstname.isEmpty) {
      toastInfo("User firstname is required");
      return;
    }
    if (lastname.isEmpty) {
      toastInfo("User lastname is required");
      return;
    }

    if (firstname.length < 3) {
      toastInfo("User First Name must be at least 3 characters");
      return;
    }

    if (email.isEmpty) {
      toastInfo("Email is required");
      return;
    }

    if (password.isEmpty) {
      toastInfo("Password is required");
      return;
    }
    if (password.length < 6) {
      toastInfo("Password must be at least 6 characters");
      return;
    }

    if (state.password != state.rePassword) {
      toastInfo("your password does not match");
      return;
    }

    ref.read(appLoaderProvider.notifier).setLoaderValue(true);
    try {
      final response = await authRepository.register(state);

      if (response.code == 201) {
        toastInfo(
            "An email has been sent to your email address, please verify your email");
        navKey.currentState?.pushNamedAndRemoveUntil("/otp", (route) => false);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    ref.read(appLoaderProvider.notifier).setLoaderValue(false);
  }
}
