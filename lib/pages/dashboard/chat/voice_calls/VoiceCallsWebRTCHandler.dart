import 'dart:async';
import 'dart:convert';

import 'package:chat_with_bisky/constant/strings.dart';
import 'package:chat_with_bisky/core/providers/RealtimeNotifierProvider.dart';
import 'package:chat_with_bisky/core/providers/RoomRepositoryProvider.dart';
import 'package:chat_with_bisky/model/CandidateModel.dart';
import 'package:chat_with_bisky/model/RTCSessionDescriptionModel.dart';
import 'package:chat_with_bisky/model/RealtimeNotifier.dart';
import 'package:chat_with_bisky/model/RoomAppwrite.dart';
import 'package:chat_with_bisky/service/LocalStorageService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:realm/realm.dart';

typedef StreamStateCallback = void Function(MediaStream stream);

final voiceCallsWebRtcProvider = Provider((ref) => VoiceCallsWebRTCHandler(ref));

class VoiceCallsWebRTCHandler {
  final Map<String, dynamic> configuration = {
    'iceServers': [
      {'url': 'stun:stun.l.google.com:19302'},
      { 'url': 'stun:stun1.l.google.com:19302' },
      { 'url': 'stun:stun2.l.google.com:19302' },
      { 'url': 'stun:stun3.l.google.com:19302' },
      {
        'url': 'turn:144.91.113.238:3478?transport=udp',
        'username': 'codewithbisky',
        'credential': 'webrtc'
      },
    ]
  };

  final Map<String, dynamic> _voiceConstraints = {
    'mandatory': {
      'OfferToReceiveAudio': true,
      'OfferToReceiveVideo': false,
    },
    'optional': [],
  };

  RTCPeerConnection? peerConnection;
  MediaStream? localStream;
  MediaStream? remoteStream;
  String? roomId;
  String? currentRoomText;
  String? callerType = 'voice';
  StreamStateCallback? onAddRemoteStream;
  StreamStateCallback? onRemoveRemoteStream;
  StreamStateCallback? onLocalStream;
  ValueChanged<RTCPeerConnectionState>? onRTCPeerConnectionStateChange;
  ValueChanged<bool>? onCallHangUpTimeout;
  ValueChanged<bool>? remoteCallHangUp;
  bool calleeAnswer = false;
  bool groupCall = false;
  bool addIntoList = true;
  bool isCaller = true;
  final List<RTCIceCandidate> _listLocalCandidates = [];
  final Ref _ref;
  List<MediaStream>? _remoteStreams;
  Timer? callingCountDownTimer;

  RoomRepositoryProvider get _roomRepository =>
      _ref.read(roomRepositoryProvider);

  VoiceCallsWebRTCHandler(this._ref);

  Future<MediaStream> createStream() async {
    var stream = await navigator.mediaDevices
        .getUserMedia({'video': false, 'audio': true});
    onLocalStream!(stream);
    return stream;
  }

  Future<RTCPeerConnection> _createPeerConnection() async {
    localStream = await createStream();
    RTCPeerConnection pc = await createPeerConnection(configuration);
    localStream?.getTracks().forEach((track) {
      pc.addTrack(track, localStream!);
    });

    return pc;
  }

  Future<String> createRoom(String callerUserId, String calleeUserId) async {
    final id = ObjectId().hexString;
    RoomAppwrite room = RoomAppwrite(
        roomId: id,
        callType: callerType,
        groupCall: groupCall,
        callerUserId: callerUserId,
        calleeUserId: calleeUserId);

    this.roomId = id;

    peerConnection = await _createPeerConnection();

    registerPeerConnectionListeners();

    await _roomRepository.createNewRoom(room);

    peerConnection?.onIceCandidate = (RTCIceCandidate candidate) async {
      if (addIntoList == true) {
        _listLocalCandidates.add(candidate);
      } else {
        await _roomRepository.addCallerCandidates(room, candidate);
      }
    };

    RTCSessionDescription offer =
        await peerConnection!.createOffer(_voiceConstraints);
    await peerConnection!.setLocalDescription(offer);

    await _roomRepository.addRtcSessionDescription(room, offer);

    var roomId = id;

    _syncChangesCaller(roomId, room);

    callingCountDownTimeout();

    return roomId;
  }

  Future<void> joinRoom(String roomId) async {
    this.roomId = roomId;
    RoomAppwrite? roomAppwrite = await _roomRepository.getRoom(roomId);
    if (roomAppwrite != null) {

      peerConnection = await _createPeerConnection();

      registerPeerConnectionListeners();

      // Code for collecting ICE candidates below
      peerConnection!.onIceCandidate = (RTCIceCandidate candidate) async {
        if (candidate.candidate == null) {
          return;
        }
        _listLocalCandidates.add(candidate);
        await _roomRepository.addCalleeCandidates(roomAppwrite, candidate);
      };

      final rtcSessionDescription = roomAppwrite.rtcSessionDescription;

      if (rtcSessionDescription != null) {
        List<dynamic> jsonData = json.decode(rtcSessionDescription);
        List<RTCSessionDescriptionModel> listRTCDescriptions = jsonData
            .map((item) => RTCSessionDescriptionModel.fromJson(item))
            .toList();


        RTCSessionDescriptionModel? rtcSessionDescriptionOffer = listRTCDescriptions.where((element) =>
        element.type == 'offer').firstOrNull;
        if(rtcSessionDescriptionOffer != null){
          var offer = RTCSessionDescription(
            rtcSessionDescriptionOffer.description,
            rtcSessionDescriptionOffer.type,
          );
          await peerConnection?.setRemoteDescription(offer);
        }

        var answer = await peerConnection!.createAnswer(_voiceConstraints);
        await peerConnection!.setLocalDescription(answer);
        await _roomRepository.addRtcSessionDescription(roomAppwrite, answer);
        _syncChangesCallee(roomId);
      }
    }
  }

