import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ulearning_app/common/data/di/repository_module.dart';
import 'package:ulearning_app/common/global_loader/global_loader.dart';
import 'package:ulearning_app/common/widgets/popup_messages.dart';
import 'package:ulearning_app/features/otp/provider/otp_provider.dart';
import 'package:ulearning_app/features/sign_up/notifiers/step_notifier.dart';

class OtpController {
  final WidgetRef ref;

  OtpController({
    required this.ref,
  });

  Future<void> handleEmailVerification() async {
    final state = ref.read(emailVerificationProvier);
    final authRepository = ref.read(authRepositoryProvider);
    final responseNotifier =
        ref.read(emailVerificationResponseProvier.notifier);

    // Affiche le loader avant la requête
    ref.read(appLoaderProvider.notifier).setLoaderValue(true);

    print(state);

    try {
      final response = await authRepository.verifyEmail(state);

      if (response.code == 200) {
        toastInfo(response.message);
        ref.read(registrationCurrentStepProvider.notifier).setCurrentStep(2);
      } else {
        responseNotifier.setResponseCode(false);
        toastInfo("La vérification de l'e-mail a échoué, veuillez réessayer.");
      }
    } catch (e) {
      responseNotifier.setResponseCode(false);
      toastInfo(
          "Erreur lors de la vérification de l'e-mail. Veuillez vérifier votre connexion.");

      if (kDebugMode) {
        print("Erreur de vérification de l'e-mail : $e");
      }
    } finally {
      ref.read(appLoaderProvider.notifier).setLoaderValue(false);
    }
  }

  Future<void> sendEmailVerificationToken() async {
    final authRepository = ref.read(authRepositoryProvider);
    final responseNotifier =
        ref.read(emailVerificationResponseProvier.notifier);
    try {
      await authRepository.sendEmailVerificationToken();
    } catch (e) {
      responseNotifier.setResponseCode(false);
      toastInfo(
          "Erreur lors de l'envoi du code de vérification par e-mail. Veuillez vérifier votre connexion.");

      if (kDebugMode) {
        print("Erreur d'envoi du code de vérification par e-mail : $e");
      }
    }
  }
}
