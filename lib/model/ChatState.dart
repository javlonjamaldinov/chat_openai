import 'package:chat_with_bisky/model/MessageAppwrite.dart';
import 'package:chat_with_bisky/model/db/ChatRealm.dart';
import 'package:chat_with_bisky/model/db/MessageRealm.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ChatState.freezed.dart';

@Freezed(makeCollectionsUnmodifiable:false)
class ChatState with _$ChatState {
  factory ChatState({
    @Default('') String myUserId,
    @Default(false) bool loading,
    @Default([]) List<ChatRealm> chats,
  }) = _ChatState;
}
