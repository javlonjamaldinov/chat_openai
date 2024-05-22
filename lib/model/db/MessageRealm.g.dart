// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MessageRealm.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class MessageRealm extends _MessageRealm
    with RealmEntity, RealmObjectBase, RealmObject {
  MessageRealm(
    ObjectId id, {
    String? senderUserId,
    String? receiverUserId,
    String? message,
    String? type,
    DateTime? sendDate,
    bool? read,
    String? localPath,
    String? previewBase64,
    String? fileName,
    String? messageIdUpstream,
    bool? delivered,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'senderUserId', senderUserId);
    RealmObjectBase.set(this, 'receiverUserId', receiverUserId);
    RealmObjectBase.set(this, 'message', message);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'sendDate', sendDate);
    RealmObjectBase.set(this, 'read', read);
    RealmObjectBase.set(this, 'localPath', localPath);
    RealmObjectBase.set(this, 'previewBase64', previewBase64);
    RealmObjectBase.set(this, 'fileName', fileName);
    RealmObjectBase.set(this, 'messageIdUpstream', messageIdUpstream);
    RealmObjectBase.set(this, 'delivered', delivered);
  }

  MessageRealm._();

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
  String? get localPath =>
      RealmObjectBase.get<String>(this, 'localPath') as String?;
  @override
  set localPath(String? value) => RealmObjectBase.set(this, 'localPath', value);

  @override
  String? get previewBase64 =>
      RealmObjectBase.get<String>(this, 'previewBase64') as String?;
  @override
  set previewBase64(String? value) =>
      RealmObjectBase.set(this, 'previewBase64', value);

  @override
  String? get fileName =>
      RealmObjectBase.get<String>(this, 'fileName') as String?;
  @override
  set fileName(String? value) => RealmObjectBase.set(this, 'fileName', value);

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
  Stream<RealmObjectChanges<MessageRealm>> get changes =>
      RealmObjectBase.getChanges<MessageRealm>(this);

  @override
  MessageRealm freeze() => RealmObjectBase.freezeObject<MessageRealm>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(MessageRealm._);
    return const SchemaObject(
        ObjectType.realmObject, MessageRealm, 'MessageRealm', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('senderUserId', RealmPropertyType.string, optional: true),
      SchemaProperty('receiverUserId', RealmPropertyType.string,
          optional: true),
      SchemaProperty('message', RealmPropertyType.string, optional: true),
      SchemaProperty('type', RealmPropertyType.string, optional: true),
      SchemaProperty('sendDate', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('read', RealmPropertyType.bool, optional: true),
      SchemaProperty('localPath', RealmPropertyType.string, optional: true),
      SchemaProperty('previewBase64', RealmPropertyType.string, optional: true),
      SchemaProperty('fileName', RealmPropertyType.string, optional: true),
      SchemaProperty('messageIdUpstream', RealmPropertyType.string,
          optional: true),
      SchemaProperty('delivered', RealmPropertyType.bool, optional: true),
    ]);
  }
}
