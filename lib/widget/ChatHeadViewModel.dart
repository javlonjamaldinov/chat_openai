import 'package:chat_with_bisky/model/ChatHeadState.dart';
import 'package:chat_with_bisky/model/db/ChatRealm.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_database/firebase_database.dart' as fd;
part 'ChatHeadViewModel.g.dart';

@riverpod
class ChatHeadViewModel extends _$ChatHeadViewModel{


  fd.FirebaseDatabase database = fd.FirebaseDatabase.instance;
  @override
  ChatHeadState build(){

    // ref.keepAlive();
    return ChatHeadState();
  }

  changedChatHead(ChatRealm chat){
    state = state.copyWith(chat: chat);
  }

  changedUserId(userId){
    state = state.copyWith(myUserId: userId);
  }


  changedTypingStatus(isTyping){
    state = state.copyWith(isTyping: isTyping);
  }
  changedFriendUserId(friendUserId){
    state = state.copyWith(friendUserId: friendUserId);
  }

  Future<void> listenFriendIsTyping()async {

    await database.goOnline();
    final typingRef = database.ref().child('typing').child(state.chat?.senderUserId??"").child(state.myUserId);

    typingRef.onValue.listen((event) {

      if(event.snapshot.exists){
        Map<Object?,Object?> map = event.snapshot.value as Map<Object?,Object?>;
        Map<Object?,Object?> typedValue = map[map.keys.first] as    Map<Object?,Object?>;

        if(typedValue.containsKey('from') && typedValue['from'] != null ){
          print('from $typedValue');
          String from = typedValue['from'] as String;
          changedFriendUserId(from);
          changedTypingStatus(true);
        }

      }else{
        changedTypingStatus(false);
        changedFriendUserId(null);
      }

    });
  }
}
