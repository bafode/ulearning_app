import 'dart:convert';
import 'package:beehive/common/entities/user/editProfileRequest/edit_profil_request.dart';
import 'package:beehive/common/routes/routes.dart';
import 'package:beehive/features/application/provider/application_nav_notifier.dart';
import 'package:beehive/features/edit_profil/provider/provider.dart';
import 'package:beehive/features/home/controller/home_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beehive/common/data/di/repository_module.dart';
import 'package:beehive/common/utils/constants.dart';
import 'package:beehive/common/utils/logger.dart';
import 'package:beehive/common/widgets/popup_messages.dart';
import 'package:beehive/global.dart';

class EditProfilController {
  final WidgetRef ref;
  EditProfilController({required this.ref});

  init() {}

  final formKey = GlobalKey<FormState>();
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController description = TextEditingController();

  String? validateFirstName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le prénom est requis';
    } else if (value.length < 3) {
      return 'Le prénom doit contenir au moins 3 lettres';
    }
    return null;
  }

  String? validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le nom est requis';
    } else if (value.length < 3) {
      return 'Le nom doit contenir au moins 3 lettres';
    }
    return null;
  }

  void handleUpdateUserInfo() {
    var state = ref.watch(editProfilNotifierProvier);
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      asyncPostAllData(state);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      toastInfo("Update User Info Error ");
    }
  }

  Future<void> asyncPostAllData(EditProfilRequest userProfile) async {
    EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: true);
    //we need to talk to server
    final authRepository = ref.read(authRepositoryProvider);
    final userInfo = ref.watch(homeUserProfileProvider);
    final userId = userInfo.asData?.value.id;
    try {
      if (userId != null) {
        var result =
            await authRepository.updateUserProfile(userId, userProfile);
        if (kDebugMode) {
          print(result);
        }
       await Global.storageService.setString(
            AppConstants.STORAGE_USER_PROFILE_KEY, jsonEncode(result));
        EasyLoading.dismiss();
        ref.read(applicationNavNotifierProvider.notifier).changeIndex(3);
        Global.navigatorKey.currentState
            ?.pushNamedAndRemoveUntil(AppRoutes.APPLICATION, (route) => false);
        //redirect to new page
      } else {
        EasyLoading.dismiss();
        toastInfo('invalid credentials');
      }
    } catch (e) {
      EasyLoading.dismiss();
      toastInfo('invalid credentials or internet error');
      Logger.write("$e");
    }
  }
}
