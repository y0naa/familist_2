import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';

class DropdownTime extends StatefulWidget {
  const DropdownTime({super.key});

  @override
  State<DropdownTime> createState() => _DropdownTimeState();
}

class _DropdownTimeState extends State<DropdownTime> {
  final items = ["A.M", "P.M."];
  String _selected = "";
  @override
  void initState() {
    _selected = items[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          iconSize: 12,
          value: _selected,
          buttonHeight: 35,
          buttonWidth: 50,
          buttonPadding: const EdgeInsets.only(left: 5, right: 5),
          buttonDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.white,
          ),
          buttonElevation: 2,
          itemHeight: 40,
          itemPadding: const EdgeInsets.only(left: 5, right: 5),
          dropdownMaxHeight: 200,
          dropdownWidth: 50,
          dropdownPadding: null,
          dropdownDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.white,
          ),
          dropdownElevation: 8,
          scrollbarRadius: const Radius.circular(40),
          scrollbarThickness: 6,
          scrollbarAlwaysShow: true,
          hint: Row(
            children: [
              const Icon(
                Icons.list,
                size: 16,
                color: Colors.grey,
              ),
              Expanded(
                child: Text(
                  'Select Item',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: sColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          items: items.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Center(
                child: Text(
                  items,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: sColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selected = value as String;
            });
          },
        ),
      ),
    );
  }
}
