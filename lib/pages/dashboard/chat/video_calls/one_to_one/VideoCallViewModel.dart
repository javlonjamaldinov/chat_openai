import 'dart:async';
import 'dart:convert';

import 'package:chat_with_bisky/constant/strings.dart';
import 'package:chat_with_bisky/core/extensions/extensions.dart';
import 'package:chat_with_bisky/core/providers/RealtimeNotifierProvider.dart';
import 'package:chat_with_bisky/core/providers/RoomRepositoryProvider.dart';
import 'package:chat_with_bisky/core/providers/UserRepositoryProvider.dart';
import 'package:chat_with_bisky/model/CandidateModel.dart';
import 'package:chat_with_bisky/model/RTCSessionDescriptionModel.dart';
import 'package:chat_with_bisky/model/RealtimeNotifier.dart';
import 'package:chat_with_bisky/model/RoomAppwrite.dart';
import 'package:chat_with_bisky/model/UserAppwrite.dart';
import 'package:chat_with_bisky/model/VideoCallState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:realm/realm.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'VideoCallViewModel.g.dart';

enum CallState {
  newCall,
  connected,
  endCall,
}
@riverpod
class VideoCallViewModel extends _$VideoCallViewModel {

  RoomRepositoryProvider get _roomRepository =>
// ignore: avoid_manual_providers_as_generated_provider_dependency
  ref.read(roomRepositoryProvider);

// ignore: avoid_public_notifier_properties
  UserDataRepositoryProvider get userRepository =>
// ignore: avoid_manual_providers_as_generated_provider_dependency
  ref.read(userRepositoryProvider);

// ignore: avoid_public_notifier_properties
  ValueChanged<CallState>? onStateChange;

// ignore: avoid_public_notifier_properties
  ValueChanged<MediaStream>? onLocalStream;

// ignore: avoid_public_notifier_properties
  ValueChanged<bool>? onHangUp;

// ignore: avoid_public_notifier_properties
  ValueChanged<MediaStream>? onAddRemoteStream;

// ignore: avoid_public_notifier_properties
  ValueChanged<MediaStream>? onRemoveRemoteStream;

// ignore: avoid_public_notifier_properties
  Timer? countdownTimer;
  final _peerConnections = <String, RTCPeerConnection>{};
  final _remoteCandidates = [];
  final List<RTCIceCandidate> _localCandidates = [];

// ignore: avoid_public_notifier_properties
  StreamSubscription? hangupSub;
  MediaStream? _localStream;
  List<MediaStream>? _remoteStreams;

// ignore: avoid_public_notifier_properties
  RTCPeerConnection? peerConnection;
// ignore: avoid_public_notifier_properties
  ValueChanged<String>? onUserPresenting;
  @override
  VideoCallState build() {
    return VideoCallState();
  }

  void setRoomId(String? input) {
    state = state.copyWith(roomId: input);
  }

  void setMyUserId(String input) {
    state = state.copyWith(myUserId: input);
  }

  void setMicStatus(bool input) {
    state = state.copyWith(micOn: input);
  }

  void setSpeaker(bool input) {
    state = state.copyWith(speakerOn: input);
  }

  void setCallActiveStatus(bool input) {
    state = state.copyWith(isOnCall: input);
  }

  void setCaller(bool input) {
    state = state.copyWith(isCaller: input);
  }

  void setSessionType(String input) {
    state = state.copyWith(sessionType: input);
  }

  void setSessionDescription(String input) {
    state = state.copyWith(sessionDescription: input);
  }

  void setAddCandidatesIntoList(bool input) {
    state = state.copyWith(addCandidatesIntoList: input);
  }

  void setCalleeAnswerStatus(bool input) {
    state = state.copyWith(calleeAnswer: input);
  }

  void setCallerType(String input) {
    state = state.copyWith(callerType: input);
  }

  void setCallState(CallState input) {
    state = state.copyWith(callState: input);
  }

  void setFriend(UserAppwrite friend) {
    state = state.copyWith(friend: friend);
  }
  void setSharing(bool input) {
    state = state.copyWith(sharingScreen: input);
  }

