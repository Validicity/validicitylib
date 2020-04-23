import 'dart:convert';

import 'package:validicitylib/error.dart';
import 'package:validicitylib/model/project.dart';
import 'package:validicitylib/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:validicitylib/rest.dart';
import 'package:validicitylib/util.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api.g.dart';

/// A Configuration to represent the API. anyMap: true makes this work for YAML too.
@JsonSerializable(
  anyMap: true,
  checked: true,
  disallowUnrecognizedKeys: true,
  nullable: false,
)
class ValidicityServerAPIConfiguration {
  /// The username to connect as.
  @JsonKey(required: true)
  String username;

  /// The password for the user.
  @JsonKey(required: true)
  String password;

  /// Which server URL to connect to, https://prod.validi.city/rpc
  @JsonKey(required: true)
  String url;

  /// Which application name to use.
  @JsonKey(required: true)
  String application;

  /// Scopes for OAuth2
  @JsonKey(required: false)
  List<String> scopes;

  /// The client ID for OAuth2
  @JsonKey(required: false)
  String clientID;

  ValidicityServerAPIConfiguration();

  factory ValidicityServerAPIConfiguration.fromJson(Map json) =>
      _$ValidicityServerAPIConfigurationFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ValidicityServerAPIConfigurationToJson(this);

  @override
  String toString() => 'ValidicityServerAPIConfiguration: ${toJson()}';
}

class ValidicityServerException implements Exception {
  /// Unique key for this error
  ValidicityServerError type;

  /// Descriptive message, typically only shown
  /// in log since it will be in english only.
  String detail;

  ValidicityServerException(this.type, this.detail);

  String toString() {
    return enumString(type) + ':' + detail;
  }
}

class ValidicityServerAPI {
  ValidicityServerAPI(this.clientID,
      {String server = 'prod.validi.city', CredentialsHolder holder}) {
    _server = server;
    credentialsHolder =
        holder == null ? CredentialsHolder.memoryHolder() : holder;
    // Default handler
    responseHandler = handleResponse;
  }

  /// Set current project id, uses in API calls
  int currentProjectId;

  // For example "city.validi.mobile" or "city.validi.client"
  String clientID;

  CredentialsHolder credentialsHolder;

  http.Response Function(http.Response response) responseHandler;

  // We try to request all scopes
  List<String> scopes = ['admin', 'validicityclient', 'user'];

  void set server(String name) {
    _server = name;
    client = null;
  }

  String get server => _server;

  String _server;
  String username;
  String password;

  RestClient client;

  void _initializeClient() {
    if (client == null) {
      client = RestClient(credentialsHolder, clientID, "https://$_server/rpc",
          scopes, username, password);
      client.responseHandler = responseHandler;
    } else {
      client
        ..username = username
        ..password = password
        ..baseURL = Uri.parse("https://$_server/rpc")
        ..scopes = scopes
        ..responseHandler = responseHandler;
    }
  }

  // Default handler for the internal RestClient does nothing special
  http.Response handleResponse(http.Response response) {
    return response;
  }

  /// Called by all API methods to properly throw ValidicityException
  /// depending on result. null is returned for a 404.
  T _handleResult<T>(http.Response response) {
    if (response == null) {
      throw ValidicityServerException(
          ValidicityServerError.error_internal_error,
          "Something failed in the communication with the backend.");
    }
    if (response.statusCode == 404) {
      return null;
      // throw ValidicityException(

      //    "error_not_found", "Either wrong URL or entity not found.");
    } else {
      if (response.statusCode == 403) {
        throw ValidicityServerException(
            ValidicityServerError.error_forbidden, "Forbidden");
      }
      if (response.statusCode == 401) {
        throw ValidicityServerException(
            ValidicityServerError.error_unauthorized, "Unauthorized");
      }
      var contentType = response.headers['content-type'];
      if (contentType != null && contentType.contains('json')) {
        try {
          var result = json.decode(response.body);
          if (result is Map) {
            if (result.containsKey("error")) {
              throw ValidicityServerException(
                  serverErrorFromString(result["error"]), result["detail"]);
            }
          }
          return result;
        } catch (e) {
          throw ValidicityServerException(
              ValidicityServerError.error_json_parse,
              "Parsing result JSON from API failed: $e");
        }
      } else {
        throw ValidicityServerException(ValidicityServerError.error_not_json,
            "API did not return JSON: ${response.body}");
      }
    }
  }

  /// Login to Validicity and return true on success.
  Future<bool> login() async {
    try {
      // We simply do a status call, does not matter what call we use
      var result = await status();
      return result != null;
    } catch (e) {
      return false;
    }
  }

  /// Logout from Validicity clearing OAuth2 credentials
  logout() async {
    if (client != null) {
      await client.logout();
      client = null;
    }
  }

