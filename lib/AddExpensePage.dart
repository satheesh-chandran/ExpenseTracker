import 'package:first_flutter_app/widgets/ExpenseCategoryBar.dart';
import 'package:first_flutter_app/widgets/ExpenseView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'Constants.dart';
import 'models/Expense.dart';
import 'models/ExpenseCategory.dart';
import 'models/NewExpense.dart';

class ContainerSizeBox extends StatelessWidget {
  const ContainerSizeBox({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 20);
  }
}

abstract class AddNewPage extends StatefulWidget {
  final String remarks;
  final String amountText;
  final String formTitle;
  final ExpenseCategory category;
  final IconData iconData;
  final String? dateValue;

  const AddNewPage(
      {super.key,
      this.remarks = "",
      this.amountText = "",
      this.category = ExpenseCategory.miscellaneous,
      this.formTitle = "Add Expense",
      this.iconData = Icons.add,
      this.dateValue});

  @override
  State<StatefulWidget> createState() {
    return AddNewPageState(
        remarks, amountText, category, formTitle, iconData, dateValue);
  }
}

class AddNewPageState extends State<AddNewPage> {
  final String formTitle;
  final IconData iconData;

  late ExpenseCategory category;
  late TextEditingController remarksController;
  late TextEditingController amountController;
  late String formDateValue;

  AddNewPageState(String remarks, String amountText, this.category,
      this.formTitle, this.iconData, String? dateValue) {
    remarksController = TextEditingController(text: remarks);
    amountController = TextEditingController(text: amountText);
    formDateValue = createFormDateValue(dateValue);
  }

  Future<void> _sentDataToHomePage(BuildContext context) async {
    try {
      var amount = int.parse(amountController.text);
      var remark = remarksController.text.trim();
      if (remark.isEmpty) throw Exception("Remarks required");
      var expense = NewExpense(remark, amount, category);
      Navigator.pop(context, expense);
    } on Exception {
      const errorMsg = "Unable to add expense, try editing the values";
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text(errorMsg)));
    }
  }

  InputDecoration _createInputDecoration(String label) {
    return InputDecoration(
      border: const UnderlineInputBorder(),
      labelText: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(APP_TITLE),
      ),
      body: Center(
          child: Container(
        decoration: getBoxDecorationWithShadow(),
        height: MediaQuery.of(context).size.height * 0.58,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  formTitle,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: Colors.pink.shade600),
                ),
                const ContainerSizeBox(),
                Text(
                  formDateValue,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.pink.shade300),
                ),
                const ContainerSizeBox(),
                TextFormField(
                  maxLength: 55,
                  controller: remarksController,
                  decoration: _createInputDecoration('Remarks'),
                ),
                const ContainerSizeBox(),
                TextFormField(
                  maxLength: 10,
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: _createInputDecoration('Amount'),
                ),
                const ContainerSizeBox(),
                ListTile(
                  leading: ExpenseCategoryBar(category.icon, category.color),
                  trailing: const Icon(Icons.add),
                  title: DropdownButton(
                      value: category,
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
                          category = newCategory!;
                        });
                      }),
                ),
                const ContainerSizeBox(),
                ElevatedButton.icon(
                    onPressed: () {
                      _sentDataToHomePage(context);
                    },
                    icon: Icon(iconData),
                    label: Text(formTitle.toUpperCase()))
              ],
            )),
      )),
    );
  }

  static createFormDateValue(String? source) {
    if (source == null) {
      return DateFormat(DATE_FORMAT).format(DateTime.now());
    }
    return DateFormat(DATE_FORMAT).format(DateTime.parse(source));
  }
}

class AddNewExpensePage extends AddNewPage {
  const AddNewExpensePage({super.key});
}

class EditExpensePage extends AddNewPage {
  final Expense expense;

  EditExpensePage(this.expense, {super.key})
      : super(
            category: expense.category,
            iconData: Icons.edit,
            remarks: expense.title,
            amountText: expense.amount.round().toString(),
            formTitle: "Edit Expense",
            dateValue: expense.paidDate);
}

class AddNewFavouritePage extends AddNewPage {
  const AddNewFavouritePage({super.key})
      : super(
          formTitle: "Add Favourite Expense",
        );
}
