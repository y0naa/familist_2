// ignore_for_file: file_names

import 'package:familist_2/screens/shopping/shoppingHelper.dart';
import 'package:familist_2/utils/currency.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';
import '../dialog.dart';

class ShoppingItem extends StatelessWidget {
  final Map item;
  final bool home;
  final Function() refresh;
  final Function() setLoading;
  final Function() doneLoading;
  final String route;
  const ShoppingItem(
      {super.key,
      required this.item,
      required this.refresh,
      required this.route,
      required this.setLoading,
      required this.doneLoading,
      required this.home});

  @override
  Widget build(BuildContext context) {
    Future deleteItem() async {
      debugPrint(item['itemID']);
      await ShoppingHelper().deleteItem(context, item['itemID']);
    }

    void updateItem() async {
      setLoading();
      print("tes");
      await ShoppingHelper().toggleCompletedItem(
          item['userID'], item['itemID'], !item['completed']);
      refresh();
      doneLoading();
    }

    return Dismissible(
      key: ValueKey(item['itemID']),
      direction: home ? DismissDirection.none : DismissDirection.horizontal,
      onDismissed: (direction) {
        updateItem();
      },
      background: item['completed']
          ? Container(
              color: Colors.red,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 16),
                  Icon(Icons.remove_circle_outline, color: Colors.white),
                ],
              ),
            )
          : Container(
              color: Colors.green,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 16),
                  Icon(Icons.done, color: Colors.white),
                ],
              ),
            ),
      secondaryBackground: item['completed']
          ? Container(
              color: Colors.red,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 16),
                  Icon(Icons.remove_circle_outline, color: Colors.white),
                ],
              ),
            )
          : Container(
              color: Colors.green,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 16),
                  Icon(Icons.done, color: Colors.white),
                ],
              ),
            ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(children: [
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
                      fontSize: 14, color: sColor, fontWeight: FontWeight.w600),
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
              child: InkWell(
                onTap: () async {
                  print("delete?");
                  bool delete = await deleteDialog(context);
                  if (delete) {
                    await deleteItem();
                    if (context.mounted) {
                      GoRouter.of(context).pushReplacement(route);
                    }
                  }
                  refresh();
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    item['currentID'] == item['userID']
                        ? const Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.red,
                          )
                        : Container(),
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
              ),
            )
          ]),
        ),
      ),
    );
  }
}
