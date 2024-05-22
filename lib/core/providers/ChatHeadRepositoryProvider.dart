import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:chat_with_bisky/constant/strings.dart';
import 'package:chat_with_bisky/core/providers/DatabaseProvider.dart';
import 'package:chat_with_bisky/model/ChatAppwrite.dart';
import 'package:chat_with_bisky/model/MessageAppwrite.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final chatHeadRepositoryProvider = Provider((ref) => ChatHeadRepositoryProvider(ref),);

class ChatHeadRepositoryProvider{

  final Ref _ref;
  Databases get _databases => _ref.read(databaseProvider);
  ChatHeadRepositoryProvider(this._ref);

  Future<void> updateChatHeadMessageSeen(String id) async{

    try{

      _databases.updateDocument(databaseId: Strings.databaseId,
          collectionId: Strings.collectionChatsId,
          documentId: id,
          data: {
            'read':true,
            'delivered':true
          });

    } catch(e){

      print('updateChatHeadMessageSeen Error $e');
    }
  }


  Future<void> updateChatHeadMessageDelivered(String id) async{

    try{

      _databases.updateDocument(databaseId: Strings.databaseId,
          collectionId: Strings.collectionChatsId,
          documentId: id,
          data: {
            'delivered':true
          });

    } catch(e){
      print('updateChatHeadMessageDelivered Error $e');
    }
  }

  Future<ChatAppwrite?> getChat(String id) async{

    try{

      Document document = await _databases.getDocument(databaseId: Strings.databaseId,
          collectionId: Strings.collectionChatsId,
          documentId: id);
      return ChatAppwrite.fromJson(document.data);

    } catch(e){

      print('getChat Error $e');
    }
    return null;
  }

  Future<void> updateChatMessageDelivered(MessageAppwrite message) async {
    String chatId = '${message.senderUserId??""}${message.receiverUserId??""}';
    String chatId2 = '${message.receiverUserId??""}${message.senderUserId??""}';
    ChatAppwrite? chatHead = await getChat(chatId);
    ChatAppwrite? chatHead2 = await getChat(chatId2);

    if(chatHead != null || chatHead2 != null){
      await updateChatHeadMessageDelivered(chatId);
      await updateChatHeadMessageDelivered(chatId2);
    }
  }

  Future<void> updateChatMessageRead(MessageAppwrite message) async {
    String chatId = '${message.senderUserId??""}${message.receiverUserId??""}';
    String chatId2 = '${message.receiverUserId??""}${message.senderUserId??""}';
    ChatAppwrite? chatHead = await getChat(chatId);
    ChatAppwrite? chatHead2 = await getChat(chatId2);
    if(chatHead!= null|| chatHead2!= null){
      updateChatHeadMessageSeen(chatId);
      updateChatHeadMessageSeen(chatId2);
    }
  }

}
