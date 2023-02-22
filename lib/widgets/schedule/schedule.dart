import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';

class Schedule extends StatelessWidget {
  final String time;
  final String title;
  const Schedule({super.key, required this.time, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Row(
            children: [
              Text(
                time,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: sColor,
                ),
              ),
              const SizedBox(width: 15),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: sColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: const [
            Icon(
              Icons.edit,
              color: sColor,
              size: 16,
            ),
            SizedBox(
              width: 10,
            ),
            Icon(
              Icons.delete,
              color: Colors.red,
              size: 16,
            ),
          ],
        ),
      ],
    );
  }
}
