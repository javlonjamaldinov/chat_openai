import 'package:chat_with_bisky/model/MessageAppwrite.dart';
import 'package:chat_with_bisky/model/StoryAppwrite.dart';
import 'package:chat_with_bisky/model/UserAppwrite.dart';
import 'package:chat_with_bisky/model/db/ChatRealm.dart';
import 'package:chat_with_bisky/model/db/FriendContactRealm.dart';
import 'package:chat_with_bisky/model/db/MessageRealm.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'StoryState.freezed.dart';

@Freezed(makeCollectionsUnmodifiable:false)
class StoryState with _$StoryState {
  factory StoryState({
    @Default('') String myUserId,
    @Default('') String storageId,
    @Default('') String storyType,
    @Default(false) bool loading,
    @Default(null) List<FriendContactRealm>? friends,
    @Default(null) List<UserAppwrite>? seenFriends,
    @Default(null) List<StoryAppwrite>? myStories,
    @Default(null) Map<String,List<StoryAppwrite>>? friendsMapStories ,
  }) = _StoryState;
}
