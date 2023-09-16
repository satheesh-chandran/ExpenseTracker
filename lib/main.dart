import 'package:first_flutter_app/Expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:grouped_list/grouped_list.dart';

import 'AddExpensePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 'DROP TABLE IF EXISTS expense;
  var schema = 'CREATE TABLE expense('
      'id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'
      ' title VARCHAR(100) NOT NULL,'
      ' amount REAL NOT NULL,'
      ' category VARCHAR(100) NOT NULL,'
      ' paid_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,'
      ' isRefundable INTEGER DEFAULT 0,'
      ' refundedAmount REAL DEFAULT 0,'
      ' deletionMarker INTEGER DEFAULT 0);';
  // var database = openDatabase(
  //   join(await getDatabasesPath(), 'expense_table.db'),
  //   onCreate: (db, version) {
  //     return db.execute(schema);
  //   },
  //   version: 1,
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var data = ThemeData(
      fontFamily: 'nunito',
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.black)
          .copyWith(background: Colors.grey.shade200),
    );
    return MaterialApp(
      title: 'Flutter Demo',
      theme: data,
      home: const HomePage(title: 'Budget tracker'),
    );
  }
}

class ExpenseCategoryBar extends StatelessWidget {
  const ExpenseCategoryBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      alignment: Alignment.center,
      child: const CircleAvatar(
        child: Icon(Icons.access_time_outlined),
      ),
    );
  }
}

class ExpenseItem extends StatelessWidget {
  late Dummy expense;

  ExpenseItem(this.expense, {super.key});

  @override
  Widget build(BuildContext context) {
    var categoryStyle = TextStyle(
        color: Colors.grey.shade800,
        fontSize: 14,
        overflow: TextOverflow.ellipsis,
        fontWeight: FontWeight.w500);
    return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        margin: const EdgeInsets.all(5),
        child: ListTile(
          title: Text(expense.title,
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis,
                  color: Colors.black)),
          subtitle: Text(expense.category.name, style: categoryStyle),
          leading: const ExpenseCategoryBar(),
          trailing: Text(expense.amount.toString(),
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.green.shade800,
                  fontSize: 18)),
        ));
  }
}

Dummy createDummyModel(String date) {
  return Dummy(
      title: "Kerala vision",
      amount: 1000.50,
      category: Category.bills,
      paidDate: date);
}

class ExpenseView extends StatelessWidget {
  const ExpenseView({super.key});

  @override
  Widget build(BuildContext context) {
    var elements = [
      createDummyModel("2023 09 16"),
      createDummyModel("2023 09 16"),
      createDummyModel("2023 09 16"),
      createDummyModel("2023 09 15"),
      createDummyModel("2023 09 14"),
      createDummyModel("2023 09 14"),
      createDummyModel("2023 09 14"),
      createDummyModel("2023 09 14"),
      createDummyModel("2023 09 16"),
      createDummyModel("2023 09 11"),
      createDummyModel("2023 09 11"),
      createDummyModel("2023 09 11"),
      createDummyModel("2023 09 13"),
      createDummyModel("2023 09 13"),
      createDummyModel("2023 09 20"),
      createDummyModel("2023 09 16"),
      createDummyModel("2023 09 20"),
      createDummyModel("2023 09 21"),
      createDummyModel("2023 09 21"),
      createDummyModel("2023 09 16"),
      createDummyModel("2023 09 16"),
    ];

    return GroupedListView<Dummy, String>(
      elements: elements,
      groupBy: (element) => element.paidDate,
      groupSeparatorBuilder: (String groupByValue) {
        var separatorStyle = TextStyle(
            color: Colors.grey.shade700,
            overflow: TextOverflow.ellipsis,
            fontStyle: FontStyle.italic,
            fontSize: 15,
            fontWeight: FontWeight.w400);
        return Container(
            margin: const EdgeInsets.only(top: 5, bottom: 5),
            color: Colors.pink.shade50,
            child: Row(
              children: [
                Padding(
                    padding:
                        const EdgeInsets.only(left: 20, bottom: 10, top: 10),
                    child: Text(groupByValue,
                        textAlign: TextAlign.left, style: separatorStyle)),
                Padding(
                    padding:
                        const EdgeInsets.only(left: 160, bottom: 10, top: 10),
                    child: Text("Expense: 3003 /-", style: separatorStyle)),
              ],
            ));
      },
      itemBuilder: (context, Dummy element) => ExpenseItem(element),
      itemComparator: (item1, item2) =>
          item1.paidDate.compareTo(item2.paidDate),
      useStickyGroupSeparators: true,
      floatingHeader: true,
      order: GroupedListOrder.DESC,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    const tabHeaderTextStyle =
        TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Budget Tracker"),
          bottom: const TabBar(
            labelPadding: EdgeInsets.all(10),
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Text("Expenses", style: tabHeaderTextStyle),
              Text("Insights", style: tabHeaderTextStyle),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ExpenseView(),
            Icon(Icons.add_chart_outlined),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddExpensePage()),
            );
          },
          tooltip: 'Add Expense',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
