// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mqtt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MqttConfiguration _$MqttConfigurationFromJson(Map json) {
  return $checkedNew('MqttConfiguration', json, () {
    $checkKeys(json, allowedKeys: const [
      'enabled',
      'host',
      'username',
      'password',
      'application',
      'willMessage',
      'willTopic',
      'willRetain',
      'clientID',
      'logging',
      'secure',
      'websocket',
      'port'
    ], requiredKeys: const [
      'host',
      'username',
      'password',
      'application'
    ]);
    final val = MqttConfiguration();
    $checkedConvert(json, 'enabled', (v) => val.enabled = v as bool ?? true);
    $checkedConvert(json, 'host', (v) => val.host = v as String);
    $checkedConvert(json, 'username', (v) => val.username = v as String);
    $checkedConvert(json, 'password', (v) => val.password = v as String);
    $checkedConvert(json, 'application', (v) => val.application = v as String);
    $checkedConvert(json, 'willMessage', (v) => val.willMessage = v as String);
    $checkedConvert(json, 'willTopic', (v) => val.willTopic = v as String);
    $checkedConvert(
        json, 'willRetain', (v) => val.willRetain = v as bool ?? true);
    $checkedConvert(json, 'clientID', (v) => val.clientID = v as String);
    $checkedConvert(json, 'logging', (v) => val.logging = v as bool ?? false);
    $checkedConvert(json, 'secure', (v) => val.secure = v as bool ?? false);
    $checkedConvert(
        json, 'websocket', (v) => val.websocket = v as bool ?? false);
    $checkedConvert(json, 'port', (v) => val.port = v as int ?? 1883);
    return val;
  });
}

Map<String, dynamic> _$MqttConfigurationToJson(MqttConfiguration instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'host': instance.host,
      'username': instance.username,
      'password': instance.password,
      'application': instance.application,
      'willMessage': instance.willMessage,
      'willTopic': instance.willTopic,
      'willRetain': instance.willRetain,
      'clientID': instance.clientID,
      'logging': instance.logging,
      'secure': instance.secure,
      'websocket': instance.websocket,
      'port': instance.port,
    };
