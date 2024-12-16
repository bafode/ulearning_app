class AppConstants {
  static const String SERVER_API_URL ="https://569e-77-136-67-27.ngrok-free.app/";
  static String IMAGE_UPLOADS_PATH = "${SERVER_API_URL}uploads/";
  static const String STORAGE_USER_PROFILE_KEY = "user_profile";
  static const String STORAGE_USER_TOKEN_KEY = "user_token";
  static const String STORAGE_DEVICE_OPEN_FIRST_KEY = "first_time";
  static const String APPID = "2b8731acd0d4481e851913553c702663";
  static const String loginEndPointUrl = "v1/auth/login";
  static const String registrationEndPointUrl = "v1/auth/register";
  static const String userEndpoint = "v1/users";
  static const String sendEmailVerificationTokenUrl = "v1/auth/send-verification-email";
  static const String emailVerificationUrl = "v1/auth/verify-email";
  static const String forgotPasswordUrl = "v1/auth/forgot-password";
   static const String resetPasswordUrl = "v1/auth/reset-password";
  static const String logoutEndPointUrl = "v1/auth/logout";
  static const String postEndPointUrl = "v1/posts";
}
