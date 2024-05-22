// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FriendContactRealm.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class FriendContactRealm extends _FriendContactRealm
    with RealmEntity, RealmObjectBase, RealmObject {
  FriendContactRealm(
    ObjectId id, {
    String? userId,
    String? mobileNumber,
    String? displayName,
    String? base64Image,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(this, 'mobileNumber', mobileNumber);
    RealmObjectBase.set(this, 'displayName', displayName);
    RealmObjectBase.set(this, 'base64Image', base64Image);
  }

  FriendContactRealm._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  String? get userId => RealmObjectBase.get<String>(this, 'userId') as String?;
  @override
  set userId(String? value) => RealmObjectBase.set(this, 'userId', value);

  @override
  String? get mobileNumber =>
      RealmObjectBase.get<String>(this, 'mobileNumber') as String?;
  @override
  set mobileNumber(String? value) =>
      RealmObjectBase.set(this, 'mobileNumber', value);

  @override
  String? get displayName =>
      RealmObjectBase.get<String>(this, 'displayName') as String?;
  @override
  set displayName(String? value) =>
      RealmObjectBase.set(this, 'displayName', value);

  @override
  String? get base64Image =>
      RealmObjectBase.get<String>(this, 'base64Image') as String?;
  @override
  set base64Image(String? value) =>
      RealmObjectBase.set(this, 'base64Image', value);

  @override
  Stream<RealmObjectChanges<FriendContactRealm>> get changes =>
      RealmObjectBase.getChanges<FriendContactRealm>(this);

  @override
  FriendContactRealm freeze() =>
      RealmObjectBase.freezeObject<FriendContactRealm>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(FriendContactRealm._);
    return const SchemaObject(
        ObjectType.realmObject, FriendContactRealm, 'FriendContactRealm', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('userId', RealmPropertyType.string, optional: true),
      SchemaProperty('mobileNumber', RealmPropertyType.string, optional: true),
      SchemaProperty('displayName', RealmPropertyType.string, optional: true),
      SchemaProperty('base64Image', RealmPropertyType.string, optional: true),
    ]);
  }
}
