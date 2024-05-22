// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'GroupDetailsState.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$GroupDetailsState {
  String get myUserId => throw _privateConstructorUsedError;
  bool get loading => throw _privateConstructorUsedError;
  List<GroupMemberAppwrite>? get members => throw _privateConstructorUsedError;
  GroupAppwrite? get group => throw _privateConstructorUsedError;
  String? get fileName => throw _privateConstructorUsedError;
  Uint8List? get image => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GroupDetailsStateCopyWith<GroupDetailsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupDetailsStateCopyWith<$Res> {
  factory $GroupDetailsStateCopyWith(
          GroupDetailsState value, $Res Function(GroupDetailsState) then) =
      _$GroupDetailsStateCopyWithImpl<$Res, GroupDetailsState>;
  @useResult
  $Res call(
      {String myUserId,
      bool loading,
      List<GroupMemberAppwrite>? members,
      GroupAppwrite? group,
      String? fileName,
      Uint8List? image});
}

/// @nodoc
class _$GroupDetailsStateCopyWithImpl<$Res, $Val extends GroupDetailsState>
    implements $GroupDetailsStateCopyWith<$Res> {
  _$GroupDetailsStateCopyWithImpl(this._value, this._then);

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
    Object? group = freezed,
    Object? fileName = freezed,
    Object? image = freezed,
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
      group: freezed == group
          ? _value.group
          : group // ignore: cast_nullable_to_non_nullable
              as GroupAppwrite?,
      fileName: freezed == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_GroupDetailsStateCopyWith<$Res>
    implements $GroupDetailsStateCopyWith<$Res> {
  factory _$$_GroupDetailsStateCopyWith(_$_GroupDetailsState value,
          $Res Function(_$_GroupDetailsState) then) =
      __$$_GroupDetailsStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String myUserId,
      bool loading,
      List<GroupMemberAppwrite>? members,
      GroupAppwrite? group,
      String? fileName,
      Uint8List? image});
}

/// @nodoc
class __$$_GroupDetailsStateCopyWithImpl<$Res>
    extends _$GroupDetailsStateCopyWithImpl<$Res, _$_GroupDetailsState>
    implements _$$_GroupDetailsStateCopyWith<$Res> {
  __$$_GroupDetailsStateCopyWithImpl(
      _$_GroupDetailsState _value, $Res Function(_$_GroupDetailsState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? myUserId = null,
    Object? loading = null,
    Object? members = freezed,
    Object? group = freezed,
    Object? fileName = freezed,
    Object? image = freezed,
  }) {
    return _then(_$_GroupDetailsState(
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
      group: freezed == group
          ? _value.group
          : group // ignore: cast_nullable_to_non_nullable
              as GroupAppwrite?,
      fileName: freezed == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
    ));
  }
}

/// @nodoc

class _$_GroupDetailsState implements _GroupDetailsState {
  _$_GroupDetailsState(
      {this.myUserId = '',
      this.loading = false,
      this.members = null,
      this.group = null,
      this.fileName = null,
      this.image = null});

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
  final GroupAppwrite? group;
  @override
  @JsonKey()
  final String? fileName;
  @override
  @JsonKey()
  final Uint8List? image;

  @override
  String toString() {
    return 'GroupDetailsState(myUserId: $myUserId, loading: $loading, members: $members, group: $group, fileName: $fileName, image: $image)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GroupDetailsState &&
            (identical(other.myUserId, myUserId) ||
                other.myUserId == myUserId) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            const DeepCollectionEquality().equals(other.members, members) &&
            (identical(other.group, group) || other.group == group) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            const DeepCollectionEquality().equals(other.image, image));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      myUserId,
      loading,
      const DeepCollectionEquality().hash(members),
      group,
      fileName,
      const DeepCollectionEquality().hash(image));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GroupDetailsStateCopyWith<_$_GroupDetailsState> get copyWith =>
      __$$_GroupDetailsStateCopyWithImpl<_$_GroupDetailsState>(
          this, _$identity);
}

abstract class _GroupDetailsState implements GroupDetailsState {
  factory _GroupDetailsState(
      {final String myUserId,
      final bool loading,
      final List<GroupMemberAppwrite>? members,
      final GroupAppwrite? group,
      final String? fileName,
      final Uint8List? image}) = _$_GroupDetailsState;

  @override
  String get myUserId;
  @override
  bool get loading;
  @override
  List<GroupMemberAppwrite>? get members;
  @override
  GroupAppwrite? get group;
  @override
  String? get fileName;
  @override
  Uint8List? get image;
  @override
  @JsonKey(ignore: true)
  _$$_GroupDetailsStateCopyWith<_$_GroupDetailsState> get copyWith =>
      throw _privateConstructorUsedError;
}
