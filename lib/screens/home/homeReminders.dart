import 'package:familist_2/widgets/home/homeCard.dart';

import 'package:flutter/material.dart';

class HomeReminders extends StatelessWidget {
  const HomeReminders({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        HomeCard(
          home: true,
          shoppingList: false,
          title: "Buang Sampah",
          extra: "13 Jan 2023",
        ),
      ],
    );
  }
}
