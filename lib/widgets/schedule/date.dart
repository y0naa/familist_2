import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';

class Date extends StatelessWidget {
  final String day;
  final String initial;
  final bool tapped;
  final Function()? ontap;

  const Date(
      {super.key,
      required this.day,
      required this.initial,
      required this.tapped,
      this.ontap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        minimumSize: Size.zero, // Set this
        padding: const EdgeInsets.all(10), // and this
        backgroundColor: tapped ? tagBgColor : tagBgColor.withOpacity(0),
      ),
      onPressed: ontap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            day,
            style: GoogleFonts.inter(
                fontSize: 14, color: sColor, fontWeight: FontWeight.w800),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 1, right: 0),
            child: Text(
              initial,
              style: GoogleFonts.inter(
                  fontSize: 32, color: sColor, fontWeight: FontWeight.w800),
            ),
          )
        ],
      ),
    );
  }
}
