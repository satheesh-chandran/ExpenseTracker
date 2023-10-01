import 'package:flutter/material.dart';

import '../DataRepository.dart';
import '../models/CallBacks.dart';
import '../pages/CategorisedExpenseViewPage.dart';
import 'ExpenseCategoryBar.dart';
import 'ExpenseView.dart';
import 'InsightsView.dart';

class ChartIndicatorTile extends StatelessWidget {
  final ChartData data;
  final DataRepository repository;
  final DeleteCallback onDelete;
  final EditCallback onEdit;
  final int grandTotal;

  const ChartIndicatorTile(
      this.data, this.repository, this.onEdit, this.onDelete, this.grandTotal,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: getBoxDecorationWithShadow(),
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.only(bottom: 5, top: 5, left: 15, right: 15),
      child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return CategorisedExpenseView(
                    repository, data.category, onDelete, onEdit);
              }),
            );
          },
          child: ListTile(
            leading:
                ExpenseCategoryBar(data.category.icon, data.category.color),
            trailing: Column(
              children: [
                Text('${((data.total / grandTotal) * 100).toStringAsFixed(2)}%',
                    style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black)),
                Text('${data.total}',
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor))
              ],
            ),
            subtitle: Text(
              data.category.qualifiedName,
              style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
            ),
            title: SizedBox(
                height: 10,
                child: LinearProgressIndicator(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  value: data.total / grandTotal,
                  backgroundColor: Colors.grey.shade300,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(data.category.color),
                )),
          )),
    );
  }
}