  /// Fetch status of Validicity system, looks something like:
  ///     {
  ///       'system': {
  ///          'hostname': 'prod.validi.city',
  ///          'version': '0.1.0',
  ///          'dartversion': '2.7.0 (Unknown timestamp) on "linux_x64"',
  ///          'osversion': 'Linux 4.15.0-45-generic #48-Ubuntu SMP Tue Jan 29 16:28:13 UTC 2019'
  ///        },
  ///        'data': {'samples': 24, 'users': 2}
  ///     }
  Future<Map<String, dynamic>> status() async {
    _initializeClient();
    var response = await client.doGet('status');
    return _handleResult(response);
  }

  /// Get information about myself, my own user
  Future<User> getMyself(String username) async {
    _initializeClient();
    var response = await client.doGet('self/$username');
    return User.fromJson(_handleResult(response));
  }

  /// Request recovery code
  Future requestRecoveryCode(String username) async {
    _initializeClient();
    var response = await client.doGet('recovery/$username');
    return _handleResult(response);
  }

  /// Reset password using previously received recovery code
  Future resetPassword(String username, String code, String password) async {
    _initializeClient();
    var response =
        await client.doPut('recovery/$username/$code/$password', null);
    return _handleResult(response);
  }

  /// Get information about a specific user
  Future<User> getUser(String username) async {
    _initializeClient();
    var response = await client.doGet('user/$username');
    return User.fromJson(_handleResult(response));
  }

  /// Get all Users
  Future<List<User>> getUsers() async {
    _initializeClient();
    var response = await client.doGet('user');
    List list = _handleResult(response);
    return list.map((map) => User.fromJson(map)).toList();
  }

  /// A normal User can only update oneself.
  Future<Map<String, dynamic>> updateUser(
      String username, Map<String, dynamic> payload) async {
    _initializeClient();
    var response = await client.doPut('user/$username', payload);
    return _handleResult(response);
  }

  /// Get all available projects for given userId
  Future<List<Project>> getProjects(int userId) async {
    _initializeClient();
    var response = await client.doGet('user/$userId/project');
    List list = _handleResult(response);
    return list.map((map) => Project.fromJson(map)).toList();
  }

  /// Add access to a Project for a User
  Future<Map<String, dynamic>> addProjectUser(int project, int user) async {
    _initializeClient();
    var response = await client.doPost('user/$user/project/$project', null);
    return _handleResult(response);
  }

  /// Remove access to a Project for a User
  /// Returns {'removed': 1} on success.
  Future<Map<String, dynamic>> removeProjectUser(int project, int user) async {
    _initializeClient();
    var response = await client.doDelete('user/$user/project/$project');
    if (response.statusCode == 200) {
      return {'removed': 1};
    } else {
      return _handleResult(response);
    }
  }

  ///
  /// Samples
  ///

  /// Get all Samples in the current Project
  Future<List<dynamic>> getSamples() async {
    _initializeClient();
    var response = await client.doGet('project/$currentProjectId/sample');
    return _handleResult(response);
  }

  /// Get a single sample by id
  Future<Map<String, dynamic>> getSample(int id,
      {bool includeFirmware = true}) async {
    _initializeClient();
    var response = await client.doGet('sample/$id');
    return _handleResult(response);
  }

  /// Find a single Sample by serial number
  Future<Map<String, dynamic>> findSample(String serial) async {
    _initializeClient();
    var response = await client.doGet('project/$currentProjectId/sample/find',
        params: {'serial': serial});
    return _handleResult(response);
  }

  /// Create a Sample. Only available to real users.
  Future<Map<String, dynamic>> createSample(Map<String, dynamic> sample) async {
    _initializeClient();
    var response = await client.doPost('sample', sample);
    return _handleResult(response);
  }

  /// Update a Sample
  Future<Map<String, dynamic>> updateSample(
      int id, Map<String, dynamic> sample) async {
    _initializeClient();
    var response = await client.doPut('sample/$id', sample);
    return _handleResult(response);
  }

  /// Add a Sample to the current Project
  Future<Map<String, dynamic>> addSample(int sample) async {
    _initializeClient();
    var response =
        await client.doPost('project/$currentProjectId/sample/$sample', null);
    return _handleResult(response);
  }

  /// Removes a Sample from a Project but does not delete it.
  /// Returns {'removed': 1} on success.
  Future<Map<String, dynamic>> removeSample(int sample) async {
    _initializeClient();
    var response =
        await client.doDelete('project/$currentProjectId/sample/$sample');
    if (response.statusCode == 200) {
      return {'removed': 1};
    } else {
      return _handleResult(response);
    }
  }

  /// Deletes a Sample, not normally used.
  /// Returns {'deleted': 1} on success.
  Future<Map<String, dynamic>> deleteSample(int id) async {
    _initializeClient();
    var response = await client.doDelete('sample/$id');
    if (response.statusCode == 200) {
      return {'deleted': 1};
    } else {
      return _handleResult(response);
    }
  }
}
