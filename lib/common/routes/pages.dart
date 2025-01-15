import 'package:beehive/common/middlewares/middlewares.dart';
import 'package:beehive/features/contact/bindings.dart';
import 'package:beehive/features/contact/view.dart';
import 'package:beehive/features/edit_profil/view/edit_profil.dart';
import 'package:beehive/features/follower/index.dart';
import 'package:beehive/features/following/index.dart';
import 'package:beehive/features/message/index.dart';
import 'package:beehive/features/message/chat/index.dart';
import 'package:beehive/features/message/videocall/bindings.dart';
import 'package:beehive/features/message/videocall/view.dart';
import 'package:beehive/features/message/voicecall/index.dart';
import 'package:beehive/features/profile/view/profile.dart';
import 'package:beehive/features/sign_up/view/widgets/privacy.dart';
import 'package:beehive/features/sign_up/view/widgets/term.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:beehive/common/routes/names.dart';
import 'package:beehive/common/routes/observers.dart';
import 'package:beehive/features/splash/splash.dart';
import 'package:beehive/features/addPost/view/add.dart';
import 'package:beehive/features/application/view/application.dart';
import 'package:beehive/features/auth/view/auth.dart';
import 'package:beehive/features/feedback/view/feedback.dart';
import 'package:beehive/features/favorites/views/favorites.dart';
import 'package:beehive/features/forgot_password/view/forgot_password.dart';
import 'package:beehive/features/home/view/home.dart';
import 'package:beehive/features/otp/view/otp.dart';
import 'package:beehive/features/post_detail/view/post_detail.dart';
import 'package:beehive/features/profile/view/setting/setting.dart';
import 'package:beehive/features/sign_up/view/sign_up.dart';
import 'package:beehive/features/reset_password/view/reset_password.dart';
import 'package:beehive/features/sign_in/view/sign_in.dart';
import 'package:beehive/features/unotification/unotification.dart';
import 'package:beehive/features/welcome/view/welcome.dart';

class AppPages {
  static const INITIAL = AppRoutes.INITIAL;
  static final RouteObserver<Route> observer = RouteObservers();
  static List<String> history = [];

  static List<GetPage> routes = [
    GetPage(
      name: AppRoutes.INITIAL,
      page: () => const Splash(),
        middlewares: [
        RouteWelcomeMiddleware(priority: 1),
      ],
    ),
    GetPage(
      name: AppRoutes.WELCOME,
      page: () => const Welcome(),
    ),
    GetPage(
      name: AppRoutes.SIGN_IN,
      page: () => const SignIn(),
    ),
    GetPage(
      name: AppRoutes.AUTH,
      page: () => const Auth(),
    ),
    GetPage(
      name: AppRoutes.SIGN_UP,
      page: () => const SignUp(),
    ),
    GetPage(
      name: AppRoutes.Otp,
      page: () => const Otp(),
    ),
    GetPage(
      name: AppRoutes.APPLICATION,
      page: () => const Application(),
      middlewares: [
        RouteAuthMiddleware(priority: 1),
      ],
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => const Home(),
    ),
    GetPage(
      name: AppRoutes.Profile,
      page: () => const Profile(),
    ),
    GetPage(
      name: AppRoutes.Setting,
      page: () => const Setting(),
    ),
    GetPage(
      name: AppRoutes.EditProfile,
      page: () => const EditProfil(),
    ),
    GetPage(
      name: AppRoutes.Add,
      page: () => const Add(),
    ),
    GetPage(
      name: AppRoutes.FORGOT_PASSWORD,
      page: () => const ForgotPassword(),
    ),
    GetPage(
      name: AppRoutes.RESET_PASSWORD,
      page: () => const ResetPassword(),
    ),
    GetPage(
      name: AppRoutes.POST_DETAIL,
      page: () => const PostDetail(),
    ),
    GetPage(
      name: AppRoutes.Unotification,
      page: () => const Unotification(),
    ),
    GetPage(
      name: AppRoutes.FAVORITES,
      page: () => const Favorites(),
    ),
    GetPage(
      name: AppRoutes.FEEDBACK,
      page: () => const Feedbacks(),
    ),
    GetPage(
      name: AppRoutes.CONTACT,
      page: () => const ContactPage(),
      binding: ContactBinding(),
    ),
    GetPage(
      name: AppRoutes.FOLLOWERS,
      page: () => const FollowersPage(),
      binding: FollowersBinding(),
    ),
     GetPage(
      name: AppRoutes.FOLLOWING,
      page: () => const FollowingPage(),
      binding: FollowingBinding(),
    ),
    GetPage(
      name: AppRoutes.Message,
      page: () => const MessagePage(),
      binding: MessageBinding(),
      middlewares: [
        RouteAuthMiddleware(priority: 1),
      ],
    ),
    GetPage(
        name: AppRoutes.Chat,
        page: () => const ChatPage(),
        binding: ChatBinding()),
    GetPage(
        name: AppRoutes.VoiceCall,
        page: () => const VoiceCallPage(),
        binding: VoiceCallBinding()),
    GetPage(
        name: AppRoutes.VideoCall,
        page: () => const VideoCallPage(),
        binding: VideoCallBinding(),
        ),
        GetPage(
        name: AppRoutes.TERMS,
        page: () => const TermsPage(),
        ),
        GetPage(
      name: AppRoutes.PRIVACY,
      page: () => const PrivacyPolicyPage(),
    ),
  ];
}
