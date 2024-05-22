import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:chat_with_bisky/constant/strings.dart';
import 'package:chat_with_bisky/core/providers/BlockedFriendsRepositoryProvider.dart';
import 'package:chat_with_bisky/core/providers/DatabaseProvider.dart';
import 'package:chat_with_bisky/core/providers/DirectoryProvider.dart';
import 'package:chat_with_bisky/core/providers/FirebaseProvider.dart';
import 'package:chat_with_bisky/core/providers/MessageRepositoryProvider.dart';
import 'package:chat_with_bisky/core/providers/RealmProvider.dart';
import 'package:chat_with_bisky/core/providers/RealtimeNotifierProvider.dart';
import 'package:chat_with_bisky/core/providers/StorageProvider.dart';
import 'package:chat_with_bisky/core/providers/UserRepositoryProvider.dart';
import 'package:chat_with_bisky/model/ChatAppwrite.dart';
import 'package:chat_with_bisky/model/MessageAppwrite.dart';
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
part 'MessageViewModel.g.dart';


@riverpod
class MessageNotifier extends _$MessageNotifier {
  Databases get _databases => ref.read(databaseProvider);

  Storage get _storage => ref.read(storageProvider);

  Realm get _realm => ref.read(realmProvider);
  BlockedFriendsRepositoryProvider get _blockedFriendsRepositoryProvider => ref.read(blockedFriendsRepositoryProvider);

  fd.FirebaseDatabase database = fd.FirebaseDatabase.instance;

  RestartableTimer? _timer;
  StreamSubscription? typingSubscription;
  ValueChanged<String>? onMessage;

  @override
  MessageState build() {
    _realtimeSynchronisation();
    return MessageState();
  }

  void messageTypeChanged(String input) {
    state = state.copyWith(messageType: input);
  }

  void messageChanged(String input) {
    state = state.copyWith(message: input);
  }

  void friendUserIdChanged(String input) {
    state = state.copyWith(friendUserId: input);
  }

  void myUserIdChanged(String input) {
    state = state.copyWith(myUserId: input);
  }

  void recordingChanged(bool input) {
    state = state.copyWith(recording: input);
  }

  Future<void> sendMessage() async {
    try {
      final isBlocked = await isUserBlocked();
      if(isBlocked){
        onMessage!('txt_blocked_message'.tr);
        return;
      }
      MessageAppwrite message = MessageAppwrite();
      message.senderUserId = state.myUserId;
      message.receiverUserId = state.friendUserId;
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

      print("message sent ${document.$id}");

      await sendPushNotificationMessage(message);

      state = state.copyWith(file: null);

      String key1 = "${message.receiverUserId}${message.senderUserId}";
      String key2 = "${message.senderUserId}${message.receiverUserId}";

      createOrUpdateChatHead(
          message, key1, state.friendUserId, state.myUserId, document.$id);
      createOrUpdateChatHead(
          message, key2, state.myUserId, state.friendUserId, document.$id);
    } on AppwriteException catch (exception) {
      print(exception);
    }
  }

  Future<bool>isUserBlocked() async{

    final fist =await _blockedFriendsRepositoryProvider.getBlockedFriendsByUserIdAndFriendId(state.friendUserId, state.myUserId);
    return fist.isNotEmpty;
  }

  Future<void> createOrUpdateChatHead(MessageAppwrite message, String key,
      String friendUserId, String myUserId, String messageId) async {
    ChatAppwrite chatAppwrite = ChatAppwrite(
        message: message.message,
        displayName: await getDisplayName(myUserId),
        sendDate: DateTime.now(),
        receiverUserId: friendUserId,
        senderUserId: myUserId,
        type: message.type,
        count: 1,
        key: key,
        delivered: false,
        messageIdUpstream: messageId,
        userId: state.myUserId,
        read: false);

    try {
      Document document = await _databases.getDocument(
          databaseId: Strings.databaseId,
          collectionId: Strings.collectionChatsId,
          documentId: key);

      ChatAppwrite retrieved = ChatAppwrite.fromJson(document.data);
      chatAppwrite.count = retrieved.count ?? 1 + 1;

      Document documentChatUpdate = await _databases.updateDocument(
          databaseId: Strings.databaseId,
          collectionId: Strings.collectionChatsId,
          documentId: key,
          data: chatAppwrite.toJson());
    } on AppwriteException catch (exception) {
      print(exception);

      if (exception.code == 404) {
        Document documentChatUpdate = await _databases.createDocument(
            databaseId: Strings.databaseId,
            collectionId: Strings.collectionChatsId,
            documentId: key,
            data: chatAppwrite.toJson());
      }
    }
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
    try {
      DocumentList documentList = await _databases.listDocuments(
          databaseId: Strings.databaseId,
          collectionId: Strings.collectionMessagesId,
          queries: [
            Query.equal("senderUserId", [state.myUserId, state.friendUserId]),
            Query.equal("receiverUserId", [state.myUserId, state.friendUserId]),
            Query.orderDesc('\$createdAt')
          ]);

      if (documentList.total > 0) {
        for (Document document in documentList.documents) {
          MessageAppwrite message = MessageAppwrite.fromJson(document.data);

          await ref.read(realmRepositoryProvider).saveMessage(
              message, document, RealtimeNotifier.loading, state.myUserId);
        }
        initializeMessages(state.myUserId, state.friendUserId);
      }
    } on AppwriteException catch (exception) {
      print(exception);
    }
  }

