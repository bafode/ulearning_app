import 'package:beehive/common/entities/user/user.dart';
import 'package:beehive/global.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:beehive/common/data/di/repository_module.dart';
import 'package:beehive/common/entities/auth/logoutRequest/logout_request.dart';
import 'package:beehive/common/entities/auth/token/tokens.dart';
part 'application_nav_notifier.g.dart';

@riverpod
class ApplicationNavNotifier extends _$ApplicationNavNotifier {
  @override
  int build() {
    return 0;
  }

  void changeIndex(int index) {
    state = index;
  }
}

@riverpod
class IsLoggedIn extends _$IsLoggedIn {
  @override
  bool build() {
    return Global.storageService.isLoggedIn();
  }

  void setValue(bool value) {
    state = value;
  }

  void logout() async {
    Tokens? tokens = Global.storageService.getTokens();
    LogoutRequest params = LogoutRequest(refreshToken: tokens!.refresh.token);
    final authRepository = ref.read(authRepositoryProvider);
    final response = await authRepository.logout(params);
    if (response.code == 200) {
      await Global.storageService.resetStorage();
      ref.read(zoomIndexProvider.notifier).setIndex(0);
      setValue(false);
    } else {
      setValue(true);
    }
  }

  void deleteAccount() async {
    User? loggedUser = Global.storageService.getUserProfile();
    String userId=loggedUser.id!;
    final authRepository = ref.read(authRepositoryProvider);
    final response = await authRepository.deleteAccount(userId);
    if (response.code == 200) {
      await Global.storageService.resetStorage();
      ref.read(zoomIndexProvider.notifier).setIndex(0);
      setValue(false);
       logout();
    } else {
      setValue(true);
    }
  }
}

@riverpod
class ZoomIndex extends _$ZoomIndex {
  @override
  int build() => 0;

  void setIndex(int value) {
    state = value;
  }
}

@riverpod
class AppZoomController extends _$AppZoomController {
  @override
  ZoomDrawerController build() => ZoomDrawerController();
}
