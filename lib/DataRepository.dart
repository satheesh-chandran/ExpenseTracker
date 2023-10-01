import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'Constants.dart';
import 'models/EditExpenseModel.dart';
import 'models/Expense.dart';
import 'main.dart';
import 'models/ExpenseCategory.dart';
import 'models/Favourite.dart';
import 'models/NewExpense.dart';

class DataRepository {
  Database database;
  SharedPreferences prefs;

  DataRepository(this.database, this.prefs);

  void _loadSchema() async {
    await database.execute('$EXPENSE_TABLE_SCHEMA\n$FAVOURITE_TABLE_SCHEMA');
    if (kIsWeb) {
      await database.execute(joinedQuery);
      await database.execute(loadFavouriteQuery);
    }
  }

  Future<String> startDate() async {
    if (!prefs.containsKey(START_DATE)) {
      await setStartDate(DateTime.now());
    }
    return toDateString(prefs.getInt(START_DATE) ?? 0);
  }

  Future<String> endDate() async {
    if (!prefs.containsKey(END_DATE)) {
      await setEndDate(DateTime.now());
    }
    return toDateString(prefs.getInt(END_DATE) ?? 0);
  }

  String toDateString(int millis) {
    return DateFormat('dd/MM/yy')
        .format(DateTime.fromMillisecondsSinceEpoch(millis));
  }

  Future<bool> setStartDate(DateTime date) {
    return setDate(START_DATE, date);
  }

  Future<bool> setEndDate(DateTime date) {
    return setDate(END_DATE, date);
  }

  Future<bool> setDate(String key, DateTime date) {
    return prefs.setInt(key, date.millisecondsSinceEpoch);
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    sqfliteFfiInit();
    var databaseFactory = kIsWeb ? databaseFactoryFfiWeb : databaseFactoryFfi;
    var database = await databaseFactory.openDatabase(await getDataBasePath());
    var repository = DataRepository(database, prefs);
    repository._loadSchema();
    return repository;
  }
}
