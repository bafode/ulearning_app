import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../entities/user/user.dart';

part 'user_api.g.dart';

@RestApi()
abstract class UserApi {
  factory UserApi(Dio dio, {String baseUrl}) = _UserApi;

  @POST("/api/users/{followId}/follow")
  Future<User?> toggleUserFollow(@Path("followId") String followId);
}
