import 'package:ed25519_dart/ed25519_dart.dart';
import 'package:test/test.dart';
import 'package:validicitylib/model/key.dart';
import 'package:validicitylib/model/sample.dart';

void main() {
  setUp(() async {
    setDigestIdentifier('Blake2b');
  });

  test("signing should work", () async {
    var k = Key()
      ..publicKey =
          "7C22105B5CB00001B01F86A7A1A54E741BD6099899AA5EF74D25354124355ED6"
      ..privateKey =
          "E4B406F1FFD4ED07EEC02A4D8F0F24E5C82792DF1F3BDA32F97506B4BAD146D3";
    var s = Sample()
      ..serial = "123456789"
      ..previous = "00";
    s.seal(k, null);
    expect(s.signature,
        "AF22C49EECD03F87824316142EB5295CF7E9A09F48B88A030F92FF4AFBF8248D54B0EE03F2D89B5FAE23C27E7248D6CD9D59EDA31920074445E76DFFC2775D0D");
    expect(verify(s.signature, s.hash, k.publicKey), true);
  });
}
