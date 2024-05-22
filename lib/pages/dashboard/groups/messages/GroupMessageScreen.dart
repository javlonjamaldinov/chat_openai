import 'package:appwrite/models.dart';
import 'package:auto_route/auto_route.dart';
import 'package:chat_with_bisky/constant/strings.dart';
import 'package:chat_with_bisky/core/extensions/extensions.dart';
import 'package:chat_with_bisky/model/AttachmentType.dart';
import 'package:chat_with_bisky/model/GroupAppwrite.dart';
import 'package:chat_with_bisky/model/GroupMessageState.dart';
import 'package:chat_with_bisky/model/db/MessageRealm.dart';
import 'package:chat_with_bisky/pages/dashboard/groups/messages/GroupMessageViewModel.dart';
import 'package:chat_with_bisky/route/app_route/AppRouter.gr.dart';
import 'package:chat_with_bisky/widget/ChatHeadViewModel.dart';
import 'package:chat_with_bisky/widget/ChatStickerDialog.dart';
import 'package:chat_with_bisky/widget/DefaultTempImage.dart';
import 'package:chat_with_bisky/widget/GroupChatMessageItem.dart';
import 'package:chat_with_bisky/widget/LoadingPageOverlay.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:realm/realm.dart' as realm;
import 'package:record/record.dart';

@RoutePage()
class GroupMessageScreen extends ConsumerStatefulWidget {
  String displayGroupName;
  String myUserId;
  String friendUserId;
  GroupAppwrite group;
  String? profilePicture;

  GroupMessageScreen(
      {required this.displayGroupName,
        required this.myUserId,
        required this.friendUserId,
        required this.group,
        this.profilePicture});

  ConsumerState<GroupMessageScreen> createState() => _GroupMessageScreenState(
      displayName: displayGroupName, myUserId: myUserId, friendUserId: friendUserId
      ,profilePicture: profilePicture);
}

class _GroupMessageScreenState extends ConsumerState<GroupMessageScreen> {
  String displayName;
  String myUserId;
  String friendUserId;
  String? profilePicture;

  final TextEditingController _messageController = TextEditingController();
  GroupMessageNotifier? messageNotifier;
  GroupMessageState? messageState;
  final ScrollController _scrollController = ScrollController();
  String? recordFilePath;
  final record = Record();

  _GroupMessageScreenState(
      {required this.displayName,
        required this.myUserId,
        required this.friendUserId,
        this.profilePicture});

  @override
  Widget build(BuildContext context) {
    messageNotifier = ref.read(groupMessageNotifierProvider.notifier);
    messageState = ref.watch(groupMessageNotifierProvider);
    return LoadingPageOverlay(
      loading: messageState?.loading ?? false,
      child: FocusDetector(
        onFocusGained: () {

          messageNotifier?.updateGroupId(widget.group.id??'');
          messageNotifier?.myUserIdChanged(myUserId);
          messageNotifier?.getMyGroupProfile();
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            flexibleSpace: SafeArea(
              child: Container(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    DefaultTempImage(Strings.profilePicturesBucketId,widget.group.pictureStorageId,size: 50,),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          AutoRouter.of(context).push(GroupDetailsRoute(myUserId: messageState?.myUserId ??"", group: messageState?.group??GroupAppwrite()));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              displayName,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Expanded(
                              child: Text(
                                  messageState?.groupDetails ?? '',
                                  style: TextStyle(
                                      color:messageState?.groupDetails.contains('typing') == true?Colors.blue.shade600:Colors.grey.shade600, fontSize: 13)
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
          body: Form(
            child: Column(
              children: [
                messageState?.messages?.isNotEmpty == true?
                Flexible(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(10.0),
                      itemBuilder: (context, index) {
                        MessageRealm message =
                            messageState?.messages?.elementAt(index) ??
                                MessageRealm(realm.ObjectId());

                        return chatMessageItem(message);
                      },
                      itemCount: messageState?.messages?.length,
                      reverse: true,
                    )):Flexible(child: Container(),),
                chatInputWidget()
              ],
            ),
          ),
        ),
      ),
    );
  }


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) => initialization(context));
  }

