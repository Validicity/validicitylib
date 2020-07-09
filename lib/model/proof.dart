import 'package:json_annotation/json_annotation.dart';

part 'proof.g.dart';

@JsonSerializable()
class Proof {
  int id;

  DateTime created;
  DateTime modified;

  /// The returned id from Chainpoint
  String proofId;

  /// The submitted hash
  String hash;

  Map<String, dynamic> metadata = {};

  Proof() {}

  factory Proof.fromJson(Map<String, dynamic> json) => _$ProofFromJson(json);

  Map<String, dynamic> toJson() => _$ProofToJson(this);
}
