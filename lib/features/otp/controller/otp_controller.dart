import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ulearning_app/common/data/di/repository_module.dart';
import 'package:ulearning_app/common/global_loader/global_loader.dart';
import 'package:ulearning_app/common/routes/app_routes_names.dart';
import 'package:ulearning_app/common/widgets/popup_messages.dart';
import 'package:ulearning_app/features/otp/provider/otp_provider.dart';
import 'package:ulearning_app/main.dart';

class OtpController {
  final WidgetRef ref;
  OtpController({
    required this.ref,
  });

  Future<void> handleEmailVerification() async {
    var state = ref.read(emailVerificationProvier);
    final authRepository = ref.read(authRepositoryProvider);
    String token = state.token ?? "";

    if (token.isEmpty) {
      toastInfo("token is required");
      return;
    }

    if (token.length != 6) {
      toastInfo("token must be equal at 6 characters");
      return;
    }

    ref.read(appLoaderProvider.notifier).setLoaderValue(true);
    try {
      final response = await authRepository.verifyEmail(state);

      if (response.code == 200) {
        toastInfo(response.message);
        ref
            .read(emailVerificationResponseProvier.notifier)
            .setResponseCode(true);
      } else {
        ref
            .read(emailVerificationResponseProvier.notifier)
            .setResponseCode(false);
      }
    } catch (e) {
      ref
          .read(emailVerificationResponseProvier.notifier)
          .setResponseCode(false);
      if (kDebugMode) {
        print(e);
      }
    }
    ref.read(appLoaderProvider.notifier).setLoaderValue(false);
  }
}
