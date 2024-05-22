import 'package:chat_with_bisky/core/providers/UserRepositoryProvider.dart';
import 'package:chat_with_bisky/model/UserAppwrite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'GetUserProvider.g.dart';

@riverpod
Future<UserAppwrite?> getUser(GetUserRef ref,
    String id) async{

  ref.keepAlive();
  final userRepository = ref.read(userRepositoryProvider);
  final user = await userRepository.getUser(id);
  return user;
}
