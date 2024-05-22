// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GroupUserModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupUserModel _$GroupUserModelFromJson(Map<String, dynamic> json) =>
    GroupUserModel(
      memberUserId: json['memberUserId'] as String?,
      base64Image: json['base64Image'] as String?,
      selected: json['selected'] as bool?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$GroupUserModelToJson(GroupUserModel instance) =>
    <String, dynamic>{
      'memberUserId': instance.memberUserId,
      'selected': instance.selected,
      'base64Image': instance.base64Image,
      'name': instance.name,
    };
