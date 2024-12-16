import 'package:flutter/material.dart';
import 'package:ulearning_app/common/routes/names.dart';
import 'package:ulearning_app/common/routes/observers.dart';
import 'package:ulearning_app/features/splash/splash.dart';
import 'package:ulearning_app/features/addPost/view/add.dart';
import 'package:ulearning_app/features/application/view/application.dart';
import 'package:ulearning_app/features/auth/view/auth.dart';
import 'package:ulearning_app/features/contact/view/contact.dart';
import 'package:ulearning_app/features/editProfile/view/edit_profile.dart';
import 'package:ulearning_app/features/favorites/views/favorites.dart';
import 'package:ulearning_app/features/forgot_password/view/forgot_password.dart';
import 'package:ulearning_app/features/home/view/home.dart';
import 'package:ulearning_app/features/message/chat/chat.dart';
import 'package:ulearning_app/features/message/message.dart';
import 'package:ulearning_app/features/message/photoview/photoview.dart';
import 'package:ulearning_app/features/message/videocall/videocall.dart';
import 'package:ulearning_app/features/message/voicecall/voicecall.dart';
import 'package:ulearning_app/features/otp/view/otp.dart';
import 'package:ulearning_app/features/post_detail/view/post_detail.dart';
import 'package:ulearning_app/features/profile/view/profile.dart';
import 'package:ulearning_app/features/profile/view/setting/setting.dart';
import 'package:ulearning_app/features/sign_up/view/sign_up.dart';
import 'package:ulearning_app/features/reset_password/view/reset_password.dart';
import 'package:ulearning_app/features/sign_in/view/sign_in.dart';
import 'package:ulearning_app/features/unotification/unotification.dart';
import 'package:ulearning_app/features/welcome/view/welcome.dart';
import 'package:ulearning_app/global.dart';

class AppPages {
  static final RouteObserver<Route> observer = RouteObservers();
  static List<String> history = [];

  static List<PageEntity> Routes() {
    return [
      PageEntity(path: AppRoutes.INITIAL, page: const Splash()),
      PageEntity(path: AppRoutes.WELCOME, page: const Welcome()),
      PageEntity(path: AppRoutes.SIGN_IN, page: const SignIn()),
      PageEntity(path: AppRoutes.AUTH, page: const Auth()),
      PageEntity(path: AppRoutes.SIGN_UP, page: const SignUp()),
      PageEntity(path: AppRoutes.Otp, page: const Otp()),
      PageEntity(path: AppRoutes.APPLICATION, page: const Application()),
      PageEntity(path: AppRoutes.HOME, page: const Home()),
      PageEntity(path: AppRoutes.Profile, page: const Profile()),
      PageEntity(path: AppRoutes.Setting, page: const Setting()),
      PageEntity(path: AppRoutes.EditProfile, page: const EditProfile()),
      PageEntity(path: AppRoutes.Add, page: const Add()),
      PageEntity(path: AppRoutes.FORGOT_PASSWORD, page: const ForgotPassword()),
      PageEntity(path: AppRoutes.RESET_PASSWORD, page: const ResetPassword()),
      PageEntity(path: AppRoutes.POST_DETAIL, page: const PostDetail()),
      PageEntity(
        path: AppRoutes.Message,
        page: const Message(),
      ),
      PageEntity(
        path: AppRoutes.Chat,
        page: const Chat(),
      ),
      PageEntity(
        path: AppRoutes.Photoview,
        page: const PhotoView(),
      ),
      PageEntity(
        path: AppRoutes.VideoCall,
        page: const VideoCall(),
      ),
      PageEntity(
        path: AppRoutes.VoiceCall,
        page: const VoiceCall(),
      ),
      PageEntity(
        path: AppRoutes.Unotification,
        page: const Unotification(),
      ),
      PageEntity(
        path: AppRoutes.FAVORITES,
        page: const Favorites(),
      ),
      PageEntity(
        path: AppRoutes.CONTACT,
        page: const Contact(),
      ),
    ];
  }

  static MaterialPageRoute GenerateRouteSettings(RouteSettings settings) {
    if (settings.name != null) {
      var result = Routes().where((element) => element.path == settings.name);
      if (result.isNotEmpty) {
        // first open App
        bool deviceFirstOpen = Global.storageService.getDeviceFirstOpen();
        if (result.first.path == AppRoutes.INITIAL && deviceFirstOpen) {
          bool isLogin = Global.storageService.isLoggedIn();
          //is login
          if (isLogin) {
            return MaterialPageRoute<void>(
                builder: (_) => const Application(), settings: settings);
          }
          return MaterialPageRoute<void>(
              builder: (_) => const SignIn(), settings: settings);
        }
        return MaterialPageRoute<void>(
            builder: (_) => result.first.page, settings: settings);
      }
    }

    return MaterialPageRoute<void>(
        builder: (_) => const SignIn(), settings: settings);
  }
}

class PageEntity<T> {
  String path;
  Widget page;

  PageEntity({
    required this.path,
    required this.page,
  });
}
