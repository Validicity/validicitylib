import "package:test/test.dart";

import 'base.dart';

void main() {
  setUp(() async {
    client
      ..username = 'validicity1'
      ..password = 'gurka';
  });

  test("login should work", () async {
    var success = await client.login();
    expect(success, true);
    await client.logout();

    client.password = 'banan';
    success = await client.login();
    expect(success, false);
  });
}
