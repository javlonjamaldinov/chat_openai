// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ChatHeadState.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ChatHeadState {
  String get myUserId => throw _privateConstructorUsedError;
  ChatRealm? get chat => throw _privateConstructorUsedError;
  bool get myMessage => throw _privateConstructorUsedError;
  bool get isTyping => throw _privateConstructorUsedError;
  String? get friendUserId => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ChatHeadStateCopyWith<ChatHeadState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatHeadStateCopyWith<$Res> {
  factory $ChatHeadStateCopyWith(
          ChatHeadState value, $Res Function(ChatHeadState) then) =
      _$ChatHeadStateCopyWithImpl<$Res, ChatHeadState>;
  @useResult
  $Res call(
      {String myUserId,
      ChatRealm? chat,
      bool myMessage,
      bool isTyping,
      String? friendUserId});
}

/// @nodoc
class _$ChatHeadStateCopyWithImpl<$Res, $Val extends ChatHeadState>
    implements $ChatHeadStateCopyWith<$Res> {
  _$ChatHeadStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? myUserId = null,
    Object? chat = freezed,
    Object? myMessage = null,
    Object? isTyping = null,
    Object? friendUserId = freezed,
  }) {
    return _then(_value.copyWith(
      myUserId: null == myUserId
          ? _value.myUserId
          : myUserId // ignore: cast_nullable_to_non_nullable
              as String,
      chat: freezed == chat
          ? _value.chat
          : chat // ignore: cast_nullable_to_non_nullable
              as ChatRealm?,
      myMessage: null == myMessage
          ? _value.myMessage
          : myMessage // ignore: cast_nullable_to_non_nullable
              as bool,
      isTyping: null == isTyping
          ? _value.isTyping
          : isTyping // ignore: cast_nullable_to_non_nullable
              as bool,
      friendUserId: freezed == friendUserId
          ? _value.friendUserId
          : friendUserId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ChatHeadStateCopyWith<$Res>
    implements $ChatHeadStateCopyWith<$Res> {
  factory _$$_ChatHeadStateCopyWith(
          _$_ChatHeadState value, $Res Function(_$_ChatHeadState) then) =
      __$$_ChatHeadStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String myUserId,
      ChatRealm? chat,
      bool myMessage,
      bool isTyping,
      String? friendUserId});
}

/// @nodoc
class __$$_ChatHeadStateCopyWithImpl<$Res>
    extends _$ChatHeadStateCopyWithImpl<$Res, _$_ChatHeadState>
    implements _$$_ChatHeadStateCopyWith<$Res> {
  __$$_ChatHeadStateCopyWithImpl(
      _$_ChatHeadState _value, $Res Function(_$_ChatHeadState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? myUserId = null,
    Object? chat = freezed,
    Object? myMessage = null,
    Object? isTyping = null,
    Object? friendUserId = freezed,
  }) {
    return _then(_$_ChatHeadState(
      myUserId: null == myUserId
          ? _value.myUserId
          : myUserId // ignore: cast_nullable_to_non_nullable
              as String,
      chat: freezed == chat
          ? _value.chat
          : chat // ignore: cast_nullable_to_non_nullable
              as ChatRealm?,
      myMessage: null == myMessage
          ? _value.myMessage
          : myMessage // ignore: cast_nullable_to_non_nullable
              as bool,
      isTyping: null == isTyping
          ? _value.isTyping
          : isTyping // ignore: cast_nullable_to_non_nullable
              as bool,
      friendUserId: freezed == friendUserId
          ? _value.friendUserId
          : friendUserId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_ChatHeadState implements _ChatHeadState {
  _$_ChatHeadState(
      {this.myUserId = '',
      this.chat = null,
      this.myMessage = false,
      this.isTyping = false,
      this.friendUserId = null});

  @override
  @JsonKey()
  final String myUserId;
  @override
  @JsonKey()
  final ChatRealm? chat;
  @override
  @JsonKey()
  final bool myMessage;
  @override
  @JsonKey()
  final bool isTyping;
  @override
  @JsonKey()
  final String? friendUserId;

  @override
  String toString() {
    return 'ChatHeadState(myUserId: $myUserId, chat: $chat, myMessage: $myMessage, isTyping: $isTyping, friendUserId: $friendUserId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ChatHeadState &&
            (identical(other.myUserId, myUserId) ||
                other.myUserId == myUserId) &&
            const DeepCollectionEquality().equals(other.chat, chat) &&
            (identical(other.myMessage, myMessage) ||
                other.myMessage == myMessage) &&
            (identical(other.isTyping, isTyping) ||
                other.isTyping == isTyping) &&
            (identical(other.friendUserId, friendUserId) ||
                other.friendUserId == friendUserId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      myUserId,
      const DeepCollectionEquality().hash(chat),
      myMessage,
      isTyping,
      friendUserId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ChatHeadStateCopyWith<_$_ChatHeadState> get copyWith =>
      __$$_ChatHeadStateCopyWithImpl<_$_ChatHeadState>(this, _$identity);
}

abstract class _ChatHeadState implements ChatHeadState {
  factory _ChatHeadState(
      {final String myUserId,
      final ChatRealm? chat,
      final bool myMessage,
      final bool isTyping,
      final String? friendUserId}) = _$_ChatHeadState;

  @override
  String get myUserId;
  @override
  ChatRealm? get chat;
  @override
  bool get myMessage;
  @override
  bool get isTyping;
  @override
  String? get friendUserId;
  @override
  @JsonKey(ignore: true)
  _$$_ChatHeadStateCopyWith<_$_ChatHeadState> get copyWith =>
      throw _privateConstructorUsedError;
}
