import 'package:flutter/material.dart';

typedef DeleteCallback = Future<int> Function(int id, bool shouldRedirect);

enum ExpenseCategory {
  education(
      "Education",
      Icon(
        Icons.menu_book_sharp,
        color: Colors.white,
      ),
      Color(0xFFEF9A9A)),
  healthcare("Healthcare", Icon(Icons.health_and_safety, color: Colors.white),
      Color(0xFFA5D6A7)),
  sports(
    "Sports & Memberships",
    Icon(Icons.sports_tennis, color: Colors.white),
    Color(0xFF64B5F6),
  ),
  vehicle("Vehicle & Transportation",
      Icon(Icons.electric_bike, color: Colors.white), Color(0xFFF48FB1)),
  bills("Utility Bills", Icon(Icons.library_books, color: Colors.white),
      Color(0xFFFFB74D)),
  gift("Gift purchases", Icon(Icons.card_giftcard, color: Colors.white),
      Color(0xFFFFF176)),
  shopping("Shopping", Icon(Icons.add_shopping_cart, color: Colors.white),
      Color(0xFF80DEEA)),
  groceries("Groceries & Grains",
      Icon(Icons.local_grocery_store, color: Colors.white), Color(0xFF7986CB)),
  food("Food & Beverages", Icon(Icons.emoji_food_beverage, color: Colors.white),
      Colors.amber),
  petcare("Pet care expense", Icon(Icons.pets, color: Colors.white),
      Color(0xFF76FF03)),
  childcare("Child care expense", Icon(Icons.child_care, color: Colors.white),
      Color(0xFFBCAAA4)),
  communication("Communication", Icon(Icons.phone, color: Colors.white),
      Color(0xFF9575CD)),
  entertainments(
      "Entertainments", Icon(Icons.tv, color: Colors.white), Color(0xFFCE93D8)),
  house("Other House needs", Icon(Icons.home, color: Colors.white),
      Color(0xFFFF9E80)),
  investments(
      "Investments", Icon(Icons.money, color: Colors.white), Color(0xFFE57373)),
  office("Office needs", Icon(Icons.local_post_office, color: Colors.white),
      Color(0xFFFF7043)),
  emi(
    "Monthly installment premium",
    Icon(Icons.monetization_on, color: Colors.white),
    Color(0xFFAB47BC),
  ),
  fruitsAndVegetables("Fruits & Vegetables",
      Icon(Icons.energy_savings_leaf, color: Colors.white), Color(0xFFB388FF)),
  fishAndMeat(
      "Fish & Meat", Icon(Icons.fastfood, color: Colors.white), Colors.lime),
  miscellaneous("Miscellaneous",
      Icon(Icons.other_houses_outlined, color: Colors.white), Colors.lightBlue),
  insurances("Insurance & Securities",
      Icon(Icons.attach_money, color: Colors.white), Color(0xFFA5D6A7));

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

class EditExpenseModel {
  final int id;
  final String title;
  final int amount;
  final ExpenseCategory category;

  const EditExpenseModel(this.id, this.title, this.amount, this.category);
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
