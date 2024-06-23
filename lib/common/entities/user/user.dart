import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    String? id,
    String? firstname,
    String? lastname,
    String? email,
    String? avatar,
    String? gender,
    String? status,
    String? description,
    String? role,
    bool? isEmailVerified,
    bool? accountClosed,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
