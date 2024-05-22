import 'package:chat_with_bisky/model/BlockedFriendAppwrite.dart';
import 'package:chat_with_bisky/model/UserAppwrite.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'FriendDetailState.freezed.dart';

@Freezed(makeCollectionsUnmodifiable:false)
class FriendDetailState with _$FriendDetailState {
  factory FriendDetailState({
    @Default('') String myUserId,
    @Default(null) String? friendUserId,
    @Default(null) UserAppwrite? friendUserAppwrite,
    @Default(null) List<BlockedFriendAppwrite>? blockedFriends,
    @Default(false) bool friendBlocked,

  }) = _FriendDetailState;
}
