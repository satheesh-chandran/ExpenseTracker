import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'Expense.dart';
import 'main.dart';

class DataRepository {
  Database database;

  DataRepository(this.database);

  void loadSchema() async {
    await database.execute(EXPENSE_TABLE_SCHEMA);
    if (kIsWeb) {
      await database.execute(joinedQuery);
    }
  }

  Future<int> addNewExpense(NewExpense expense) async {
    return await database.insert(TABLE_NAME, expense.toMap());
  }

  Future<List<RawExpenseModel>> getAllExpenses() async {
    final List<Map<String, dynamic>> maps = await database.query(TABLE_NAME);

    return List.generate(maps.length, (i) {
      return RawExpenseModel(
        id: maps[i]['id'],
        title: maps[i]['title'],
        amount: maps[i]['amount'],
        category: ExpenseCategory.values.byName(maps[i]['category']),
        paidDate: maps[i]['paid_date'],
        isRefundable: maps[i]['isRefundable'] != 0,
        refundedAmount: maps[i]['refundedAmount'],
        deletionMarker: maps[i]['deletionMarker'] != 0,
      );
    });
  }

  static Future<DataRepository> initialise() async {
    sqfliteFfiInit();
    var databaseFactory = kIsWeb ? databaseFactoryFfiWeb : databaseFactoryFfi;
    var database = databaseFactory.openDatabase(await getDataBasePath());
    return DataRepository(await database);
  }
}
