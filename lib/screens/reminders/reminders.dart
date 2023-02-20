import 'package:flutter/material.dart';

import '../../widgets/home/homeCard.dart';

class Reminders extends StatelessWidget {
  const Reminders({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        HomeCard(
          shoppingList: false,
          title: "Buang Sampah",
          extra: "13 Jan 2023",
        ),
        HomeCard(
          shoppingList: false,
          title: "Buang Sampah",
          extra: "13 Jan 2023",
        ),
      ],
    );
  }
}
