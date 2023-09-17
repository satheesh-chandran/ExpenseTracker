import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'HomePage.dart';

const String APP_TITLE = 'Budget tracker';
const String TABLE_NAME = 'expense';
const String DATE_FORMAT = 'dd MMMM yyyy, hh:mm aaa';
const String EXPENSE_TABLE_SCHEMA = 'CREATE TABLE IF NOT EXISTS $TABLE_NAME('
    'id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'
    'title VARCHAR(100) NOT NULL,'
    'amount REAL NOT NULL,'
    'category VARCHAR(100) NOT NULL,'
    'paid_date VARCHAR(40) DEFAULT CURRENT_TIMESTAMP NOT NULL,'
    'isRefundable INTEGER DEFAULT 0,'
    'refundedAmount REAL DEFAULT 0,'
    'deletionMarker INTEGER DEFAULT 0);';

const String expense1 =
    'INSERT INTO expense (title, amount, category, paid_date) VALUES (\'Kerala vision\', 600, \'bills\', \'2023-09-01 09:20:23\');';
const String expense2 =
    'INSERT INTO expense (title, amount, category, paid_date) VALUES (\'Groceries\', 3000, \'shopping\', \'2023-09-01 09:20:23\');';
const String expense3 =
    'INSERT INTO expense (title, amount, category, paid_date) VALUES (\'Jio recharge\', 249, \'bills\', \'2023-09-04 09:20:23\');';
const String expense4 =
    'INSERT INTO expense (title, amount, category, paid_date) VALUES (\'Pizza\', 500, \'food\', \'2023-09-06 09:20:23\');';
const String expense5 =
    'INSERT INTO expense (title, amount, category, paid_date) VALUES (\'Gold Investment\', 3000, \'investments\', \'2023-09-07 09:20:23\');';
const String expense6 =
    'INSERT INTO expense (title, amount, category, paid_date) VALUES (\'Car Petrol\', 1000, \'vehicle\', \'2023-09-10 09:20:23\');';
const String expense7 =
    'INSERT INTO expense (title, amount, category, paid_date) VALUES (\'Bike Service\', 2360, \'vehicle\', \'2023-09-10 09:20:23\');';
const String expense8 =
    'INSERT INTO expense (title, amount, category, paid_date) VALUES (\'Hospital diabetic checkup\', 450, \'healthcare\', \'2023-09-11 09:20:23\');';
const String expense9 =
    'INSERT INTO expense (title, amount, category, paid_date) VALUES (\'Snacks\', 150, \'food\', \'2023-09-11 09:20:23\');';
const String expense10 =
    'INSERT INTO expense (title, amount, category, paid_date) VALUES (\'Fruits and vegetables\', 270, \'food\', \'2023-09-13 09:20:23\');';
const String expense11 =
    'INSERT INTO expense (title, amount, category, paid_date) VALUES (\'Home loan EMI\', 7500, \'emi\', \'2023-09-14 09:20:23\');';
const String expense12 =
    'INSERT INTO expense (title, amount, category, paid_date) VALUES (\'Bike EMI\', 2700, \'emi\', \'2023-09-17 09:20:23\');';
const String expense13 =
    'INSERT INTO expense (title, amount, category, paid_date) VALUES (\'Onam dress purchage\', 3100, \'shopping\', \'2023-08-17 09:20:23\');';

var joinedQuery = [
  expense1,
  expense2,
  expense3,
  expense4,
  expense5,
  expense6,
  expense7,
  expense8,
  expense9,
  expense10,
  expense11,
  expense12,
  expense13,
].join("\n");

Future<String> getDataBasePath() async {
  if (kIsWeb) {
    return inMemoryDatabasePath;
  }
  final io.Directory appDocumentsDir = await getApplicationDocumentsDirectory();
  return path.join(appDocumentsDir.path, "databases", "expense_app.db");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  var databaseFactory = kIsWeb ? databaseFactoryFfiWeb : databaseFactoryFfi;
  var database = databaseFactory.openDatabase(await getDataBasePath());
  database.then((db) => db.execute(EXPENSE_TABLE_SCHEMA));
  if (kIsWeb) {
    database.then((db) => db.execute(joinedQuery));
  }
  runApp(MyApp(database));
}

class MyApp extends StatelessWidget {
  Future<Database> database;

  MyApp(this.database, {super.key});

  @override
  Widget build(BuildContext context) {
    var data = ThemeData(
      fontFamily: 'nunito',
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.black)
          .copyWith(background: Colors.grey.shade200),
    );
    return MaterialApp(
      title: 'Flutter Demo',
      theme: data,
      home: HomePage(database),
    );
  }
}
