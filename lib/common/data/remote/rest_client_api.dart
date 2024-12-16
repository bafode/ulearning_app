import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ulearning_app/common/data/di/network_module.dart';
import 'package:ulearning_app/common/entities/auth/forgotPasswordRequest/forgot_password_request.dart';
import 'package:ulearning_app/common/entities/auth/loginRequest/login_request.dart';
import 'package:ulearning_app/common/entities/auth/loginResponse/login_response.dart';
import 'package:ulearning_app/common/entities/auth/logoutRequest/logout_request.dart';
import 'package:ulearning_app/common/entities/auth/logoutResponse/logout_response.dart';
import 'package:ulearning_app/common/entities/auth/registrationRequest/registration_request.dart';
import 'package:ulearning_app/common/entities/auth/registrationResponse/registration_response.dart';
import 'package:ulearning_app/common/entities/auth/resetPasswordRequest/reset_password_request.dart';
import 'package:ulearning_app/common/entities/auth/updateUserInfoRequest/update_user_info_request.dart';
import 'package:ulearning_app/common/entities/auth/verifyEmailRequest/verify_email_request.dart';
import 'package:ulearning_app/common/entities/post/createCommentRequest/create_comment_request.dart';
import 'package:ulearning_app/common/entities/post/createPostResponse/post_create_response.dart';
import 'package:ulearning_app/common/entities/post/postResponse/post_response.dart';
import 'package:ulearning_app/common/entities/user/user.dart';
import 'package:ulearning_app/common/utils/constants.dart';

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
    @Query("q") String? query,
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
    Future<User> updateUser({
      @Path("userId") required String userId,
      @Body() required UpdateUserInfoRequest updateUserInfoRequest,
    });

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

  @POST(AppConstants.postEndPointUrl)
  @MultiPart()
  Future<PostCreateResponse> createPost(
      @Part(name: 'title') String title,
      @Part(name: 'content') String content,
      @Part(name: 'category') String category,
      @Part(name: 'domain') List<String> domain,
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
}
