import 'dart:io';

import 'package:chat_with_bisky/constant/strings.dart';
import 'package:chat_with_bisky/core/providers/AppwriteAccountProvider.dart';
import 'package:chat_with_bisky/core/providers/ProfileRepositoryProvider.dart';
import 'package:chat_with_bisky/core/providers/StorageProvider.dart';
import 'package:chat_with_bisky/core/providers/UserRepositoryProvider.dart';
import 'package:chat_with_bisky/model/ProfileState.dart';
import 'package:chat_with_bisky/model/UserAppwrite.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'ProfileViewModel.g.dart';

@riverpod
class ProfileViewModel extends _$ProfileViewModel {

  ProfileRepositoryProvider get _profileRepositoryProvider =>
      ref.read(profileRepositoryProvider);

  UserDataRepositoryProvider get _userRepositoryProvider =>
      ref.read(userRepositoryProvider);

  StorageAppwriteProvider get _storageAppwriteProvider =>
      ref.read(storageAppwriteProvider);

  @override
  ProfileState build() {
    return ProfileState();
  }

  setUserId(String input) {
    state = state.copyWith(myUserId: input);
  }

  setLoading(bool input) {
    state = state.copyWith(loading: input);
  }

  setImageList(Uint8List? input) {
    state = state.copyWith(uint8list: input);
  }

  setImageFile(File? input) {
    state = state.copyWith(imageFile: input);
  }

  setImageUrl(String input) {
    state = state.copyWith(imageUrl: input);
  }

  setStorageId(String? input) {
    state = state.copyWith(profilePictureStorageId: input);
  }

  setImageExists(String? input) {
    state = state.copyWith(imageExist: input);
  }

  setUser(UserAppwrite? input) {
    state = state.copyWith(user: input);
    if (input != null && input.profilePictureStorageId != null) {
      setStorageId(input.profilePictureStorageId);
      setImageExists(input.profilePictureStorageId);
      getImageList();
    }
  }
  loader(bool input) {
    state = state.copyWith(loading: input);
  }

  getImageList() async {
    final list = await _profileRepositoryProvider
        .getExistingProfilePicture(state.profilePictureStorageId ?? "");
    setImageList(list);
  }

  Future<UserAppwrite?> uploadImageAndUpdateName(String name) async {
    loader(true);
    final user = state.user;
    UserAppwrite userAppwrite= UserAppwrite( userId: state.myUserId,name: name);
    if(user!= null){
      userAppwrite.profilePictureStorageId = user.profilePictureStorageId;
      userAppwrite.firebaseToken = user.firebaseToken;
    }
    if (state.imageFile != null) {
      if (state.imageExist != null) {
        await _storageAppwriteProvider.delete(
            state.imageExist ?? "", Strings.profilePicturesBucketId);
      }
      String imageId = const Uuid().v4();
      final file = await _storageAppwriteProvider.uploadMedia(
          imageId, state.imageFile!.path, Strings.profilePicturesBucketId);
      if (file != null) {
        userAppwrite.profilePictureStorageId = imageId;
      }
    }
    final result = await _userRepositoryProvider.updateUser(userAppwrite);
    loader(false);
    return result;
  }
}
