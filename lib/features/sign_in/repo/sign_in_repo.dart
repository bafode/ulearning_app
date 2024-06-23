import 'package:ulearning_app/common/models/entities.dart';
import 'package:ulearning_app/common/services/http_util.dart';

class SignInRepo {
  static Future<UserLoginResponseEntity> login(
      {LoginRequestEntity? params}) async {
    var response =
        await HttpUtil().post("v1/auth/login", data: params?.toJson());
    return UserLoginResponseEntity.fromJson(response);
  }
}
