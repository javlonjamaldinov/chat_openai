import 'package:chat_with_bisky/core/providers/GroupMessagesInfoRepositoryProvider.dart';
import 'package:chat_with_bisky/model/GroupAppwrite.dart';
import 'package:chat_with_bisky/model/GroupMessageInfoAppwrite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'GetGroupMessageInfoProvider.g.dart';

@riverpod
Future<GroupMessageInfoAppwrite?> getGroupMessageInfo(
    GetGroupMessageInfoRef ref, GroupAppwrite group, String myUserId) async {
  ref.keepAlive();
  final groupMessagesInfoRepository =
  ref.read(groupMessagesInfoRepositoryProvider);
  final info = await groupMessagesInfoRepository.getOrCreateGroupMessageInfo(
      group.messageId ?? "", myUserId, group);
  return info;
}
