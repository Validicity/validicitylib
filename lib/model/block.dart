import 'package:nanodart/nanodart.dart';

abstract class Block {
  String signature;

  String calculateHash() {}
}

/// Just make a hash from a String
String makeHash(String data) {
  return NanoHelpers.byteToHex(
      Blake2b.digest256([NanoHelpers.stringToBytesUtf8(data)])).toUpperCase();
}