  final Map<String, dynamic> _iceServers = {
    'iceServers': [
      {'url': 'stun:stun.l.google.com:19302'},
      { 'url': 'stun:stun1.l.google.com:19302'},
      { 'url': 'stun:stun2.l.google.com:19302'},
      { 'url': 'stun:stun3.l.google.com:19302'},
      {
        'url': 'turn:144.91.113.238:3478?transport=udp',
        'username': 'codewithbisky',
        'credential': 'webrtc'
      },
    ]
  };

  final Map<String, dynamic> _config = {
    'mandatory': {},
    'optional': [
      {'DtlsSrtpKeyAgreement': true},
    ],
  };

  final Map<String, dynamic> _constraints = {
    'mandatory': {
      'OfferToReceiveVideo': true,
      'OfferToReceiveAudio': true,
    },
    'optional': [],
  };


  void createRoomAndInitiateCall(String friendUserId) async {
    if (onStateChange != null) {
      onStateChange!(CallState.newCall);
    }
    _createPeerConnection(friendUserId).then((peerConection) async {
      _peerConnections[friendUserId] = peerConection;
      peerConnection = peerConection;
      await _createOffer(friendUserId, peerConection);
      initiateCountDownTimer();
    }, onError: (e) {
      print(e);
    });
  }

  Future<RTCPeerConnection> _createPeerConnection(id) async {
    _localStream = await createStream();
    RTCPeerConnection peerConnection = await createPeerConnection(
        _iceServers, _config);

    peerConnection.onIceCandidate = (RTCIceCandidate candidate) {
      _localCandidates.add(candidate);
    };
    peerConnection.onAddStream = (stream) {
      if (onAddRemoteStream != null) onAddRemoteStream!(stream);
    };
    peerConnection.onRemoveStream = (stream) {
      if (onRemoveRemoteStream != null) onRemoveRemoteStream!(stream);
      _remoteStreams!.removeWhere((MediaStream it) {
        return (it.id == stream.id);
      });
    };

    _localStream?.getTracks().forEach((track) {
      peerConnection.addTrack(track, _localStream!);
    });
    return peerConnection;
  }

  _createOffer(String id, RTCPeerConnection peerConnection) async {
    try {
      RTCSessionDescription s = await peerConnection.createOffer(_constraints);
      peerConnection.setLocalDescription(s);
      final id = ObjectId().hexString;
      RoomAppwrite room = RoomAppwrite(
          roomId: id,
          callType: state.callerType,
          groupCall: false,
          callerUserId: state.myUserId,
          calleeUserId: state.friend?.userId ?? "");

      setRoomId(id);
      await _roomRepository.createNewRoom(room);
      await _roomRepository.addRtcSessionDescription(
          room, s);
      _syncChangesCaller(state.roomId!, room);
    } catch (e) {
      print(e.toString());
    }
  }


