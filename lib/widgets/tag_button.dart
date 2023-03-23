import 'package:familist_2/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TagButton extends StatelessWidget {
  final String text;
  final Function()? onTap;
  final bool tapped;
  const TagButton({
    super.key,
    required this.text,
    this.onTap,
    required this.tapped,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: ButtonStyle(
        backgroundColor: tapped
            ? const MaterialStatePropertyAll<Color>(tagBgColor)
            : MaterialStatePropertyAll<Color>(tagBgColor.withOpacity(0)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          color: sColor,
        ),
      ),
    );
  }
}
