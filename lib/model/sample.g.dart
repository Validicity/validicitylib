// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sample.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sample _$SampleFromJson(Map<String, dynamic> json) {
  return Sample()
    ..id = json['id'] as int
    ..created = json['created'] == null
        ? null
        : DateTime.parse(json['created'] as String)
    ..modified = json['modified'] == null
        ? null
        : DateTime.parse(json['modified'] as String)
    ..hash = json['hash'] as String
    ..previous = json['previous'] as String
    ..signature = json['signature'] as String
    ..publicKey = json['publicKey'] as String
    ..serial = json['serial'] as String
    ..state = _$enumDecodeNullable(_$SampleStateEnumMap, json['state']);
}

Map<String, dynamic> _$SampleToJson(Sample instance) => <String, dynamic>{
      'id': instance.id,
      'created': instance.created?.toIso8601String(),
      'modified': instance.modified?.toIso8601String(),
      'hash': instance.hash,
      'previous': instance.previous,
      'signature': instance.signature,
      'publicKey': instance.publicKey,
      'serial': instance.serial,
      'state': _$SampleStateEnumMap[instance.state],
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

const _$SampleStateEnumMap = {
  SampleState.registered: 'registered',
  SampleState.assigned: 'assigned',
  SampleState.used: 'used',
  SampleState.destructed: 'destructed',
};