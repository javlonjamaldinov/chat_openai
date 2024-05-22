// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ChatState.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ChatState {
  String get myUserId => throw _privateConstructorUsedError;
  bool get loading => throw _privateConstructorUsedError;
  List<ChatRealm> get chats => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ChatStateCopyWith<ChatState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatStateCopyWith<$Res> {
  factory $ChatStateCopyWith(ChatState value, $Res Function(ChatState) then) =
      _$ChatStateCopyWithImpl<$Res, ChatState>;
  @useResult
  $Res call({String myUserId, bool loading, List<ChatRealm> chats});
}

/// @nodoc
class _$ChatStateCopyWithImpl<$Res, $Val extends ChatState>
    implements $ChatStateCopyWith<$Res> {
  _$ChatStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? myUserId = null,
    Object? loading = null,
    Object? chats = null,
  }) {
    return _then(_value.copyWith(
      myUserId: null == myUserId
          ? _value.myUserId
          : myUserId // ignore: cast_nullable_to_non_nullable
              as String,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      chats: null == chats
          ? _value.chats
          : chats // ignore: cast_nullable_to_non_nullable
              as List<ChatRealm>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ChatStateCopyWith<$Res> implements $ChatStateCopyWith<$Res> {
  factory _$$_ChatStateCopyWith(
          _$_ChatState value, $Res Function(_$_ChatState) then) =
      __$$_ChatStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String myUserId, bool loading, List<ChatRealm> chats});
}

/// @nodoc
class __$$_ChatStateCopyWithImpl<$Res>
    extends _$ChatStateCopyWithImpl<$Res, _$_ChatState>
    implements _$$_ChatStateCopyWith<$Res> {
  __$$_ChatStateCopyWithImpl(
      _$_ChatState _value, $Res Function(_$_ChatState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? myUserId = null,
    Object? loading = null,
    Object? chats = null,
  }) {
    return _then(_$_ChatState(
      myUserId: null == myUserId
          ? _value.myUserId
          : myUserId // ignore: cast_nullable_to_non_nullable
              as String,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      chats: null == chats
          ? _value.chats
          : chats // ignore: cast_nullable_to_non_nullable
              as List<ChatRealm>,
    ));
  }
}

/// @nodoc

class _$_ChatState implements _ChatState {
  _$_ChatState(
      {this.myUserId = '', this.loading = false, this.chats = const []});

  @override
  @JsonKey()
  final String myUserId;
  @override
  @JsonKey()
  final bool loading;
  @override
  @JsonKey()
  final List<ChatRealm> chats;

  @override
  String toString() {
    return 'ChatState(myUserId: $myUserId, loading: $loading, chats: $chats)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ChatState &&
            (identical(other.myUserId, myUserId) ||
                other.myUserId == myUserId) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            const DeepCollectionEquality().equals(other.chats, chats));
  }

  @override
  int get hashCode => Object.hash(runtimeType, myUserId, loading,
      const DeepCollectionEquality().hash(chats));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ChatStateCopyWith<_$_ChatState> get copyWith =>
      __$$_ChatStateCopyWithImpl<_$_ChatState>(this, _$identity);
}

abstract class _ChatState implements ChatState {
  factory _ChatState(
      {final String myUserId,
      final bool loading,
      final List<ChatRealm> chats}) = _$_ChatState;

  @override
  String get myUserId;
  @override
  bool get loading;
  @override
  List<ChatRealm> get chats;
  @override
  @JsonKey(ignore: true)
  _$$_ChatStateCopyWith<_$_ChatState> get copyWith =>
      throw _privateConstructorUsedError;
}
