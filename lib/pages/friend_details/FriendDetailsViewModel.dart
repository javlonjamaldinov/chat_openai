import 'package:chat_with_bisky/core/providers/BlockedFriendsRepositoryProvider.dart';
import 'package:chat_with_bisky/core/providers/UserRepositoryProvider.dart';
import 'package:chat_with_bisky/model/BlockedFriendAppwrite.dart';
import 'package:chat_with_bisky/model/FriendDetailState.dart';
import 'package:chat_with_bisky/model/UserAppwrite.dart';
import 'package:realm/realm.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'FriendDetailsViewModel.g.dart';

@riverpod
class FriendDetailsViewModel extends _$FriendDetailsViewModel {
  BlockedFriendsRepositoryProvider get _blockedFriendsRepositoryProvider =>
      ref.read(blockedFriendsRepositoryProvider);

  UserDataRepositoryProvider get _userRepositoryProvider =>
      ref.read(userRepositoryProvider);

  FriendDetailState build() {
    return FriendDetailState();
  }

  void myUserIdChanged(String input) {
    state = state.copyWith(myUserId: input);
  }

  void friendUserIdChanged(String input) {
    state = state.copyWith(friendUserId: input);
  }

  void setFriendUserAppwrite(UserAppwrite? input) {
    state = state.copyWith(friendUserAppwrite: input);
  }

  void setFriendBlocked(bool input) {
    state = state.copyWith(friendBlocked: input);
  }

  void blockedFriendsChanged(List<BlockedFriendAppwrite>? blockedFriends) {
    state = state.copyWith(blockedFriends: blockedFriends);
  }

  getFriendDetails() async {
    final friend =
        await _userRepositoryProvider.getUser(state.friendUserId ?? "");
    setFriendUserAppwrite(friend);
  }

  isFriendBlocked() async {
    final listBlockedFriends = await _blockedFriendsRepositoryProvider
        .getBlockedFriendsByUserIdAndFriendId(
            state.myUserId ?? "", state.friendUserId ?? "");
    blockedFriendsChanged(listBlockedFriends);
    if (listBlockedFriends.isNotEmpty) {
      setFriendBlocked(true);
    } else {
      setFriendBlocked(false);
    }
  }

  Future<bool> blockUser() async {
    final request = BlockedFriendAppwrite(
        id: ObjectId().hexString,
        userId: state.myUserId,
        friendId: state.friendUserId);
    bool isBlocked = await _blockedFriendsRepositoryProvider.create(request);
    isFriendBlocked();
    return isBlocked;
  }

  Future<bool> unBlockUser() async {
    if (state.blockedFriends != null && state.blockedFriends!.isNotEmpty) {
      for (BlockedFriendAppwrite blockedFriendAppwrite
          in state.blockedFriends!) {
        await _blockedFriendsRepositoryProvider
            .deleteBlockedFriend(blockedFriendAppwrite.id ?? "");
      }
      isFriendBlocked();
      return true;
    }

    return false;
  }

  Future<List<BlockedFriendAppwrite>> getBlockedFriends() async {
    final listBlockedFriends = await _blockedFriendsRepositoryProvider
        .getBlockedFriendsByUserId(state.myUserId);
    blockedFriendsChanged(listBlockedFriends);
    return listBlockedFriends;
  }

  Future<bool> unBlockUserById(String id) async {
    await _blockedFriendsRepositoryProvider.deleteBlockedFriend(id ?? "");
    return true;
  }
}
