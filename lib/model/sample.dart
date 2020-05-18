import 'package:json_annotation/json_annotation.dart';
import 'package:validicitylib/model/key.dart';
import 'package:validicitylib/util.dart';

part 'sample.g.dart';

@JsonSerializable()
class Sample {
  int id;

  DateTime created;
  DateTime modified;

  /// Cryptographic hash of this record
  // @Column(unique: true, indexed: true)
  String hash;

  /// Previous record hash in the same Project, or Project hash.
  // @Column(unique: true)
  String previous;

  /// Cryptographic signature of this record
  String signature;

  /// Creator of this record
  String publicKey;

  /// The serial identifier for the Sample, the NFC tag id?
  String serial;

  /// The current state of the Sample's lifecycle
  // @Column(defaultValue: "'registered'")
  SampleState state;

  Sample() {}

  factory Sample.fromJson(Map<String, dynamic> json) => _$SampleFromJson(json);

  Map<String, dynamic> toJson() => _$SampleToJson(this);

  /// Seal this Sample by signing.
  seal(Key key, Sample previous) {}

  sign(Key key) {}

  calculateHash() {}
}
