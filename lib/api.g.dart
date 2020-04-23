// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ValidicityServerAPIConfiguration _$ValidicityServerAPIConfigurationFromJson(
    Map json) {
  return $checkedNew('ValidicityServerAPIConfiguration', json, () {
    $checkKeys(json, allowedKeys: const [
      'username',
      'password',
      'url',
      'application',
      'scopes',
      'clientID'
    ], requiredKeys: const [
      'username',
      'password',
      'url',
      'application'
    ]);
    final val = ValidicityServerAPIConfiguration();
    $checkedConvert(json, 'username', (v) => val.username = v as String);
    $checkedConvert(json, 'password', (v) => val.password = v as String);
    $checkedConvert(json, 'url', (v) => val.url = v as String);
    $checkedConvert(json, 'application', (v) => val.application = v as String);
    $checkedConvert(json, 'scopes',
        (v) => val.scopes = (v as List).map((e) => e as String).toList());
    $checkedConvert(json, 'clientID', (v) => val.clientID = v as String);
    return val;
  });
}

Map<String, dynamic> _$ValidicityServerAPIConfigurationToJson(
        ValidicityServerAPIConfiguration instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
      'url': instance.url,
      'application': instance.application,
      'scopes': instance.scopes,
      'clientID': instance.clientID,
    };
