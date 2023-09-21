import 'package:first_flutter_app/widgets/ExpenseView.dart';
import 'package:first_flutter_app/widgets/InsightsView.dart';
import 'package:flutter/material.dart';

import 'AddExpensePage.dart';
import 'DataRepository.dart';
import 'Expense.dart';
import 'main.dart';

class HomePage extends StatefulWidget {
  final DataRepository repository;

  const HomePage(this.repository, {super.key});

  @override
  _HomePageState createState() => _HomePageState(repository);
}

class _HomePageState extends State<HomePage> {
  final DataRepository repository;
  List<RawExpenseModel> expenses = [];
  bool isLoaded = false;

  _HomePageState(this.repository);

  void showSnackbarMessage(String msg) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  Widget _showAlertDialog(BuildContext context, int id) {
    return AlertDialog(
      title: const Text("Do you want to delete selected expense ?",
          style: TextStyle(fontSize: 16)),
      actions: [
        TextButton(
            onPressed: () async {
              var allExpenses = await repository.deleteExpense(id);
              setState(() {
                expenses = allExpenses;
              });
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text("Yes")),
        TextButton(
            onPressed: () async {
              Navigator.pop(context);
            },
            child: const Text("No"))
      ],
    );
  }

  void onDelete(BuildContext context, int id) async {
    showDialog(
        context: context, builder: (context) => _showAlertDialog(context, id));
  }

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
      showSnackbarMessage(msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    loadAllExpenses();
    deleteAction(id) => onDelete(context, id);
    const tabHeaderTextStyle =
    TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .inversePrimary,
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
                ? ExpenseView(expenses, deleteAction)
                : const Center(child: CircularProgressIndicator()),
            isLoaded
                ? InsightsView(expenses, deleteAction)
                : const Center(child: CircularProgressIndicator()),
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
