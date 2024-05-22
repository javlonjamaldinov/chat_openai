import 'package:chat_with_bisky/model/GroupAppwrite.dart';
import 'package:chat_with_bisky/model/GroupMemberAppwrite.dart';
import 'package:chat_with_bisky/model/GroupMessageInfoAppwrite.dart';
import 'package:chat_with_bisky/model/db/MessageRealm.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'GroupMessageDetailsState.freezed.dart';

@Freezed(makeCollectionsUnmodifiable:false)
class GroupMessageDetailsState with _$GroupMessageDetailsState {
  factory GroupMessageDetailsState({
    @Default('') String myUserId,
    @Default(false) bool loading,
    @Default(null) List<GroupMemberAppwrite>? members,
    @Default(null) List<GroupMessageInfoAppwrite>? deliveredToMembers,
    @Default(null) List<GroupMessageInfoAppwrite>? readsToMembers,
    @Default(null) GroupAppwrite? group,
    @Default(null) MessageRealm? message,
  }) = _GroupMessageDetailsState;
}
