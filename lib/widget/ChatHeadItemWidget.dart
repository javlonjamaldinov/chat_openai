import 'package:auto_route/auto_route.dart';
import 'package:chat_with_bisky/core/extensions/extensions.dart';
import 'package:chat_with_bisky/core/providers/ChatHeadRepositoryProvider.dart';
import 'package:chat_with_bisky/model/AttachmentType.dart';
import 'package:chat_with_bisky/model/ChatHeadState.dart';
import 'package:chat_with_bisky/model/MessageAppwrite.dart';
import 'package:chat_with_bisky/model/UserAppwrite.dart';
import 'package:chat_with_bisky/model/db/ChatRealm.dart';
import 'package:chat_with_bisky/route/app_route/AppRouter.gr.dart';
import 'package:chat_with_bisky/service/LocalStorageService.dart';
import 'package:chat_with_bisky/widget/ChatHeadViewModel.dart';
import 'package:chat_with_bisky/widget/friend_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChatHeadItemWidget extends ConsumerStatefulWidget {
  final ChatRealm chat;
  final String userId;
  const ChatHeadItemWidget({
    super.key,
    required this.chat,
    required this.userId,
  });
  @override
  _ChatHeadItemWidget createState() {

    return _ChatHeadItemWidget();
  }


}
class _ChatHeadItemWidget extends ConsumerState <ChatHeadItemWidget>{


  ChatHeadViewModel? notifier;
  ChatHeadState? model;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => initialization(context));
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    notifier = ref.read(chatHeadViewModelProvider.notifier);
    model = ref.watch(chatHeadViewModelProvider);
    bool isRead = widget.chat.read == true;

    return ListTile(
      leading: FriendImage(widget.chat.base64Image),
      title:  Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(widget.chat.displayName ?? "",
              maxLines: 1,
              style: style.labelSmall?.copyWith(fontSize: 13),
              overflow: TextOverflow.ellipsis,),
          ),
          if (model?.isTyping == true && widget.chat.senderUserId == model?.friendUserId)
            Text(
              ' ${'txt_typing'.tr}',
              style: style.labelSmall!.copyWith(
                  color: Colors.blue.shade600,
                  fontSize: 12
              ),
            ),
          const Spacer(flex: 2,),
          Text(widget.chat.sendDate!.getFormattedTime(), maxLines: 1,
            overflow: TextOverflow.ellipsis,style: style.labelSmall?.copyWith(fontSize: 10),),
        ],
      ),
      // subtitle: Text(friend.message ?? ""),
      subtitle: Row(
        children: [
          Expanded(
            child:  chatMessage(isRead),
          ),

          if(myMessage())
            Icon(widget.chat.read == true || widget.chat.delivered == true?
            Icons.done_all_rounded : Icons.done_rounded,
              size: 16,
              color: widget.chat.read == true? Colors.green.shade800:Colors.grey,),
          if (!isRead && !myMessage())
            const CircleAvatar(
              backgroundColor: Colors.orange,
              radius: 8,
              child: Text(
                '',
                style: TextStyle(
                  fontSize: 10,
                ),
              ),
            ),
        ],
      ),
      onTap: () async {
        String userId =
            await LocalStorageService.getString(
                LocalStorageService.userId) ??
                "";
        AutoRouter.of(context).push(MessageRoute(displayName: widget.chat.displayName ?? "",
            myUserId:userId,
            friendUserId:widget.chat.senderUserId ?? "",friendUser: UserAppwrite(userId: widget.chat.senderUserId,
                name: widget.chat.displayName),profilePicture: widget.chat.base64Image));
        ref.read(chatHeadRepositoryProvider).updateChatMessageRead(MessageAppwrite(receiverUserId: widget.chat.receiverUserId,senderUserId: widget.chat.senderUserId));

      },
    );
  }

  Widget chatMessage(bool isRead) {
    if (widget.chat.type == 'IMAGE') {
      return  Align(
        alignment: Alignment.topLeft,
        child: Row(
          children: [
            const Icon(Icons.image,color: Colors.blue),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text("txt_image".tr,style: const TextStyle(color: Colors.blue,fontSize: 12),),
            )
          ],
        ),
      );
    } else if (widget.chat.type == 'VIDEO') {
      return  Align(
        alignment: Alignment.topLeft,
        child: Row(
          children: [
            const Icon(Icons.video_chat,color: Colors.blue,),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text("txt_video".tr,style: const TextStyle(color: Colors.blue,fontSize: 12),),
            )
          ],
        ),
      );
    }else if (widget.chat.type == AttachmentType.sticker) {
      return  Align(
        alignment: Alignment.topLeft,
        child: Row(
          children: [
            const Icon(Icons.sticky_note_2,color: Colors.blue,),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text("txt_voice".tr,style: const TextStyle(color: Colors.blue,fontSize: 12),),
            )
          ],

        ),
      );
    }else if (widget.chat.type == AttachmentType.voice) {
      return Align(
        alignment: Alignment.topLeft,
        child: Row(
          children: [
            const Icon(Icons.voice_chat,color: Colors.blue,),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text("txt_sticker".tr,style: const TextStyle(color: Colors.blue,fontSize: 12),),
            )
          ],

        ),
      );
    } else {
    return  Text(
        widget.chat.message ?? "",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 12,
          fontWeight: !isRead && !myMessage() ? FontWeight.bold : null,
        ),
      );
    }
  }

  bool myMessage(){

    return widget.chat.userId == widget.userId;
  }

  initialization(BuildContext context) {

    notifier?.changedChatHead(widget.chat);
    notifier?.changedUserId(widget.userId);
    notifier?.listenFriendIsTyping();

  }
}
