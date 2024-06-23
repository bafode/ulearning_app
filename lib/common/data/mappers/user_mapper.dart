import 'package:ulearning_app/common/data/domain/user.dart';
import 'package:ulearning_app/common/data/remote/models/login.dart';

extension UserMapper on UserG {
  User toDomain() => User(
        firstname: firstname,
        lastname: lastname,
        email: email,
        avatar: avatar,
        description: description,
        role: role,
        isEmailVerified: isEmailVerified,
        accountClosed: accountClosed,
        id: id,
      );
}

extension TokensMapper on TokensG {
  Tokens toDomain() => Tokens(
        access: access.toDomain(),
        refresh: refresh.toDomain(),
      );
}

extension AccessTokenMapper on AccessTokenG {
  AccessToken toDomain() => AccessToken(
        token: token,
        expires: expires,
      );
}

extension RefreshTokenMapper on RefreshTokenG {
  RefreshToken toDomain() => RefreshToken(
        token: token,
        expires: expires,
      );
}
