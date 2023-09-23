import 'package:flutter/material.dart';

class ExpenseCategoryBar extends StatelessWidget {
  final Icon icon;
  final Color color;

  const ExpenseCategoryBar(this.icon, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      alignment: Alignment.center,
      child: CircleAvatar(
        backgroundColor: color,
        child: icon,
      ),
    );
  }
}
