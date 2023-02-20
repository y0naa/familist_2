import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';

class ShoppingItem extends StatelessWidget {
  final String text;
  final String price;
  final int category;
  const ShoppingItem(
      {super.key,
      required this.text,
      required this.price,
      required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                category == 0
                    ? "🍕"
                    : category == 1
                        ? "💄"
                        : "🎲",
                style: GoogleFonts.inter(fontSize: 48),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        color: sColor,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Jowna",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: sColor,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.red,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "[Rp. $price]",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: sColor,
                      ),
                    ),
                  ],
                ),
              )
            ]),
      ),
    );
  }
}
