import 'package:expense_tracker/models/FilterCategory.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'Constants.dart';
import 'main.dart';
import 'models/EditExpenseModel.dart';
import 'models/Expense.dart';
import 'models/ExpenseCategory.dart';
import 'models/Favourite.dart';
import 'models/NewExpense.dart';

class DataRepository {
  Database database;
  SharedPreferences prefs;

  DataRepository(this.database, this.prefs);

  void _loadSchema() async {
    await database.execute('$EXPENSE_TABLE_SCHEMA\n$FAVOURITE_TABLE_SCHEMA');
    var category = await filterCategory;
    if (category != FilterCategory.all ||
        category != FilterCategory.dateRange) {
      setEndDate(DateTime.now());
    }
    if (kIsWeb) {
      await database.execute(joinedQuery);
      await database.execute(loadFavouriteQuery);
    }
  }

  Future<FilterCategory> get filterCategory async {
    if (!prefs.containsKey(TIME_FILTER)) {
      await setFilterCategory(FilterCategory.all);
    }
    return FilterCategory.values.byName(prefs.getString(TIME_FILTER) ?? "all");
  }

  Future<DateTime> get startDate async {
    if (!prefs.containsKey(START_DATE)) {
      await setStartDate(DateTime.now());
    }
    return _toDateTime(prefs.getInt(START_DATE) ?? 0);
  }

  Future<DateTime> get endDate async {
    if (!prefs.containsKey(END_DATE)) {
      await setEndDate(DateTime.now());
    }
    return _toDateTime(prefs.getInt(END_DATE) ?? 0);
  }

  Future<bool> setFilterCategory(FilterCategory category) {
    return prefs.setString(TIME_FILTER, category.name);
  }

  Future<bool> setStartDate(DateTime date) {
    return _setDate(START_DATE, date);
  }

  Future<bool> setEndDate(DateTime date) {
    return _setDate(END_DATE, date);
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
    var list = await filterCategory == FilterCategory.all
        ? await database.query(EXPENSE_TABLE_NAME)
        : await database.query(EXPENSE_TABLE_NAME,
            where: _where, whereArgs: await _whereArgs);
    return _mapToModelExpenseList(list);
  }

  Future<List<Expense>> getAllExpensesOf(ExpenseCategory category) async {
    return _mapToModelExpenseList(await database.query(EXPENSE_TABLE_NAME,
        where: await _whereWithExpenseCategory,
        whereArgs: [category.name, ...await _whereArgs]));
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
    return _mapToModelFavouriteList(await database.query(FAVOURITE_TABLE_NAME));
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

  String get _where {
    return "paid_date BETWEEN ? AND  ?";
  }

  Future<String> get _whereWithExpenseCategory async {
    String s = await filterCategory == FilterCategory.all
        ? ""
        : _where == ""
            ? _where
            : " AND $_where";
    return "category = ?$s";
  }

  Future<List<String>> get _whereArgs async {
    return await filterCategory == FilterCategory.all
        ? []
        : [
            _toDateString(await startDate),
            "${_toDateString(await endDate)} 23:59:59"
          ];
  }

  DateTime _toDateTime(int millis) {
    return DateTime.fromMillisecondsSinceEpoch(millis);
  }

  String _toDateString(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future<bool> _setDate(String key, DateTime date) {
    return prefs.setInt(key, date.millisecondsSinceEpoch);
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
