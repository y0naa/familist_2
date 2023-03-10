// ignore_for_file: file_names

import 'package:familist_2/screens/shopping/shoppingHelper.dart';
import 'package:familist_2/utils/currency.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';

class ShoppingItem extends StatelessWidget {
  final Map item;
  final Function() refresh;
  const ShoppingItem({super.key, required this.item, required this.refresh});

  @override
  Widget build(BuildContext context) {
    Future deleteItem() async {
      debugPrint(item['itemID']);
      await ShoppingHelper().deleteItem(context, item['itemID']);
    }

    Future updateItem() async {
      await ShoppingHelper().toggleCompletedItem(
          item['currentID'], item['itemID'], !item['completed']);
    }

    return Dismissible(
      key: Key(item['item name']),
      direction: DismissDirection.horizontal,
      onDismissed: (direction) async {
        await updateItem();
        refresh;
      },
      background: Container(
        color: Colors.green,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.done, color: Colors.white),
            SizedBox(width: 16),
          ],
        ),
      ),
      secondaryBackground: Container(
        color: Colors.green,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.done, color: Colors.white),
            SizedBox(width: 16),
          ],
        ),
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  item['category'] == "Food"
                      ? "🍕 "
                      : item['category'] == "Beauty"
                          ? "💄 "
                          : item['category'] == "Others"
                              ? "🎲 "
                              : "🔀 ",
                  style: GoogleFonts.inter(fontSize: 48),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['item name'],
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          color: sColor,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      item['fullName'],
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: sColor,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () async {
                            await deleteItem();

                            // ignore: use_build_context_synchronously
                            GoRouter.of(context).pushReplacement("/shopping");
                          },
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        Currency.convertToIdr(item['price']),
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: sColor,
                        ),
                      ),
                    ],
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
