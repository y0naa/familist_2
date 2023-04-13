import 'package:familist_2/widgets/reminders/bill.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/modules/reminders_helper.dart';

class Bills extends StatefulWidget {
  final VoidCallback refresh;
  const Bills({super.key, required this.refresh});

  @override
  State<Bills> createState() => _BillsState();
}

class _BillsState extends State<Bills> {
  @override
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
          future: RemindersHelpers().getBills(context),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              List<Bill> billCards = [];
              List<Map<String, dynamic>> allBills = [];
              snapshot.data.forEach((userId, bills) {
                allBills.addAll(bills);
              });
              if (allBills.isEmpty) {
                return Center(
                  child: Text(
                    "No items found",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }
              allBills.sort((a, b) => a['repeated in'] - b['repeated in']);
              for (var bill in allBills) {
                billCards.add(
                  Bill(
                    canDelete:
                        bill['userID'] == bill['currentID'] ? true : false,
                    map: bill,
                    refresh: () {
                      setState(() {});
                    },
                  ),
                );
              }

              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: ListView(
                  shrinkWrap: true,
                  children: billCards,
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
      ],
    );
  }
}
