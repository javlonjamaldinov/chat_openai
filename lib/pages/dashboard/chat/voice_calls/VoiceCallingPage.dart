import 'dart:ui';

import 'package:chat_with_bisky/core/extensions/extensions.dart';
import 'package:chat_with_bisky/model/UserAppwrite.dart';
import 'package:chat_with_bisky/pages/dashboard/chat/voice_calls/VoiceCallsWebRTCHandler.dart';
import 'package:chat_with_bisky/service/LocalStorageService.dart';
import 'package:chat_with_bisky/widget/countup.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum CallStatus {
  calling,
  accepted,
  ringing,
  progress,
  connecting,
  disconnected
}

class VoiceCallingPage extends ConsumerStatefulWidget {
  final UserAppwrite user;
  CallStatus? callStatus;
  final String? roomId;

  VoiceCallingPage({Key? key, required this.user, this.callStatus, this.roomId})
      : super(key: key);

  @override
  _VoiceCallingPageState createState() => _VoiceCallingPageState();
}

class _VoiceCallingPageState extends ConsumerState<VoiceCallingPage> {
  late CallStatus callStatus;

  VoiceCallsWebRTCHandler? webrtcLogic;

  String? roomId;
  bool _isCaller = false;

  initializeWebRTC() async {
    await Future.delayed(const Duration(milliseconds: 500));
    LocalStorageService.putString(LocalStorageService.callInProgress, 'YES');
    webrtcLogic!.onLocalStream = ((stream) {});

    webrtcLogic?.onAddRemoteStream = ((stream) {});
    webrtcLogic?.onRTCPeerConnectionStateChange = ((state) {
      switch (state) {
        case RTCPeerConnectionState.RTCPeerConnectionStateClosed:
        case RTCPeerConnectionState.RTCPeerConnectionStateFailed:
        case RTCPeerConnectionState.RTCPeerConnectionStateDisconnected:
          if (mounted) {
            setState(() {
              callStatus = CallStatus.disconnected;
            });
          }
          break;

        case RTCPeerConnectionState.RTCPeerConnectionStateNew:
          break;
        case RTCPeerConnectionState.RTCPeerConnectionStateConnecting:
          setState(() {
            callStatus = CallStatus.connecting;
          });
          break;
        case RTCPeerConnectionState.RTCPeerConnectionStateConnected:
          if (_isCaller == true) {
            setState(() {
              callStatus = CallStatus.progress;
            });
          } else {
            setState(() {
              callStatus = CallStatus.accepted;
            });
          }

          break;
      }
    });

    webrtcLogic?.onRemoveRemoteStream = ((stream) {});
    webrtcLogic?.onCallHangUpTimeout = ((stream) {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
    webrtcLogic?.remoteCallHangUp = ((stream) {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });

    if (callStatus == CallStatus.calling) {
      final userId =
          await LocalStorageService.getString(LocalStorageService.userId) ?? "";
      roomId = await webrtcLogic?.createRoom(userId, widget.user.userId ?? "");
      print("roomID: $roomId");

      setState(() {
        _isCaller = true;
      });
    } else if (callStatus == CallStatus.ringing) {
      if (!_isCaller) {
        webrtcLogic?.roomId = roomId;
        FlutterRingtonePlayer.playRingtone();
        webrtcLogic?.callingCountDownTimeout();
      }
    }

    if (kDebugMode) {
      print("connected successfully");
    }
  }

  disconnectCall() async {
    await webrtcLogic?.hangUp();
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    callStatus = widget.callStatus ?? CallStatus.calling;

    initializeWebRTC();
    super.initState();
  }

  @override
  void dispose() {
    webrtcLogic?.hangUp();
    if (!_isCaller) {
      FlutterRingtonePlayer.stop();
    }

    super.dispose();
  }

  Widget getBody() {
    switch (callStatus) {
      case CallStatus.calling:
        return Center(
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              Column(
                children: [
                  const SizedBox(
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    widget.user.name ?? "",
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "txt_calling".tr,
                    style: const TextStyle(
                        color: Colors.white,
                        shadows: [
                          BoxShadow(color: Colors.black, blurRadius: 3)
                        ],
                        fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      disconnectCall();
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: const BoxDecoration(
                              color: Colors.redAccent, shape: BoxShape.circle),
                          child: const Icon(Icons.phone_disabled,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          "txt_decline".tr,
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      case CallStatus.accepted:
        return Center(
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              Column(
                children: [
                  Container(
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    widget.user.name ?? "",
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Countup(
                    style: const TextStyle(
                        color: Colors.white,
                        shadows: [
                          BoxShadow(color: Colors.black, blurRadius: 3)
                        ],
                        fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      disconnectCall();
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: const BoxDecoration(
                              color: Colors.redAccent, shape: BoxShape.circle),
                          child: const Icon(Icons.phone_disabled,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          "txt_end".tr,
                          style: const TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      case CallStatus.ringing:
        return Column(
          children: [
            const Spacer(),
            Column(
              children: [
                const SizedBox(
                  width: 150,
                  height: 150,
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  widget.user.name ?? "",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "txt_ringing".tr,
                  style: const TextStyle(
                      color: Colors.white,
                      shadows: [BoxShadow(color: Colors.black, blurRadius: 3)],
                      fontSize: 16),
                )
              ],
            ),
            const SizedBox(
              height: 60,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    FlutterRingtonePlayer.stop();
                    webrtcLogic!.callingCountDownTimer?.cancel();
                    roomId = widget.roomId;
                    webrtcLogic?.joinRoom(roomId!);
                    setState(() {
                      callStatus = CallStatus.accepted;
                    });
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: const BoxDecoration(
                            color: Colors.blue, shape: BoxShape.circle),
                        child: const Icon(Icons.phone, color: Colors.white),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "txt_accept".tr,
                        style: const TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    disconnectCall();
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: const BoxDecoration(
                            color: Colors.redAccent, shape: BoxShape.circle),
                        child: const Icon(Icons.phone_disabled,
                            color: Colors.white),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "txt_decline".tr,
                        style: const TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 60,
            ),
            Text(
              "txt_decline_and_send_message".tr,
              style: const TextStyle(color: Colors.white60, fontSize: 14),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 80,
            ),
          ],
        );
      case CallStatus.connecting:
      case CallStatus.progress:
      case CallStatus.disconnected:
        return Center(
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              Column(
                children: [
                  const SizedBox(
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    widget.user.name ?? "",
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                        fontWeight: FontWeight.bold),
                  ),
                  if (CallStatus.connecting == callStatus)
                    Text(
                      "txt_call_connecting".tr,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  if (CallStatus.disconnected == callStatus)
                    Text(
                      "txt_call_disconnected_message".tr,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  const SizedBox(
                    height: 8,
                  ),
                  Countup(
                    style: const TextStyle(
                        color: Colors.white,
                        shadows: [
                          BoxShadow(color: Colors.black, blurRadius: 3)
                        ],
                        fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      disconnectCall();
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: const BoxDecoration(
                              color: Colors.redAccent, shape: BoxShape.circle),
                          child: const Icon(Icons.phone_disabled,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Text(
                          "End",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    webrtcLogic = ref.read(voiceCallsWebRtcProvider);
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
              ),
            ),
          ),
          getBody(),
        ],
      ),
    );
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
