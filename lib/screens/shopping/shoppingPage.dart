import 'package:familist_2/constants.dart';
import 'package:familist_2/widgets/shopping/category.dart';
import 'package:familist_2/widgets/shopping/shoppingItem.dart';
import 'package:familist_2/widgets/tagButton.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:google_fonts/google_fonts.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  int _index = 0; // for complete and incomplete state
  int _category = 0; //index for category
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0A369D),
        child: const Icon(Icons.add),
        onPressed: () {
          showShoppingModal(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 64),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Shopping List",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                height: 200,
                decoration: const BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(70),
                    topRight: Radius.circular(70),
                  ),
                ),
                child:
                    // main column for white area
                    Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // category row
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 24, left: 12, right: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Category(
                            text: "Food",
                            tapped: _category == 0 ? true : false,
                            onTap: () {
                              setState(() {
                                _category == 0 ? _category = -1 : _category = 0;
                              });
                            },
                          ),
                          Category(
                            text: "Beauty",
                            tapped: _category == 1 ? true : false,
                            onTap: () {
                              setState(() {
                                _category == 1 ? _category = -1 : _category = 1;
                              });
                            },
                          ),
                          Category(
                            text: "Others",
                            tapped: _category == 2 ? true : false,
                            onTap: () {
                              setState(() {
                                _category == 2 ? _category = -1 : _category = 2;
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    // complete incomplete
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TagButton(
                            tapped: _index == 0 ? true : false,
                            text: "Incomplete",
                            onTap: () {
                              setState(() {
                                _index = 0;
                              });
                            },
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          TagButton(
                            tapped: _index == 1 ? true : false,
                            text: "Completed",
                            onTap: () {
                              setState(() {
                                _index = 1;
                              });
                            },
                          )
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(32),
                      child: Container(
                        height: 1,
                        color: sColor,
                      ),
                    ),

                    // Total
                    Padding(
                      padding: const EdgeInsets.only(left: 32),
                      child: Row(
                        children: [
                          Text(
                            "Total: ",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: sColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          // Price total
                          Text(
                            "[Rp. 5.000.000.000]",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: sColor,
                            ),
                          )
                        ],
                      ),
                    ),

                    // show list
                    const SizedBox(
                      height: 10,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 24, right: 24),
                      child:
                          // separate widget
                          Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          ShoppingItem(
                            text: "Fiesta Chicken Nuggets",
                            price: "50.000",
                            category: 0,
                          ),
                          ShoppingItem(
                            text: "Contoh",
                            price: "50.000",
                            category: 0,
                          ),
                          ShoppingItem(
                            text: "Fiesta Chicken Nuggets",
                            price: "50.000",
                            category: 0,
                          ),
                          ShoppingItem(
                            text: "Fiesta Chicken Nuggets",
                            price: "50.000",
                            category: 0,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<dynamic> showShoppingModal(BuildContext context) {
    return showBarModalBottomSheet(
      context: context,
      builder: (context) =>
          StatefulBuilder(builder: (BuildContext context, setState) {
        return SingleChildScrollView(
          controller: ModalScrollController.of(context),
          child: Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Create an item",
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      color: sColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: Text(
                    "Item name",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: sColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 32, right: 32, top: 14, bottom: 32),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Input item name here",
                      filled: true,
                      fillColor: Colors.grey.shade100.withOpacity(0.5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide:
                            BorderSide(color: Colors.grey.shade100, width: 0.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: Text(
                    "Price per piece",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: sColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 32, right: 32, top: 14, bottom: 32),
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          'Rp.',
                          style: GoogleFonts.inter(
                              fontSize: 18,
                              color: sColor,
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                      hintText: "Enter item price",
                      filled: true,
                      fillColor: Colors.grey.shade100.withOpacity(0.5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide:
                            BorderSide(color: Colors.grey.shade100, width: 0.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: Text(
                    "Category",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: sColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 32, right: 32, top: 14, bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Category(
                        text: "Food",
                        tapped: _category == 0 ? true : false,
                        onTap: () {
                          setState(() {
                            _category == 0 ? _category = -1 : _category = 0;
                          });
                        },
                      ),
                      Category(
                        text: "Beauty",
                        tapped: _category == 1 ? true : false,
                        onTap: () {
                          setState(() {
                            _category == 1 ? _category = -1 : _category = 1;
                          });
                        },
                      ),
                      Category(
                        text: "Others",
                        tapped: _category == 2 ? true : false,
                        onTap: () {
                          setState(() {
                            _category == 2 ? _category = -1 : _category = 2;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 32, right: 32, top: 32, bottom: 32),
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                              const Color(0xFF0A369D).withOpacity(0.8),
                            ),
                          ),
                          onPressed: () {},
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 16),
                            child: Text(
                              "Done",
                              style: GoogleFonts.inter(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
