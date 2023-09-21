import 'package:first_flutter_app/widgets/ExpenseCategoryBar.dart';
import 'package:first_flutter_app/widgets/ExpenseView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'Expense.dart';
import 'main.dart';

class ContainerSizeBox extends StatelessWidget {
  const ContainerSizeBox({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 20);
  }
}

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  ExpenseCategory dropdownValue = ExpenseCategory.miscellaneous;
  var remarksController = TextEditingController();
  var amountController = TextEditingController();

  Future<void> _sentDataToHomePage(BuildContext context) async {
    try {
      var amount = int.parse(amountController.text);
      var remark = remarksController.text.trim();
      if (remark.isEmpty) throw Exception("Remarks required");
      var expense = NewExpense(remark, amount, dropdownValue);
      Navigator.pop(context, expense);
    } on Exception {
      const errorMsg = "Unable to add expense, try editing the values";
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text(errorMsg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    var localDate = DateFormat(DATE_FORMAT).format(DateTime.now());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(APP_TITLE),
      ),
      body: Center(
          child: Container(
        decoration: getBoxDecorationWithShadow(),
        height: MediaQuery.of(context).size.height * 0.55,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  "Add New Expense",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: Colors.pink.shade600),
                ),
                const ContainerSizeBox(),
                Text(
                  localDate,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.pink.shade300),
                ),
                const ContainerSizeBox(),
                TextFormField(
                  maxLength: 55,
                  controller: remarksController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Remarks',
                  ),
                ),
                const ContainerSizeBox(),
                TextFormField(
                  maxLength: 10,
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Amount',
                  ),
                ),
                const ContainerSizeBox(),
                ListTile(
                  leading: ExpenseCategoryBar(
                      dropdownValue.icon, dropdownValue.color),
                  trailing: const Icon(Icons.add),
                  title: DropdownButton(
                      value: dropdownValue,
                      underline: Container(),
                      isExpanded: true,
                      items:
                          ExpenseCategory.values.map((ExpenseCategory value) {
                        return DropdownMenuItem<ExpenseCategory>(
                          value: value,
                          child: Text(value.qualifiedName),
                        );
                      }).toList(),
                      onChanged: (newCategory) {
                        setState(() {
                          dropdownValue = newCategory!;
                        });
                      }),
                ),
                const ContainerSizeBox(),
                ElevatedButton.icon(
                    onPressed: () {
                      _sentDataToHomePage(context);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("ADD EXPENSE"))
              ],
            )),
      )),
    );
  }
}
