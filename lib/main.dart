import 'package:first_flutter_app/Expense.dart';
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'AddExpensePage.dart';

const String APP_TITLE = 'Budget tracker';
const String TABLE_NAME = 'expense';
const String DATE_FORMAT = 'dd MMMM yyyy, hh:mm aaa';
const String EXPENSE_TABLE_SCHEMA = 'CREATE TABLE $TABLE_NAME('
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
  EXPENSE_TABLE_SCHEMA,
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
  var db = await database;
  await db.execute(joinedQuery);
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

class ExpenseCategoryBar extends StatelessWidget {
  const ExpenseCategoryBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      alignment: Alignment.center,
      child: const CircleAvatar(
        child: Icon(Icons.access_time_outlined),
      ),
    );
  }
}

class ExpenseItem extends StatelessWidget {
  late RawExpenseModel expense;

  ExpenseItem(this.expense, {super.key});

  @override
  Widget build(BuildContext context) {
    var categoryStyle = TextStyle(
        color: Colors.grey.shade800,
        fontSize: 14,
        overflow: TextOverflow.ellipsis,
        fontWeight: FontWeight.w500);
    return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        margin: const EdgeInsets.all(5),
        child: ListTile(
          title: Text(expense.title,
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis,
                  color: Colors.black)),
          subtitle: Text(expense.category.name, style: categoryStyle),
          leading: const ExpenseCategoryBar(),
          trailing: Text(expense.amount.toString(),
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.green.shade800,
                  fontSize: 18)),
        ));
  }
}

class ExpenseView extends StatelessWidget {
  List<RawExpenseModel> expenses;

  ExpenseView(this.expenses, {super.key});

  @override
  Widget build(BuildContext context) {
    return GroupedListView<RawExpenseModel, String>(
      elements: expenses,
      groupBy: (element) => element.paidDate.split(" ")[0],
      groupSeparatorBuilder: (String groupByValue) {
        var totalGroupExpense = expenses
            .where((element) => element.paidDate.split(" ")[0] == groupByValue)
            .map((e) => e.amount)
            .reduce((value, element) => value + element);

        var separatorStyle = TextStyle(
            color: Colors.grey.shade700,
            overflow: TextOverflow.ellipsis,
            fontStyle: FontStyle.italic,
            fontSize: 15,
            fontWeight: FontWeight.w400);
        return Container(
            margin: const EdgeInsets.only(top: 5, bottom: 5),
            color: Colors.pink.shade50,
            child: Row(
              children: [
                Padding(
                    padding:
                        const EdgeInsets.only(left: 20, bottom: 10, top: 10),
                    child: Text(groupByValue,
                        textAlign: TextAlign.left, style: separatorStyle)),
                Padding(
                    padding:
                        const EdgeInsets.only(left: 160, bottom: 10, top: 10),
                    child: Text("Expense: $totalGroupExpense /-",
                        style: separatorStyle)),
              ],
            ));
      },
      itemBuilder: (context, RawExpenseModel element) => ExpenseItem(element),
      itemComparator: (item1, item2) =>
          item1.paidDate.compareTo(item2.paidDate),
      useStickyGroupSeparators: true,
      floatingHeader: true,
      order: GroupedListOrder.DESC,
    );
  }
}

class HomePage extends StatefulWidget {
  Future<Database> database;

  HomePage(this.database, {super.key});

  @override
  _HomePageState createState() => _HomePageState(database);
}

class _HomePageState extends State<HomePage> {
  Future<Database> database;
  List<RawExpenseModel> expenses = [];
  bool isLoaded = false;

  _HomePageState(this.database);

  Future<void> loadAllExpenses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(TABLE_NAME);

    setState(() {
      expenses = expenses = List.generate(maps.length, (i) {
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
      isLoaded = true;
    });
  }

  Future<void> _navigateToAddExpensePage(BuildContext context) async {
    NewExpense expense = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddExpensePage()),
    );
    if (!context.mounted) return;
    if (expense != null) {
      database
          .then((db) => db.insert(TABLE_NAME, expense.toMap()))
          .then((value) => loadAllExpenses());
      var msg = '${expense.title}, ${expense.amount}, ${expense.category.name}';
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    loadAllExpenses();
    const tabHeaderTextStyle =
        TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text(APP_TITLE),
          bottom: const TabBar(
            labelPadding: EdgeInsets.all(10),
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Text("Expenses", style: tabHeaderTextStyle),
              Text("Insights", style: tabHeaderTextStyle),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            isLoaded
                ? ExpenseView(expenses)
                : const Center(child: CircularProgressIndicator()),
            const Icon(Icons.add_chart_outlined),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _navigateToAddExpensePage(context);
          },
          tooltip: 'Add Expense',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
