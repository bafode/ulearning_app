import 'package:beehive/common/entities/auth/forgotPasswordRequest/forgot_password_request.dart';
import 'package:beehive/common/entities/auth/loginRequest/login_request.dart';
import 'package:beehive/common/entities/auth/loginResponse/login_response.dart';
import 'package:beehive/common/entities/auth/logoutRequest/logout_request.dart';
import 'package:beehive/common/entities/auth/logoutResponse/logout_response.dart';
import 'package:beehive/common/entities/auth/registrationRequest/registration_request.dart';
import 'package:beehive/common/entities/auth/registrationResponse/registration_response.dart';
import 'package:beehive/common/entities/auth/resetPasswordRequest/reset_password_request.dart';
import 'package:beehive/common/entities/auth/updateUserInfoRequest/update_user_info_request.dart';
import 'package:beehive/common/entities/auth/verifyEmailRequest/verify_email_request.dart';
import 'package:beehive/common/entities/user/user.dart';

abstract class AuthRepository {
  Future<LoginResponse?> login(LoginRequest params);
  Future<LoginResponse> register(RegistrationRequest params);
  Future<void> sendEmailVerificationToken();
  Future<RegistrationResponse> verifyEmail(VerifyEmailRequest token);
  Future<RegistrationResponse> forgotPassword(ForgotPasswordRequest forgotPasswordRequest);
  Future<RegistrationResponse> resetPassword(
      ResetPasswordRequest resetPasswordRequest);
  Future<LogoutResponse> logout(LogoutRequest refreshToken);
  Future<User> updateUserInfo(String userId,UpdateUserInfoRequest userInfo);
}
