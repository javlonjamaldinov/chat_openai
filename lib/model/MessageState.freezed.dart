// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'MessageState.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$MessageState {
  String get myUserId => throw _privateConstructorUsedError;
  String get friendUserId => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String get messageType => throw _privateConstructorUsedError;
  bool get loading => throw _privateConstructorUsedError;
  List<MessageRealm> get messages => throw _privateConstructorUsedError;
  File? get file => throw _privateConstructorUsedError;
  String get onlineStatus => throw _privateConstructorUsedError;
  bool? get recording => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MessageStateCopyWith<MessageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageStateCopyWith<$Res> {
  factory $MessageStateCopyWith(
          MessageState value, $Res Function(MessageState) then) =
      _$MessageStateCopyWithImpl<$Res, MessageState>;
  @useResult
  $Res call(
      {String myUserId,
      String friendUserId,
      String message,
      String messageType,
      bool loading,
      List<MessageRealm> messages,
      File? file,
      String onlineStatus,
      bool? recording});
}

/// @nodoc
class _$MessageStateCopyWithImpl<$Res, $Val extends MessageState>
    implements $MessageStateCopyWith<$Res> {
  _$MessageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? myUserId = null,
    Object? friendUserId = null,
    Object? message = null,
    Object? messageType = null,
    Object? loading = null,
    Object? messages = null,
    Object? file = freezed,
    Object? onlineStatus = null,
    Object? recording = freezed,
  }) {
    return _then(_value.copyWith(
      myUserId: null == myUserId
          ? _value.myUserId
          : myUserId // ignore: cast_nullable_to_non_nullable
              as String,
      friendUserId: null == friendUserId
          ? _value.friendUserId
          : friendUserId // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      messageType: null == messageType
          ? _value.messageType
          : messageType // ignore: cast_nullable_to_non_nullable
              as String,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      messages: null == messages
          ? _value.messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<MessageRealm>,
      file: freezed == file
          ? _value.file
          : file // ignore: cast_nullable_to_non_nullable
              as File?,
      onlineStatus: null == onlineStatus
          ? _value.onlineStatus
          : onlineStatus // ignore: cast_nullable_to_non_nullable
              as String,
      recording: freezed == recording
          ? _value.recording
          : recording // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_MessageStateCopyWith<$Res>
    implements $MessageStateCopyWith<$Res> {
  factory _$$_MessageStateCopyWith(
          _$_MessageState value, $Res Function(_$_MessageState) then) =
      __$$_MessageStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String myUserId,
      String friendUserId,
      String message,
      String messageType,
      bool loading,
      List<MessageRealm> messages,
      File? file,
      String onlineStatus,
      bool? recording});
}

/// @nodoc
class __$$_MessageStateCopyWithImpl<$Res>
    extends _$MessageStateCopyWithImpl<$Res, _$_MessageState>
    implements _$$_MessageStateCopyWith<$Res> {
  __$$_MessageStateCopyWithImpl(
      _$_MessageState _value, $Res Function(_$_MessageState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? myUserId = null,
    Object? friendUserId = null,
    Object? message = null,
    Object? messageType = null,
    Object? loading = null,
    Object? messages = null,
    Object? file = freezed,
    Object? onlineStatus = null,
    Object? recording = freezed,
  }) {
    return _then(_$_MessageState(
      myUserId: null == myUserId
          ? _value.myUserId
          : myUserId // ignore: cast_nullable_to_non_nullable
              as String,
      friendUserId: null == friendUserId
          ? _value.friendUserId
          : friendUserId // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      messageType: null == messageType
          ? _value.messageType
          : messageType // ignore: cast_nullable_to_non_nullable
              as String,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      messages: null == messages
          ? _value.messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<MessageRealm>,
      file: freezed == file
          ? _value.file
          : file // ignore: cast_nullable_to_non_nullable
              as File?,
      onlineStatus: null == onlineStatus
          ? _value.onlineStatus
          : onlineStatus // ignore: cast_nullable_to_non_nullable
              as String,
      recording: freezed == recording
          ? _value.recording
          : recording // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc

class _$_MessageState implements _MessageState {
  _$_MessageState(
      {this.myUserId = '',
      this.friendUserId = '',
      this.message = '',
      this.messageType = '',
      this.loading = false,
      this.messages = const [],
      this.file = null,
      this.onlineStatus = '',
      this.recording = false});

  @override
  @JsonKey()
  final String myUserId;
  @override
  @JsonKey()
  final String friendUserId;
  @override
  @JsonKey()
  final String message;
  @override
  @JsonKey()
  final String messageType;
  @override
  @JsonKey()
  final bool loading;
  @override
  @JsonKey()
  final List<MessageRealm> messages;
  @override
  @JsonKey()
  final File? file;
  @override
  @JsonKey()
  final String onlineStatus;
  @override
  @JsonKey()
  final bool? recording;

  @override
  String toString() {
    return 'MessageState(myUserId: $myUserId, friendUserId: $friendUserId, message: $message, messageType: $messageType, loading: $loading, messages: $messages, file: $file, onlineStatus: $onlineStatus, recording: $recording)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MessageState &&
            (identical(other.myUserId, myUserId) ||
                other.myUserId == myUserId) &&
            (identical(other.friendUserId, friendUserId) ||
                other.friendUserId == friendUserId) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.messageType, messageType) ||
                other.messageType == messageType) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            const DeepCollectionEquality().equals(other.messages, messages) &&
            (identical(other.file, file) || other.file == file) &&
            (identical(other.onlineStatus, onlineStatus) ||
                other.onlineStatus == onlineStatus) &&
            (identical(other.recording, recording) ||
                other.recording == recording));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      myUserId,
      friendUserId,
      message,
      messageType,
      loading,
      const DeepCollectionEquality().hash(messages),
      file,
      onlineStatus,
      recording);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_MessageStateCopyWith<_$_MessageState> get copyWith =>
      __$$_MessageStateCopyWithImpl<_$_MessageState>(this, _$identity);
}

abstract class _MessageState implements MessageState {
  factory _MessageState(
      {final String myUserId,
      final String friendUserId,
      final String message,
      final String messageType,
      final bool loading,
      final List<MessageRealm> messages,
      final File? file,
      final String onlineStatus,
      final bool? recording}) = _$_MessageState;

  @override
  String get myUserId;
  @override
  String get friendUserId;
  @override
  String get message;
  @override
  String get messageType;
  @override
  bool get loading;
  @override
  List<MessageRealm> get messages;
  @override
  File? get file;
  @override
  String get onlineStatus;
  @override
  bool? get recording;
  @override
  @JsonKey(ignore: true)
  _$$_MessageStateCopyWith<_$_MessageState> get copyWith =>
      throw _privateConstructorUsedError;
}
