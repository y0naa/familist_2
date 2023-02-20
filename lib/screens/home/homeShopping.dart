import 'package:familist_2/widgets/home/homeCard.dart';
import 'package:flutter/material.dart';

class HomeShopping extends StatelessWidget {
  const HomeShopping({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        HomeCard(
          shoppingList: true,
          title: "Fiesta Chicken Nugget",
          extra: "20000",
        ),
      ],
    );
  }
}
