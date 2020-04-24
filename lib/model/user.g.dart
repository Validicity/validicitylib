// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['name'] as String,
    json['email'] as String,
  )
    ..id = json['id'] as int
    ..username = json['username'] as String
    ..created = json['created'] == null
        ? null
        : DateTime.parse(json['created'] as String)
    ..modified = json['modified'] == null
        ? null
        : DateTime.parse(json['modified'] as String)
    ..type = _$enumDecodeNullable(_$UserTypeEnumMap, json['type'])
    ..userProjects = User.flatten(json['userProjects'] as List);
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'username': instance.username,
      'created': instance.created?.toIso8601String(),
      'modified': instance.modified?.toIso8601String(),
      'type': _$UserTypeEnumMap[instance.type],
      'userProjects': instance.userProjects,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$UserTypeEnumMap = {
  UserType.admin: 'admin',
  UserType.client: 'client',
  UserType.user: 'user',
  UserType.superuser: 'superuser',
};
