// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'FriendState.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$FriendState {
  String get myUserId => throw _privateConstructorUsedError;
  bool get loading => throw _privateConstructorUsedError;
  List<FriendContactRealm> get friends => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FriendStateCopyWith<FriendState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendStateCopyWith<$Res> {
  factory $FriendStateCopyWith(
          FriendState value, $Res Function(FriendState) then) =
      _$FriendStateCopyWithImpl<$Res, FriendState>;
  @useResult
  $Res call({String myUserId, bool loading, List<FriendContactRealm> friends});
}

/// @nodoc
class _$FriendStateCopyWithImpl<$Res, $Val extends FriendState>
    implements $FriendStateCopyWith<$Res> {
  _$FriendStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? myUserId = null,
    Object? loading = null,
    Object? friends = null,
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
      friends: null == friends
          ? _value.friends
          : friends // ignore: cast_nullable_to_non_nullable
              as List<FriendContactRealm>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_FriendStateCopyWith<$Res>
    implements $FriendStateCopyWith<$Res> {
  factory _$$_FriendStateCopyWith(
          _$_FriendState value, $Res Function(_$_FriendState) then) =
      __$$_FriendStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String myUserId, bool loading, List<FriendContactRealm> friends});
}

/// @nodoc
class __$$_FriendStateCopyWithImpl<$Res>
    extends _$FriendStateCopyWithImpl<$Res, _$_FriendState>
    implements _$$_FriendStateCopyWith<$Res> {
  __$$_FriendStateCopyWithImpl(
      _$_FriendState _value, $Res Function(_$_FriendState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? myUserId = null,
    Object? loading = null,
    Object? friends = null,
  }) {
    return _then(_$_FriendState(
      myUserId: null == myUserId
          ? _value.myUserId
          : myUserId // ignore: cast_nullable_to_non_nullable
              as String,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      friends: null == friends
          ? _value.friends
          : friends // ignore: cast_nullable_to_non_nullable
              as List<FriendContactRealm>,
    ));
  }
}

/// @nodoc

class _$_FriendState implements _FriendState {
  _$_FriendState(
      {this.myUserId = '', this.loading = false, this.friends = const []});

  @override
  @JsonKey()
  final String myUserId;
  @override
  @JsonKey()
  final bool loading;
  @override
  @JsonKey()
  final List<FriendContactRealm> friends;

  @override
  String toString() {
    return 'FriendState(myUserId: $myUserId, loading: $loading, friends: $friends)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FriendState &&
            (identical(other.myUserId, myUserId) ||
                other.myUserId == myUserId) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            const DeepCollectionEquality().equals(other.friends, friends));
  }

  @override
  int get hashCode => Object.hash(runtimeType, myUserId, loading,
      const DeepCollectionEquality().hash(friends));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FriendStateCopyWith<_$_FriendState> get copyWith =>
      __$$_FriendStateCopyWithImpl<_$_FriendState>(this, _$identity);
}

abstract class _FriendState implements FriendState {
  factory _FriendState(
      {final String myUserId,
      final bool loading,
      final List<FriendContactRealm> friends}) = _$_FriendState;

  @override
  String get myUserId;
  @override
  bool get loading;
  @override
  List<FriendContactRealm> get friends;
  @override
  @JsonKey(ignore: true)
  _$$_FriendStateCopyWith<_$_FriendState> get copyWith =>
      throw _privateConstructorUsedError;
}
