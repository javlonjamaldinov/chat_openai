import 'package:chat_with_bisky/core/providers/GroupRepositoryProvider.dart';
import 'package:chat_with_bisky/core/providers/ProfileRepositoryProvider.dart';
import 'package:chat_with_bisky/model/GroupAppwrite.dart';
import 'package:chat_with_bisky/model/GroupDetailsState.dart';
import 'package:chat_with_bisky/model/GroupMemberAppwrite.dart';
import 'package:flutter/services.dart';
import 'package:realm/realm.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'GroupDetailsViewModel.g.dart';

@riverpod
class GroupDetailsViewModel extends _$GroupDetailsViewModel{

  GroupRepositoryProvider get _groupRepositoryProvider => ref.read(groupRepositoryProvider);
  ProfileRepositoryProvider get _profileRepositoryProvider => ref.read(profileRepositoryProvider);

  @override
  GroupDetailsState build(){

    return GroupDetailsState();
  }

  setUserId(String userId){

    state = state.copyWith(myUserId: userId);
  }

  setGroup(GroupAppwrite group) async {
    state = state.copyWith(group: group,
        fileName:group.pictureStorageId);

  }
  getGroupMembers(String groupId) async {
    loader(true);
    List<GroupMemberAppwrite> members = await _groupRepositoryProvider.getGroupMembers(groupId);
    loader(false);
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


  getGroupImage() async {
    if(state.group?.pictureStorageId != null){
      Uint8List? image =await _profileRepositoryProvider.getExistingProfilePicture(state.group!.pictureStorageId!);
      if(image!= null){
        state = state.copyWith(image:image);
      }
    }
  }

  Future<bool> uploadGroupProfilePicture(String path) async {

    String id=ObjectId().hexString;
    bool isUploaded =await _profileRepositoryProvider.uploadGroupProfilePicture(state.fileName,id,path);
    if(isUploaded == true){
      await _groupRepositoryProvider.updateGroupProfilePicture(state.group!,id);
      GroupAppwrite? group =await _groupRepositoryProvider.getGroup(state.group?.id??"");
      if(group!=null){
        setGroup(group);
        getGroupImage();
        return true;
      }
    }else{
      // todo show error
    }

    return false;
  }




  Future<bool> exitGroup() async {
    loader(true);
    final isDeleted = await  _groupRepositoryProvider.deleteMemberByUserId(state.group?.id??"", state.myUserId);
    loader(false);
   return isDeleted;


  }

  Future<bool> removeMember(GroupMemberAppwrite groupMemberAppwrite) async {
    loader(true);
    final isDeleted = await  _groupRepositoryProvider.deleteMemberByUserId(state.group?.id??"", groupMemberAppwrite.memberUserId??"");

    if(isDeleted == true){
      getGroupMembers(state.group!.id!);
    }
    loader(false);
    return isDeleted;


  }


}
