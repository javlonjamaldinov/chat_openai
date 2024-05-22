import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:chat_with_bisky/constant/strings.dart';
import 'package:chat_with_bisky/core/extensions/extensions.dart';
import 'package:chat_with_bisky/core/providers/FileTempProvider.dart';
import 'package:chat_with_bisky/core/providers/GetUserProvider.dart';
import 'package:chat_with_bisky/model/AttachmentType.dart';
import 'package:chat_with_bisky/model/GroupAppwrite.dart';
import 'package:chat_with_bisky/model/GroupDetailsState.dart';
import 'package:chat_with_bisky/model/GroupMemberAppwrite.dart';
import 'package:chat_with_bisky/model/GroupMessageDetailsState.dart';
import 'package:chat_with_bisky/model/GroupMessageInfoAppwrite.dart';
import 'package:chat_with_bisky/model/db/MessageRealm.dart';
import 'package:chat_with_bisky/pages/dashboard/groups/details/GroupDetailsViewModel.dart';
import 'package:chat_with_bisky/pages/dashboard/groups/messages/details/GroupMessageDetailViewModel.dart';
import 'package:chat_with_bisky/widget/GroupMemberTileWidget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

@RoutePage()
class GroupMessageDetailsScreen extends ConsumerStatefulWidget {
  final GroupAppwrite group;
  final MessageRealm message;
  final String myUserId;

  const GroupMessageDetailsScreen(
      {super.key,
        required this.group,
        required this.myUserId,
        required this.message});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _GroupMessageDetailsScreenState();
  }
}

class _GroupMessageDetailsScreenState
    extends ConsumerState<GroupMessageDetailsScreen> {
  GroupMessageDetailViewModel? _notifier;
  GroupMessageDetailsState? _state;

  @override
  Widget build(BuildContext context) {
    _notifier = ref.read(groupMessageDetailViewModelProvider.notifier);
    _state = ref.watch(groupMessageDetailViewModelProvider);
    return Scaffold(
      appBar: AppBar(title: Text(widget.group.name ?? "")),
      body: SizedBox(
        width: MediaQuery.of(context).size.width, // added
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            messageDetails(),
             Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('txt_read_by'.tr,style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.blue)),
            ),
             (_state?.readsToMembers?.isNotEmpty == true)?
              Expanded(
                  child: ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        GroupMessageInfoAppwrite groupMessageInfoAppwrite =
                        _state!.readsToMembers![index];
                        return memberWidget(groupMessageInfoAppwrite);
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          width: 1,
                        );
                      },
                      itemCount: _state?.readsToMembers?.length ?? 0))
            :Padding(
               padding: const EdgeInsets.all(8.0),
               child: Text('txt_no_one'.tr,style: const TextStyle(color: Colors.black)),
             ),
             Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('txt_delivered_to'.tr,style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.orange)),
            ),
             (_state?.deliveredToMembers?.isNotEmpty == true)?
              Expanded(
                  child: ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        GroupMessageInfoAppwrite groupMessageInfoAppwrite =
                        _state!.deliveredToMembers![index];
                        return memberWidget(groupMessageInfoAppwrite);
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          width: 1,
                        );
                      },
                      itemCount: _state?.deliveredToMembers?.length ?? 0))
                 : Padding(
               padding: const EdgeInsets.all(8.0),
               child: Text('txt_no_one'.tr,style: const TextStyle(color: Colors.black)),
             )
          ],
        ),
      ),
    );
  }

  messageDetails() {
    return SizedBox(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                 Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('txt_type'.tr,style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      AttachmentType.messageType(_state?.message?.type ?? '')),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                 Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('txt_message'.tr,style: const TextStyle(fontWeight: FontWeight.bold),),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: getMessage(_state?.message),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  memberWidget(GroupMessageInfoAppwrite groupMessageInfoAppwrite) {
    return Consumer(
      builder: (context, ref, child) {
        final userAsync = ref
            .read(GetUserProvider(groupMessageInfoAppwrite.memberUserId ?? ""));

        return userAsync.when(
          data: (user) {
            if (user != null) {
              return GroupMemberTileWidget(
                  GroupMemberAppwrite(
                      name: user.name, memberUserId: user.userId),
                  _state?.myUserId ?? "");
            }

            return const SizedBox();
          },
          error: (error, stackTrace) {
            print(stackTrace);
            return const SizedBox();
          },
          loading: () =>
          const SizedBox(width: 20, child: LinearProgressIndicator()),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initialization());
  }

  Future<void> initialization() async {
    _notifier?.setUserId(widget.myUserId);
    _notifier?.setGroup(widget.group);
    _notifier?.setMessage(widget.message);
    _notifier?.getGroupMembers(widget.group.id ?? "");
    _notifier?.getMessageDeliveredMembers();
    _notifier?.getMessageReadsMembers();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  getMessage(MessageRealm? message) {
    if (message == null) {
      return const SizedBox();
    }
    if (AttachmentType.text == message.type) {
      return Text(
        message.message ?? "",
        overflow: TextOverflow.ellipsis,
      );
    } else if (AttachmentType.image == message.type) {
      return const Icon(
        Icons.image,
        color: Colors.grey,
      );
    } else if (AttachmentType.video == message.type) {
      return const Icon(
        Icons.video_call,
        color: Colors.grey,
      );
    } else if (AttachmentType.voice == message.type) {
      return const Icon(
        Icons.keyboard_voice,
        color: Colors.grey,
      );
    }
    return const SizedBox();
  }
}
