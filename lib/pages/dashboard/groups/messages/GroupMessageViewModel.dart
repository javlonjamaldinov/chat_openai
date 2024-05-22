import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:chat_with_bisky/constant/strings.dart';
import 'package:chat_with_bisky/core/providers/DatabaseProvider.dart';
import 'package:chat_with_bisky/core/providers/DirectoryProvider.dart';
import 'package:chat_with_bisky/core/providers/FirebaseProvider.dart';
import 'package:chat_with_bisky/core/providers/GroupRepositoryProvider.dart';
import 'package:chat_with_bisky/core/providers/MessageRepositoryProvider.dart';
import 'package:chat_with_bisky/core/providers/RealmProvider.dart';
import 'package:chat_with_bisky/core/providers/RealtimeNotifierProvider.dart';
import 'package:chat_with_bisky/core/providers/StorageProvider.dart';
import 'package:chat_with_bisky/core/providers/UserRepositoryProvider.dart';
import 'package:chat_with_bisky/model/ChatAppwrite.dart';
import 'package:chat_with_bisky/model/GroupAppwrite.dart';
import 'package:chat_with_bisky/model/GroupMemberAppwrite.dart';
import 'package:chat_with_bisky/model/GroupMessageState.dart';
import 'package:chat_with_bisky/model/MessageAppwrite.dart';
import 'package:chat_with_bisky/model/MessageAppwriteDocument.dart';
import 'package:chat_with_bisky/model/MessageState.dart';
import 'package:chat_with_bisky/model/RealtimeNotifier.dart';
import 'package:chat_with_bisky/model/UserAppwrite.dart';
import 'package:chat_with_bisky/model/db/MessageRealm.dart';
import 'package:firebase_database/firebase_database.dart' as fd;
import 'package:flutter/foundation.dart';
import 'package:realm/realm.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart' as uuid;
import 'package:timeago/timeago.dart' as timeago;
import 'package:async/async.dart';
import 'package:chat_with_bisky/core/extensions/extensions.dart';
part 'GroupMessageViewModel.g.dart';


@riverpod
class GroupMessageNotifier extends _$GroupMessageNotifier {

  Databases get _databases => ref.read(databaseProvider);
  Storage get _storage => ref.read(storageProvider);
  MessageRepositoryProvider get _messageRepositoryProvider => ref.read(messageRepositoryProvider);
  GroupRepositoryProvider get _groupRepositoryProvider => ref.read(groupRepositoryProvider);
  UserDataRepositoryProvider get _userRepositoryProvider => ref.read(userRepositoryProvider);

  fd.FirebaseDatabase database = fd.FirebaseDatabase.instance;

  RestartableTimer? _timer;
  StreamSubscription? typingSubscription;
  ValueChanged<GroupMemberAppwrite?>?  onNoProfileRetrieved;

  @override
  GroupMessageState build() {
    _realtimeSynchronisation();
    return GroupMessageState();
  }

  void messageTypeChanged(String input) {
    state = state.copyWith(messageType: input);
  }

  void messageChanged(String input) {
    state = state.copyWith(message: input);
  }

  void myUserIdChanged(String input) {
    state = state.copyWith(myUserId: input);

    setUser(input);

  }

  void recordingChanged(bool input) {
    state = state.copyWith(recording: input);
  }

  Future<void> setUser(String input) async {
    if(state.user == null){
      UserAppwrite? user = await _userRepositoryProvider.getUser(input);
      if(user!=null){
        state = state.copyWith(user:user);
      }
    }
  }

  void updateGroupId(String groupId) {
    state = state.copyWith(groupId: groupId);
  }

  Future<void> sendMessage() async {
    try {
      MessageAppwrite message = MessageAppwrite();
      message.senderUserId = state.myUserId;
      message.receiverUserId = state.groupId;
      message.read = false;
      message.message = state.message;
      message.type = state.messageType;
      message.sendDate = DateTime.now();

      if (state.file != null) {
        message.fileName = state.file?.name;
      }

      Document document = await _databases.createDocument(
          databaseId: Strings.databaseId,
          collectionId: Strings.collectionMessagesId,
          documentId: const uuid.Uuid().v4(),
          data: message.toJson());

      state = state.copyWith(file: null);

      updateGroup(
          message,  state.groupId, state.myUserId, document.$id);

    } on AppwriteException catch (exception) {
      print('send group message Exception $exception');
    }
  }

