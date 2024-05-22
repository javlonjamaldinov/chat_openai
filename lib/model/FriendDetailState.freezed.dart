// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'FriendDetailState.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$FriendDetailState {
  String get myUserId => throw _privateConstructorUsedError;
  String? get friendUserId => throw _privateConstructorUsedError;
  UserAppwrite? get friendUserAppwrite => throw _privateConstructorUsedError;
  List<BlockedFriendAppwrite>? get blockedFriends =>
      throw _privateConstructorUsedError;
  bool get friendBlocked => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FriendDetailStateCopyWith<FriendDetailState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendDetailStateCopyWith<$Res> {
  factory $FriendDetailStateCopyWith(
          FriendDetailState value, $Res Function(FriendDetailState) then) =
      _$FriendDetailStateCopyWithImpl<$Res, FriendDetailState>;
  @useResult
  $Res call(
      {String myUserId,
      String? friendUserId,
      UserAppwrite? friendUserAppwrite,
      List<BlockedFriendAppwrite>? blockedFriends,
      bool friendBlocked});
}

/// @nodoc
class _$FriendDetailStateCopyWithImpl<$Res, $Val extends FriendDetailState>
    implements $FriendDetailStateCopyWith<$Res> {
  _$FriendDetailStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? myUserId = null,
    Object? friendUserId = freezed,
    Object? friendUserAppwrite = freezed,
    Object? blockedFriends = freezed,
    Object? friendBlocked = null,
  }) {
    return _then(_value.copyWith(
      myUserId: null == myUserId
          ? _value.myUserId
          : myUserId // ignore: cast_nullable_to_non_nullable
              as String,
      friendUserId: freezed == friendUserId
          ? _value.friendUserId
          : friendUserId // ignore: cast_nullable_to_non_nullable
              as String?,
      friendUserAppwrite: freezed == friendUserAppwrite
          ? _value.friendUserAppwrite
          : friendUserAppwrite // ignore: cast_nullable_to_non_nullable
              as UserAppwrite?,
      blockedFriends: freezed == blockedFriends
          ? _value.blockedFriends
          : blockedFriends // ignore: cast_nullable_to_non_nullable
              as List<BlockedFriendAppwrite>?,
      friendBlocked: null == friendBlocked
          ? _value.friendBlocked
          : friendBlocked // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_FriendDetailStateCopyWith<$Res>
    implements $FriendDetailStateCopyWith<$Res> {
  factory _$$_FriendDetailStateCopyWith(_$_FriendDetailState value,
          $Res Function(_$_FriendDetailState) then) =
      __$$_FriendDetailStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String myUserId,
      String? friendUserId,
      UserAppwrite? friendUserAppwrite,
      List<BlockedFriendAppwrite>? blockedFriends,
      bool friendBlocked});
}

/// @nodoc
class __$$_FriendDetailStateCopyWithImpl<$Res>
    extends _$FriendDetailStateCopyWithImpl<$Res, _$_FriendDetailState>
    implements _$$_FriendDetailStateCopyWith<$Res> {
  __$$_FriendDetailStateCopyWithImpl(
      _$_FriendDetailState _value, $Res Function(_$_FriendDetailState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? myUserId = null,
    Object? friendUserId = freezed,
    Object? friendUserAppwrite = freezed,
    Object? blockedFriends = freezed,
    Object? friendBlocked = null,
  }) {
    return _then(_$_FriendDetailState(
      myUserId: null == myUserId
          ? _value.myUserId
          : myUserId // ignore: cast_nullable_to_non_nullable
              as String,
      friendUserId: freezed == friendUserId
          ? _value.friendUserId
          : friendUserId // ignore: cast_nullable_to_non_nullable
              as String?,
      friendUserAppwrite: freezed == friendUserAppwrite
          ? _value.friendUserAppwrite
          : friendUserAppwrite // ignore: cast_nullable_to_non_nullable
              as UserAppwrite?,
      blockedFriends: freezed == blockedFriends
          ? _value.blockedFriends
          : blockedFriends // ignore: cast_nullable_to_non_nullable
              as List<BlockedFriendAppwrite>?,
      friendBlocked: null == friendBlocked
          ? _value.friendBlocked
          : friendBlocked // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_FriendDetailState implements _FriendDetailState {
  _$_FriendDetailState(
      {this.myUserId = '',
      this.friendUserId = null,
      this.friendUserAppwrite = null,
      this.blockedFriends = null,
      this.friendBlocked = false});

  @override
  @JsonKey()
  final String myUserId;
  @override
  @JsonKey()
  final String? friendUserId;
  @override
  @JsonKey()
  final UserAppwrite? friendUserAppwrite;
  @override
  @JsonKey()
  final List<BlockedFriendAppwrite>? blockedFriends;
  @override
  @JsonKey()
  final bool friendBlocked;

  @override
  String toString() {
    return 'FriendDetailState(myUserId: $myUserId, friendUserId: $friendUserId, friendUserAppwrite: $friendUserAppwrite, blockedFriends: $blockedFriends, friendBlocked: $friendBlocked)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FriendDetailState &&
            (identical(other.myUserId, myUserId) ||
                other.myUserId == myUserId) &&
            (identical(other.friendUserId, friendUserId) ||
                other.friendUserId == friendUserId) &&
            (identical(other.friendUserAppwrite, friendUserAppwrite) ||
                other.friendUserAppwrite == friendUserAppwrite) &&
            const DeepCollectionEquality()
                .equals(other.blockedFriends, blockedFriends) &&
            (identical(other.friendBlocked, friendBlocked) ||
                other.friendBlocked == friendBlocked));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      myUserId,
      friendUserId,
      friendUserAppwrite,
      const DeepCollectionEquality().hash(blockedFriends),
      friendBlocked);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FriendDetailStateCopyWith<_$_FriendDetailState> get copyWith =>
      __$$_FriendDetailStateCopyWithImpl<_$_FriendDetailState>(
          this, _$identity);
}

abstract class _FriendDetailState implements FriendDetailState {
  factory _FriendDetailState(
      {final String myUserId,
      final String? friendUserId,
      final UserAppwrite? friendUserAppwrite,
      final List<BlockedFriendAppwrite>? blockedFriends,
      final bool friendBlocked}) = _$_FriendDetailState;

  @override
  String get myUserId;
  @override
  String? get friendUserId;
  @override
  UserAppwrite? get friendUserAppwrite;
  @override
  List<BlockedFriendAppwrite>? get blockedFriends;
  @override
  bool get friendBlocked;
  @override
  @JsonKey(ignore: true)
  _$$_FriendDetailStateCopyWith<_$_FriendDetailState> get copyWith =>
      throw _privateConstructorUsedError;
}
