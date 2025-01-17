import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';
import 'package:nanodart/nanodart.dart' as nano;
import 'package:validicitylib/model/block.dart';
import 'package:validicitylib/model/key.dart';
import 'package:validicitylib/model/proof.dart';
import 'package:validicitylib/model/user.dart';
import 'package:validicitylib/util.dart';

part 'sample.g.dart';

@JsonSerializable()
class Sample extends Block {
  int id;

  DateTime created;
  DateTime modified;

  /// Previous record hash in the same Project, or Project hash.
  // @Column(unique: true)
  String previous;

  /// Creator of this record
  String publicKey;

  /// The serial identifier for the Sample, the NFC tag.
  String serial;

  /// Cryptographic hash of this record.
  // @Column(unique: true, indexed: true)
  String hash;

  /// Cryptographic signature of this record.
  String signature;

  String comment;

  String location;
  double latitude;
  double longitude;

  /// The current state of the Sample's lifecycle
  // @Column(defaultValue: "'registered'")
  SampleState state = SampleState.registered;

  Map<String, dynamic> metadata = {};

  Proof proof;

  User user;

  Sample();
  factory Sample.fromJson(Map<String, dynamic> json) => _$SampleFromJson(json);

  Map<String, dynamic> toJson() => _$SampleToJson(this);

  /// Seal this Sample by adding previous hash and signing it.
  seal(KeyPair key, Sample previousSample) {
    if (previousSample != null) {
      previous = previousSample.hash;
    } else {
      previous = "00"; // TODO: Root of project!
    }
    sign(key);
  }

  /// Sign this Sample by recording the publicKey of the signing key and then adding the signature.
  sign(KeyPair key) {
    publicKey = key.publicKey;
    signature = key.signBlock(this);
  }

  Uint8List intToBytes(int n) {
    var bytes = ByteData(8);
    bytes.setInt64(0, n);
    return bytes.buffer.asUint8List();
  }

  Uint8List datetimeToBytes(DateTime n) {
    return intToBytes(n.millisecondsSinceEpoch);
  }

  /// Convert all parts into bytes and then make a Blake2b hash.
  String calculateHash() {
    /* Uint8List idBytes = intToBytes(id);
    Uint8List createdBytes = datetimeToBytes(created);
    Uint8List modifiedBytes = datetimeToBytes(modified);
    */
    Uint8List previousBytes =
        nano.NanoHelpers.hexToBytes(previous.padLeft(64, "0"));
    Uint8List publicKeyBytes = nano.NanoHelpers.hexToBytes(publicKey);
    Uint8List serialBytes = nano.NanoHelpers.stringToBytesUtf8(serial);
    hash = nano.NanoHelpers.byteToHex(nano.Blake2b.digest256([
      /* idBytes,
      createdBytes,
      modifiedBytes,*/
      publicKeyBytes,
      previousBytes,
      serialBytes
    ])).toUpperCase();
    return hash;
  }
}
