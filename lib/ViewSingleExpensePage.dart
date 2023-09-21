import 'package:first_flutter_app/widgets/ExpenseCategoryBar.dart';
import 'package:flutter/material.dart';

import 'AddExpensePage.dart';
import 'Expense.dart';

class ViewSingleExpensePage extends StatelessWidget {
  final RawExpenseModel expense;
  final DeleteCallback onDelete;

  const ViewSingleExpensePage(this.expense, this.onDelete, {super.key});

  @override
  Widget build(BuildContext context) {
    var category = expense.category;
    var textStyle = TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 14,
        fontStyle: FontStyle.italic);
    return SizedBox(
      height: 370,
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
            title: Text(expense.paidDate, style: textStyle),
          ),
          const ContainerSizeBox(),
          ListTile(
            leading: ExpenseCategoryBar(category.icon, category.color),
            title: Text(category.qualifiedName, style: textStyle),
          ),
          const ContainerSizeBox(),
          ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit),
              label: const Text("EDIT EXPENSE")),
          const ContainerSizeBox(),
          ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                onDelete(expense.id);
              },
              icon: const Icon(Icons.delete),
              label: const Text("DELETE"))
        ],
      ),
    );
  }
}
