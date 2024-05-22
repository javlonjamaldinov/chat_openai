// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'GroupMessageDetailsState.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$GroupMessageDetailsState {
  String get myUserId => throw _privateConstructorUsedError;
  bool get loading => throw _privateConstructorUsedError;
  List<GroupMemberAppwrite>? get members => throw _privateConstructorUsedError;
  List<GroupMessageInfoAppwrite>? get deliveredToMembers =>
      throw _privateConstructorUsedError;
  List<GroupMessageInfoAppwrite>? get readsToMembers =>
      throw _privateConstructorUsedError;
  GroupAppwrite? get group => throw _privateConstructorUsedError;
  MessageRealm? get message => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GroupMessageDetailsStateCopyWith<GroupMessageDetailsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupMessageDetailsStateCopyWith<$Res> {
  factory $GroupMessageDetailsStateCopyWith(GroupMessageDetailsState value,
          $Res Function(GroupMessageDetailsState) then) =
      _$GroupMessageDetailsStateCopyWithImpl<$Res, GroupMessageDetailsState>;
  @useResult
  $Res call(
      {String myUserId,
      bool loading,
      List<GroupMemberAppwrite>? members,
      List<GroupMessageInfoAppwrite>? deliveredToMembers,
      List<GroupMessageInfoAppwrite>? readsToMembers,
      GroupAppwrite? group,
      MessageRealm? message});
}

/// @nodoc
class _$GroupMessageDetailsStateCopyWithImpl<$Res,
        $Val extends GroupMessageDetailsState>
    implements $GroupMessageDetailsStateCopyWith<$Res> {
  _$GroupMessageDetailsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? myUserId = null,
    Object? loading = null,
    Object? members = freezed,
    Object? deliveredToMembers = freezed,
    Object? readsToMembers = freezed,
    Object? group = freezed,
    Object? message = freezed,
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
      members: freezed == members
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<GroupMemberAppwrite>?,
      deliveredToMembers: freezed == deliveredToMembers
          ? _value.deliveredToMembers
          : deliveredToMembers // ignore: cast_nullable_to_non_nullable
              as List<GroupMessageInfoAppwrite>?,
      readsToMembers: freezed == readsToMembers
          ? _value.readsToMembers
          : readsToMembers // ignore: cast_nullable_to_non_nullable
              as List<GroupMessageInfoAppwrite>?,
      group: freezed == group
          ? _value.group
          : group // ignore: cast_nullable_to_non_nullable
              as GroupAppwrite?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as MessageRealm?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_GroupMessageDetailsStateCopyWith<$Res>
    implements $GroupMessageDetailsStateCopyWith<$Res> {
  factory _$$_GroupMessageDetailsStateCopyWith(
          _$_GroupMessageDetailsState value,
          $Res Function(_$_GroupMessageDetailsState) then) =
      __$$_GroupMessageDetailsStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String myUserId,
      bool loading,
      List<GroupMemberAppwrite>? members,
      List<GroupMessageInfoAppwrite>? deliveredToMembers,
      List<GroupMessageInfoAppwrite>? readsToMembers,
      GroupAppwrite? group,
      MessageRealm? message});
}

