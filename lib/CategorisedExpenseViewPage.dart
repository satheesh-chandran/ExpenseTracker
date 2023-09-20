import 'package:first_flutter_app/widgets/ExpenseView.dart';
import 'package:flutter/material.dart';

import 'Expense.dart';
import 'main.dart';

class CategorisedExpenseView extends StatelessWidget {
  final List<RawExpenseModel> expenses;

  const CategorisedExpenseView(this.expenses, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(APP_TITLE),
      ),
      body: ExpenseView(expenses),
    );
  }
}