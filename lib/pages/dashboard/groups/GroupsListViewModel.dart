import 'package:chat_with_bisky/constant/strings.dart';
import 'package:chat_with_bisky/core/providers/GroupRepositoryProvider.dart';
import 'package:chat_with_bisky/core/providers/RealtimeNotifierProvider.dart';
import 'package:chat_with_bisky/model/GroupAppwrite.dart';
import 'package:chat_with_bisky/model/MyGroupsState.dart';
import 'package:chat_with_bisky/model/RealtimeNotifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'GroupsListViewModel.g.dart';
@riverpod
class GroupsListViewModel extends _$GroupsListViewModel{

  GroupRepositoryProvider get _groupRepositoryProvider => ref.read(groupRepositoryProvider);

  @override
  MyGroupsState build(){
    ref.keepAlive();
    _realtimeSynchronisation();
    return MyGroupsState();
  }

  setUserId(String userId){

    state = state.copyWith(myUserId: userId);
  }

  getMyGroups() async {
    List<GroupAppwrite> groups = await _groupRepositoryProvider.getMemberGroups(state.myUserId);

    if(state.groups == null){
      state = state.copyWith(groups: []);
    }
    state = state.copyWith(groups: groups);

  }

  void createOrUpdateChatHead(GroupAppwrite group,String type) {


    switch (type) {
      case RealtimeNotifier.create:
        state = state.copyWith(
            groups: [
              group,
              ...state.groups??[]
            ]
        );

        break;

      case RealtimeNotifier.update:

        state =  state.copyWith(
            groups:  state.groups?.map((e) => e.id == group.id ? group:e)
                .toList()
        );

        break;

      case RealtimeNotifier.delete:

        state =  state.copyWith(
            groups:  state.groups?.where((e) => e.id != group.id)
                .toList()
        );


        break;

      default:
        break;
    }

  }


  _realtimeSynchronisation() {
    ref.listen<RealtimeNotifier?>(
        realtimeNotifierProvider.select((value) => value.asData?.value), (
        previous, next) async {
      if (next?.document.$collectionId == Strings.collectionGroupId) {
        final group = GroupAppwrite.fromJson(next!.document.data);
        final groupMember =await _groupRepositoryProvider.getGroupMemberByUserId(group.id??"", state.myUserId);
        if (groupMember != null) {
          createOrUpdateChatHead(group, next.type);

        }
      }
    });
  }

}
