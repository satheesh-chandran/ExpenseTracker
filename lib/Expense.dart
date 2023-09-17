import 'package:flutter/material.dart';

enum ExpenseCategory {
  education("Education", Icon(Icons.menu_book_sharp), Color(0xFFEF9A9A)),
  healthcare("Healthcare", Icon(Icons.health_and_safety), Color(0xFFA5D6A7)),
  sports(
    "Sports & Memberships",
    Icon(Icons.sports_tennis),
    Color(0xFF64B5F6),
  ),
  vehicle(
      "Vehicle & Transportation", Icon(Icons.electric_bike), Color(0xFFF48FB1)),
  bills("Utility Bills", Icon(Icons.library_books), Color(0xFFFFB74D)),
  gift("Gift purchases", Icon(Icons.card_giftcard), Color(0xFFFFF176)),
  shopping("Shopping", Icon(Icons.add_shopping_cart), Color(0xFF80DEEA)),
  groceries(
      "Groceries & Grains", Icon(Icons.local_grocery_store), Color(0xFF7986CB)),
  food("Food & Beverages", Icon(Icons.emoji_food_beverage), Colors.amber),
  petcare("Pet care expense", Icon(Icons.pets), Color(0xFF76FF03)),
  childcare("Child care expense", Icon(Icons.child_care), Color(0xFFBCAAA4)),
  communication("Communication", Icon(Icons.phone), Color(0xFF9575CD)),
  entertainments("Entertainments", Icon(Icons.tv), Color(0xFFCE93D8)),
  house("Other House needs", Icon(Icons.home), Color(0xFFFF9E80)),
  investments("Investments", Icon(Icons.money), Color(0xFFE57373)),
  office("Office needs", Icon(Icons.local_post_office), Color(0xFFFF7043)),
  emi(
    "Monthly installment premium",
    Icon(Icons.monetization_on),
    Color(0xFFAB47BC),
  ),
  fruitsAndVegetables("Fruits & Vegetables", Icon(Icons.energy_savings_leaf),
      Color(0xFFB388FF)),
  fishAndMeat("Fish & Meat", Icon(Icons.fastfood), Colors.lime),
  miscellaneous(
      "Miscellaneous", Icon(Icons.other_houses_outlined), Colors.lightBlue),
  insurances(
      "Insurance & Securities", Icon(Icons.attach_money), Color(0xFFA5D6A7));

  final String qualifiedName;
  final Icon icon;
  final Color color;

  const ExpenseCategory(this.qualifiedName, this.icon, this.color);
}

enum FilterCategory {
  since,
  dateRange,
  lastMonth,
  lastWeek,
  lastThreeMonths,
  lastSixMonths
}

class RawExpenseModel {
  final int id;
  final String title;
  final double amount;
  final ExpenseCategory category;
  final String paidDate;
  final bool isRefundable;
  final double refundedAmount;
  final bool deletionMarker;

  const RawExpenseModel(
      {required this.id,
      required this.title,
      required this.amount,
      required this.category,
      required this.paidDate,
      required this.isRefundable,
      required this.refundedAmount,
      required this.deletionMarker});
}

class NewExpense {
  final String title;
  final int amount;
  final ExpenseCategory category;

  const NewExpense(this.title, this.amount, this.category);

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'category': category.name,
    };
  }
}

class Dummy {
  final String title;
  final double amount;
  final ExpenseCategory category;
  final String paidDate;

  const Dummy({
    required this.title,
    required this.amount,
    required this.category,
    required this.paidDate,
  });
}
