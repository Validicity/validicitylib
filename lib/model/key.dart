import 'dart:convert';
import 'dart:io';

import 'package:ed25519_dart/ed25519_dart.dart';
import 'package:nanodart/nanodart.dart';
import 'package:validicitylib/model/block.dart';
import 'package:validicitylib/config.dart';

import 'package:json_annotation/json_annotation.dart';

part 'key.g.dart';

String keyFile = 'key.json';

Key validicityKey;

String createKey() {
  validicityKey = Key();
  validicityKey.create();
  return saveKey();
}

loadKey() {
  var f = fileInHome(keyFile);
  if (f.existsSync()) {
    try {
      var jsonString = f.readAsStringSync();
      validicityKey = Key.fromJson(json.decode(jsonString));
    } catch (e) {
      print('Failed to parse key file ${f.path} : $e');
      exit(1);
    }
  }
}

String saveKey() {
  var f = fileInHome(keyFile);
  try {
    f.writeAsStringSync(json.encode(validicityKey.toJson()));
  } catch (e) {
    print('Failed to save key file ${f.path} : $e');
    exit(1);
  }
  return f.path;
}

bool verify(String signature, String hash, String publicKey) {
  print("Sig: $signature Hash: $hash Key: $publicKey");
  setDigestIdentifier('Blake2b');
  return verifySignature(NanoHelpers.hexToBytes(signature),
      NanoHelpers.hexToBytes(hash), NanoHelpers.hexToBytes(publicKey));
  /*return Signature.detachedVerify(NanoHelpers.hexToBytes(hash),
      NanoHelpers.hexToBytes(signature), NanoHelpers.hexToBytes(publicKey));*/
}

@JsonSerializable()
class Key {
  String seed;
  String publicKey;
  String privateKey;

  Key() {}

  create() {
    // Generating a random seed
    seed = NanoSeeds.generateSeed();
    // Getting private key at index-0 of this seed
    privateKey = NanoKeys.seedToPrivate(seed, 0);
    // Getting public key from this private key
    publicKey = NanoKeys.createPublicKey(privateKey);
  }

  /// Signing a block
  signBlock(Block block) {
    setDigestIdentifier('Blake2b');
    block.signature = NanoHelpers.byteToHex(sign(
            NanoHelpers.hexToBytes(block.calculateHash()),
            NanoHelpers.hexToBytes(privateKey),
            NanoHelpers.hexToBytes(publicKey)))
        .toUpperCase();
    print(block.signature);
    //NanoSignatures.signBlock(block.calculateHash(), privateKey);
  }

  factory Key.fromJson(Map<String, dynamic> json) => _$KeyFromJson(json);

  Map<String, dynamic> toJson() => _$KeyToJson(this);
}
