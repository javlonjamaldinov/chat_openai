import 'package:appwrite/models.dart';
import 'package:chat_with_bisky/model/GroupAppwrite.dart';
import 'package:chat_with_bisky/model/MessageAppwrite.dart';
import 'package:chat_with_bisky/model/UserAppwrite.dart';
import 'package:chat_with_bisky/model/db/MessageRealm.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'GroupMessageState.freezed.dart';

@Freezed(makeCollectionsUnmodifiable:false)
class GroupMessageState with _$GroupMessageState {
  factory GroupMessageState({
    @Default('') String myUserId,
    @Default('') String message,
    @Default('') String messageType,
    @Default(false) bool loading,
    @Default(null) List<MessageRealm>? messages,
    @Default(null) File? file,
    @Default('') String groupDetails,
    @Default('') String groupId,
    @Default(null) GroupAppwrite? group,
    @Default(null) UserAppwrite? user,
    @Default(false) bool? recording,

  }) = _GroupMessageState;
}
