import 'package:chat_with_bisky/model/GroupAppwrite.dart';
import 'package:chat_with_bisky/model/GroupUserModel.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'CreateGroupState.freezed.dart';

@Freezed(makeCollectionsUnmodifiable:false)
class CreateGroupState with _$CreateGroupState {
  factory CreateGroupState({
    @Default('') String myUserId,
    @Default(false) bool loading,
    @Default(null) GroupAppwrite? group,
    @Default(null) List<GroupUserModel>? members,
    @Default(null) List<GroupUserModel>? allFriends,
  }) = _CreateGroupState;
}
