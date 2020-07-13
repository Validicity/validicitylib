// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proof.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Proof _$ProofFromJson(Map<String, dynamic> json) {
  return Proof()
    ..id = json['id'] as int
    ..created = json['created'] == null
        ? null
        : DateTime.parse(json['created'] as String)
    ..modified = json['modified'] == null
        ? null
        : DateTime.parse(json['modified'] as String)
    ..proofId = json['proofId'] as String
    ..hash = json['hash'] as String
    ..proof = json['proof'] as String
    ..cal = json['cal'] as bool
    ..btc = json['btc'] as bool
    ..metadata = json['metadata'] as Map<String, dynamic>;
}

Map<String, dynamic> _$ProofToJson(Proof instance) => <String, dynamic>{
      'id': instance.id,
      'created': instance.created?.toIso8601String(),
      'modified': instance.modified?.toIso8601String(),
      'proofId': instance.proofId,
      'hash': instance.hash,
      'proof': instance.proof,
      'cal': instance.cal,
      'btc': instance.btc,
      'metadata': instance.metadata,
    };
