import 'package:chat_with_bisky/core/providers/GroupMessagesInfoRepositoryProvider.dart';
import 'package:chat_with_bisky/core/providers/GroupRepositoryProvider.dart';
import 'package:chat_with_bisky/model/GroupAppwrite.dart';
import 'package:chat_with_bisky/model/GroupMemberAppwrite.dart';
import 'package:chat_with_bisky/model/GroupMessageDetailsState.dart';
import 'package:chat_with_bisky/model/GroupMessageInfoAppwrite.dart';
import 'package:chat_with_bisky/model/db/MessageRealm.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'GroupMessageDetailViewModel.g.dart';

@riverpod
class GroupMessageDetailViewModel extends _$GroupMessageDetailViewModel{

  GroupRepositoryProvider get _groupRepositoryProvider => ref.read(groupRepositoryProvider);
  GroupMessagesInfoRepositoryProvider get _groupMessagesInfoRepositoryProvider => ref.read(groupMessagesInfoRepositoryProvider);

  @override
  GroupMessageDetailsState build(){

    return GroupMessageDetailsState();
  }

  setUserId(String userId){

    state = state.copyWith(myUserId: userId);
  }

  setGroup(GroupAppwrite group) async {
    state = state.copyWith(group: group);

  }
  setMessage(MessageRealm messageRealm) async {
    state = state.copyWith(message: messageRealm);

  }
  getGroupMembers(String groupId) async {
    List<GroupMemberAppwrite> members = await _groupRepositoryProvider.getGroupMembers(groupId);
    if(members.isNotEmpty){
      setGroupMembers(members);
    }
  }

  setGroupMembers(List<GroupMemberAppwrite> members) async {
    state = state.copyWith(members: members);
  }

  loader(bool isLoading){
    state = state.copyWith(loading: isLoading);
  }

  getMessageDeliveredMembers() async {

    List<GroupMessageInfoAppwrite> deliveredToMembers = await _groupMessagesInfoRepositoryProvider.getGroupMessageDelivered(state.message?.messageIdUpstream??"");
    state = state.copyWith(deliveredToMembers: deliveredToMembers);
  }

  getMessageReadsMembers() async {

    List<GroupMessageInfoAppwrite> readsToMembers = await _groupMessagesInfoRepositoryProvider.getGroupMessageReads(state.message?.messageIdUpstream??"");
    state = state.copyWith(readsToMembers: readsToMembers);
  }


}
