import 'dart:convert';
import 'dart:io';
import 'package:validicitylib/validicitylib.dart';
import 'package:validicitylib/mqtt.dart';
import 'package:checked_yaml/checked_yaml.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;

part 'config.g.dart';

// For logging
Logger log;

// Can we hold it on package level?
ValidicitylibConfiguration config;

/// Configure logging and read the configuration. In Flutter we supply it
/// as a String, on other platforms as a filename.
configure(String appName, String yaml, String filename) {
  if (Platform.isIOS || Platform.isAndroid) {
    configureFlutter(appName, yaml);
  } else {
    log = Logger(appName);

    // Different logic, sigh
    var home = (Platform.operatingSystem == 'windows')
        ? Platform.environment['APPDATA']
        : Platform.environment['HOME'];
    var configPath = path.join(home, filename);
    var f = File(configPath);
    if (f.existsSync()) {
      try {
        var yamlContent = f.readAsStringSync();
        config = checkedYamlDecode(
            yamlContent, (m) => ValidicitylibConfiguration.fromJson(m),
            sourceUrl: configPath);
        config.path = configPath;
      } catch (e) {
        print('Failed to parse config file $configPath : $e');
        exit(1);
      }
    } else {
      print('Missing configuration file $configPath');
      exit(1);
    }
    var configLevel = config.logging.level.toLowerCase();
    Logger.root.level =
        Level.LEVELS.firstWhere((l) => l.name.toLowerCase() == configLevel);
    Logger.root.onRecord.listen((LogRecord rec) {
      print('${rec.level.name}: ${rec.time}: ${rec.message}');
    });
  }
}

/// A Configuration to represent validicitylib. anyMap: true makes this work for YAML too.
@JsonSerializable(
  anyMap: true,
  checked: true,
  disallowUnrecognizedKeys: true,
  nullable: false,
)
class ValidicitylibConfiguration {
  String path;
  bool verbose = false;
  bool pretty = true;
  MqttConfiguration mqtt;
  ValidicityServerAPIConfiguration api;
  LoggingConfiguration logging;

  ValidicitylibConfiguration();
  factory ValidicitylibConfiguration.fromJson(Map<dynamic, dynamic> json) =>
      _$ValidicitylibConfigurationFromJson(json);
  Map<String, dynamic> toJson() => _$ValidicitylibConfigurationToJson(this);
  String toString() => 'validicitylibConfiguration: ${toJson()}';
}

/// A Configuration for logging
@JsonSerializable(
  anyMap: true,
  checked: true,
  disallowUnrecognizedKeys: true,
  nullable: false,
)
class LoggingConfiguration {
  String level;

  LoggingConfiguration();
  factory LoggingConfiguration.fromJson(Map<dynamic, dynamic> json) =>
      _$LoggingConfigurationFromJson(json);
  Map<String, dynamic> toJson() => _$LoggingConfigurationToJson(this);
  String toString() => 'LoggingConfiguration: ${toJson()}';
}

configureFlutter(String appName, String yaml) {
  config =
      checkedYamlDecode(yaml, (m) => ValidicitylibConfiguration.fromJson(m));

  // Logging?
  log = Logger(appName);
  var configLevel = config.logging.level;
  Logger.root.level =
      Level.LEVELS.firstWhere((l) => l.name.toLowerCase() == configLevel);
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
}

/// Load a file
loadFile(String fn) {
  var payload;
  var f = File(fn);
  if (f.existsSync()) {
    try {
      payload = json.decode(f.readAsStringSync());
    } catch (e) {
      log.severe('Failed to parse JSON file $fn : $e');
      exit(1);
    }
  } else {
    log.severe('Missing JSON file $fn');
    exit(1);
  }
  return payload;
}
