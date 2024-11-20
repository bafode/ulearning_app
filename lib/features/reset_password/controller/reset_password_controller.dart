import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ulearning_app/common/data/di/repository_module.dart';
import 'package:ulearning_app/common/global_loader/global_loader.dart';
import 'package:ulearning_app/common/routes/app_routes_names.dart';
import 'package:ulearning_app/common/widgets/popup_messages.dart';
import 'package:ulearning_app/features/reset_password/provider/reset_password_provider.dart';
import 'package:ulearning_app/main.dart';

class ResetPasswordController {
  final WidgetRef ref;
  ResetPasswordController({required this.ref});

  init() {}

  Future<void> resetPassword() async {
    final authRepository = ref.read(authRepositoryProvider);
    final state = ref.watch(resetPasswordProvider);
    try {
      if (kDebugMode) {
        print("token: ${state.token}");
         print("password: ${state.password}");
      }
       ref.read(appLoaderProvider.notifier).setLoaderValue(true);
      final response = await authRepository.resetPassword(state);

      if (response.code == 200) {
        toastInfo(response.message);
        ref.read(appLoaderProvider.notifier).setLoaderValue(false);
        navKey.currentState!.pushNamed(AppRoutesNames.SIGN_IN);
      } else {
         ref.read(appLoaderProvider.notifier).setLoaderValue(false);
        toastInfo(
            "La réinitialisation du mot de passe a échoué, veuillez réessayer.");
      }
    } catch (e) {
       ref.read(appLoaderProvider.notifier).setLoaderValue(false);
      toastInfo(
          "Erreur lors de la réinitialisation du mot de passe. Veuillez vérifier votre connexion.");

      if (kDebugMode) {
        print("Erreur lors de la réinitialisation du mot de passe: $e");
      }
    }
  }
}
