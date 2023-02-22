import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';

class Member extends StatelessWidget {
  final String name;
  const Member({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 7,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.person_outline_rounded,
                  color: sColor,
                ),
                const SizedBox(
                  width: 15,
                ),
                Text(
                  name,
                  style: GoogleFonts.inter(
                      fontSize: 14, color: sColor, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
            Positioned(
              top: 5,
              right: 0,
              child: Row(
                children: const [
                  Icon(
                    Icons.edit_outlined,
                    size: 16,
                    color: sColor,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Icon(
                    Icons.delete_outline_rounded,
                    size: 16,
                    color: Colors.red,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