  Future<void> updateGroup(MessageAppwrite message,
      String groupId, String myUserId, String messageId) async {
    final group = GroupAppwrite(
        id: state.group?.id,
        createdDate: state.group?.createdDate,
        creatorUserId: state.group?.creatorUserId,
        pictureName: state.group?.pictureName,
        pictureStorageId: state.group?.pictureStorageId,
        description: state.group?.description,
        name: state.group?.name,
        delivered: false,
        read: false,
        messageType: message.type,
        messageId: messageId,
        sendUserId: myUserId,
        message: message.message,
        sendDate: DateTime.now());

    bool success = await _groupRepositoryProvider.updateGroup(group);
  }

  loader(bool load){
    state = state.copyWith(loading:load);
  }

  getDisplayName(String userId) async {
    try {
      Document document = await _databases.getDocument(
          databaseId: Strings.databaseId,
          collectionId: Strings.collectionUsersId,
          documentId: userId);

      UserAppwrite userAppwrite = UserAppwrite.fromJson(document.data);

      return userAppwrite.name;
    } on AppwriteException catch (exception) {
      print(exception);
    }

    return userId;
  }

  getMessages() async {

    List<MessageAppwriteDocument> messages = await _messageRepositoryProvider.getGroupMessages(state.groupId);

    if(messages.isNotEmpty){
      List<MessageRealm> realmMessages = [];
      initializeMessages();
      for (var element in messages) {

        final message = ref
            .read(realmRepositoryProvider)
            .mapMessageRealm(element.messageAppwrite!, element.document!);
        realmMessages.add(message);
      }
      state = state.copyWith(messages: realmMessages);
    }
  }

  saveMessage(
      MessageAppwrite messageAppwrite, Document document, String type) async {
    try {
      final message = ref
          .read(realmRepositoryProvider)
          .mapMessageRealm(messageAppwrite, document);

      initializeMessages();

      switch (type) {
        case RealtimeNotifier.create:
          state = state.copyWith(messages: [message, ...?state.messages]);

          updateMessageRead(message);

          break;

        case RealtimeNotifier.update:
          state = state.copyWith(
              messages: state.messages
                  ?.map((e) => e.id == message.id ? message : e)
                  .toList());

          updateMessageRead(message);
          break;

        case RealtimeNotifier.delete:
          state = state.copyWith(
              messages:
              state.messages?.where((e) => e.id != message.id).toList());

          break;

        default:
          break;
      }
    } catch (e) {
      print(e);
    }
  }

  void initializeMessages() {
    if(state.messages == null){
      state = state.copyWith(messages:[]);
    }
  }