/// @nodoc
class __$$_GroupMessageDetailsStateCopyWithImpl<$Res>
    extends _$GroupMessageDetailsStateCopyWithImpl<$Res,
        _$_GroupMessageDetailsState>
    implements _$$_GroupMessageDetailsStateCopyWith<$Res> {
  __$$_GroupMessageDetailsStateCopyWithImpl(_$_GroupMessageDetailsState _value,
      $Res Function(_$_GroupMessageDetailsState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? myUserId = null,
    Object? loading = null,
    Object? members = freezed,
    Object? deliveredToMembers = freezed,
    Object? readsToMembers = freezed,
    Object? group = freezed,
    Object? message = freezed,
  }) {
    return _then(_$_GroupMessageDetailsState(
      myUserId: null == myUserId
          ? _value.myUserId
          : myUserId // ignore: cast_nullable_to_non_nullable
              as String,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      members: freezed == members
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<GroupMemberAppwrite>?,
      deliveredToMembers: freezed == deliveredToMembers
          ? _value.deliveredToMembers
          : deliveredToMembers // ignore: cast_nullable_to_non_nullable
              as List<GroupMessageInfoAppwrite>?,
      readsToMembers: freezed == readsToMembers
          ? _value.readsToMembers
          : readsToMembers // ignore: cast_nullable_to_non_nullable
              as List<GroupMessageInfoAppwrite>?,
      group: freezed == group
          ? _value.group
          : group // ignore: cast_nullable_to_non_nullable
              as GroupAppwrite?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as MessageRealm?,
    ));
  }
}

/// @nodoc

class _$_GroupMessageDetailsState implements _GroupMessageDetailsState {
  _$_GroupMessageDetailsState(
      {this.myUserId = '',
      this.loading = false,
      this.members = null,
      this.deliveredToMembers = null,
      this.readsToMembers = null,
      this.group = null,
      this.message = null});

  @override
  @JsonKey()
  final String myUserId;
  @override
  @JsonKey()
  final bool loading;
  @override
  @JsonKey()
  final List<GroupMemberAppwrite>? members;
  @override
  @JsonKey()
  final List<GroupMessageInfoAppwrite>? deliveredToMembers;
  @override
  @JsonKey()
  final List<GroupMessageInfoAppwrite>? readsToMembers;
  @override
  @JsonKey()
  final GroupAppwrite? group;
  @override
  @JsonKey()
  final MessageRealm? message;

  @override
  String toString() {
    return 'GroupMessageDetailsState(myUserId: $myUserId, loading: $loading, members: $members, deliveredToMembers: $deliveredToMembers, readsToMembers: $readsToMembers, group: $group, message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GroupMessageDetailsState &&
            (identical(other.myUserId, myUserId) ||
                other.myUserId == myUserId) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            const DeepCollectionEquality().equals(other.members, members) &&
            const DeepCollectionEquality()
                .equals(other.deliveredToMembers, deliveredToMembers) &&
            const DeepCollectionEquality()
                .equals(other.readsToMembers, readsToMembers) &&
            (identical(other.group, group) || other.group == group) &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      myUserId,
      loading,
      const DeepCollectionEquality().hash(members),
      const DeepCollectionEquality().hash(deliveredToMembers),
      const DeepCollectionEquality().hash(readsToMembers),
      group,
      const DeepCollectionEquality().hash(message));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GroupMessageDetailsStateCopyWith<_$_GroupMessageDetailsState>
      get copyWith => __$$_GroupMessageDetailsStateCopyWithImpl<
          _$_GroupMessageDetailsState>(this, _$identity);
}

abstract class _GroupMessageDetailsState implements GroupMessageDetailsState {
  factory _GroupMessageDetailsState(
      {final String myUserId,
      final bool loading,
      final List<GroupMemberAppwrite>? members,
      final List<GroupMessageInfoAppwrite>? deliveredToMembers,
      final List<GroupMessageInfoAppwrite>? readsToMembers,
      final GroupAppwrite? group,
      final MessageRealm? message}) = _$_GroupMessageDetailsState;

  @override
  String get myUserId;
  @override
  bool get loading;
  @override
  List<GroupMemberAppwrite>? get members;
  @override
  List<GroupMessageInfoAppwrite>? get deliveredToMembers;
  @override
  List<GroupMessageInfoAppwrite>? get readsToMembers;
  @override
  GroupAppwrite? get group;
  @override
  MessageRealm? get message;
  @override
  @JsonKey(ignore: true)
  _$$_GroupMessageDetailsStateCopyWith<_$_GroupMessageDetailsState>
      get copyWith => throw _privateConstructorUsedError;
}
