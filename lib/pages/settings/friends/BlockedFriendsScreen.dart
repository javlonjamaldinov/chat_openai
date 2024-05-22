import 'package:chat_with_bisky/core/extensions/extensions.dart';
import 'package:chat_with_bisky/localization/app_localization.dart';
import 'package:chat_with_bisky/main.dart';
import 'package:chat_with_bisky/model/AppLanguage.dart';
import 'package:chat_with_bisky/model/BlockedFriendAppwrite.dart';
import 'package:chat_with_bisky/model/FriendDetailState.dart';
import 'package:chat_with_bisky/pages/friend_details/FriendDetailsViewModel.dart';
import 'package:chat_with_bisky/service/LocalStorageService.dart';
import 'package:chat_with_bisky/widget/UserImageNameRowWidget.dart';
import 'package:chat_with_bisky/widget/UserImageNameWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BlockedFriendsScreen extends ConsumerStatefulWidget {
  const BlockedFriendsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _BlockedFriendsScreenState();
  }
}

class _BlockedFriendsScreenState extends ConsumerState<BlockedFriendsScreen> {
  FriendDetailsViewModel? _notifier;
  FriendDetailState? _state;

  @override
  Widget build(BuildContext context) {
    _notifier = ref.read(friendDetailsViewModelProvider.notifier);
    _state = ref.watch(friendDetailsViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('txt_blocked_users'.tr),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            _state?.blockedFriends?.isNotEmpty == true
                ? Expanded(
                    child: ListView.separated(
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          BlockedFriendAppwrite blockedFriendAppwrite =
                              _state!.blockedFriends![index];
                          return SwipeActionCell(
                            trailingActions: <SwipeAction>[
                              SwipeAction(
                                  title: "txt_unblock".tr,
                                  onTap: (CompletionHandler handler) async {
                                    await _notifier?.unBlockUserById(
                                        blockedFriendAppwrite.id ?? "");
                                    await handler(true);
                                    await _notifier?.getBlockedFriends();
                                  },
                                  color: Colors.red),
                            ],
                            key: ObjectKey(blockedFriendAppwrite.id ?? ""),
                            child: UserImageNameItemRowWidget(
                              userId: blockedFriendAppwrite.friendId,
                              onSelected: (value) {},
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            width: 1,
                          );
                        },
                        itemCount: _state?.blockedFriends?.length ?? 0))
                : Center(
                    child: Text("txt_empty_results".tr),
                  )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initialization());
  }

  Future<void> initialization() async {
    String? userId =
        await LocalStorageService.getString(LocalStorageService.userId);
    _notifier?.myUserIdChanged(userId ?? "");
    await _notifier?.getBlockedFriends();
  }
}
