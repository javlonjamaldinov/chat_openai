

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:chat_with_bisky/constant/strings.dart';
import 'package:chat_with_bisky/core/providers/DatabaseProvider.dart';
import 'package:chat_with_bisky/core/providers/RealmProvider.dart';
import 'package:chat_with_bisky/core/providers/RealtimeNotifierProvider.dart';
import 'package:chat_with_bisky/model/ChatAppwrite.dart';
import 'package:chat_with_bisky/model/ChatState.dart';
import 'package:chat_with_bisky/model/RealtimeNotifier.dart';
import 'package:chat_with_bisky/model/db/ChatRealm.dart';
import 'package:realm/realm.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ChatListViewModel.g.dart';

@riverpod
class ChatListViewModel extends _$ChatListViewModel{

  Databases get _databases => ref.read(databaseProvider);
  Realm get _realm => ref.read(realmProvider);

  @override
  ChatState build(){

    ref.keepAlive();
    _realtimeSynchronisation();
    return ChatState();
  }
  changedUserId(userId){
    state = state.copyWith(myUserId: userId);
  }

  loader(bool input){
    state = state.copyWith(loading: input);
  }
  
  
  getChats(String userId) async{
    loader(true);
    try{
      DocumentList documentList = await _databases.listDocuments(databaseId: Strings.databaseId, collectionId: Strings.collectionChatsId,
      queries: [
        Query.equal("receiverUserId", [userId]),
        Query.orderDesc('\$updatedAt'),
        Query.limit(100)
      ]);
      
      if(documentList.total > 0){
        
        for(Document document in documentList.documents){
          ChatAppwrite chatAppwrite =  ChatAppwrite.fromJson(document.data);
          await ref
              .read(realmRepositoryProvider)
              .createOrUpdateChatHead(
              chatAppwrite, document, RealtimeNotifier.loading, state.myUserId);
          
        }
        initializeFriends(userId);
      }
      
    }catch (e){
      
      print(e);
    }
    loader(false);
  }

  void createOrUpdateChatHead(ChatRealm chatRealm,String type) {


      switch (type) {
        case RealtimeNotifier.create:
          state = state.copyWith(
              chats: [
                chatRealm,
                ...state.chats
              ]
          );

          break;

        case RealtimeNotifier.update:

          state =  state.copyWith(
              chats:  state.chats.map((e) => e.id == chatRealm.id ? chatRealm:e)
                  .toList()
          );

          break;

        case RealtimeNotifier.delete:

          state =  state.copyWith(
              chats:  state.chats.where((e) => e.id != chatRealm.id)
                  .toList()
          );


          break;

        default:
          break;
    }
    
  }


  initializeFriends(String userId){

    final results = _realm.query<ChatRealm>(r'receiverUserId = $0 SORT(displayName ASC)',[userId]);
    if(results.isNotEmpty){
      state = state.copyWith(
          chats: results.toList()
      );
    }

  }



  _realtimeSynchronisation() {
    ref.listen<RealtimeNotifier?>(
        realtimeNotifierProvider.select((value) => value.asData?.value), (
        previous, next) async {
      if (next?.document.$collectionId == Strings.collectionChatsId) {
        final chatAppwrite = ChatAppwrite.fromJson(next!.document.data);

        if (chatAppwrite.receiverUserId == state.myUserId) {

          ChatRealm? chatRealm =  await ref
              .read(realmRepositoryProvider)
              .mapToChatRealm(
              chatAppwrite, next.document);

            createOrUpdateChatHead(chatRealm, next.type);

        }
      }
    });
  }

}
