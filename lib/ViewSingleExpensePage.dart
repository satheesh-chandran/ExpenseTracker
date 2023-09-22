import 'package:first_flutter_app/widgets/ExpenseCategoryBar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'AddExpensePage.dart';
import 'Constants.dart';
import 'models/CallBacks.dart';
import 'models/EditExpenseModel.dart';
import 'models/Expense.dart';
import 'models/NewExpense.dart';

class ViewSingleExpensePage extends StatelessWidget {
  final Expense expense;
  final DeleteCallback onDelete;
  final bool shouldRedirect;
  final EditCallback onEdit;

  const ViewSingleExpensePage(
      this.expense, this.shouldRedirect, this.onDelete, this.onEdit,
      {super.key});

  void _toEditPage(BuildContext context) async {
    Navigator.pop(context);
    NewExpense newExpense = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddAndEditExpensePage(expense: expense)));
    if (newExpense != null) {
      var editExpenseModel = EditExpenseModel(
          expense.id, newExpense.title, newExpense.amount, newExpense.category);
      onEdit(editExpenseModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    var category = expense.category;
    var textStyle = TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 14,
        fontStyle: FontStyle.italic);
    return SizedBox(
      height: 390,
      child: Column(
        children: [
          Text(expense.title,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic)),
          const ContainerSizeBox(),
          ListTile(
            leading: ExpenseCategoryBar(
                const Icon(
                  Icons.attach_money,
                  color: Colors.white,
                ),
                Theme.of(context).primaryColor),
            title: Text(expense.amount.round().toString(), style: textStyle),
          ),
          const ContainerSizeBox(),
          ListTile(
            leading: ExpenseCategoryBar(
                const Icon(
                  Icons.date_range,
                  color: Colors.white,
                ),
                Theme.of(context).primaryColor),
            title: Text(
                DateFormat(DATE_FORMAT)
                    .format(DateTime.parse(expense.paidDate)),
                style: textStyle),
          ),
          const ContainerSizeBox(),
          ListTile(
            leading: ExpenseCategoryBar(category.icon, category.color),
            title: Text(category.qualifiedName, style: textStyle),
          ),
          const ContainerSizeBox(),
          ElevatedButton.icon(
              onPressed: () {
                _toEditPage(context);
              },
              icon: const Icon(Icons.edit),
              label: const Text("EDIT EXPENSE")),
          const ContainerSizeBox(),
          ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                onDelete(expense.id, shouldRedirect);
              },
              icon: const Icon(Icons.delete),
              label: const Text("DELETE"))
        ],
      ),
    );
  }
}
