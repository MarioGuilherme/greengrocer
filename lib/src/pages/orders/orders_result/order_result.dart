import "package:freezed_annotation/freezed_annotation.dart";

part "order_result.freezed.dart";

@freezed
class OrderResult<T> with _$OrderResult<T> {
  factory OrderResult.success(T data) = Success<T>;
  factory OrderResult.error(String message) = Error<T>;
}