import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:chat_with_bisky/core/providers/AppwriteClientProvider.dart';
import 'package:chat_with_bisky/model/ChatAppwrite.dart';
import 'package:chat_with_bisky/model/MessageAppwrite.dart';
import 'package:chat_with_bisky/model/RealtimeNotifier.dart';
import 'package:chat_with_bisky/model/db/ChatRealm.dart';
import 'package:chat_with_bisky/model/db/FriendContactRealm.dart';
import 'package:chat_with_bisky/model/db/MessageRealm.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:realm/realm.dart';
import 'package:chat_with_bisky/core/providers/MessageRepositoryProvider.dart';
import 'package:chat_with_bisky/core/providers/UserRepositoryProvider.dart';
import 'package:chat_with_bisky/core/util/Util.dart';
import 'package:chat_with_bisky/constant/strings.dart';
import 'package:flutter/services.dart';

final config = Configuration.local([MessageRealm.schema
,ChatRealm.schema, FriendContactRealm.schema],schemaVersion:3);

final realmProvider=  Provider((ref) => Realm(config));


final realmRepositoryProvider = Provider((ref) => RealmRepositoryProvider(ref));
class RealmRepositoryProvider {
  final Ref _ref;

  get _realm => _ref.read(realmProvider);

  RealmRepositoryProvider(this._ref);

  Future<MessageRealm?> saveMessage(MessageAppwrite messageAppwrite,
      Document document, String type, String myUserId) async {
    if (messageAppwrite.senderUserId != myUserId &&
        messageAppwrite.receiverUserId != myUserId) {
      return null;
    }
    try {

      final message = mapMessageRealm(messageAppwrite, document);

      final results =
      _realm.query<MessageRealm>(r'messageIdUpstream = $0', [message.messageIdUpstream]);
      if (results.isEmpty) {
        _realSaveMessage(message);
        return message;
      } else {
        switch (type) {
          case RealtimeNotifier.create:
          case RealtimeNotifier.update:
            _realSaveMessage(message);
            return message;
          case RealtimeNotifier.delete:
            realDeleteMessage(message);
            return message;
          default:
            _realSaveMessage(message);
            return message;
        }
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<ChatRealm?> createOrUpdateChatHead(ChatAppwrite chat,
      Document document, String type, String myUserId) async {

    if (chat.receiverUserId != myUserId) {
      return null;
    }
    ChatRealm chatRealm = await mapToChatRealm(chat,document);

    switch (type) {
      case RealtimeNotifier.loading:
      case RealtimeNotifier.create:
      case RealtimeNotifier.update:
        _saveChatRealm(chatRealm);
        return chatRealm;
      case RealtimeNotifier.delete:
        _realm.delete(chatRealm);
        return chatRealm;
      default:
        _saveChatRealm(chatRealm);
        return chatRealm;
    }
  }

  void _saveChatRealm(ChatRealm chatRealm) {
    _realm.write(() {
      _realm.add(chatRealm, update: true);
    });
  }
  void _realSaveMessage(MessageRealm message) {
    _realm.write(() {
      _realm.add(message, update: true);
    });
  }



  MessageRealm mapMessageRealm(MessageAppwrite messageAppwrite,
      Document document){

    DateTime createdDate = DateTime.parse(document.$createdAt);
    final id = ObjectId.fromTimestamp(createdDate);
    return MessageRealm(id,
        senderUserId: messageAppwrite.senderUserId,
        receiverUserId: messageAppwrite.receiverUserId,
        message: messageAppwrite.message,
        type: messageAppwrite.type,
        sendDate: createdDate,
        read: messageAppwrite.read,
        fileName: messageAppwrite.fileName,
        messageIdUpstream: document.$id,
        delivered: messageAppwrite.delivered);
  }

  Future<ChatRealm> mapToChatRealm(ChatAppwrite chat,
      Document document) async{

    final results = _realm.query<ChatRealm>(
        r'senderUserId = $0', [chat.senderUserId]);
    ObjectId id = ObjectId();
    if(results.isNotEmpty){
      id = results.first.id;
    }
    bool? delivered = chat.delivered;
    bool? read = chat.read;
    MessageAppwrite? messageUpstream = await _ref.read(messageRepositoryProvider).getMessage(chat.messageIdUpstream?? '');
    DateTime messageDate = DateTime.parse(document.$createdAt);
    if(messageUpstream != null){
      delivered= messageUpstream.delivered;
      read= messageUpstream.read;
      messageDate= messageUpstream.sendDate ?? DateTime.now();
    }else{
      final resultsMessages =
      _realm.query<MessageRealm>(r'messageIdUpstream = $0', [chat.messageIdUpstream?? '']);
      if(!resultsMessages.isEmpty){
        MessageRealm retrieved = resultsMessages.first;
        delivered= retrieved.delivered;
        read= retrieved.read;
        messageDate= retrieved.sendDate ?? DateTime.now();
      }
    }

    final user = await _ref.read(userRepositoryProvider).getUser(chat.senderUserId??"");
    String? base64;
    if(user != null && user.profilePictureStorageId != null){
      Storage storage = Storage(clientService.getClient());
      Uint8List imageBytes = await storage.getFilePreview(
        bucketId: Strings.profilePicturesBucketId,
        fileId: user.profilePictureStorageId ?? "",
      );
      base64 = uint8ListToBase64(imageBytes);
    }

    return  ChatRealm(id, senderUserId: chat.senderUserId,
        receiverUserId: chat.receiverUserId,
        message: chat.message,
        type: chat.type,
        sendDate: messageDate,
        read: read,
        displayName: chat.displayName,
        count: chat.count,
        userId: chat.userId,
        delivered: delivered,
        messageIdUpstream: chat.messageIdUpstream,
        base64Image: base64
    );
  }

  List<FriendContactRealm> getMyFriends(String userId){
    RealmResults<FriendContactRealm> results = _realm.query<FriendContactRealm>(r'userId = $0 SORT(displayName ASC)',[userId]);
    if(results.isNotEmpty){
      return results.toList();
    }
    return [];
  }
  List<ChatRealm> getMyChats(String userId){
    RealmResults<ChatRealm> results = _realm.query<ChatRealm>(r'receiverUserId = $0 SORT(displayName ASC)',[userId]);
    if(results.isNotEmpty){
      return results.toList();
    }
    return [];
  }

  void realDeleteMessage(MessageRealm message) {
    try {
    var resultsMessages = _realm.query<MessageRealm>(r'messageIdUpstream = $0', [message.messageIdUpstream?? '']);
    if(!resultsMessages.isEmpty){
      MessageRealm retrieved = resultsMessages.first;
      _realm.write(() {
        _realm.delete(retrieved);
      });
    }
    } catch (e) {
      print('DELETE REALM MESSAGE EXCEPTION $e ${message.id}');
    }
  }
}
