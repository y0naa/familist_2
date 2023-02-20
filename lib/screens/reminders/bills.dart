import 'package:familist_2/widgets/reminders/bill.dart';
import 'package:flutter/material.dart';

class Bills extends StatelessWidget {
  const Bills({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Bill(text: "Electricity", price: "1,500.000"),
        Bill(text: "Electricity", price: "1,500.000")
      ],
    );
  }
}
