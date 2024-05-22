import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:chat_with_bisky/core/providers/AppwriteAccountProvider.dart';
import 'package:chat_with_bisky/model/AuthenticationState.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'AuthViewModel.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  Account get _account => ref.read(appwriteAccountProvider);

  @override
  AuthenticationState build() {
    return AuthenticationState();
  }

  void phoneNumberChanged(String string) {
    state = state.copyWith(phoneNumber: string);
  }

  void setSecret(String string) {
    state = state.copyWith(secret: string);
  }

  void loader(bool input) {
    state = state.copyWith(loading: input);
  }

  Future<void> loginWithMobileNumber() async {
    try {
      state = state.copyWith(loading: true);

      String mobileNumber = state.phoneNumber;
      Token token = await _account.createPhoneSession(
        userId: mobileNumber.substring(1), //+32444444
        phone: mobileNumber,
      );

      state = state.copyWith(phoneNumber: mobileNumber.substring(1));
      state = state.copyWith(loading: false);
    } on AppwriteException catch (exception) {
      print(exception);

      state = state.copyWith(loading: false);

      return Future.error(exception.message ?? '${exception.code}');
    }
  }

  Future<bool> mobileNumberVerification() async {
    loader(true);
    try {
      await _account.updatePhoneSession(
        userId: state.phoneNumber,
        secret: state.secret,
      );
      await Future.delayed(const Duration(seconds: 3));
      loader(false);
      return true;
    } catch (exception) {
      print(exception);
    }
    loader(false);
    return false;
  }
}
