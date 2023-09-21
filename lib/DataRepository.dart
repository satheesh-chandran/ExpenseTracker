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

  Future<List<RawExpenseModel>> addNewExpense(NewExpense expense) async {
    await database.insert(TABLE_NAME, expense.toMap());
    return getAllExpenses();
  }

  Future<List<RawExpenseModel>> editExpense(EditExpenseModel model) async {
    await database.update(
        TABLE_NAME,
        <String, Object?>{
          'title': model.title,
          'category': model.category.name,
          'amount': model.amount
        },
        where: 'id = ?',
        whereArgs: [model.id]);
    return getAllExpenses();
  }

  Future<List<RawExpenseModel>> deleteExpense(int id) async {
    await database.delete(TABLE_NAME, where: 'id = ?', whereArgs: [id]);
    return getAllExpenses();
  }

  Future<List<RawExpenseModel>> getAllExpenses() async {
    return mapToModelList(await database.query(TABLE_NAME));
  }

  Future<List<RawExpenseModel>> getAllExpensesOf(
      ExpenseCategory category) async {
    return mapToModelList(await database
        .query(TABLE_NAME, where: 'category = ?', whereArgs: [category.name]));
  }

  List<RawExpenseModel> mapToModelList(List<Map<String, dynamic>> mappings) {
    return List.generate(mappings.length, (i) {
      return RawExpenseModel(
        id: mappings[i]['id'],
        title: mappings[i]['title'],
        amount: mappings[i]['amount'],
        category: ExpenseCategory.values.byName(mappings[i]['category']),
        paidDate: mappings[i]['paid_date'],
        isRefundable: mappings[i]['isRefundable'] != 0,
        refundedAmount: mappings[i]['refundedAmount'],
        deletionMarker: mappings[i]['deletionMarker'] != 0,
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
