import 'package:validicitylib/model/user.dart';
import 'package:validicitylib/validicitylib.dart';

ValidicityServerAPI client =
    ValidicityServerAPI('city.validi.client', server: 'test.validi.city');

User user;
var unit;

loginValidicity1() async {
  return await login('validicity1', 'gurka');
}

login(String username, String password) async {
  await client.logout();
  client
    ..username = username
    ..password = password;
  await client.login();
  user = await client.getUser(username);
}