  Future<void> hangUp() async {
    LocalStorageService.deleteKey(LocalStorageService.callInProgress);
    remoteStream?.getTracks().forEach((track) => track.stop());

    peerConnection?.close();

    if (roomId != null) {
      await _roomRepository.deleteRoom(roomId ?? "");
    }

    localStream?.dispose();
    remoteStream?.dispose();
  }

  void registerPeerConnectionListeners() {
    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
    };

    peerConnection?.onConnectionState = (RTCPeerConnectionState state) {

      if (onRTCPeerConnectionStateChange != null) {
        onRTCPeerConnectionStateChange!(state);
      }
    };

    peerConnection?.onSignalingState = (RTCSignalingState state) {
    };

    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
    };

    peerConnection?.onAddStream = (MediaStream stream) {
      if (onAddRemoteStream != null) onAddRemoteStream!(stream);
    };

    peerConnection?.onRemoveStream = (stream) {
      if (onRemoveRemoteStream != null) {
        onRemoveRemoteStream!(stream);
      }
      _remoteStreams?.removeWhere((MediaStream it) {
        return (it.id == stream.id);
      });
    };
  }

  void _syncChangesCaller(String roomId, RoomAppwrite room) async {
    _ref.listen<RealtimeNotifier?>(
        realtimeNotifierProvider.select((value) => value.asData?.value),
        (_, next) async {
      if (next?.document.$collectionId == Strings.collectionRoomId) {
        final roomState = RoomAppwrite.fromJson(next!.document.data);
        if (roomState.roomId == roomId) {
          String userId = await LocalStorageService.getString(LocalStorageService.userId) ?? "";
          if(roomState.roomId == roomId && (userId == roomState.calleeUserId || userId == roomState.callerUserId) && next.type == RealtimeNotifier.delete){

            remoteCallHangUp!(true);
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

            if (calleeAnswer == false) {

              RTCSessionDescriptionModel? rtcSessionDescriptionAnswer = listRTCDescriptions.where((element) => element.type == 'answer').firstOrNull;
              if(rtcSessionDescriptionAnswer != null){
                calleeAnswer = true;
                var answer = RTCSessionDescription(
                  rtcSessionDescriptionAnswer.description,
                  rtcSessionDescriptionAnswer.type,
                );
                await peerConnection?.setRemoteDescription(answer);
                callingCountDownTimer?.cancel();
                if (_listLocalCandidates.isNotEmpty) {
                  for (RTCIceCandidate candidate in _listLocalCandidates) {
                    await _roomRepository.addCallerCandidates(
                        room, candidate);
                  }
                }
                addIntoList = false;
              }
            }
          }
        }
      } else if (next?.document.$collectionId == Strings.collectionCalleeId) {
        // Listen for remote Ice candidates below
        final roomState = CandidateModel.fromJson(next!.document.data);
        if (roomState.roomId == roomId &&
            next.type == RealtimeNotifier.create) {
          peerConnection!.addCandidate(
            RTCIceCandidate(
              roomState.candidate,
              roomState.sdpMid,
              roomState.sdpMLineIndex,
            ),
          );
        }
      }
    });
  }

  void _syncChangesCallee(String roomId) async {
    _ref.listen<RealtimeNotifier?>(
        realtimeNotifierProvider.select((value) => value.asData?.value),
        (_, next) async {
      if (next?.document.$collectionId == Strings.collectionCallerId) {
        final roomState = CandidateModel.fromJson(next!.document.data);

        if (roomState.roomId == roomId &&
            next.type == RealtimeNotifier.create) {
          peerConnection!.addCandidate(
            RTCIceCandidate(
              roomState.candidate,
              roomState.sdpMid,
              roomState.sdpMLineIndex,
            ),
          );
        }
      }else   if (next?.document.$collectionId == Strings.collectionRoomId && next?.type != RealtimeNotifier.delete) {

        final roomState = RoomAppwrite.fromJson(next!.document.data);

        String userId = await LocalStorageService.getString(LocalStorageService.userId) ?? "";

        if(roomState.roomId == roomId && (userId == roomState.calleeUserId || userId == roomState.callerUserId) && next.type == RealtimeNotifier.delete){

          remoteCallHangUp!(true);

        }

      }
    });
  }

  callingCountDownTimeout() {
    callingCountDownTimer = Timer(const Duration(minutes: 1), () {
      onCallHangUpTimeout!(true);
    });
  }

}
