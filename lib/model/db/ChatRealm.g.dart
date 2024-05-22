// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ChatRealm.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class ChatRealm extends _ChatRealm
    with RealmEntity, RealmObjectBase, RealmObject {
  ChatRealm(
    ObjectId id, {
    String? senderUserId,
    String? receiverUserId,
    String? message,
    String? type,
    DateTime? sendDate,
    bool? read,
    String? key,
    String? displayName,
    String? base64Image,
    int? count,
    String? messageIdUpstream,
    bool? delivered,
    String? userId,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'senderUserId', senderUserId);
    RealmObjectBase.set(this, 'receiverUserId', receiverUserId);
    RealmObjectBase.set(this, 'message', message);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'sendDate', sendDate);
    RealmObjectBase.set(this, 'read', read);
    RealmObjectBase.set(this, 'key', key);
    RealmObjectBase.set(this, 'displayName', displayName);
    RealmObjectBase.set(this, 'base64Image', base64Image);
    RealmObjectBase.set(this, 'count', count);
    RealmObjectBase.set(this, 'messageIdUpstream', messageIdUpstream);
    RealmObjectBase.set(this, 'delivered', delivered);
    RealmObjectBase.set(this, 'userId', userId);
  }

  ChatRealm._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  String? get senderUserId =>
      RealmObjectBase.get<String>(this, 'senderUserId') as String?;
  @override
  set senderUserId(String? value) =>
      RealmObjectBase.set(this, 'senderUserId', value);

  @override
  String? get receiverUserId =>
      RealmObjectBase.get<String>(this, 'receiverUserId') as String?;
  @override
  set receiverUserId(String? value) =>
      RealmObjectBase.set(this, 'receiverUserId', value);

  @override
  String? get message =>
      RealmObjectBase.get<String>(this, 'message') as String?;
  @override
  set message(String? value) => RealmObjectBase.set(this, 'message', value);

  @override
  String? get type => RealmObjectBase.get<String>(this, 'type') as String?;
  @override
  set type(String? value) => RealmObjectBase.set(this, 'type', value);

  @override
  DateTime? get sendDate =>
      RealmObjectBase.get<DateTime>(this, 'sendDate') as DateTime?;
  @override
  set sendDate(DateTime? value) => RealmObjectBase.set(this, 'sendDate', value);

  @override
  bool? get read => RealmObjectBase.get<bool>(this, 'read') as bool?;
  @override
  set read(bool? value) => RealmObjectBase.set(this, 'read', value);

  @override
  String? get key => RealmObjectBase.get<String>(this, 'key') as String?;
  @override
  set key(String? value) => RealmObjectBase.set(this, 'key', value);

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
  int? get count => RealmObjectBase.get<int>(this, 'count') as int?;
  @override
  set count(int? value) => RealmObjectBase.set(this, 'count', value);

  @override
  String? get messageIdUpstream =>
      RealmObjectBase.get<String>(this, 'messageIdUpstream') as String?;
  @override
  set messageIdUpstream(String? value) =>
      RealmObjectBase.set(this, 'messageIdUpstream', value);

  @override
  bool? get delivered => RealmObjectBase.get<bool>(this, 'delivered') as bool?;
  @override
  set delivered(bool? value) => RealmObjectBase.set(this, 'delivered', value);

  @override
  String? get userId => RealmObjectBase.get<String>(this, 'userId') as String?;
  @override
  set userId(String? value) => RealmObjectBase.set(this, 'userId', value);

  @override
  Stream<RealmObjectChanges<ChatRealm>> get changes =>
      RealmObjectBase.getChanges<ChatRealm>(this);

  @override
  ChatRealm freeze() => RealmObjectBase.freezeObject<ChatRealm>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(ChatRealm._);
    return const SchemaObject(ObjectType.realmObject, ChatRealm, 'ChatRealm', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('senderUserId', RealmPropertyType.string, optional: true),
      SchemaProperty('receiverUserId', RealmPropertyType.string,
          optional: true),
      SchemaProperty('message', RealmPropertyType.string, optional: true),
      SchemaProperty('type', RealmPropertyType.string, optional: true),
      SchemaProperty('sendDate', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('read', RealmPropertyType.bool, optional: true),
      SchemaProperty('key', RealmPropertyType.string, optional: true),
      SchemaProperty('displayName', RealmPropertyType.string, optional: true),
      SchemaProperty('base64Image', RealmPropertyType.string, optional: true),
      SchemaProperty('count', RealmPropertyType.int, optional: true),
      SchemaProperty('messageIdUpstream', RealmPropertyType.string,
          optional: true),
      SchemaProperty('delivered', RealmPropertyType.bool, optional: true),
      SchemaProperty('userId', RealmPropertyType.string, optional: true),
    ]);
  }
}
