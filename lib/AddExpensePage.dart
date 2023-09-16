
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
  Category dropdownValue = Category.miscellaneous;

  @override
  Widget build(BuildContext context) {
    const dateFormat = 'dd MMMM yyyy, hh:mm aaa';
    var formatter = DateFormat(dateFormat);
    var localDate = formatter.format(DateTime.now());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Budget Tracker"),
      ),
      body: Center(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Color(0xffDDDDDD),
                  blurRadius: 6.0,
                  spreadRadius: 2.0,
                  offset: Offset(0.0, 0.0),
                )
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.45,
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
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Remarks',
                      ),
                    ),
                    const ContainerSizeBox(),
                    TextFormField(
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
                      leading: const ExpenseCategoryBar(),
                      trailing: const Icon(Icons.add),
                      title: DropdownButton(
                          value: dropdownValue,
                          underline: Container(),
                          isExpanded: true,
                          items: Category.values.map((Category value) {
                            return DropdownMenuItem<Category>(
                              value: value,
                              child: Text(value.name.toUpperCase()),
                            );
                          }).toList(),
                          onChanged: (newCategory) {
                            setState(() {
                              dropdownValue = newCategory!;
                            });
                          }),
                    ),
                    const ContainerSizeBox(),
                    ElevatedButton(
                        onPressed: () {}, child: const Text("ADD EXPENSE"))
                  ],
                )),
          )),
    );
  }
}
