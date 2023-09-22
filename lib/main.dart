import 'dart:io' as io;

import 'package:first_flutter_app/DataRepository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'Constants.dart';
import 'HomePage.dart';

Future<String> getDataBasePath() async {
  if (kIsWeb) {
    return inMemoryDatabasePath;
  }
  final io.Directory appDocumentsDir = await getApplicationDocumentsDirectory();
  return path.join(appDocumentsDir.path, "databases", DATABASE_FILE);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  DataRepository repository = await DataRepository.initialise();
  repository.loadSchema();
  runApp(MyApp(repository));
}

class MyApp extends StatelessWidget {
  DataRepository repository;

  MyApp(this.repository, {super.key});

  @override
  Widget build(BuildContext context) {
    var data = ThemeData(
      fontFamily: 'nunito',
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.pink,
      ),
    );
    return MaterialApp(
      title: 'Flutter Demo',
      theme: data,
      home: HomePage(repository),
    );
  }
}
