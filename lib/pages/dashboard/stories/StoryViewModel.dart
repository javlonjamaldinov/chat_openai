
import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:chat_with_bisky/constant/strings.dart';
import 'package:chat_with_bisky/core/providers/FileTempProvider.dart';
import 'package:chat_with_bisky/core/providers/RealmProvider.dart';
import 'package:chat_with_bisky/core/providers/StorageProvider.dart';
import 'package:chat_with_bisky/core/providers/StoryRepositoryProvider.dart';
import 'package:chat_with_bisky/core/providers/UserRepositoryProvider.dart';
import 'package:chat_with_bisky/model/AttachmentType.dart';
import 'package:chat_with_bisky/model/StoryAppwrite.dart';
import 'package:chat_with_bisky/model/StoryState.dart';
import 'package:chat_with_bisky/model/UserAppwrite.dart';
import 'package:chat_with_bisky/model/db/FriendContactRealm.dart';
import 'package:chat_with_bisky/pages/dashboard/stories/StoriesViewScreen.dart';
import 'package:chat_with_bisky/widget/StoryViewFileImageWidget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import "package:story_view/story_view.dart";
part 'StoryViewModel.g.dart';
@riverpod
class StoryViewModel extends _$StoryViewModel{

  StoryRepositoryProvider get _storyRepositoryProvider => ref.read(storyRepositoryProvider);
  RealmRepositoryProvider get _realmRepositoryProvider => ref.read(realmRepositoryProvider);
  UserDataRepositoryProvider get _userRepositoryProvider => ref.read(userRepositoryProvider);

  Storage get _storage => ref.read(storageProvider);

  @override
  StoryState build(){

    return StoryState();
  }


  setMyUserId(String input){
    state = state.copyWith(myUserId: input);
  }

  setStorageId(String input){
    state = state.copyWith(storageId: input);
  }

  setStoryType(String input){
    state = state.copyWith(storyType: input);
  }

  setFriends(List<FriendContactRealm> input){
    state = state.copyWith(friends: input);
  }
  setFriendsStories(Map<String,List<StoryAppwrite>>? input){
    state = state.copyWith(friendsMapStories: input);
  }
  setMyStories(List<StoryAppwrite> input){
    state = state.copyWith(myStories: input);
  }

  setSeenFriends(List<UserAppwrite> input){
    state = state.copyWith(seenFriends: input);
  }

  Future<bool>saveStory(model.File? file) async{

    if(file != null) {
      setStorageId(file.$id);
    }

    List<FriendContactRealm> friends =  _realmRepositoryProvider.getMyFriends(state.myUserId);
    if(friends.isNotEmpty){
      friends = friends.where((i) => i.mobileNumber != state.myUserId).toList();
      setFriends(friends);
    }


    final result = await _storyRepositoryProvider.createStory(state);
    getStories();
    return result;
  }


  Future<model.File?> uploadStoryMedia(String imageId, String filePath) async {
    try {
      state = state.copyWith(loading: true);
      model.File file = await _storage.createFile(
          bucketId: Strings.messagesBucketId,
          fileId: imageId,
          file: InputFile(
              path: filePath,
              filename: '$imageId${getFileExtension(filePath)}'));
      state = state.copyWith(loading: false);

      return file;
    } catch (e) {
      state = state.copyWith(loading: false);
      print(e);
    }
    return null;
  }


  String getFileExtension(String filePath) {
    try {
      return '.${filePath.split('.').last}';
    } catch (e) {
      print(e);
      return "";
    }
  }

  void getStories() async{

    final myStories = await _storyRepositoryProvider.getMyStories(state.myUserId);
    final friendStories = await _storyRepositoryProvider.getStoriesFromFriends(state.myUserId);
    setMyStories(myStories);
    if(friendStories.isNotEmpty){
      Map<String,List<StoryAppwrite>> friendsMap = {};
      Set<String> friendsIdSet = {};
      for(StoryAppwrite story in friendStories){
        final friendId = story.friendId??"N/A";
        if(friendsIdSet.contains(friendId)){
          friendsMap[friendId]?.add(story);
        }else{
          friendsIdSet.add(friendId);
          friendsMap[friendId] =  [story];
        }
      }
      setFriendsStories(friendsMap);
    }
  }

  Future<List<StoryItem>>mapToViewStories(List<StoryAppwrite> stories,StoryController controller) async{

    List<StoryItem> storyItems = [];
    if(stories.isNotEmpty){
      for(StoryAppwrite story in stories){
        if(story.storyType == AttachmentType.image){
          storyItems.add(customStoryViewImage(storageId: story.storageId??"",story: story));
        }
      }
    }
    return storyItems;
  }

  Future<List<UserAppwrite>> getSeenStories() async{
    List<UserAppwrite> users = [];
    var seenStories = await _storyRepositoryProvider.getSeenFromFriends(state.myUserId,state.storageId);
    if(seenStories.isNotEmpty){

      seenStories = seenStories.where((i) => i.friendId != state.myUserId).toList();
      for(StoryAppwrite story in seenStories){
        final user =await _userRepositoryProvider.getUser(story.friendId ??"");
        if(user != null){
          users.add(user);
        }
      }
      setSeenFriends(users);
    }
    return users;
  }

  deleteStory(String id)  async{

    return await _storyRepositoryProvider.deleteAllStories(id);
  }

}