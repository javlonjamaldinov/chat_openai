import 'dart:io';

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:chat_with_bisky/constant/strings.dart';
import 'package:chat_with_bisky/core/extensions/extensions.dart';
import 'package:chat_with_bisky/core/providers/FileProvider.dart';
import 'package:chat_with_bisky/core/providers/FileTempProvider.dart';
import 'package:chat_with_bisky/core/providers/GetUserProvider.dart';
import 'package:chat_with_bisky/core/providers/GroupMessagesInfoRepositoryProvider.dart';
import 'package:chat_with_bisky/core/providers/MessageRepositoryProvider.dart';
import 'package:chat_with_bisky/core/providers/ThumbnailProvider.dart';
import 'package:chat_with_bisky/core/providers/UserRepositoryProvider.dart';
import 'package:chat_with_bisky/model/AttachmentType.dart';
import 'package:chat_with_bisky/model/UserAppwrite.dart';
import 'package:chat_with_bisky/model/db/MessageRealm.dart';
import 'package:chat_with_bisky/widget/AnimatedAttachment.dart';
import 'package:chat_with_bisky/widget/AsynWidget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:voice_message_package/voice_message_package.dart';

class GroupChatMessageItem extends HookConsumerWidget {
  final MessageRealm message;
  final bool myMessage;
  final String displayName;
  final String myUserId;
  ValueChanged<MessageRealm> messageLongPress;

  GroupChatMessageItem(
      {Key? key,
        required this.message,
        required this.myMessage,
        required this.displayName,
        required this.myUserId,
        required this.messageLongPress,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final theme = Theme.of(context);
    final style = theme.textTheme;



    useEffect((){

      if(!myMessage && message.read != true){

        ref.read(groupMessagesInfoRepositoryProvider).updateGroupMemberMessagesInfoSeen(message.receiverUserId??"",myUserId,message.messageIdUpstream??"");

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
      }else if (messageAppwrite.type == AttachmentType.video ||messageAppwrite.type == AttachmentType.image
          ||messageAppwrite.type == AttachmentType.voice) {
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
      }else{

        return const SizedBox();
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
                      if(!myMessage) Consumer(builder: (context, ref, child) {
                        final userAsync = ref.watch(getUserProvider((message.senderUserId??"")));
                        return userAsync.when(
                          data: (user) => userDetail(user, message),
                          error: (error, stackTrace) {
                            return Text(message.senderUserId ??"",style: const TextStyle(color: Colors.brown),);
                          },
                          loading: () =>
                          const SizedBox(width: 20, child: LinearProgressIndicator()),
                        );
                      },),
                      GestureDetector(onLongPress: () => messageLongPress(message),
                          child: messageWidget(snapshot))
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      );
    }

    return Padding(
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

                    Padding(padding: const EdgeInsets.all(4),
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
            )));
  }
  Future<File> getFile(String path)async {

    return File(path);
  }
  userDetail(UserAppwrite? user, MessageRealm message) {
    if(user != null){
      return Consumer(builder: (context, ref, child) {
        final fileAsync = ref.watch(fileTempProvider(Strings.profilePicturesBucketId,user.profilePictureStorageId??""));
        return fileAsync.when(
          data: (file) => memberProfilePicture(file,user),
          error: (error, stackTrace) {
            return Text(user.name ?? message.senderUserId ??"",style: const TextStyle(color: Colors.brown),);
          },
          loading: () =>
          const SizedBox(width: 20, child: LinearProgressIndicator()),
        );
      });
    }
    return const SizedBox();
  }

  memberProfilePicture(File file, UserAppwrite user) {

    Uint8List uint8list = Uint8List.fromList(file.readAsBytesSync());
    return Row(
      children: [
        CircleAvatar(
            backgroundImage: MemoryImage(uint8list)
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(user.name ?? message.senderUserId ??"",style: const TextStyle(color: Colors.orange,fontWeight: FontWeight.bold),),
        ),
      ],
    );
  }


}

