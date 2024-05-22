import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:chat_with_bisky/constant/strings.dart';
import 'package:chat_with_bisky/core/extensions/extensions.dart';
import 'package:chat_with_bisky/core/providers/FileTempProvider.dart';
import 'package:chat_with_bisky/model/FriendDetailState.dart';
import 'package:chat_with_bisky/model/GroupAppwrite.dart';
import 'package:chat_with_bisky/model/GroupDetailsState.dart';
import 'package:chat_with_bisky/model/GroupMemberAppwrite.dart';
import 'package:chat_with_bisky/pages/dashboard/groups/details/GroupDetailsViewModel.dart';
import 'package:chat_with_bisky/pages/friend_details/FriendDetailsViewModel.dart';
import 'package:chat_with_bisky/widget/GroupMemberTileWidget.dart';
import 'package:chat_with_bisky/widget/UserImage.dart';
import 'package:chat_with_bisky/widget/custom_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

@RoutePage()
class FriendDetailsScreen extends ConsumerStatefulWidget {
  final String friendId;
  final String myUserId;
  final String name;

  const FriendDetailsScreen(
      {super.key,
      required this.friendId,
      required this.myUserId,
      required this.name});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _FriendDetailsScreenState();
  }
}

class _FriendDetailsScreenState extends ConsumerState<FriendDetailsScreen> {
  FriendDetailsViewModel? _notifier;
  FriendDetailState? _state;

  @override
  Widget build(BuildContext context) {
    _notifier = ref.read(friendDetailsViewModelProvider.notifier);
    _state = ref.watch(friendDetailsViewModelProvider);
    return Scaffold(
      appBar: AppBar(title: Text(widget.name ?? "")),
      body: SizedBox(
        width: MediaQuery.of(context).size.width, // added
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // friend image
            UserImage(widget.friendId,radius: 80),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('txt_name'.tr,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                      Text(widget.name)
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('txt_mobile_number'.tr,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                      Text(widget.friendId)
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            if(_state?.friendBlocked == false)
            ElevatedButton(
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.red)),
              onPressed: () {
                ChatDialogs.confirmDialog(context, (value) async {
                  if (value) {
                    final isDeleted = await _notifier?.blockUser();

                    if (isDeleted == true) {
                      showMessage('txt_user_has_been_blocked'.tr);
                    }
                  }
                },
                    title: 'txt_block_user'.tr,
                    description: 'txt_are_you_sure'.tr,
                    type: AlertType.warning);
              },
              child: Text('txt_block'.tr),
            ),

            if(_state?.friendBlocked == true)
              ElevatedButton(
                style: ButtonStyle(
                    foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.red)),
                onPressed: () {
                  ChatDialogs.confirmDialog(context, (value) async {
                    if (value) {
                      final isDeleted = await _notifier?.unBlockUser();

                      if (isDeleted == true) {
                        showMessage('txt_user_has_been_unblocked'.tr);
                      }
                    }
                  },
                      title: 'txt_unblock_user'.tr,
                      description: 'txt_are_you_sure'.tr,
                      type: AlertType.warning);
                },
                child: Text('txt_unblock'.tr),
              ),
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
    _notifier?.myUserIdChanged(widget.myUserId);
    _notifier?.friendUserIdChanged(widget.friendId);
    _notifier?.getFriendDetails();
    _notifier?.isFriendBlocked();

  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }


  showMessage(String message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:  Text(message),
        action: SnackBarAction(
          label: 'txt_action'.tr,
          onPressed: () {
            // Code to execute.
          },
        ),
      ),
    );
  }
}
