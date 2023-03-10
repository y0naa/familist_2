import 'package:familist_2/widgets/reminders/bill.dart';
import 'package:flutter/material.dart';

import '../../utils/remindersHelper.dart';

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
              allBills.sort((a, b) => a['repeated in']
                  .toString()
                  .compareTo(b['repeated in'].toString()));

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
