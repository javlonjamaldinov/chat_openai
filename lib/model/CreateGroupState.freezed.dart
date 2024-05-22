// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'CreateGroupState.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$CreateGroupState {
  String get myUserId => throw _privateConstructorUsedError;
  bool get loading => throw _privateConstructorUsedError;
  GroupAppwrite? get group => throw _privateConstructorUsedError;
  List<GroupUserModel>? get members => throw _privateConstructorUsedError;
  List<GroupUserModel>? get allFriends => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CreateGroupStateCopyWith<CreateGroupState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateGroupStateCopyWith<$Res> {
  factory $CreateGroupStateCopyWith(
          CreateGroupState value, $Res Function(CreateGroupState) then) =
      _$CreateGroupStateCopyWithImpl<$Res, CreateGroupState>;
  @useResult
  $Res call(
      {String myUserId,
      bool loading,
      GroupAppwrite? group,
      List<GroupUserModel>? members,
      List<GroupUserModel>? allFriends});
}

/// @nodoc
class _$CreateGroupStateCopyWithImpl<$Res, $Val extends CreateGroupState>
    implements $CreateGroupStateCopyWith<$Res> {
  _$CreateGroupStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? myUserId = null,
    Object? loading = null,
    Object? group = freezed,
    Object? members = freezed,
    Object? allFriends = freezed,
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
      group: freezed == group
          ? _value.group
          : group // ignore: cast_nullable_to_non_nullable
              as GroupAppwrite?,
      members: freezed == members
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<GroupUserModel>?,
      allFriends: freezed == allFriends
          ? _value.allFriends
          : allFriends // ignore: cast_nullable_to_non_nullable
              as List<GroupUserModel>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_CreateGroupStateCopyWith<$Res>
    implements $CreateGroupStateCopyWith<$Res> {
  factory _$$_CreateGroupStateCopyWith(
          _$_CreateGroupState value, $Res Function(_$_CreateGroupState) then) =
      __$$_CreateGroupStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String myUserId,
      bool loading,
      GroupAppwrite? group,
      List<GroupUserModel>? members,
      List<GroupUserModel>? allFriends});
}

/// @nodoc
class __$$_CreateGroupStateCopyWithImpl<$Res>
    extends _$CreateGroupStateCopyWithImpl<$Res, _$_CreateGroupState>
    implements _$$_CreateGroupStateCopyWith<$Res> {
  __$$_CreateGroupStateCopyWithImpl(
      _$_CreateGroupState _value, $Res Function(_$_CreateGroupState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? myUserId = null,
    Object? loading = null,
    Object? group = freezed,
    Object? members = freezed,
    Object? allFriends = freezed,
  }) {
    return _then(_$_CreateGroupState(
      myUserId: null == myUserId
          ? _value.myUserId
          : myUserId // ignore: cast_nullable_to_non_nullable
              as String,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      group: freezed == group
          ? _value.group
          : group // ignore: cast_nullable_to_non_nullable
              as GroupAppwrite?,
      members: freezed == members
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<GroupUserModel>?,
      allFriends: freezed == allFriends
          ? _value.allFriends
          : allFriends // ignore: cast_nullable_to_non_nullable
              as List<GroupUserModel>?,
    ));
  }
}

/// @nodoc

class _$_CreateGroupState implements _CreateGroupState {
  _$_CreateGroupState(
      {this.myUserId = '',
      this.loading = false,
      this.group = null,
      this.members = null,
      this.allFriends = null});

  @override
  @JsonKey()
  final String myUserId;
  @override
  @JsonKey()
  final bool loading;
  @override
  @JsonKey()
  final GroupAppwrite? group;
  @override
  @JsonKey()
  final List<GroupUserModel>? members;
  @override
  @JsonKey()
  final List<GroupUserModel>? allFriends;

  @override
  String toString() {
    return 'CreateGroupState(myUserId: $myUserId, loading: $loading, group: $group, members: $members, allFriends: $allFriends)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CreateGroupState &&
            (identical(other.myUserId, myUserId) ||
                other.myUserId == myUserId) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.group, group) || other.group == group) &&
            const DeepCollectionEquality().equals(other.members, members) &&
            const DeepCollectionEquality()
                .equals(other.allFriends, allFriends));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      myUserId,
      loading,
      group,
      const DeepCollectionEquality().hash(members),
      const DeepCollectionEquality().hash(allFriends));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CreateGroupStateCopyWith<_$_CreateGroupState> get copyWith =>
      __$$_CreateGroupStateCopyWithImpl<_$_CreateGroupState>(this, _$identity);
}

abstract class _CreateGroupState implements CreateGroupState {
  factory _CreateGroupState(
      {final String myUserId,
      final bool loading,
      final GroupAppwrite? group,
      final List<GroupUserModel>? members,
      final List<GroupUserModel>? allFriends}) = _$_CreateGroupState;

  @override
  String get myUserId;
  @override
  bool get loading;
  @override
  GroupAppwrite? get group;
  @override
  List<GroupUserModel>? get members;
  @override
  List<GroupUserModel>? get allFriends;
  @override
  @JsonKey(ignore: true)
  _$$_CreateGroupStateCopyWith<_$_CreateGroupState> get copyWith =>
      throw _privateConstructorUsedError;
}
