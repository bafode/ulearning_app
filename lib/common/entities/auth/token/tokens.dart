import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ulearning_app/common/entities/auth/token/token.dart';
part 'tokens.freezed.dart';
part 'tokens.g.dart';

@freezed
class Tokens with _$Tokens {
  const factory Tokens({
    required Token access,
    required Token refresh,
  }) = _Tokens;

  factory Tokens.fromJson(Map<String, Object?> json) => _$TokensFromJson(json);
}
