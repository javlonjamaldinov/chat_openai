import 'dart:async';

import 'package:appwrite/models.dart';
import 'package:auto_route/annotations.dart';
import 'package:chat_with_bisky/constant/strings.dart';
import 'package:chat_with_bisky/core/extensions/extensions.dart';
import 'package:chat_with_bisky/core/providers/FirebaseProvider.dart';
import 'package:chat_with_bisky/core/providers/RealtimeNotifierProvider.dart';
import 'package:chat_with_bisky/core/providers/UserRepositoryProvider.dart';
import 'package:chat_with_bisky/core/util/Util.dart';
import 'package:chat_with_bisky/localization/app_localization.dart';
import 'package:chat_with_bisky/main.dart';
import 'package:chat_with_bisky/model/AppLanguage.dart';
import 'package:chat_with_bisky/model/RTCSessionDescriptionModel.dart';
import 'package:chat_with_bisky/model/RealtimeNotifier.dart';
import 'package:chat_with_bisky/model/RoomAppwrite.dart';
import 'package:chat_with_bisky/pages/dashboard/chat/list/ChatListScreen.dart';
import 'package:chat_with_bisky/pages/dashboard/chat/voice_calls/VoiceCallingPage.dart';
import 'package:chat_with_bisky/pages/dashboard/chat/voice_calls/VoiceCallsWebRTCHandler.dart';
import 'package:chat_with_bisky/pages/dashboard/friends/FriendsListScreen.dart';
import 'package:chat_with_bisky/pages/dashboard/stories/StoriesScreen.dart';
import 'package:chat_with_bisky/pages/settings/settings_screen.dart';
import 'package:chat_with_bisky/service/LocalStorageService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chat_with_bisky/pages/dashboard/groups/GroupsListScreen.dart';
import 'dart:convert';
import 'package:chat_with_bisky/pages/dashboard/chat/video_calls/one_to_one/VideoCallVMScreen.dart';

@RoutePage()
class DashboardPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<DashboardPage> createState() {
    return _DashboardPageState();
  }
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  int selectedIndex = 0;
  final firebaseProvider = FirebaseProvider();
  StreamSubscription<FGBGType>? subscription;

  @override
  Widget build(BuildContext context) {

    _listenIncomingCalls();
    return Scaffold(
      body: Stack(
        children: [getSelectedScreen(selectedIndex)],
      ),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  Widget bottomNavigationBar() {
    return Card(
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        showSelectedLabels: true,
        items: [
          BottomNavigationBarItem(
              icon: Image.asset(
                "assets/images/chat.png",
                width: 20,
                height: 20,
              ),
              label: "txt_chats".tr,
              activeIcon: Image.asset(
                "assets/images/chat.png",
                width: 20,
                height: 20,
                color: Colors.blue,
              )),
          BottomNavigationBarItem(
              icon: Image.asset(
                "assets/images/groups.png",
                width: 20,
                height: 20,
              ),
              label: "txt_groups".tr,
              activeIcon: Image.asset(
                "assets/images/groups.png",
                width: 20,
                height: 20,
                color: Colors.blue,
              )),
          BottomNavigationBarItem(
              icon: Image.asset(
                "assets/images/contacts.png",
                width: 20,
                height: 20,
              ),
              label: "txt_friends".tr,
              activeIcon: Image.asset(
                "assets/images/contacts.png",
                width: 20,
                height: 20,
                color: Colors.blue,
              )),
          BottomNavigationBarItem(
              icon: Image.asset(
                "assets/images/stories.png",
                width: 20,
                height: 20,
              ),
              label: "txt_stories".tr,
              activeIcon: Image.asset(
                "assets/images/stories.png",
                width: 20,
                height: 20,
                color: Colors.blue,
              )),
          BottomNavigationBarItem(
              icon: Image.asset(
                "assets/images/settings.png",
                width: 20,
                height: 20,
              ),
              label: "txt_settings".tr,
              activeIcon: Image.asset(
                "assets/images/settings.png",
                width: 20,
                height: 20,
                color: Colors.blue,
              ))
        ],
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
      ),
    );
  }

  Widget getSelectedScreen(int index) {
    switch (index) {
      case 0:
        return ChatListScreen();
      case 1:
        return GroupsListScreen();
      case 2:
        return FriendsListScreen();
      case 3:
        return StoriesScreen();

      default:
         return const SettingsScreen();
    }
  }


  void _listenIncomingCalls() {

    LocalStorageService.deleteKey(LocalStorageService.callInProgress);

    ref.listen<RealtimeNotifier?>(
        realtimeNotifierProvider.select((value) => value.asData?.value),
            (_, next) async {

          if (next?.document.$collectionId == Strings.collectionRoomId) {
            final roomState = RoomAppwrite.fromJson(next!.document.data);

            String username = await LocalStorageService.getString(LocalStorageService.userId) ?? "";

            if(username == roomState.calleeUserId && roomState.rtcSessionDescription != null && next.type != RealtimeNotifier.delete){

              final inProgress = await LocalStorageService.getString(LocalStorageService.callInProgress);

              if(inProgress !=null){

                // todo  update room with state repository
                return;
              }
              final caller =  await ref.read(userRepositoryProvider).getUser(roomState.callerUserId??"");

              if(caller != null){
                if(roomState.callType == 'voice'){
                  ref.invalidate(voiceCallsWebRtcProvider);
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) =>
                      VoiceCallingPage(
                        user: caller,
                        callStatus: CallStatus.ringing,
                        roomId: roomState.roomId ?? "",
                      )));
                }else if(roomState.callType == 'video'){

                  final rtcSessionDescription = roomState.rtcSessionDescription;

                  if (rtcSessionDescription != null) {
                    List<dynamic> jsonData = json.decode(rtcSessionDescription);
                    List<
                        RTCSessionDescriptionModel> listRTCDescriptions = jsonData
                        .map((item) =>
                        RTCSessionDescriptionModel.fromJson(item))
                        .toList();

                    RTCSessionDescriptionModel? rtcSessionDescriptionOffer = listRTCDescriptions.where((element) => element.type == 'offer').firstOrNull;
                    if(rtcSessionDescriptionOffer != null){

                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) =>
                          VideoCallVMScreen(
                            friend:caller,
                            isCaller: false,
                            sessionDescription: rtcSessionDescriptionOffer.description,
                            sessionType: rtcSessionDescriptionOffer.type,
                            selId: username,
                            roomId: roomState.roomId,)));
                    }

                  }
                }

              }
            }
          }
        });
  }

  @override
  void initState() {
    super.initState();


    firebaseProvider.configurePresence();
    subscription = FGBGEvents.stream.listen((event) {

      if(event == FGBGType.foreground){

        firebaseProvider.connect();
      }else if(event == FGBGType.background){
        firebaseProvider.disconnect();
      }
    });

    createFirebaseToken();


  }

  createFirebaseToken(){

    FirebaseMessaging.instance.getToken().then((value) async {

      print('TOKEN _$value');


      String userId = await LocalStorageService.getString(LocalStorageService.userId) ?? "";

        final myUser =  await ref.read(userRepositoryProvider).getUser(userId);

        if(myUser != null && myUser.firebaseToken != value){

          myUser.firebaseToken = value;

          await ref.read(userRepositoryProvider).updateUser(myUser);




        }


    });

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
