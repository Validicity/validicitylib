import 'dart:io';

import 'package:hive/hive.dart';

/// A thin wrapper over Hive, a singleton instance.
class Database {
  String basePath;
  String get databasePath => basePath + '/database';

  //Box<Sample> sampleBox;

  static final Database _singleton = Database._internal();

  /// Return the singleton instance
  factory Database() {
    return _singleton;
  }

  Database._internal() {
    /// Add all adapters here
    // Hive.registerAdapter(SampleAdapter());
  }

  Future initialize(String path) async {
    // When running unit tests this can be called multiple times
    // so we make sure we only actually do it once.
    if (basePath == null) {
      await _initialize(path);
    }
  }

  Future _initialize(String path) async {
    basePath = path;
    var needToCreate = false;
    var dir = Directory(databasePath);
    if (!dir.existsSync()) {
      await dir.create();
    }
    Hive.init(databasePath);
    // sampleBox = await Hive.openBox<Sample>('samples');
  }

  /// Clear all boxes
  void clear() async {
    // await sampleBox.clear();
  }
}
