import 'dart:io';

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:chat_with_bisky/constant/strings.dart';
import 'package:chat_with_bisky/core/extensions/extensions.dart';
import 'package:chat_with_bisky/core/providers/AssetFileProvider.dart';
import 'package:chat_with_bisky/core/providers/FileProvider.dart';
import 'package:chat_with_bisky/core/providers/MessageRepositoryProvider.dart';
import 'package:chat_with_bisky/core/providers/RealmProvider.dart';
import 'package:chat_with_bisky/core/providers/ThumbnailProvider.dart';
import 'package:chat_with_bisky/model/AttachmentType.dart';
import 'package:chat_with_bisky/model/db/MessageRealm.dart';
import 'package:chat_with_bisky/widget/AnimatedAttachment.dart';
import 'package:chat_with_bisky/widget/AsynWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chat_with_bisky/model/MessageAppwrite.dart';
import 'package:voice_message_package/voice_message_package.dart';

class ChatMessageItem extends HookConsumerWidget {
  final MessageRealm message;
  final bool myMessage;
  final String displayName;

  const ChatMessageItem(
      {Key? key,
      required this.message,
      required this.myMessage,
      required this.displayName})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final theme = Theme.of(context);
    final style = theme.textTheme;
    
    
    
    useEffect((){

      if(!myMessage && message.read != true){
        
        ref.read(messageRepositoryProvider).updateMessageSeen(message.messageIdUpstream?? "");
        
      }
      return null;
      
    });
    

    Widget fileView(File file, String type) {



      if (type == AttachmentType.voice) {
        return VoiceMessage(
          audioFile: getFile(file.path),
          played: false, // To show played badge or not.
          me: myMessage, // Set message side.
          onPlay: () {}, // Do something when voice played.
        );
      }
      return Stack(
        fit: StackFit.passthrough,
        children: [
          ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 0,
                maxHeight:
                    [AttachmentType.image, AttachmentType.video].contains(type)
                        ? double.infinity
                        : (context.media.size.width * 3 / 4),
              ),
              child: Stack(
                children: [
                  if (type == AttachmentType.video)
                  AsyncWidget(
                    value: ref.watch(thumbnailProvider(file.path)),
                    data: (data) => data != null
                        ? Stack(
                      fit: StackFit.passthrough,
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: BubbleNormalImage(
                            onTap: () =>  context.playVideo(file.path),

                            id: message.sendDate.toString(),
                            image: Image.file(
                              File(data),
                              fit: BoxFit.cover,
                            ),
                            color: myMessage?const Color(0xFF1B97F3):const Color(0xFFE8E8EE),
                            // tail: true,
                            isSender: myMessage,
                          ) ,
                        ),
                        const Icon(
                          Icons.play_arrow_rounded,
                          size: 40,
                          color: Colors.blue,
                        ),
                      ],
                    )
                        : const SizedBox(),
                  ),
                  if (type == AttachmentType.image)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child:  BubbleNormalImage(
                        onTap: () =>  context.openImage(file.path),
                        id: message.sendDate.toString(),
                        image: Image.file(
                          file,
                          fit: BoxFit.cover,
                        ),
                        color: myMessage?const Color(0xFF1B97F3):const Color(0xFFE8E8EE),
                        isSender: myMessage,
                      ) ,
                    )

                ],
              )),
        ],
      );
    }

    Widget messageWidget(MessageRealm messageAppwrite) {
      if (messageAppwrite.type == AttachmentType.text) {

        return BubbleNormal(
          text: messageAppwrite.message ?? "",
          isSender: myMessage,
          color: myMessage?const Color(0xFF1B97F3):const Color(0xFFE8E8EE),
          tail: true,
          textStyle: TextStyle(
            fontSize: 12,
            color:  myMessage?Colors.white:Colors.blue,
          ),
        );
      } else if (messageAppwrite.type == AttachmentType.sticker) {

        return Align(alignment:  myMessage? AlignmentDirectional.topEnd:AlignmentDirectional.topStart,
          child: Consumer(builder: (context, ref, child) {

            return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AnimatedAttachment(
              sticker: messageAppwrite.message ?? "",
            ),
          ); },),
        );
      }else {
        return Consumer(
          builder: (context, ref, child) {
            final fileAsync = ref.watch(fileProvider(Strings.messagesBucketId,
                messageAppwrite.message ?? "", messageAppwrite.fileName ?? ""));
            return fileAsync.when(
              data: (file) => fileView(file, messageAppwrite.type ?? ""),
              error: (error, stackTrace) {
                print(error);
                return Center(
                  child: Text('$error'),
                );
              },
              loading: () =>
                  const SizedBox(width: 20, child: LinearProgressIndicator()),
            );
          },
        );
      }
    }
    Widget buildChatLayout(MessageRealm snapshot) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment:
                  myMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      messageWidget(snapshot)
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      );
    }

    return SwipeActionCell(
      trailingActions: <SwipeAction>[
        SwipeAction(
            title: "txt_delete".tr,
            onTap: (CompletionHandler handler) async {
              final id =message.messageIdUpstream?? "";
              ref.read(messageRepositoryProvider).deleteMessage(id);
              await handler(true);
            },
            color: Colors.red),

      ],
      key: ObjectKey(message.messageIdUpstream),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(myMessage?0:16),
                topLeft: Radius.circular(myMessage?16:0),
                bottomLeft: const Radius.circular(16),
                bottomRight: const Radius.circular(16),

              ),
            ),
              child: Column(
                children: [
                  buildChatLayout(message),
                  Row(
                    mainAxisAlignment:
                    myMessage? MainAxisAlignment.end: MainAxisAlignment.start,

                    children: [
                      if(myMessage) const Spacer(),

                      Padding(padding: EdgeInsets.all(4),
                      child: Wrap(
                        alignment: WrapAlignment.end,
                        spacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.end,
                        children: [
                          Text(message.sendDate!.getFormattedTime(),
                          style: style.labelSmall!.copyWith(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.bold
                          ),),
                          if(myMessage)
                            Icon(message.read == true || message.delivered == true?
                            Icons.done_all_rounded : Icons.done_rounded,
                            size: 16,
                                color: message.read == true? Colors.green.shade800:Colors.grey,)
                        ],
                      ),
                      )
                    ],
                  )
                ],
              ))),
    );
  }

  Future<File> getFile(String path)async {

    return File(path);
  }
}
