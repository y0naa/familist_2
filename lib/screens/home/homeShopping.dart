import 'package:familist_2/utils/auth.dart';
import 'package:familist_2/utils/profile.dart';
import 'package:familist_2/widgets/home/homeCard.dart';
import 'package:flutter/material.dart';

import '../../widgets/shopping/shoppingItem.dart';
import '../shopping/shoppingHelper.dart';

class HomeShopping extends StatefulWidget {
  const HomeShopping({super.key});

  @override
  State<HomeShopping> createState() => _HomeShoppingState();
}

class _HomeShoppingState extends State<HomeShopping> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ShoppingHelper().getShoppingItems(context),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          List<Widget> shoppingCards = [];
          List<Map<String, dynamic>> allShopping = [];
          List<Map<String, dynamic>> completedShopping = [];
          List<Map<String, dynamic>> incompleteShopping = [];

          snapshot.data.forEach((userId, shopping) {
            allShopping.addAll(shopping);
          });

          allShopping = allShopping
              .where((item) => item['userID'] == item['currentID'])
              .toList();

          // ! complete and incomplete filters
          for (var item in allShopping) {
            if (item["completed"]) {
              completedShopping.add(item);
            } else {
              incompleteShopping.add(item);
            }
          }

          for (var item in incompleteShopping) {
            shoppingCards.add(
              ShoppingItem(
                item: item,
                refresh: () {
                  setState(() {});
                },
              ),
            );
          }

          for (var item in completedShopping) {
            shoppingCards.add(
              ShoppingItem(
                item: item,
                refresh: () {
                  setState(() {});
                },
              ),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: shoppingCards.length > 5 ? 5 : shoppingCards.length,
            itemBuilder: (BuildContext context, int index) {
              return shoppingCards[index];
            },
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
