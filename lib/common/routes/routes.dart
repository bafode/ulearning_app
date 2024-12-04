import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ulearning_app/features/addPost/view/add.dart';
import 'package:ulearning_app/features/application/view/application.dart';
import 'package:ulearning_app/common/routes/app_routes_names.dart';
import 'package:ulearning_app/features/auth/view/auth.dart';
import 'package:ulearning_app/features/editProfile/view/edit_profile.dart';
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
import 'package:ulearning_app/features/res/view/registration.dart';
import 'package:ulearning_app/features/reset_password/view/reset_password.dart';
import 'package:ulearning_app/features/sign_in/view/sign_in.dart';
import 'package:ulearning_app/features/splash/splash.dart';
import 'package:ulearning_app/features/unotification/unotification.dart';
import 'package:ulearning_app/features/welcome/view/welcome.dart';

import '../../global.dart';

class AppPages {
  static List<RouteEntity> routes() {
    return [
      RouteEntity(path: AppRoutesNames.SPLASH, page: const Splash()),
      RouteEntity(path: AppRoutesNames.WELCOME, page: const Welcome()),
      RouteEntity(path: AppRoutesNames.SIGN_IN, page: const SignIn()),
      RouteEntity(path: AppRoutesNames.AUTH, page: const Auth()),
      RouteEntity(path: AppRoutesNames.REGISTER, page: const Registration()),
      RouteEntity(path: AppRoutesNames.Otp, page: const Otp()),
      RouteEntity(path: AppRoutesNames.APPLICATION, page: const Application()),
      RouteEntity(path: AppRoutesNames.HOME, page: const Home()),
      RouteEntity(path: AppRoutesNames.Profile, page: const Profile()),
      RouteEntity(path: AppRoutesNames.Setting, page: const Setting()),
      RouteEntity(path: AppRoutesNames.EditProfile, page: const EditProfile()),
      RouteEntity(path: AppRoutesNames.Add, page: const Add()),
      RouteEntity(
          path: AppRoutesNames.FORGOT_PASSWORD, page: const ForgotPassword()),
      RouteEntity(
          path: AppRoutesNames.RESET_PASSWORD, page: const ResetPassword()),
      RouteEntity(path: AppRoutesNames.POST_DETAIL, page: const PostDetail()),
      RouteEntity(
        path: AppRoutesNames.Message,
        page: const Message(),
      ),
      RouteEntity(
        path: AppRoutesNames.Chat,
        page: const Chat(),
      ),
      RouteEntity(
        path: AppRoutesNames.Photoview,
        page: const PhotoView(),
      ),
      RouteEntity(
        path: AppRoutesNames.VideoCall,
        page: const VideoCall(),
      ),
      RouteEntity(
        path: AppRoutesNames.VoiceCall,
        page: const VoiceCall(),
      ),
      RouteEntity(
        path: AppRoutesNames.Unotification,
        page: const Unotification(),
      ),

    ];
  }

  static MaterialPageRoute generateRouteSettings(RouteSettings settings) {
    if (kDebugMode) {
      print("clicked route is ${settings.name}");
    }
    if (settings.name != null) {
      var result = routes().where((element) => element.path == settings.name);

      if (result.isNotEmpty) {
        //if we used this is first time  or not
        bool deviceFirstTime = Global.storageService.getDeviceFirstOpen();

        if (result.first.path == AppRoutesNames.WELCOME && deviceFirstTime) {
          bool isLoggedIn = Global.storageService.isLoggedIn();
          if (isLoggedIn) {
            return MaterialPageRoute(
                builder: (_) => const Application(), settings: settings);
          } else {
            return MaterialPageRoute(
                builder: (_) => const Auth(), settings: settings);
          }
        } else {
          if (kDebugMode) {
            print('App ran first time');
          }
          return MaterialPageRoute(
              builder: (_) => result.first.page, settings: settings);
        }
      }
    }
    return MaterialPageRoute(
        builder: (_) => const Welcome(), settings: settings);
  }
}

class RouteEntity {
  String path;
  Widget page;

  RouteEntity({required this.path, required this.page});
}
