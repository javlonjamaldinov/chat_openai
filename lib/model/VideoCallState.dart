import 'package:chat_with_bisky/model/UserAppwrite.dart';
import 'package:chat_with_bisky/pages/dashboard/chat/video_calls/one_to_one/VideoCallViewModel.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'VideoCallState.freezed.dart';
@freezed
class VideoCallState with _$VideoCallState {
  factory VideoCallState({
    @Default('') String myUserId,
    @Default(null) String? roomId,
    @Default(false) bool isOnCall,
    @Default(true) bool micOn,
    @Default(true) bool speakerOn,
    @Default(true) bool isCaller,
    @Default(null) String? sessionType,
    @Default(null) String? sessionDescription,
    @Default(null) UserAppwrite? friend,
    @Default(true) bool addCandidatesIntoList,
    @Default(false) bool calleeAnswer,
    @Default('video') String callerType,
    @Default(CallState.newCall) CallState callState,
    @Default(false) bool sharingScreen,
  }) = _VideoCallState;
}