  initialization(BuildContext context) {
    messageNotifier?.initializeMessages();
    messageNotifier?.listenFriendIsTyping();
    messageNotifier!.onNoProfileRetrieved = (value) {

      if(value== null){

        Navigator.pop(context);
      }


    };
    getMessages();
  }


  chatInputWidget() {


    return   Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          messageState?.recording == true
              ?const SizedBox():Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: InkWell(
              child: const Icon(
                Icons.sticky_note_2,
                color: Colors.pink,
                size: 24,
              ),
              onTap: () {
                _showStickerModal();
              },
            ),
          ),
          Container(
            width:
            MediaQuery.of(context).size.width / 1.7,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding: const EdgeInsets.only(left: 18),
            margin: const EdgeInsets.symmetric(
                horizontal: 15),
            child: TextField(
              readOnly: messageState?.recording == true?true:false,
              controller: _messageController,
              onChanged: (value) {
                messageNotifier?.typingChanges(value);
              },
              decoration: InputDecoration(
                hintText: messageState?.recording == true?'hint_recording'.tr:"hint_write_message".tr,
                hintStyle: const TextStyle(
                    color: Colors.white54),
                contentPadding:
                const EdgeInsets.only(top: 16),
                border: InputBorder.none,
                suffixIcon: IconButton(
                  onPressed: _modalBottomSheet,
                  icon: Icon(Icons.attach_file),
                  color: Colors.orange,
                ),
              ),
            ),
          ),

