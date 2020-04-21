import 'package:test/test.dart';
import 'package:aqueduct_test/aqueduct_test.dart';
import 'base.dart';

void main() {
  setUp(() async {
    await loginValidicity1();
  });

  test("status should work", () async {
    var res = await client.status();
    expect(res, {'system': isNotNull, 'data': isNotNull});
  });

  test("getUser should work", () async {
    var res = await client.getUser('validicity1');
    expect(
        res,
        partial({
          'id': isInteger,
          'email': 'user1@validicity.com',
          'created': isTimestamp,
          'modified': isTimestamp,
          'type': 'validicity',
          'canDebug': isBoolean,
          'username': 'validicity1'
        }));
  });
}
