// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'key.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KeyPair _$KeyPairFromJson(Map<String, dynamic> json) {
  return KeyPair()
    ..seed = json['seed'] as String
    ..publicKey = json['publicKey'] as String
    ..privateKey = json['privateKey'] as String;
}

Map<String, dynamic> _$KeyPairToJson(KeyPair instance) => <String, dynamic>{
      'seed': instance.seed,
      'publicKey': instance.publicKey,
      'privateKey': instance.privateKey,
    };
