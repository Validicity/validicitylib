// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Project _$ProjectFromJson(Map<String, dynamic> json) {
  return Project(
    json['name'] as String,
  )
    ..id = json['id'] as int
    ..description = json['description'] as String
    ..created = json['created'] == null
        ? null
        : DateTime.parse(json['created'] as String)
    ..modified = json['modified'] == null
        ? null
        : DateTime.parse(json['modified'] as String);
}

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'created': instance.created?.toIso8601String(),
      'modified': instance.modified?.toIso8601String(),
    };
