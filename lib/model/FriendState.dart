import 'package:chat_with_bisky/model/MessageAppwrite.dart';
import 'package:chat_with_bisky/model/db/ChatRealm.dart';
import 'package:chat_with_bisky/model/db/FriendContactRealm.dart';
import 'package:chat_with_bisky/model/db/MessageRealm.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'FriendState.freezed.dart';

@Freezed(makeCollectionsUnmodifiable:false)
class FriendState with _$FriendState {
  factory FriendState({
    @Default('') String myUserId,
    @Default(false) bool loading,
    @Default([]) List<FriendContactRealm> friends,
  }) = _FriendState;
}
