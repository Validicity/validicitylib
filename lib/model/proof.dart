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

  /// The actual proof in base64
  String proof;

  /// Is it anchored in CAL?
  bool cal;

  /// Is it anchored in BTC?
  bool btc;

  Map<String, dynamic> metadata = {};

  Proof() {}

  factory Proof.fromJson(Map<String, dynamic> json) => _$ProofFromJson(json);

  Map<String, dynamic> toJson() => _$ProofToJson(this);
}
