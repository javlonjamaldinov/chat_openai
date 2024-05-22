import 'dart:io';

import 'package:chat_with_bisky/model/UserAppwrite.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ProfileState.freezed.dart';

@Freezed(makeCollectionsUnmodifiable:false)
class ProfileState with _$ProfileState {
  factory ProfileState({
    @Default('') String myUserId,
    @Default('https://www.w3schools.com/w3images/avatar3.png') String imageUrl,
    @Default(false) bool loading,
    @Default(null) Uint8List? uint8list,
    @Default(null) File? imageFile,
    @Default(null) String? profilePictureStorageId,
    @Default(null) String? imageExist,
    @Default(null) UserAppwrite? user,
  }) = _ProfileState;
}
