import 'dart:ui';

import 'package:chat_with_bisky/core/util/Util.dart';
import 'package:chat_with_bisky/model/UserAppwrite.dart';
import 'package:chat_with_bisky/model/VideoCallState.dart';
import 'package:chat_with_bisky/pages/dashboard/chat/video_calls/one_to_one/VideoCallViewModel.dart';
import 'package:chat_with_bisky/service/LocalStorageService.dart';
import 'package:chat_with_bisky/widget/UserImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakelock/wakelock.dart';

class VideoCallVMScreen extends ConsumerStatefulWidget {
  final UserAppwrite friend;
  final bool isCaller;
  final String? sessionDescription;
  final String? sessionType;
  final String selId;
  final String? roomId;

  const VideoCallVMScreen(
      {super.key,
        required this.friend,
        required this.isCaller,
        required this.sessionDescription,
        required this.selId,
        required this.sessionType,
        this.roomId});

  @override
  _VideoCallScreenState createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends ConsumerState<VideoCallVMScreen> {
  VideoCallViewModel? _notifier;
  VideoCallState? _state;
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  MediaStream? _localStream;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initialization());
  }

  initialization() {
    LocalStorageService.putString(LocalStorageService.callInProgress, 'YES');
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    if (!widget.isCaller) {
      FlutterRingtonePlayer.playRingtone();
    }
    initRenderers();
    _connect();
    if (!widget.isCaller) {
      _notifier?.listenToCallerEvents();
      _notifier?.initiateCountDownTimer();
    }
    Wakelock.enable();
  }

  initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }



  @override
  void dispose() {
    _notifier?.hangupSub?.cancel();
    _notifier?.countdownTimer?.cancel();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    if (!widget.isCaller) {
      FlutterRingtonePlayer.stop();
    }
    LocalStorageService.deleteKey(LocalStorageService.callInProgress);
    if (_notifier != null) _notifier?.closeStreams();
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    ref.invalidate(videoCallViewModelProvider);
    super.dispose();
    Wakelock.disable();
  }

  void _connect() async {

    initializeNotifier();

    initializeStateChangeListener();
    callsEventListeners();
    if (widget.isCaller) {
      _notifier?.createRoomAndInitiateCall(widget.friend.userId ?? "");
    }
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).unfocus();
    _notifier = ref.read(videoCallViewModelProvider.notifier);
    _state = ref.watch(videoCallViewModelProvider);
    return Material(child: OrientationBuilder(builder: (context, orientation) {
      return Stack(children: [
        remoteVideoWidget(),
        callingBlur(),
        userProfilePicture(orientation),
        videoFullScreen(orientation),
        callButtons(),
      ]);
    }));
  }

  _endCall() {
    if (_notifier != null) {
      _notifier?.countdownTimer?.cancel();
      _notifier?.deleteRoom();
    }
    if (!widget.isCaller) {
      FlutterRingtonePlayer.stop();
    }
    Navigator.pop(context);
  }

  remoteVideoWidget() {
    return _state!.isOnCall
        ? Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(color: Colors.blue),
        child: RTCVideoView(
          _remoteRenderer,
          mirror: true,
          objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
        ),
      ),
    )
        : const SizedBox();
  }

  userProfilePicture(Orientation orientation) {
    return _state!.isOnCall
        ? const SizedBox()
        : Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: orientation == Orientation.portrait ? 80 : 15),
          child: SizedBox(width: MediaQuery.of(context).size.width),
        ),
        UserImage(
          widget.friend.userId ?? "",
          radius: 60,
        ),
        const SizedBox(height: 10),
        Text(
          '${widget.friend.name}',
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white),
        )
      ],
    );
  }

  videoFullScreen(Orientation orientation) {
    return _state!.isOnCall
        ? Positioned.directional(
      textDirection: Directionality.of(context),
      start: 20.0,
      top: 20.0,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        color: Colors.black,
        child: SizedBox(
            width: orientation == Orientation.portrait ? 90.0 : 120.0,
            height: orientation == Orientation.portrait ? 120.0 : 90.0,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: RTCVideoView(
                  _localRenderer,
                  mirror: true,
                  objectFit:
                  RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                ))),
      ),
    )
        : const SizedBox();
  }

  callButtons() {
    return Positioned(
      bottom: 40,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          widget.isCaller || _state!.isOnCall
              ? const SizedBox()
              : FloatingActionButton(
              heroTag: "btn5",
              backgroundColor: Colors.green,
              child: const Icon(Icons.call),
              onPressed: () {
                FlutterRingtonePlayer.stop();
                _notifier?.countdownTimer?.cancel();
                _notifier?.joinRoom(
                    widget.sessionDescription!, widget.sessionType!);
                _notifier?.setCallActiveStatus(true);
              }),
          _state!.isOnCall
              ? FloatingActionButton(
            heroTag: "btn4",
            backgroundColor: Colors.orange,
            onPressed: () {
              _notifier?.setSpeaker(_state!.speakerOn ? false : true);
              _localStream
                  ?.getAudioTracks()[0]
                  .enableSpeakerphone(_state!.speakerOn);
            },
            child: Icon(
                _state!.speakerOn ? Icons.volume_up : Icons.volume_off),
          )
              : const SizedBox(),
          FloatingActionButton(
            heroTag: "btn3",
            onPressed: () => _endCall(),
            backgroundColor: Colors.red,
            child: const Icon(Icons.call_end),
          ),
          _state!.isOnCall
              ? FloatingActionButton(
            heroTag: "btn2",
            backgroundColor: Colors.blue,
            onPressed: () {

              if(_state!.sharingScreen == true){
                _notifier?.cancelShareStream();
              }else{
                _notifier?.createShareStream(false);
              }

            },
            child: Icon(_state!.sharingScreen ? Icons.cancel_presentation : Icons.present_to_all),
          )
              : const SizedBox(),
          _state!.isOnCall
              ? FloatingActionButton(
            heroTag: "btn1",
            backgroundColor: Colors.orange,
            onPressed: () {
              _notifier?.setMicStatus(_state!.micOn ? false : true);
            },
            child: Icon(_state!.micOn ? Icons.mic : Icons.mic_off),
          )
              : const SizedBox()
        ],
      ),
    );
  }

  callingBlur() {
    return _state!.isOnCall
        ? const SizedBox()
        : SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
        ),
      ),
    );
  }

  void callsEventListeners() {

    _notifier?.onLocalStream = ((stream) {
      if (mounted) {

        setState(() {
          _localStream = stream;
          _localRenderer.srcObject = _localStream;
        });
      }
    });


    _notifier?.onHangUp = (value) {
      if (value == true) {
        Navigator.pop(context);
      }
    };

    _notifier?.onAddRemoteStream = ((stream) {
      if (mounted) {
        setState(() {
          _notifier?.setCallActiveStatus(true);
          _remoteRenderer.srcObject = stream;
        });
      }
    });

    _notifier?.onRemoveRemoteStream = ((stream) {
      if (mounted) {
        setState(() {
          _notifier?.setCallActiveStatus(false);
          _remoteRenderer.srcObject = null;
        });
      }
    });
    _notifier?.onUserPresenting = ((presentingMessage) {
      _modalAnotherUserSharingBottomSheet(presentingMessage);
    });
  }

  void initializeNotifier() {
    _notifier?.setCaller(widget.isCaller);
    _notifier?.setMyUserId(widget.selId);
    _notifier?.setFriend(widget.friend);
    _notifier?.setRoomId(widget.roomId);
  }

  void initializeStateChangeListener() {
    _notifier?.onStateChange = (CallState state) {
      switch (state) {
        case CallState.newCall:
          break;
        case CallState.connected:
          {
            if (mounted) {
              _notifier?.setCallActiveStatus(true);
              setState(() {
                _notifier?.countdownTimer?.cancel();
              });
            }
            break;
          }
        case CallState.endCall:
          setState(() {
            _localRenderer.srcObject = null;
            _remoteRenderer.srcObject = null;
            _notifier?.setCallActiveStatus(false);
          });
          break;
        default:
          break;
      }
    };
  }

  void _modalAnotherUserSharingBottomSheet(String message) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Container(
          height: 250.0,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          ),
          child: Container(
            width: double.infinity,
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(message),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    _notifier?.createShareStream(true);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 38,
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Icon(
                          Icons.video_camera_front,
                          color: Colors.grey,
                        ),
                        Text("txt_continue_sharing"),
                        Spacer()
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}
