


import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:chat_with_bisky/constant/strings.dart';
import 'package:chat_with_bisky/core/providers/DatabaseProvider.dart';
import 'package:chat_with_bisky/core/providers/RealmProvider.dart';
import 'package:chat_with_bisky/model/MessageAppwrite.dart';
import 'package:chat_with_bisky/model/db/MessageRealm.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chat_with_bisky/model/MessageAppwriteDocument.dart';

final messageRepositoryProvider = Provider((ref) => MessageRepositoryProvider(ref),);

class MessageRepositoryProvider{

  Ref _ref;
  Databases get _databases => _ref.read(databaseProvider);
  MessageRepositoryProvider(this._ref);

  Future<void> updateMessageSeen(String id) async{

    try{

      _databases.updateDocument(databaseId: Strings.databaseId,
          collectionId: Strings.collectionMessagesId,
          documentId: id,
      data: {
        'read':true,
        'delivered':true
      });

    } catch(e){

      print('updateMessageSeen $e');
    }
  }


  Future<void> updateMessageDelivered(String id) async{

    try{

      _databases.updateDocument(databaseId: Strings.databaseId,
          collectionId: Strings.collectionMessagesId,
          documentId: id,
          data: {
            'delivered':true
          });

    } catch(e){

      print('updateMessageSeen $e');
    }
  }

  Future<MessageAppwrite?> getMessage(String id) async{
    try{
      Document document = await _databases.getDocument(databaseId: Strings.databaseId,
          collectionId: Strings.collectionMessagesId,
          documentId: id);
      MessageAppwrite message = MessageAppwrite.fromJson(document.data);
      message.sendDate = DateTime.parse(document.$createdAt);
      return message;
    } catch(e){
      print('getMessage Error $e');
    }
    return null;
  }
  Future<List<MessageAppwriteDocument>> getGroupMessages(String groupId) async {

    try {

      DocumentList documentList = await _databases.listDocuments(
          databaseId: Strings.databaseId,
          collectionId: Strings.collectionMessagesId,
          queries: [
            Query.equal("receiverUserId", [groupId]),
            Query.orderDesc('\$createdAt'),
            Query.limit(100),
          ]);

      List<MessageAppwriteDocument> messages = [];
      if (documentList.total > 0) {
        for (Document document in documentList.documents) {
          MessageAppwrite message = MessageAppwrite.fromJson(document.data);
          message.sendDate = DateTime.parse(document.$createdAt);
          messages.add(MessageAppwriteDocument(messageAppwrite: message,document: document));
        }

        return messages;
      }
    } on AppwriteException catch (exception) {
      print(exception);
    }

    return [];

  }

  deleteMessage(String messageId) async {

    try {

      await _databases.deleteDocument(
          databaseId: Strings.databaseId,
          collectionId: Strings.collectionMessagesId,
          documentId: messageId);

      return true;
    } on AppwriteException catch (exception) {
      print('delete message $exception');
    }

    return false;
  }
}
