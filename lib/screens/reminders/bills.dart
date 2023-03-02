import 'package:familist_2/widgets/reminders/bill.dart';
import 'package:flutter/material.dart';

import '../../utils/remindersHelper.dart';

class Bills extends StatelessWidget {
  const Bills({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
          future: RemindersHelpers().getBills(context),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              // Build a list of HomeCard widgets using the data from the snapshot
              List<Bill> homeCards = [];
              snapshot.data.forEach((userId, bills) {
                bills.forEach((bill) {
                  homeCards.add(
                    Bill(
                      user: bill["fullName"],
                      repeated: bill["repeated in"],
                      text: bill["item name"],
                      price: bill["price"],
                      uid: bill["userID"],
                      billId: bill["billID"],
                      initCompleted: bill["completed"],
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
      // Bill(text: "Electricity", price: "1,500.000"),
      // Bill(text: "Electricity", price: "1,500.000")
    );
  }
}
