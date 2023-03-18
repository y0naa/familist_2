// ignore_for_file: file_names
import 'package:familist_2/constants.dart';
import 'package:familist_2/screens/shopping/shoppingHelper.dart';
import 'package:familist_2/widgets/shopping/category.dart';
import 'package:familist_2/widgets/shopping/shoppingItem.dart';
import 'package:familist_2/widgets/tagButton.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../utils/currency.dart';
import '../../utils/profile.dart';
import '../../widgets/dialog.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  // variables
  String uid = "";
  int _index = 0; // for complete and incomplete state
  int _category = -1;
  double total = 0;

  // text controllers
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String _categoryChosen = "N/A";

  // Methods
  void getUid() async {
    uid = await Profile().getUserID();
  }

  Future addShopping() async {
    try {
      print("cat = $_categoryChosen");
      ShoppingHelper().addShoppingItem({
        "item name": _itemNameController.text.trim(),
        "price": double.tryParse(_priceController.text.trim()),
        "category": _categoryChosen,
        "completed": false,
      }, uid);
      if (context.mounted) {
        dialog(
          context,
          "Saved Successfully",
        );
      }
    } catch (e) {
      dialog(context, e.toString());
    }
  }

  int getCategoryNumber(String category) {
    if (category == "Food") {
      return 0;
    } else if (category == "Beauty") {
      return 1;
    } else {
      return 2;
    }
  }

  // built-in method
  @override
  void initState() {
    super.initState();
    getUid();
  }

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
                              if (mounted) {
                                setState(() {
                                  _category == 0
                                      ? _category = -1
                                      : _category = 0;
                                });
                              }
                            },
                          ),
                          Category(
                            text: "Beauty",
                            tapped: _category == 1 ? true : false,
                            onTap: () {
                              if (mounted) {
                                setState(() {
                                  _category == 1
                                      ? _category = -1
                                      : _category = 1;
                                });
                              }
                            },
                          ),
                          Category(
                            text: "Others",
                            tapped: _category == 2 ? true : false,
                            onTap: () {
                              if (mounted) {
                                setState(() {
                                  _category == 2
                                      ? _category = -1
                                      : _category = 2;
                                });
                              }
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
                              if (mounted) {
                                setState(() {
                                  _index = 0;
                                });
                              }
                            },
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          TagButton(
                            tapped: _index == 1 ? true : false,
                            text: "Completed",
                            onTap: () {
                              if (mounted) {
                                setState(() {
                                  _index = 1;
                                });
                              }
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
                            Currency.convertToIdr(total),
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
                      child: FutureBuilder(
                        future: ShoppingHelper().getShoppingItems(context),
                        builder: (BuildContext context, snapshot) {
                          if (snapshot.hasData) {
                            total = 0;
                            List<Widget> shoppingCards = [];
                            List<Map<String, dynamic>> allShopping = [];
                            List<Map<String, dynamic>> filtered = [];
                            List<Map<String, dynamic>> completedShopping = [];
                            List<Map<String, dynamic>> incompleteShopping = [];

                            snapshot.data.forEach((userId, reminders) {
                              allShopping.addAll(reminders);
                            });

                            // ! category filters
                            if (_category == 0) {
                              filtered = allShopping
                                  .where((item) => item['category'] == 'Food')
                                  .toList();
                            } else if (_category == 1) {
                              filtered = allShopping
                                  .where((item) => item['category'] == 'Beauty')
                                  .toList();
                            } else if (_category == 2) {
                              filtered = allShopping
                                  .where((item) => item['category'] == 'Others')
                                  .toList();
                            } else {
                              filtered = allShopping;
                            }

                            // ! complete and incomplete filters
                            for (var item in filtered) {
                              if (item["completed"]) {
                                completedShopping.add(item);
                              } else {
                                incompleteShopping.add(item);
                              }
                            }

                            if (_index == 0) {
                              for (var item in incompleteShopping) {
                                total = total + item["price"];
                                shoppingCards.add(
                                  ShoppingItem(
                                    route: "/shopping",
                                    item: item,
                                    refresh: () {
                                      if (mounted) {
                                        setState(() {
                                          ShoppingHelper()
                                              .getShoppingItems(context);
                                        });
                                      }
                                    },
                                  ),
                                );
                              }
                            } else {
                              for (var item in completedShopping) {
                                total = total + item["price"];
                                shoppingCards.add(
                                  ShoppingItem(
                                    route: "/shopping",
                                    item: item,
                                    refresh: () {
                                      if (mounted) {
                                        setState(() {
                                          ShoppingHelper()
                                              .getShoppingItems(context);
                                        });
                                      }
                                    },
                                  ),
                                );
                              }
                            }

                            // * refreshing total
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (mounted) {
                                setState(() {});
                              }
                            });

                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: ListView(
                                shrinkWrap: true,
                                children: shoppingCards,
                              ),
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
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            controller: ModalScrollController.of(context),
            child: Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                      controller: _itemNameController,
                      decoration: InputDecoration(
                        hintText: "Input item name here",
                        filled: true,
                        fillColor: Colors.grey.shade100.withOpacity(0.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                              color: Colors.grey.shade100, width: 0.0),
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
                      controller: _priceController,
                      keyboardType: TextInputType.number,
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
                          borderSide: BorderSide(
                              color: Colors.grey.shade100, width: 0.0),
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
                            debugPrint("test category ");
                            if (_category == 0) {
                              _category = -1;
                            } else {
                              _category = 0;
                              _categoryChosen = "Food";
                            }
                            if (mounted) {
                              setState(() {});
                            }
                          },
                        ),
                        Category(
                          text: "Beauty",
                          tapped: _category == 1 ? true : false,
                          onTap: () {
                            if (mounted) {
                              setState(() {
                                if (_category == 1) {
                                  _category = -1;
                                } else {
                                  _category = 1;
                                  _categoryChosen = "Beauty";
                                }
                              });
                            }
                          },
                        ),
                        Category(
                          text: "Others",
                          tapped: _category == 2 ? true : false,
                          onTap: () {
                            if (mounted) {
                              setState(() {
                                if (_category == 2) {
                                  _category = -1;
                                } else {
                                  _category = 2;
                                  _categoryChosen = "Others";
                                }
                              });
                            }
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
                            onPressed: () async {
                              await addShopping();
                              if (mounted) {
                                GoRouter.of(context)
                                    .pushReplacement("/shopping");
                              }
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 16, bottom: 16),
                              child: Text(
                                "Save",
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
          ),
        );
      }),
    );
  }
}