  Future<MediaStream> createStream() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        'minWidth': '640',
        'minHeight': '480',
        'minFrameRate': '24',
        'facingMode': 'user',
        'optional': [],
      }
    };
    MediaStream stream =
    await navigator.mediaDevices.getUserMedia(mediaConstraints);
    if (onLocalStream != null) {
      onLocalStream!(stream);
    }
    return stream;
  }


  listenToCallerEvents() {
    _syncChangesCallee(state.roomId!);
  }

  void initiateCountDownTimer() {
    countdownTimer = Timer(const Duration(minutes: 1), () {
      deleteRoom();
      if (!state.isCaller) {
        FlutterRingtonePlayer.stop();
      }
      onHangUp!(true);
    });
  }


  void deleteRoom() async {
    if (state.roomId != null) {
      await _roomRepository.deleteRoom(state.roomId ?? "");
    }
  }

  joinRoom(String sessionDescription, String sessionType) async {
    try {
      if (onStateChange != null) {
        onStateChange!(CallState.newCall);
      }
      String friendUserId = state.friend?.userId ?? "";
      RTCPeerConnection peerConnection = await _createPeerConnection(
          friendUserId);
      peerConnection = peerConnection;
      this.peerConnection = peerConnection;
      _peerConnections[friendUserId] = peerConnection;
      await peerConnection.setRemoteDescription(
          RTCSessionDescription(sessionDescription, sessionType));
      RTCSessionDescription s = await peerConnection.createAnswer(_constraints);
      peerConnection.setLocalDescription(s);
      _sendAnswerAndCalleeCandidates(s);
      if (_remoteCandidates.isNotEmpty) {
        _remoteCandidates.forEach((candidate) async {
          await peerConnection.addCandidate(candidate);
        });
        _remoteCandidates.clear();
      }
    } catch (e) {
      print('JoinVideoException $e');
    }
  }

  void _sendAnswerAndCalleeCandidates(RTCSessionDescription answer) async {
    RoomAppwrite? room = await _roomRepository.getRoom(state.roomId!);
    if (room != null) {
      await _roomRepository.addRtcSessionDescription(room, answer);
      if (_localCandidates.isNotEmpty) {
        for (RTCIceCandidate candidate in _localCandidates) {
          await _roomRepository.addCalleeCandidates(room, candidate);
        }
      }
    }
  }


  void _syncChangesCaller(String roomId, RoomAppwrite room) async {
    ref.listen<RealtimeNotifier?>(
// ignore: avoid_manual_providers_as_generated_provider_dependency
        realtimeNotifierProvider.select((value) => value.asData?.value),
            (_, next) async {
          if (next?.document.$collectionId == Strings.collectionRoomId) {
            final roomState = RoomAppwrite.fromJson(next!.document.data);
            if (roomState.roomId == roomId) {
              if (next.type == RealtimeNotifier.delete) {
                onHangUp!(true);
                return;
              }

              final rtcSessionDescription = roomState.rtcSessionDescription;

              if (rtcSessionDescription != null) {
                List<dynamic> jsonData = json.decode(rtcSessionDescription);
                List<RTCSessionDescriptionModel> listRTCDescriptions = jsonData
                    .map((item) => RTCSessionDescriptionModel.fromJson(item))
                    .toList();

                if (roomState.status == 'busy') {
                  return;
                }

                if (state.calleeAnswer == false) {
                  RTCSessionDescriptionModel? rtcSessionDescriptionAnswer =
                      listRTCDescriptions
                          .where((element) => element.type == 'answer')
                          .firstOrNull;
                  if (rtcSessionDescriptionAnswer != null) {
                    setCalleeAnswerStatus(true);
                    var answer = RTCSessionDescription(
                      rtcSessionDescriptionAnswer.description,
                      rtcSessionDescriptionAnswer.type,
                    );
                    await peerConnection?.setRemoteDescription(answer);
                    if (_localCandidates.isNotEmpty) {
                      for (RTCIceCandidate candidate in _localCandidates) {
                        await _roomRepository.addCallerCandidates(
                            room, candidate);
                      }
                    }
                    setAddCandidatesIntoList(false);
                  }
                }
              }
              cancelScreenSharingListener(roomState);
            }
          } else
          if (next?.document.$collectionId == Strings.collectionCalleeId) {
            // Listen for remote Ice candidates below
            final calleeCandidate = CandidateModel.fromJson(
                next!.document.data);
            if (calleeCandidate.roomId == roomId &&
                next.type == RealtimeNotifier.create) {
              var id = state.friend?.userId ?? "";
              var pc = _peerConnections[id];
              RTCIceCandidate candidate = RTCIceCandidate(
                calleeCandidate.candidate,
                calleeCandidate.sdpMid,
                calleeCandidate.sdpMLineIndex,
              );
              if (pc != null) {
                await pc.addCandidate(candidate);
              } else {
                _remoteCandidates.add(candidate);
              }

              if (onStateChange != null) {
                onStateChange!(CallState.connected);
              }
            }
          }
        });
  }

  void _syncChangesCallee(String roomId) async {
    ref.listen<RealtimeNotifier?>(
// ignore: avoid_manual_providers_as_generated_provider_dependency
        realtimeNotifierProvider.select((value) => value.asData?.value),
            (_, next) async {
          if (next?.document.$collectionId == Strings.collectionCallerId) {
            final callerCandidate = CandidateModel.fromJson(
                next!.document.data);

            if (callerCandidate.roomId == roomId &&
                next.type == RealtimeNotifier.create) {
              var id = state.friend?.userId ?? "";
              var pc = _peerConnections[id];
              RTCIceCandidate candidate = RTCIceCandidate(
                callerCandidate.candidate,
                callerCandidate.sdpMid,
                callerCandidate.sdpMLineIndex,
              );
              if (pc != null) {
                await pc.addCandidate(candidate);
              } else {
                _remoteCandidates.add(candidate);
              }

              if (onStateChange != null) {
                onStateChange!(CallState.connected);
              }
            }
          } else if (next?.document.$collectionId == Strings.collectionRoomId &&
              next?.type != RealtimeNotifier.delete) {
            final roomState = RoomAppwrite.fromJson(next!.document.data);

            if (roomState.roomId == roomId &&
                next.type == RealtimeNotifier.delete) {
              onHangUp!(true);
            }
            cancelScreenSharingListener(roomState);
          }
        });
  }


  closeStreams() {
    if (_localStream != null) {
      _localStream?.dispose();
      _localStream = null;
    }
    hangupSub?.cancel();
    _peerConnections.forEach((key, pc) {
      pc.close();
    });
    _remoteStreams?.forEach((element) {
      element.dispose();
    });
    peerConnection?.dispose();
    hangupSub?.cancel();
  }


  Future<void> createShareStream(bool force) async {

    RoomAppwrite? room = await _roomRepository.getRoom(state.roomId??"");
    if(room == null){
      return;
    }
    if(room.presentingUserId != null && force == false){
      UserAppwrite? user = await userRepository.getUser(room.presentingUserId!);
      if(user!=null){
        onUserPresenting!("${user.name ?? room.presentingUserId!} ${'txt_is_presenting_the_screen'.tr}");
      }else{
        onUserPresenting!("${room.presentingUserId!} ${'txt_is_presenting_the_screen'.tr}");
      }
      return;
    }

    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': true
    };

    if (WebRTC.platformIsIOS) {
      mediaConstraints['video'] = {'deviceId': 'broadcast'};
    }
    MediaStream stream =    await navigator.mediaDevices.getDisplayMedia(mediaConstraints);
    MediaStreamTrack? newTrack = stream.getTracks().where((element) => element.kind == 'video').firstOrNull;
    if (newTrack!= null) {
      List<RTCRtpSender>? senders = await peerConnection?.getSenders();
      if (senders != null) {
        senders.forEach((s) async {
          if (s.track != null && s.track?.kind == 'video') {
            await s.replaceTrack(newTrack);
          }
        });
        if (onLocalStream != null) {
          onLocalStream!(stream);
          setSharing(true);
          _roomRepository.updatePresenterUserRoom(room, state.myUserId);
        }
      }
    }
  }

  Future<void> cancelShareStream() async {
    MediaStream stream =    await createStream();
    MediaStreamTrack? newTrack = stream.getTracks().where((element) => element.kind == 'video').firstOrNull;

    if (newTrack != null) {
      List<RTCRtpSender>? senders = await peerConnection?.getSenders();
      if (senders != null) {
        senders.forEach((s) async {
          if (s.track != null && s.track?.kind == 'video') {
            await s.replaceTrack(newTrack);
          }
        });
      }
      setSharing(false);
      RoomAppwrite? room = await _roomRepository.getRoom(state.roomId??"");
      if(room != null){
        _roomRepository.updatePresenterUserRoom(room, null);
      }
    }
  }
  void cancelScreenSharingListener(RoomAppwrite roomState) {
    if(state.sharingScreen && roomState.presentingUserId != state.myUserId){
      cancelShareStream();
    }
  }
}