  saveMessage(
      MessageAppwrite messageAppwrite, Document document, String type) async {
    try {
      final message = ref
          .read(realmRepositoryProvider)
          .mapMessageRealm(messageAppwrite, document);

      switch (type) {
        case RealtimeNotifier.create:
          state = state.copyWith(messages: [message, ...state.messages]);

          updateMessageRead(message);

          break;

        case RealtimeNotifier.update:
          state = state.copyWith(
              messages: state.messages
                  .map((e) => e.id == message.id ? message : e)
                  .toList());

          updateMessageRead(message);
          break;

        case RealtimeNotifier.delete:
          state = state.copyWith(
              messages:
                  state.messages.where((e) => e.id != message.id).toList());

          break;

        default:
          break;
      }
    } catch (e) {
      print(e);
    }
  }

  initializeMessages(String senderUserId, String receiverUserId) {
    RealmResults<MessageRealm> results = _realm.query<MessageRealm>(
        r'senderUserId == $0 AND receiverUserId == $1 OR senderUserId == $1 AND receiverUserId == $0 SORT(sendDate DESC)',
        [senderUserId, receiverUserId]);

    if (results.isNotEmpty) {
      state = state.copyWith(messages: results.toList());
    }
    state = state.copyWith(friendUserId: receiverUserId,
    myUserId: senderUserId);
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
              filename: '$imageId.${getFileExtension(filePath)}'));

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
      return "";
    }
  }

  _realtimeSynchronisation() {
    ref.listen<RealtimeNotifier?>(
        realtimeNotifierProvider.select((value) => value.asData?.value),
        (previous, next) {
      if (next?.document.$collectionId == Strings.collectionMessagesId) {
        final message = MessageAppwrite.fromJson(next!.document.data);

        if ((message.senderUserId == state.myUserId ||
                message.receiverUserId == state.myUserId) &&
            (message.senderUserId == state.friendUserId ||
                message.receiverUserId == state.friendUserId)) {
          saveMessage(message, next.document, next.type);
        }
      }
    });
  }

  void onChangedUploadedFile(File file) {
    state = state.copyWith(file: file);
  }

  updateMessageRead(MessageRealm message) {
    if (!myMessage(message) && message.read != true) {
      ref
          .read(messageRepositoryProvider)
          .updateMessageSeen(message.messageIdUpstream ?? "");
    }
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


  Future<void> getUserPresenceStatus(String friendId) async {


    print(friendId);
    final myConnectionRef = database.ref()
        .child('presence')
        .child(friendId)
        .child('connections');

    final friendConnectionUser = await myConnectionRef.get();


    if(friendConnectionUser.exists){
      state = state.copyWith(onlineStatus: 'txt_online'.tr);
    }else{

      getUserLastSeen(friendId);
    }

    myConnectionRef.onValue.listen((event) {
      if(event.snapshot.exists){
        state = state.copyWith(onlineStatus: 'txt_online'.tr);
      }else{
        getUserLastSeen(friendId);
      }

    });

  }

  Future<void> getUserLastSeen(String friendId) async {


    final lastOnlineRef = database.ref()
        .child('presence')
        .child(friendId)
        .child('lastOnline');
    await database.goOnline();

    final friendLastOnlineUser = await lastOnlineRef.get();

    if(friendLastOnlineUser.exists){

      print(friendLastOnlineUser.value);
      int map = friendLastOnlineUser.value as int;


        var date = DateTime.fromMillisecondsSinceEpoch(map).toLocal();
       String dateTime = date.getFormattedLastSeenTime();

        print(dateTime);

        state =state.copyWith(onlineStatus: dateTime);


    }else{
      state =state.copyWith(onlineStatus: '');
    }

  }


  Future<void> listenFriendIsTyping()async {


    final typingRef = database.ref().child('typing').child(state.friendUserId).child(state.myUserId);
    typingRef.onValue.listen((event) {

      if(event.snapshot.exists){
        state = state.copyWith(onlineStatus: 'txt_typing'.tr);
      }else{

        getUserPresenceStatus(state.friendUserId);
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
      con.set({'from':state.myUserId,'to':state.friendUserId});
      resetOrStartTimer();
    }

  }

  fd.DatabaseReference ownUserTypingRef() {
    return database.ref().child('typing').child(state.myUserId).child(state.friendUserId);
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

  getRecordingFile() async {
    final file =await getTempFile('${ObjectId().hexString}.m4a');
    return file.path;
  }


}
