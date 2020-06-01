import 'dart:math';
import 'package:convert/convert.dart';

/// The different User types. admin can do anything, client is a machine, user is a normal user.
enum UserType { admin, client, user, superuser }

/// The different LifeCycle states of a Sample.
enum SampleState {
  /// Sample is registered
  registered,

  /// Sample is being analysed
  analysed,

  /// Sample is destructed
  destructed
}

/// Return just the short name of an enum member
String enumString(dynamic type) {
  return type.toString().split(".").last;
}

/// Return an SampleState value from its name as a String
SampleState sampleStateFromString(String str) {
  var match = "SampleState.$str";
  return SampleState.values.firstWhere((e) => e.toString() == match);
}

/// Return a random hex of <len> bytes
String randomHex(int len) {
  var rng = new Random();
  var l = new List.generate(len, (_) => rng.nextInt(256));
  return hex.encode(l);
}

// Format a Duration in 'h:mm'
String formatDuration(Duration duration) {
  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  // String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "${duration.inHours}:$twoDigitMinutes";
}

// Capitalize first letter of a String
String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
