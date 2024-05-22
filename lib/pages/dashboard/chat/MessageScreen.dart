import 'package:appwrite/models.dart';
import 'package:auto_route/auto_route.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:chat_with_bisky/core/extensions/extensions.dart';
import 'package:chat_with_bisky/localization/app_localization.dart';
import 'package:chat_with_bisky/model/AttachmentType.dart';
import 'package:chat_with_bisky/model/MessageState.dart';
import 'package:chat_with_bisky/model/UserAppwrite.dart';
import 'package:chat_with_bisky/model/db/MessageRealm.dart';
import 'package:chat_with_bisky/pages/dashboard/chat/MessageViewModel.dart';
import 'package:chat_with_bisky/pages/dashboard/chat/voice_calls/VoiceCallingPage.dart';
import 'package:chat_with_bisky/pages/dashboard/chat/voice_calls/VoiceCallsWebRTCHandler.dart';
import 'package:chat_with_bisky/route/app_route/AppRouter.gr.dart';
import 'package:chat_with_bisky/widget/ChatHeadViewModel.dart';
import 'package:chat_with_bisky/widget/ChatMessageItem.dart';
import 'package:chat_with_bisky/widget/ChatStickerDialog.dart';
import 'package:chat_with_bisky/widget/LoadingPageOverlay.dart';
import 'package:chat_with_bisky/widget/friend_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:realm/realm.dart' as realm;
import 'package:chat_with_bisky/pages/dashboard/chat/video_calls/one_to_one/VideoCallVMScreen.dart';
import 'package:record/record.dart';

@RoutePage()
class MessageScreen extends ConsumerStatefulWidget {
  String displayName;
  String myUserId;
  String friendUserId;
  UserAppwrite friendUser;
  String? profilePicture;

  MessageScreen(
      {required this.displayName,
      required this.myUserId,
      required this.friendUserId,
      required this.friendUser,
      this.profilePicture});

  ConsumerState<MessageScreen> createState() => _MessageScreenState(
      displayName: displayName, myUserId: myUserId, friendUserId: friendUserId
  ,profilePicture: profilePicture);
}

class _MessageScreenState extends ConsumerState<MessageScreen> {
  String displayName;
  String myUserId;
  String friendUserId;
  String? profilePicture;

  final TextEditingController _messageController = TextEditingController();
  MessageNotifier? messageNotifier;
  MessageState? messageState;
  final ScrollController _scrollController = ScrollController();
  String? recordFilePath;
  final record = Record();

  _MessageScreenState(
      {required this.displayName,
      required this.myUserId,
      required this.friendUserId,
        this.profilePicture});

  @override
  Widget build(BuildContext context) {
    messageNotifier = ref.read(messageNotifierProvider.notifier);
    messageState = ref.watch(messageNotifierProvider);
    messageNotifier?.onMessage = (value) {
      showMessage(value);
    };
    return LoadingPageOverlay(
      loading: messageState?.loading ?? false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          flexibleSpace: SafeArea(
            child: GestureDetector(
              onTap: () {
                AutoRouter.of(context).push(FriendDetailsRoute(myUserId: messageState?.myUserId??"",
                friendId: messageState?.friendUserId??"",name: displayName));

              },
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
                    FriendImage(profilePicture),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
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
                              messageState?.onlineStatus ?? '',
                              style: TextStyle(
                                  color:messageState?.onlineStatus.contains('typing') == true?Colors.blue.shade600:Colors.grey.shade600, fontSize: 13)
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          ref.invalidate(voiceCallsWebRtcProvider);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => VoiceCallingPage(
                                user: widget.friendUser,
                              )));
                        },
                        child: const Icon(
                          Icons.phone,
                          size: 27,
                          color: Colors.blue,
                        )),
                    const SizedBox(
                      width: 16,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => VideoCallVMScreen(
                                isCaller: true,
                                friend: widget.friendUser,
                                sessionDescription: null,
                                sessionType: null,
                                selId: widget.myUserId,
                              )));
                        },
                        child: const Icon(
                          Icons.video_call,
                          size: 27,
                          color: Colors.blue,
                        ))
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Form(
          child: Column(
            children: [
              Flexible(
                  child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(10.0),
                itemBuilder: (context, index) {
                  MessageRealm message =
                      messageState?.messages.elementAt(index) ??
                          MessageRealm(realm.ObjectId());

                  return chatMessageItem(message);
                },
                itemCount: messageState?.messages.length,
                reverse: true,
              )),
              chatInputWidget()
            ],
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
    messageNotifier?.initializeMessages(myUserId, friendUserId);
    messageNotifier?.getUserPresenceStatus(friendUserId);
    messageNotifier?.listenFriendIsTyping();
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

      // Check and request permission
      if (await record.hasPermission()) {
        messageNotifier?.recordingChanged(true);
        recordFilePath = await messageNotifier?.getRecordingFile();
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

    messageNotifier?.friendUserIdChanged(friendUserId);
    messageNotifier?.myUserIdChanged(myUserId);
    messageNotifier?.messageTypeChanged(type);
    messageNotifier?.messageChanged(message);
    messageNotifier?.sendMessage();
    _messageController.text = "";
  }

  void getMessages() {
    messageNotifier?.friendUserIdChanged(friendUserId);
    messageNotifier?.myUserIdChanged(myUserId);
    messageNotifier?.getMessages();
  }

  Widget chatMessageItem(MessageRealm documentSnapshot) {
    return ChatMessageItem(
      message: documentSnapshot,
      displayName: displayName,
      myMessage: documentSnapshot.senderUserId == myUserId,
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
