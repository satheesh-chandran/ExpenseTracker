import 'package:first_flutter_app/widgets/ExpenseView.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'AddExpensePage.dart';
import 'DataRepository.dart';
import 'Expense.dart';
import 'main.dart';

class HomePage extends StatefulWidget {
  DataRepository repository;

  HomePage(this.repository, {super.key});

  @override
  _HomePageState createState() => _HomePageState(repository);
}

class _HomePageState extends State<HomePage> {
  DataRepository repository;
  List<RawExpenseModel> expenses = [];
  bool isLoaded = false;

  _HomePageState(this.repository);

  Future<void> loadAllExpenses() async {
    var allExpenses = await repository.getAllExpenses();
    setState(() {
      expenses = allExpenses;
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
      repository.addNewExpense(expense).then((_) => loadAllExpenses());
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
