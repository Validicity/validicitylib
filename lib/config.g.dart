// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ValidicitylibConfiguration _$ValidicitylibConfigurationFromJson(Map json) {
  return $checkedNew('ValidicitylibConfiguration', json, () {
    $checkKeys(json, allowedKeys: const [
      'path',
      'verbose',
      'pretty',
      'mqtt',
      'api',
      'logging'
    ]);
    final val = ValidicitylibConfiguration();
    $checkedConvert(json, 'path', (v) => val.path = v as String);
    $checkedConvert(json, 'verbose', (v) => val.verbose = v as bool);
    $checkedConvert(json, 'pretty', (v) => val.pretty = v as bool);
    $checkedConvert(
        json, 'mqtt', (v) => val.mqtt = MqttConfiguration.fromJson(v as Map));
    $checkedConvert(json, 'api',
        (v) => val.api = ValidicityServerAPIConfiguration.fromJson(v as Map));
    $checkedConvert(json, 'logging',
        (v) => val.logging = LoggingConfiguration.fromJson(v as Map));
    return val;
  });
}

Map<String, dynamic> _$ValidicitylibConfigurationToJson(
        ValidicitylibConfiguration instance) =>
    <String, dynamic>{
      'path': instance.path,
      'verbose': instance.verbose,
      'pretty': instance.pretty,
      'mqtt': instance.mqtt,
      'api': instance.api,
      'logging': instance.logging,
    };

LoggingConfiguration _$LoggingConfigurationFromJson(Map json) {
  return $checkedNew('LoggingConfiguration', json, () {
    $checkKeys(json, allowedKeys: const ['level']);
    final val = LoggingConfiguration();
    $checkedConvert(json, 'level', (v) => val.level = v as String);
    return val;
  });
}

Map<String, dynamic> _$LoggingConfigurationToJson(
        LoggingConfiguration instance) =>
    <String, dynamic>{
      'level': instance.level,
    };
