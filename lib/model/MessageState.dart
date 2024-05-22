import 'package:appwrite/models.dart';
import 'package:chat_with_bisky/model/MessageAppwrite.dart';
import 'package:chat_with_bisky/model/db/MessageRealm.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'MessageState.freezed.dart';

@Freezed(makeCollectionsUnmodifiable:false)
class MessageState with _$MessageState {
  factory MessageState({
    @Default('') String myUserId,
    @Default('') String friendUserId,
    @Default('') String message,
    @Default('') String messageType,
    @Default(false) bool loading,
    @Default([]) List<MessageRealm> messages,
    @Default(null) File? file,
    @Default('') String onlineStatus,
    @Default(false) bool? recording,


  }) = _MessageState;
}
