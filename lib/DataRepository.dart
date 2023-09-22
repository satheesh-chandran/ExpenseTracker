import 'package:first_flutter_app/models/Favourite.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'Constants.dart';
import 'models/EditExpenseModel.dart';
import 'models/Expense.dart';
import 'main.dart';
import 'models/ExpenseCategory.dart';
import 'models/NewExpense.dart';

class DataRepository {
  Database database;

  DataRepository(this.database);

  void loadSchema() async {
    await database.execute('$EXPENSE_TABLE_SCHEMA\n$FAVOURITE_TABLE_SCHEMA');
    if (kIsWeb) {
      await database.execute(joinedQuery);
      await database.execute(loadFavouriteQuery);
    }
  }

  // region Expenses

  Future<List<Expense>> addNewExpense(NewExpense expense) async {
    await _addExpense(expense, EXPENSE_TABLE_NAME);
    return getAllExpenses();
  }

  Future<List<Expense>> editExpense(EditExpenseModel model) async {
    await _editExpense(model, EXPENSE_TABLE_NAME);
    return getAllExpenses();
  }

  Future<List<Expense>> deleteExpense(int id) async {
    await _deleteExpense(id, EXPENSE_TABLE_NAME);
    return getAllExpenses();
  }

  Future<List<Expense>> getAllExpenses() async {
    return _mapToModelExpenseList(await _getAll(EXPENSE_TABLE_NAME));
  }

  Future<List<Expense>> getAllExpensesOf(ExpenseCategory category) async {
    return _mapToModelExpenseList(await database.query(EXPENSE_TABLE_NAME,
        where: 'category = ?', whereArgs: [category.name]));
  }

  List<Expense> _mapToModelExpenseList(List<Map<String, dynamic>> mappings) {
    return List.generate(mappings.length, (i) {
      return Expense(
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

  // endregion

  // region Favourites
  Future<List<Favourite>> getAllFavouriteExpenses() async {
    return _mapToModelFavouriteList(await _getAll(FAVOURITE_TABLE_NAME));
  }

  Future<List<Favourite>> addNewFavouriteExpense(NewExpense expense) async {
    await _addExpense(expense, FAVOURITE_TABLE_NAME);
    return getAllFavouriteExpenses();
  }

  Future<List<Favourite>> deleteFavouriteExpense(int id) async {
    await _deleteExpense(id, FAVOURITE_TABLE_NAME);
    return getAllFavouriteExpenses();
  }

  Future<List<Favourite>> editFavouriteExpense(EditExpenseModel model) async {
    await _editExpense(model, FAVOURITE_TABLE_NAME);
    return getAllFavouriteExpenses();
  }

  List<Favourite> _mapToModelFavouriteList(
      List<Map<String, dynamic>> mappings) {
    return List.generate(mappings.length, (i) {
      return Favourite(
        id: mappings[i]['id'],
        title: mappings[i]['title'],
        amount: mappings[i]['amount'],
        category: ExpenseCategory.values.byName(mappings[i]['category']),
      );
    });
  }

  // endregion

  Future<List<Map<String, dynamic>>> _getAll(String tableName) async {
    return await database.query(tableName);
  }

  Future<int> _addExpense(NewExpense expense, String tableName) async {
    return await database.insert(tableName, expense.toMap());
  }

  Future<int> _deleteExpense(int id, String tableName) async {
    return await database.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> _editExpense(EditExpenseModel model, String tableName) async {
    return await database.update(
        tableName,
        <String, Object?>{
          'title': model.title,
          'category': model.category.name,
          'amount': model.amount
        },
        where: 'id = ?',
        whereArgs: [model.id]);
  }

  static Future<DataRepository> initialise() async {
    sqfliteFfiInit();
    var databaseFactory = kIsWeb ? databaseFactoryFfiWeb : databaseFactoryFfi;
    var database = databaseFactory.openDatabase(await getDataBasePath());
    return DataRepository(await database);
  }
}
