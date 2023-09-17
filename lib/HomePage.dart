import 'package:first_flutter_app/widgets/ExpenseView.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'AddExpensePage.dart';
import 'Expense.dart';
import 'main.dart';

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
    final List<Map<String, dynamic>> maps =
        await database.then((db) => db.query(TABLE_NAME));

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
          .then((_) => loadAllExpenses());
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
