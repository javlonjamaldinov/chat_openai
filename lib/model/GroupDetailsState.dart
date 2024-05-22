import 'package:chat_with_bisky/model/GroupAppwrite.dart';
import 'package:chat_with_bisky/model/GroupMemberAppwrite.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'GroupDetailsState.freezed.dart';

@Freezed(makeCollectionsUnmodifiable:false)
class GroupDetailsState with _$GroupDetailsState {
  factory GroupDetailsState({
    @Default('') String myUserId,
    @Default(false) bool loading,
    @Default(null) List<GroupMemberAppwrite>? members,
    @Default(null) GroupAppwrite? group,
    @Default(null) String? fileName,
    @Default(null) Uint8List? image,
  }) = _GroupDetailsState;
}
