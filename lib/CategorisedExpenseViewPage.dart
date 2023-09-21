import 'package:first_flutter_app/DataRepository.dart';
import 'package:first_flutter_app/widgets/ExpenseView.dart';
import 'package:flutter/material.dart';

import 'Expense.dart';
import 'main.dart';

class CategorisedExpenseView extends StatefulWidget {
  final DeleteCallback onDelete;
  final ExpenseCategory category;
  final DataRepository repository;

  const CategorisedExpenseView(this.repository, this.category, this.onDelete,
      {super.key});

  @override
  State<StatefulWidget> createState() {
    return _CategorisedExpenseViewState(repository, category, onDelete);
  }
}

class _CategorisedExpenseViewState extends State<CategorisedExpenseView> {
  List<RawExpenseModel> expenses = [];
  final DeleteCallback onDelete;
  final ExpenseCategory category;
  final DataRepository repository;

  _CategorisedExpenseViewState(this.repository, this.category, this.onDelete);

  void setExpenseState() async {
    var list = await repository.getAllExpensesOf(category);
    if (mounted) {
      setState(() {
        expenses = list;
      });
    }
  }

  Future<int> onExpenseDelete(int id, bool shouldRedirect) async {
    await onDelete(id, shouldRedirect);
    setExpenseState();
    return id;
  }

  @override
  Widget build(BuildContext context) {
    setExpenseState();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(APP_TITLE),
      ),
      body: ExpenseView(expenses, expenses.length <= 1,
          (id, shouldRedirect) => onExpenseDelete(id, shouldRedirect)),
    );
  }
}
