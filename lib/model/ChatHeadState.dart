import 'package:chat_with_bisky/model/MessageAppwrite.dart';
import 'package:chat_with_bisky/model/db/ChatRealm.dart';
import 'package:chat_with_bisky/model/db/MessageRealm.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ChatHeadState.freezed.dart';

@Freezed(makeCollectionsUnmodifiable:false)
class ChatHeadState with _$ChatHeadState {
  factory ChatHeadState({
    @Default('') String myUserId,
    @Default(null) ChatRealm? chat,
    @Default(false) bool myMessage,
    @Default(false) bool isTyping,
    @Default(null) String? friendUserId,

  }) = _ChatHeadState;
}