  Future<Uint8List?> getFilePreview(String fileId) async {
    try {
      return await _storage.getFilePreview(
          bucketId: Strings.messagesBucketId, fileId: fileId);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<File?> uploadMedia(String imageId, String filePath) async {
    try {
      state = state.copyWith(loading: true);
      File file = await _storage.createFile(
          bucketId: Strings.messagesBucketId,
          fileId: imageId,
          file: InputFile(
              path: filePath,
              filename: '$imageId${getFileExtension(filePath)}'));

      state = state.copyWith(loading: false);

      return file;
    } catch (e) {
      state = state.copyWith(loading: false);
      print(e);
    }

    return null;
  }

  String getFileExtension(String filePath) {
    try {
      return '.${filePath.split('.').last}';
    } catch (e) {
      print(e);
      return "";
    }
  }

  _realtimeSynchronisation() {
    ref.listen<RealtimeNotifier?>(
        realtimeNotifierProvider.select((value) => value.asData?.value),
            (previous, next) {
          if (next?.document.$collectionId == Strings.collectionMessagesId) {
            final message = MessageAppwrite.fromJson(next!.document.data);
            if (message.receiverUserId == state.groupId) {
              saveMessage(message, next.document, next.type);
            }
          }
        });
  }

  void onChangedUploadedFile(File file) {
    state = state.copyWith(file: file);
  }

  updateMessageRead(MessageRealm message) {


  }

  myMessage(MessageRealm message) {
    return message.senderUserId == state.myUserId;
  }

  sendPushNotificationMessage(MessageAppwrite messageAppwrite) async {
    final friendUser = await ref
        .read(userRepositoryProvider)
        .getUser(messageAppwrite.receiverUserId ?? "");
    final myUser = await ref
        .read(userRepositoryProvider)
        .getUser(messageAppwrite.senderUserId ?? "");

    if (friendUser != null && myUser != null) {
      final body = {
        'fromName': myUser.name ?? "",
        'messageType': messageAppwrite.type ?? "",
        'message': messageAppwrite.message ?? "",
        'fromUserId': myUser.userId ?? "",
      };

      if (friendUser.firebaseToken != null) {
        sendPayload(friendUser.firebaseToken!, body);
      }
    }
  }




  Future<void> listenFriendIsTyping()async {


    final typingRef = database.ref().child('typing').child(state.groupId);
    typingRef.onValue.listen((event) {

      if(event.snapshot.exists){


        Map<Object?,Object?> map = event.snapshot.value as Map<Object?,Object?>;
        Map<Object?,Object?> typedValue = map[map.keys.first] as    Map<Object?,Object?>;
        Map<Object?,Object?> typedValueMap = typedValue[typedValue.keys.first] as    Map<Object?,Object?>;

        if(typedValueMap.containsKey('from') && typedValueMap['from'] != null ){
          String from = typedValueMap['from'] as String;

          if(from == state.myUserId){
            state = state.copyWith(groupDetails: 'txt_view_group_details'.tr);
            return;
          }
        }
        if(typedValueMap.containsKey('memberName') && typedValueMap['memberName'] != null ){
          String memberName = typedValueMap['memberName'] as String;
          state = state.copyWith(groupDetails: '$memberName ${'txt_is_typing'.tr}');
        }else{
          state = state.copyWith(groupDetails: 'txt_typing'.tr);
        }

      }else{
        state = state.copyWith(groupDetails: 'txt_view_group_details'.tr);
      }

    });
  }

  Future<void> typingChanges(String text)async {

    if(_timer == null){

      fd.DatabaseReference con;
      await database.goOnline();
      final typingRef = ownUserTypingRef();
      await database.goOnline();
      con = typingRef.push();
      con.set({'from':state.myUserId,'to':state.groupId,'memberName':state.user?.name??''});
      resetOrStartTimer();
    }

  }

  fd.DatabaseReference ownUserTypingRef() {
    return database.ref().child('typing').child(state.groupId);
  }

  void resetOrStartTimer() {


    if(_timer == null){
      initializeTimer();
    }else{
      _timer?.reset();
    }

  }

  void initializeTimer() {
    _timer ??= RestartableTimer(const Duration(seconds: 5),  onTimerRunsOut);

  }



  onTimerRunsOut() {

    _timer = null;
    deleteTypingRef();

  }

  void deleteTypingRef() {

    final typingRef = ownUserTypingRef();
    typingRef.remove();
  }

  typingConnectionListener() async{

    final typingRef = ownUserTypingRef();
    await database.goOnline();
    typingSubscription = database.ref().child('.info/connected').onValue.listen((event) {

      if(event.snapshot.value != null){

        typingRef.onDisconnect().remove();
      }
    });

  }


  void disconnect(){

    if(typingSubscription != null){
      typingSubscription?.cancel();
    }

    database.goOffline();
    onTimerRunsOut();
  }

  setGroup(GroupAppwrite group) async {

    state = state.copyWith(group: group);
    state = state.copyWith(groupDetails: 'txt_view_group_details'.tr);

  }

  Future<bool>deleteMessage(String messageId) async {
    loader(true);
    bool deleted  = await _messageRepositoryProvider.deleteMessage(messageId);
    loader(false);
    return deleted;
  }


   getMyGroupProfile() async {
    final profile = await  _groupRepositoryProvider.getGroupMemberByUserId(state.groupId, state.myUserId);
    if(onNoProfileRetrieved!= null){
      onNoProfileRetrieved!(profile);
    }


  }

getFile() async {
    final file =await getTempFile('${ObjectId().hexString}.m4a');
    return file.path;
  }


}
