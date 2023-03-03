import 'package:familist_2/widgets/reminders/bill.dart';
import 'package:flutter/material.dart';

import '../../utils/remindersHelper.dart';

class Bills extends StatelessWidget {
  final VoidCallback refresh;
  const Bills({super.key, required this.refresh});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
          future: RemindersHelpers().getBills(context),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              List<Bill> homeCards = [];
              snapshot.data.forEach((userId, bills) {
                bills.forEach((bill) {
                  homeCards.add(
                    Bill(
                      canDelete:
                          bill['userID'] == bill['currentID'] ? true : false,
                      user: bill["fullName"],
                      repeated: bill["repeated in"],
                      text: bill["item name"],
                      price: bill["price"],
                      uid: bill["userID"],
                      billId: bill["billID"],
                      initCompleted: bill["completed"],
                      refresh: refresh,
                    ),
                  );
                });
              });

              return ListView(
                shrinkWrap: true,
                children: homeCards,
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