          Container(
              height: 40,
              margin: const EdgeInsets.fromLTRB(5, 5, 10, 5),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: messageState?.recording == true
                        ? Colors.white
                        : Colors.black12,
                    spreadRadius: 4)
              ], color: Colors.pink, shape: BoxShape.circle),
              child: GestureDetector(
                onTap: () {
                  startStopRecord();


                },
                child: Container(
                    padding: const EdgeInsets.all(4),
                    child:  Icon(
                      messageState?.recording == true ? Icons.stop : Icons.mic,
                      color: Colors.white,
                      size: 30,
                    )),
              )),
          if(messageState?.recording == false)
          Expanded(
            child: Container(
              height: 50,
              decoration: const BoxDecoration(
                  color: Colors.pink, shape: BoxShape.circle),
              child: IconButton(
                icon: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  if(_messageController.text.isEmpty){
                    return;
                  }
                  sendMessage("TEXT", _messageController.text);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void startStopRecord() async {

    if(messageState?.recording == true){
      stopRecord();
      messageNotifier?.recordingChanged(false);
    }else{
      messageNotifier?.recordingChanged(true);
      // Check and request permission
      if (await record.hasPermission()) {
        recordFilePath = await messageNotifier?.getFile();
        // Start recording
        await record.start(
          path: recordFilePath,
          encoder: AudioEncoder.aacLc, // by default
          bitRate: 128000, // by default
          samplingRate: 44100, // by default
        );
      }
    }

  }

  void stopRecord() async {

    // Get the state of the recorder
    bool isRecording = await record.isRecording();
    if(isRecording == true){
      await record.stop();
      File? fileUploaded = await messageNotifier?.uploadMedia(
          realm.ObjectId().hexString, recordFilePath!);
      if (fileUploaded != null) {
        sendMessage(AttachmentType.voice, fileUploaded.$id, file: fileUploaded);
      }
      // Stop recording
      await record.stop();
    }
    //39397

  }

  void pickImage(ImageSource source) async {
    Navigator.pop(context);
    final file = await context.pickAndCropImage(3 / 4, source);

    if (file != null) {
      print(file.path);

      File? fileUploaded = await messageNotifier?.uploadMedia(
          realm.ObjectId().hexString, file.path);

      if (fileUploaded != null) {
        sendMessage("IMAGE", fileUploaded.$id, file: fileUploaded);
      }
    }
  }

  void pickVideo() async {
    Navigator.pop(context);
    context.pickVideo(
      context,
          (file) async {
        print(file.path);

        File? fileUploaded = await messageNotifier?.uploadMedia(
            realm.ObjectId().hexString, file.path);

        if (fileUploaded != null) {
          sendMessage("VIDEO", fileUploaded.$id, file: fileUploaded);
        }
      },
    );
  }

  void sendMessage(String type, String message, {File? file}) {
    if (file != null) {
      messageNotifier?.onChangedUploadedFile(file);
    }

    messageNotifier?.updateGroupId(widget.group.id??'');
    messageNotifier?.myUserIdChanged(myUserId);
    messageNotifier?.messageTypeChanged(type);
    messageNotifier?.messageChanged(message);
    messageNotifier?.sendMessage();
    _messageController.text = "";
  }

  void getMessages() {
    messageNotifier?.updateGroupId(widget.group.id??'');
    messageNotifier?.setGroup(widget.group);
    messageNotifier?.myUserIdChanged(myUserId);
    messageNotifier?.getMessages();
  }

  Widget chatMessageItem(MessageRealm documentSnapshot) {
    return GroupChatMessageItem(
      message: documentSnapshot,
      displayName: displayName,
      myMessage: documentSnapshot.senderUserId == myUserId,
      myUserId: myUserId,
      messageLongPress: (value) => onMessageLongPress(value),
    );
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void _modalBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Container(
          height: 250.0,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          ),
          child: Container(
            width: double.infinity,
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text("txt_select_an_option".tr),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    pickVideo();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 38,
                    child:  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const Icon(
                          Icons.video_camera_front,
                          color: Colors.grey,
                        ),
                        Text("txt_video".tr),
                        const Spacer()
                      ],
                    ),
                  ),
                ),
                const Divider(),
                InkWell(
                  onTap: () {
                    pickImage(ImageSource.gallery);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 38,
                    child:  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const Icon(
                          Icons.image,
                          color: Colors.grey,
                        ),
                        Text("txt_image".tr),
                        const Spacer()
                      ],
                    ),
                  ),
                ),
                const Divider(),
                InkWell(
                  onTap: () {
                    pickImage(ImageSource.camera);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 38,
                    child:  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const Icon(
                          Icons.camera_alt,
                          color: Colors.grey,
                        ),
                        Text("txt_camera".tr),
                        const Spacer()
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    messageNotifier?.disconnect();
    record.dispose();
    super.dispose();


  }


  void _messageInfoModalBottomSheet(MessageRealm messageRealm) {

    if(!myMessage(messageRealm)){
      return;
    }
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Container(
          height: 250.0,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          ),
          child: Container(
            width: double.infinity,
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Text("Actions"),
                const SizedBox(
                  height: 10,
                ),
                if(myMessage(messageRealm))
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      AutoRouter.of(context).push(GroupMessageDetailsRoute(myUserId: messageState?.myUserId ??"", group: messageState?.group??GroupAppwrite(), message: messageRealm));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: 38,
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Icon(
                            Icons.info,
                            color: Colors.blue,
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("View Details"),
                          ),
                          Spacer()
                        ],
                      ),
                    ),
                  ),
                const Divider(),
                if(myMessage(messageRealm))
                  InkWell(
                    onTap: () async{
                      Navigator.pop(context);

                      bool? deleted = await messageNotifier?.deleteMessage(messageRealm.messageIdUpstream??"");
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: 38,
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Delete"),
                          ),
                          Spacer()
                        ],
                      ),
                    ),
                  ),

              ],
            ),
          ),
        );
      },
    );
  }

  bool myMessage(MessageRealm messageRealm) => myUserId == messageRealm.senderUserId;

  onMessageLongPress(MessageRealm value) {

    _messageInfoModalBottomSheet(value);
  }

  Future<void> _showStickerModal() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => const ChatStickerDialog(),
    );
    _sendStickerMessage(result);
  }

  void _sendStickerMessage(String? result) {

    if(result!=null){

      sendMessage("STICKER", result);
    }


  }
}
