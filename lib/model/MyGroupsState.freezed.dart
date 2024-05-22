// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'MyGroupsState.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$MyGroupsState {
  String get myUserId => throw _privateConstructorUsedError;
  bool get loading => throw _privateConstructorUsedError;
  List<GroupAppwrite>? get groups => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MyGroupsStateCopyWith<MyGroupsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MyGroupsStateCopyWith<$Res> {
  factory $MyGroupsStateCopyWith(
          MyGroupsState value, $Res Function(MyGroupsState) then) =
      _$MyGroupsStateCopyWithImpl<$Res, MyGroupsState>;
  @useResult
  $Res call({String myUserId, bool loading, List<GroupAppwrite>? groups});
}

/// @nodoc
class _$MyGroupsStateCopyWithImpl<$Res, $Val extends MyGroupsState>
    implements $MyGroupsStateCopyWith<$Res> {
  _$MyGroupsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? myUserId = null,
    Object? loading = null,
    Object? groups = freezed,
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
      groups: freezed == groups
          ? _value.groups
          : groups // ignore: cast_nullable_to_non_nullable
              as List<GroupAppwrite>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_MyGroupsStateCopyWith<$Res>
    implements $MyGroupsStateCopyWith<$Res> {
  factory _$$_MyGroupsStateCopyWith(
          _$_MyGroupsState value, $Res Function(_$_MyGroupsState) then) =
      __$$_MyGroupsStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String myUserId, bool loading, List<GroupAppwrite>? groups});
}

/// @nodoc
class __$$_MyGroupsStateCopyWithImpl<$Res>
    extends _$MyGroupsStateCopyWithImpl<$Res, _$_MyGroupsState>
    implements _$$_MyGroupsStateCopyWith<$Res> {
  __$$_MyGroupsStateCopyWithImpl(
      _$_MyGroupsState _value, $Res Function(_$_MyGroupsState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? myUserId = null,
    Object? loading = null,
    Object? groups = freezed,
  }) {
    return _then(_$_MyGroupsState(
      myUserId: null == myUserId
          ? _value.myUserId
          : myUserId // ignore: cast_nullable_to_non_nullable
              as String,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      groups: freezed == groups
          ? _value.groups
          : groups // ignore: cast_nullable_to_non_nullable
              as List<GroupAppwrite>?,
    ));
  }
}

/// @nodoc

class _$_MyGroupsState implements _MyGroupsState {
  _$_MyGroupsState(
      {this.myUserId = '', this.loading = false, this.groups = null});

  @override
  @JsonKey()
  final String myUserId;
  @override
  @JsonKey()
  final bool loading;
  @override
  @JsonKey()
  final List<GroupAppwrite>? groups;

  @override
  String toString() {
    return 'MyGroupsState(myUserId: $myUserId, loading: $loading, groups: $groups)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MyGroupsState &&
            (identical(other.myUserId, myUserId) ||
                other.myUserId == myUserId) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            const DeepCollectionEquality().equals(other.groups, groups));
  }

  @override
  int get hashCode => Object.hash(runtimeType, myUserId, loading,
      const DeepCollectionEquality().hash(groups));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_MyGroupsStateCopyWith<_$_MyGroupsState> get copyWith =>
      __$$_MyGroupsStateCopyWithImpl<_$_MyGroupsState>(this, _$identity);
}

abstract class _MyGroupsState implements MyGroupsState {
  factory _MyGroupsState(
      {final String myUserId,
      final bool loading,
      final List<GroupAppwrite>? groups}) = _$_MyGroupsState;

  @override
  String get myUserId;
  @override
  bool get loading;
  @override
  List<GroupAppwrite>? get groups;
  @override
  @JsonKey(ignore: true)
  _$$_MyGroupsStateCopyWith<_$_MyGroupsState> get copyWith =>
      throw _privateConstructorUsedError;
}
