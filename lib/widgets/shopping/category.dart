import 'package:familist_2/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Category extends StatelessWidget {
  final String text;
  final Function()? onTap;
  final bool tapped;
  const Category(
      {super.key, required this.text, this.onTap, required this.tapped});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: ButtonStyle(
        backgroundColor: tapped
            ? MaterialStatePropertyAll<Color>(tColor.withOpacity(0.43))
            : MaterialStatePropertyAll<Color>(tagBgColor.withOpacity(0)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            side: BorderSide(color: tColor.withOpacity(0.43)),
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: GoogleFonts.inter(
                fontSize: 14, color: sColor, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}
