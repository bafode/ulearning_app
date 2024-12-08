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
    String? phone,
    bool? online,
    String? open_id,
    String? authType,
    String? city,
    String? school,
    String? fieldOfStudy,
    String? levelOfStudy,
    List<String>? categories,
    List<String>? favorites,
    List<String>? followers,
    List<String>? following,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
