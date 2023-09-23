import 'package:flutter/material.dart';

class WhiteIcon extends Icon {
  const WhiteIcon(IconData icon, {super.key})
      : super(icon, color: Colors.white);
}

enum ExpenseCategory {
  education("Education", WhiteIcon(Icons.menu_book_sharp), Colors.red),
  healthcare("Healthcare", WhiteIcon(Icons.health_and_safety), Colors.green),
  sports(
    "Sports & Memberships",
    WhiteIcon(Icons.sports_tennis),
    Color(0xFF8D6E63),
  ),
  vehicle("Vehicle & Transportation", WhiteIcon(Icons.electric_bike),
      Colors.yellow),
  bills("Utility Bills", WhiteIcon(Icons.library_books), Colors.lime),
  gift("Gift purchases", WhiteIcon(Icons.card_giftcard), Colors.purple),
  shopping("Shopping", WhiteIcon(Icons.add_shopping_cart), Colors.orange),
  groceries(
      "Groceries & Grains", WhiteIcon(Icons.local_grocery_store), Colors.amber),
  food("Food & Beverages", WhiteIcon(Icons.emoji_food_beverage), Colors.indigo),
  petcare("Pet care expense", WhiteIcon(Icons.pets), Colors.cyan),
  childcare("Child care expense", WhiteIcon(Icons.child_care), Colors.pink),
  communication("Communication", WhiteIcon(Icons.phone), Colors.teal),
  entertainments("Entertainments", WhiteIcon(Icons.tv), Colors.blue),
  house("Other House needs", WhiteIcon(Icons.home), Colors.deepPurple),
  investments("Investments", WhiteIcon(Icons.money), Colors.deepOrange),
  office("Office needs", WhiteIcon(Icons.local_post_office), Colors.lightGreen),
  emi(
    "Monthly installment premium",
    WhiteIcon(Icons.monetization_on),
    Color(0xFF4FC3F7),
  ),
  fruitsAndVegetables("Fruits & Vegetables",
      WhiteIcon(Icons.energy_savings_leaf), Color(0xFFB388FF)),
  fishAndMeat("Fish & Meat", WhiteIcon(Icons.fastfood), Color(0xFFDCE775)),
  miscellaneous("Miscellaneous", WhiteIcon(Icons.other_houses_outlined),
      Color(0xFF1565C0)),
  insurances("Insurance & Securities", WhiteIcon(Icons.attach_money),
      Color(0xFFA5D6A7));

  final String qualifiedName;
  final Icon icon;
  final Color color;

  const ExpenseCategory(this.qualifiedName, this.icon, this.color);
}
