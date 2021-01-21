import 'package:validicitylib/util.dart';

enum ValidicityServerError {
  error_unknown_error,
  error_json_parse,
  error_not_json,
  error_internal_error,
  error_forbidden,
  error_unauthorized
}

Map<String, String> makeError(ValidicityServerError type, String detail) {
  return {'error': enumString(type), 'detail': detail};
}

/// Return a ValidicityServerError value from its name as a String
ValidicityServerError serverErrorFromString(String str) {
  var match = "ValidicityServerError.$str";
  return ValidicityServerError.values.firstWhere((e) => e.toString() == match,
      orElse: () => ValidicityServerError.error_unknown_error);
}
