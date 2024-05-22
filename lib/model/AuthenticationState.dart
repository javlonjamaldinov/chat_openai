import 'package:freezed_annotation/freezed_annotation.dart';

part 'AuthenticationState.freezed.dart';

@freezed
class AuthenticationState with _$AuthenticationState {
  factory AuthenticationState({
    @Default('') String phoneNumber,
    @Default('') String secret,
    @Default(false) bool loading,
  }) = _AuthenticationState;
}
