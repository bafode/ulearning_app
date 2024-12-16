import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ulearning_app/common/data/di/repository_module.dart';
import 'package:ulearning_app/common/global_loader/global_loader.dart';
import 'package:ulearning_app/common/routes/routes.dart';
import 'package:ulearning_app/common/widgets/popup_messages.dart';
import 'package:ulearning_app/features/forgot_password/provider/forgot_password_provider.dart';
import 'package:ulearning_app/global.dart';
class ForgotPasswordController {
  final WidgetRef ref;
  ForgotPasswordController({required this.ref});

    init() {}
  
  Future<void> sendResetPasswordToken() async {
    final authRepository = ref.read(authRepositoryProvider);
    final state=ref.watch(forgotPasswordProvider);
    try {
      if(kDebugMode){
        print("email: ${state.email}");
      }
      ref.read(appLoaderProvider.notifier).setLoaderValue(true);
    final response = await authRepository.forgotPassword(state);

      if (response.code == 200) {
        toastInfo(response.message);
        Global.navigatorKey.currentState!.pushNamed(AppRoutes.RESET_PASSWORD);
        ref.read(appLoaderProvider.notifier).setLoaderValue(false);
      } else {
         ref.read(appLoaderProvider.notifier).setLoaderValue(false);
        toastInfo("L'envoi du code de vérification par e-mail a échoué, veuillez réessayer.");
      }
    } catch (e) {
       ref.read(appLoaderProvider.notifier).setLoaderValue(false);
      toastInfo(
          "Erreur lors de l'envoi du code de vérification par e-mail. Veuillez vérifier votre connexion.");

      if (kDebugMode) {
        print("Erreur lors de l'envoi du code de vérification par e-mail : $e");
      }
    }
  }
}
