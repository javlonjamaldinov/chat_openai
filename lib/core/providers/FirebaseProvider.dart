import 'dart:async';
import 'dart:convert';

import 'package:chat_with_bisky/constant/strings.dart';
import 'package:chat_with_bisky/service/LocalStorageService.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;


sendPayload(String token, Map<String, dynamic> data) async{



  print('Data $data');

  http.Response response = await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
  headers: <String,String>{
    'Content-Type':'application/json',
    'Authorization':'key=${Strings.serverKey}'
  },body:  jsonEncode( {
      'data':data,
      'to':token
      }),
  );

  print('Code ${response.statusCode}');
  print('Body ${response.body}');



}


class FirebaseProvider{

  StreamSubscription? subscription;
  FirebaseDatabase database = FirebaseDatabase.instance;


  Future<void>  configurePresence() async{

    String myUserId = await LocalStorageService.getString(LocalStorageService.userId) ?? "";

    DatabaseReference con;
    final myConnectionRef = database.ref()
    .child('presence')
    .child(myUserId)
    .child('connections');

    final lastOnlineRef = database.ref()
        .child('presence')
        .child(myUserId)
        .child('lastOnline');

    await database.goOnline();

    // database.ref().child('presence').child(myUserId).onValue.listen((event) {});

    subscription = database.ref()
    .child('.info/connected').onValue.listen((event) {

      if(event.snapshot.value != null){

        con = myConnectionRef.push();

        con.onDisconnect().remove();

        con.set(true);

        lastOnlineRef.onDisconnect().set(ServerValue.timestamp);

      }

    });

  }

  void connect(){
    configurePresence();
  }

  disconnect(){
    subscription?.cancel();
    database.goOffline();
  }
}
