import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:familist_2/utils/scheduleHelper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';
import '../../utils/profile.dart';

class Dropdown extends StatefulWidget {
  final List<String> items;
  final ValueChanged<String> onChanged;
  final bool isFuture;

  const Dropdown({
    super.key,
    required this.items,
    required this.onChanged,
    required this.isFuture,
  });

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  String _selected = "";
  String name = "";

  void getName() async {
    name = await Profile().getCurrentName();
  }

  @override
  void initState() {
    if (!widget.isFuture) {
      _selected = widget.items[0];
    } else {
      getName();
      _selected = name;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return widget.isFuture
        ? FutureBuilder(
            future: ScheduleHelper().checkUser(widget.items),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                int data = snapshot.data!;
                if (widget.items.isNotEmpty) {
                  if (_selected.isEmpty) {
                    _selected = widget.items[data];
                  }
                } else {
                  _selected = "No item found";
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      iconSize: 16,
                      value: _selected,
                      buttonHeight: 35,
                      buttonWidth: size.width * 0.5,
                      buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                      buttonDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.white,
                      ),
                      buttonElevation: 2,
                      itemHeight: 40,
                      itemPadding: const EdgeInsets.only(left: 14, right: 14),
                      dropdownMaxHeight: 200,
                      dropdownWidth: 200,
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
                          const SizedBox(
                            width: 4,
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
                      items: widget.items.map((String items) {
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
                        widget.onChanged(value!);
                      },
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: Text("No user found"),
                );
              }
            })
        : Padding(
            padding: const EdgeInsets.only(top: 0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2(
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                iconSize: 16,
                value: _selected,
                buttonHeight: 35,
                buttonWidth: size.width * 0.5,
                buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                buttonDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white,
                ),
                buttonElevation: 2,
                itemHeight: 40,
                itemPadding: const EdgeInsets.only(left: 14, right: 14),
                dropdownMaxHeight: 200,
                dropdownWidth: 200,
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
                    const SizedBox(
                      width: 4,
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
                items: widget.items.map((String items) {
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
                  widget.onChanged(value!);
                },
              ),
            ),
          );
  }
}
