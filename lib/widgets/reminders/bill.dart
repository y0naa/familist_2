import 'package:familist_2/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Bill extends StatelessWidget {
  final String text;
  final String price;
  const Bill({super.key, required this.text, required this.price});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "⚡",
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
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        Text(
                          "Repeated in ",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: sColor,
                          ),
                        ),
                        Text(
                          "30 ",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: sColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "days",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: sColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      "Jowna",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: sColor,
                      ),
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
