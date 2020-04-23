import 'dart:async';
import 'dart:convert';
import 'package:oauth2/oauth2.dart';
import 'package:http/http.dart' as http;

/// This class encapsulates the HTTP calls to the API
/// including authentication via OAuth2 and handling the credentials.
class RestClient {
  RestClient(this.credentialsHolder, this.clientID, String url, this.scopes,
      [String username, String password]) {
    baseURL = Uri.parse(url);
    this.username = username;
    this.password = password;
    // Default handler
    responseHandler = handleResponse;
  }

  /// Settings for HTTP operations
  String clientID;
  Uri baseURL;
  String username;
  String password;
  List<String> scopes;

  /// Holding onto OAuth2 credentials
  CredentialsHolder credentialsHolder;

  /// Handler of HTTP responses
  http.Response Function(http.Response response) responseHandler;

  // Default headers used
  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  // HTTP Client
  http.Client client;

  // Default handler does nothing special
  http.Response handleResponse(http.Response response) {
    return response;
  }

  /// Check we have a client and if not, either load an OAuth2 client
  /// from saved credentials or authenticate a new one.
  Future<http.Client> authenticate() async {
    if (client == null) {
      var savedCredentials = await credentialsHolder.loadCredentials();
      if (savedCredentials != null) {
        // If the OAuth2 credentials have already been saved from a previous run, we just want to reload them.
        var credentials = new Credentials.fromJson(savedCredentials);
        client = new Client(credentials, identifier: clientID);
      } else {
        var uri = Uri.https(baseURL.authority, baseURL.path + '/auth/token');
        client = await resourceOwnerPasswordGrant(uri, username, password,
            identifier: clientID, secret: '', scopes: scopes);
      }
      await credentialsHolder.saveCredentials(getCredentials());
    }
    return client;
  }

  String getCredentials() => (client as Client).credentials.toJson();

  /// Remove credentials and throw away client
  logout() async {
    await credentialsHolder.removeCredentials();
    client = null;
  }

  Future<http.Response> doPost(String path, payload,
      {bool auth = true, Map<String, String> params}) async {
    if (auth) {
      await authenticate();
    }
    var uri = Uri.https(baseURL.authority, baseURL.path + '/' + path, params);
    var body = json.encode(payload);
    return checkAndRetry(() {
      if (auth) {
        return client.post(uri, body: body, headers: headers);
      } else {
        return http.post(uri, body: body, headers: headers);
      }
    });
  }

  String basicAuthenticationHeader(String username, String password) {
    return 'Basic ' + base64Encode(utf8.encode('$username:$password'));
  }

  Future<http.Response> doBasicPost(String path, payload, username, password,
      {Map<String, String> params}) async {
    var uri = Uri.https(baseURL.authority, baseURL.path + '/' + path, params);
    var body = json.encode(payload);
    var extra = Map<String, String>.from(headers);
    extra['authorization'] = basicAuthenticationHeader(username, password);
    return responseHandler(await http.post(uri, body: body, headers: extra));
  }

  /// Takes a function that returns a Response,
  /// wraps it in retry and error handling logic.
  Future<http.Response> checkAndRetry(Future<http.Response> f()) async {
    int retry = 0;
    var response;
    while (response == null && retry < 2) {
      try {
        response = await f();
      } on ExpirationException {
        // OAuth2 expired, remove file and retry once
        await credentialsHolder.removeCredentials();
        retry++;
      } catch (e, s) {
        // No idea, retry
        print('Unexpected exception, details:\n $e');
        print('Stack trace:\n $s');
        print('Retry: $retry');
        retry++;
      }
    }
    return responseHandler(response);
  }

  Future<http.Response> doPut(String path, payload,
      {bool auth = true, Map<String, String> params}) async {
    if (auth) {
      await authenticate();
    }
    var uri = Uri.https(baseURL.authority, baseURL.path + '/' + path, params);
    var body = json.encode(payload);
    return checkAndRetry(() {
      if (auth) {
        return client.put(uri, body: body, headers: headers);
      } else {
        return http.put(uri, body: body, headers: headers);
      }
    });
  }

  Future<http.Response> doDelete(String path,
      {bool auth = true, Map<String, String> params}) async {
    if (auth) {
      await authenticate();
    }
    var uri = Uri.https(baseURL.authority, baseURL.path + '/' + path, params);
    return checkAndRetry(() {
      if (auth) {
        return client.delete(uri, headers: headers);
      } else {
        return http.delete(uri, headers: headers);
      }
    });
  }

  Future<http.Response> doGet(String path,
      {bool auth = true, Map<String, String> params}) async {
    if (auth) {
      await authenticate();
    }
    var uri = Uri.https(baseURL.authority, baseURL.path + '/' + path, params);
    return checkAndRetry(() {
      if (auth) {
        return client.get(uri, headers: headers);
      } else {
        return http.get(uri, headers: headers);
      }
    });
  }
}

/// This is an interface for persisting OAuth2 credentials.
/// Typically Stratus uses a file while the mobile app uses something else.
abstract class CredentialsHolder {
  /// Called to purge cached credentials, used when doing logout.
  Future<void> removeCredentials();

  // Called to load credentials for reuse, returns null if there is none.
  Future<String> loadCredentials();

  // Called to save credentials for reuse.
  Future<void> saveCredentials(String credentials);

  static CredentialsHolder memoryHolder() {
    return MemoryHolder();
  }
}

/// A trivial Credentials holder that just keeps it in RAM
class MemoryHolder extends CredentialsHolder {
  String credentials;

  @override
  Future<String> loadCredentials() {
    return Future.value(credentials);
  }

  @override
  Future<void> removeCredentials() {
    credentials = null;
    return null;
  }

  @override
  Future<void> saveCredentials(String cred) {
    credentials = cred;
    return null;
  }
}
