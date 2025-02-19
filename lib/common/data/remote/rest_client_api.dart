import 'dart:io';
import 'package:beehive/common/entities/contact/contactResponse/contact_response_entity.dart';
import 'package:beehive/common/entities/user/editProfileRequest/edit_profil_request.dart';
import 'package:beehive/common/entities/base/base_response_entity.dart';
import 'package:beehive/common/entities/auth/bindFcmTokenRequest/bind_fcm_token_request.dart';
import 'package:beehive/common/models/chat.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';
import 'package:beehive/common/data/di/network_module.dart';
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
import 'package:beehive/common/entities/post/createCommentRequest/create_comment_request.dart';
import 'package:beehive/common/entities/post/createPostResponse/post_create_response.dart';
import 'package:beehive/common/entities/post/postResponse/post_response.dart';
import 'package:beehive/common/entities/user/user.dart';
import 'package:beehive/common/utils/constants.dart';

part 'rest_client_api.g.dart';

final restClientApiProvider =
    Provider((ref) => RestClientApi(ref.watch(dioProvider)));

@RestApi()
abstract class RestClientApi {
  factory RestClientApi(Dio dio, {String baseUrl}) = _RestClientApi;

  @GET(AppConstants.postEndPointUrl)
  Future<PostResponse> getPosts({
    @Query("query") String? query,
    @Query("category") String? category,
    @Query("sortBy") String? sortBy,
    @Query("page") int? page,
    @Query("limit") int? limit,
  });

  @GET("${AppConstants.userEndpoint}/favorites")
  Future<PostResponse> getFavorites({
    @Query("q") String? query,
    @Query("page") int? page,
    @Query("limit") int? limit,
  });

  @GET("${AppConstants.userEndpoint}/me/posts")
  Future<PostResponse> getLoggedUserPost({
    @Query("query") String? query,
    @Query("page") int? page,
    @Query("limit") int? limit,
  });

  @POST(AppConstants.loginEndPointUrl)
  Future<LoginResponse> login({
    @Body() required LoginRequest loginRequest,
  });

  @POST(AppConstants.registrationEndPointUrl)
  Future<LoginResponse> register({
    @Body() required RegistrationRequest registrationRequest,
  });

  @PATCH("${AppConstants.userEndpoint}/{userId}")
  Future<User> updateUser(
    @Path("userId") String userId,
    @Body() UpdateUserInfoRequest updateUserInfoRequest
  );

  @PATCH("${AppConstants.userEndpoint}/{userId}")
  Future<User> updateUserProfile(
    @Path("userId") String userId,
    @Body() EditProfilRequest profilRequest
  );

  @GET("${AppConstants.userEndpoint}/contacts")
  Future<ContactResponseEntity> getContacts();

  @GET("${AppConstants.userEndpoint}/{userId}/followers")
  Future<ContactResponseEntity> getFollowers(@Path("userId") String userId);

  @GET("${AppConstants.userEndpoint}/{userId}/following")
  Future<ContactResponseEntity> getFollowings(@Path("userId") String userId);

  @GET("${AppConstants.userEndpoint}/{userId}")
  Future<User> getUserById(@Path("userId") String userId);

  @POST(AppConstants.sendEmailVerificationTokenUrl)
  Future<void> sendEmailVerificationToken();

  @POST(AppConstants.emailVerificationUrl)
  Future<RegistrationResponse> verifyEmail({
    @Body() required VerifyEmailRequest verifyEmailRequest,
  });
  
  @POST(AppConstants.forgotPasswordUrl)
  Future<RegistrationResponse> forgotPassword({
    @Body() required ForgotPasswordRequest forgotPasswordRequest,
  });

  @POST(AppConstants.resetPasswordUrl)
  Future<RegistrationResponse> resetPassword({
    @Body() required ResetPasswordRequest resetPasswordRequest,
  });

  @POST(AppConstants.logoutEndPointUrl)
  Future<LogoutResponse> logout({
    @Body() required LogoutRequest refreshToken,
  });

  @DELETE("${AppConstants.userEndpoint}/{userId}")
  Future<LogoutResponse> deleteAccount(
    @Path("userId") String userId,
  );

  @POST(AppConstants.postEndPointUrl)
  @MultiPart()
  Future<PostCreateResponse> createPost(
      @Part(name: 'title') String title,
      @Part(name: 'content') String content,
      @Part(name: 'category') String category,
      @Part(name: 'domain') List<String>? domain,
      @Part() List<MultipartFile>? media,
      {@SendProgress() ProgressCallback? onSendProgress});

  @PATCH("${AppConstants.userEndpoint}/{userId}")
  @MultiPart()
  Future<User> updateProfilePicture(
      @Part(name: 'userId') String title,
      @Part() List<MultipartFile>? media,
      {@SendProgress() ProgressCallback? onSendProgress});
  
  @PATCH("${AppConstants.postEndPointUrl}/{postId}/likes")
  Future<Post> toagleLikePost(
    @Path("postId") String postId,
  );

  @GET("${AppConstants.postEndPointUrl}/{postId}")
  Future<Post> getPost(
    @Path("postId") String postId,
  );

  @POST("${AppConstants.postEndPointUrl}/{postId}/comment")
  Future<Post> addComment(
    @Path("postId") String postId,
    @Body() CreateCommentRequest content,
  );

  @PATCH("${AppConstants.userEndpoint}/{postId}/favorites")
  Future<User> toggleUserFavorites(
    @Path("postId") String postId,
  );

  @PATCH("${AppConstants.userEndpoint}/{followId}/follow")
  Future<User> toggleUserFollow(
    @Path("followId") String followId,
  );

  // Chat endpoints
  @POST("v1/auth/bind_fcmtoken")
  Future<BaseResponseEntity> bindFcmToken(
    @Body() BindFcmTokenRequestEntity params,
  );

  @POST("v1/notifications/send_notice")
  Future<BaseResponseEntity> sendCallNotification(
    @Body() CallRequestEntity params,
  );

  @POST("v1/auth/get_rtc_token")
  Future<BaseResponseEntity> getRtcToken(
    @Body() CallTokenRequestEntity params,
  );

  @POST("api/message")
  Future<BaseResponseEntity> sendMessage(
    @Body() ChatRequestEntity params,
  );

  @POST("v1/notifications/upload_photo")
  @MultiPart()
  Future<BaseResponseEntity> uploadImage(
    @Part() File file,
  );

  @PATCH("${AppConstants.userEndpoint}/{userId}")
  @MultiPart()
  Future<User> uploadProfileImage(
    @Path("userId") String userId,
    @Part() File image,
  );

  @POST("api/sync_message")
  Future<SyncMessageResponseEntity> syncMessage(
    @Body() SyncMessageRequestEntity params,
  );
}
