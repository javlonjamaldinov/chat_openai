import 'package:chat_with_bisky/core/extensions/extensions.dart';
import 'package:chat_with_bisky/core/providers/GroupRepositoryProvider.dart';
import 'package:chat_with_bisky/core/providers/RealmProvider.dart';
import 'package:chat_with_bisky/model/CreateGroupState.dart';
import 'package:chat_with_bisky/model/GroupAppwrite.dart';
import 'package:chat_with_bisky/model/GroupUserModel.dart';
import 'package:chat_with_bisky/model/db/ChatRealm.dart';
import 'package:chat_with_bisky/model/db/FriendContactRealm.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'CreateGroupViewModel.g.dart';
@riverpod
class CreateGroupViewModel extends _$CreateGroupViewModel{
  RealmRepositoryProvider get _realmRepositoryProvider => ref.read(realmRepositoryProvider);
  GroupRepositoryProvider get _groupRepositoryProvider => ref.read(groupRepositoryProvider);
  ValueChanged<bool>? onGroupCreated;
  @override
  CreateGroupState build(){

    return  CreateGroupState();
  }


  void userIdChanged(String userId) {

    state = state.copyWith(myUserId: userId);
  }


  void groupNameChanged(String groupName) {

    state = state.copyWith(group: GroupAppwrite(name: groupName));
  }


  void selectUserChanged(GroupUserModel userModel, bool isAdd) {

    List<GroupUserModel>? members = state.members;
    members ??= [];
    if(isAdd){
      members.add(userModel);
      state = state.copyWith(members: members);
    }else{
      state = state.copyWith(
          members:
          state.members?.where((e) => e.memberUserId != userModel.memberUserId).toList());
    }
  }

  getAllFriends(){

    List<ChatRealm> chats =  _realmRepositoryProvider.getMyChats(state.myUserId);
    List<GroupUserModel> allFriends = [];
    Set<String> mobileNumbers = {};
    if(chats.isNotEmpty){

      for (var element in chats) {

        if(!mobileNumbers.contains(element.senderUserId) && element.senderUserId!= state.myUserId){
          mobileNumbers.add(element.senderUserId??"");
          GroupUserModel user = GroupUserModel(memberUserId: element.senderUserId,base64Image: element.base64Image,name: element.displayName);
          allFriends.add(user);
        }
      }
    }

    List<FriendContactRealm> friends =  _realmRepositoryProvider.getMyFriends(state.myUserId);
    if(friends.isNotEmpty){

      for (var element in friends) {

        if(!mobileNumbers.contains(element.mobileNumber) && element.mobileNumber != state.myUserId){
          mobileNumbers.add(element.mobileNumber??"");
          GroupUserModel user = GroupUserModel(memberUserId: element.mobileNumber,base64Image: element.base64Image,name: element.displayName);
          allFriends.add(user);
        }
      }
    }
    state = state.copyWith(allFriends:allFriends);
  }


  createGroup() async{

    final group = GroupAppwrite(message: "txt_new_group_created".tr,name: state.group?.name,delivered: false,read: false,messageType: 'newGroup',createdDate: DateTime.now(),sendDate: DateTime.now());
    loader(true);
    bool success = await _groupRepositoryProvider.createGroup(group, state.members?? []) ?? false;
    loader(false);
    if(success == true){
      onGroupCreated!(true);
    }

  }

  loader(bool load){
    state = state.copyWith(loading:load);
  }

}
