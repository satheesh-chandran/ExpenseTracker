enum Category {
  groceries("Groceries & Grains"),
  bills("Bills"),
  investments("Investments"),
  education("Education"),
  emi("EMIs"),
  healthcare("Healthcare"),
  vehicle("Vehicle & Transportation"),
  shopping("Shopping"),
  food("Food & Beverages"),
  entertainments("Entertainments"),
  house("Other House needs"),
  miscellaneous("Miscellaneous");

  final String qualifiedName;

  const Category(this.qualifiedName);
}

class RawExpenseModel {
  final int id;
  final String title;
  final double amount;
  final Category category;
  final int paidDate;
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

class Dummy {
  final String title;
  final double amount;
  final Category category;
  final String paidDate;

  const Dummy({
    required this.title,
    required this.amount,
    required this.category,
    required this.paidDate,
  });
}
