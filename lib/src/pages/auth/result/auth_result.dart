import "package:freezed_annotation/freezed_annotation.dart";
import "package:greengrocer/src/models/user_model.dart";

part "auth_result.freezed.dart";

@freezed
abstract class AuthResult with _$AuthResult {
   factory AuthResult.success(UserModel user) = Success;
   factory AuthResult.error(String message) = Error;
}