import 'package:chat_with_bisky/model/GroupAppwrite.dart';
import 'package:chat_with_bisky/model/GroupUserModel.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'MyGroupsState.freezed.dart';

@Freezed(makeCollectionsUnmodifiable:false)
class MyGroupsState with _$MyGroupsState {
  factory MyGroupsState({
    @Default('') String myUserId,
    @Default(false) bool loading,
    @Default(null) List<GroupAppwrite>? groups,
  }) = _MyGroupsState;
}
