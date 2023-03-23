import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';
import '../../utils/profile.dart';

class Member extends StatefulWidget {
  final String name;
  final bool isUser;
  final String docID;
  final VoidCallback refresh;
  const Member(
      {super.key,
      required this.name,
      required this.isUser,
      required this.docID,
      required this.refresh});

  @override
  State<Member> createState() => _MemberState();
}

class _MemberState extends State<Member> {
  Future deleteMember() async {
    print("deleteMember");
    await Profile().updateData(widget.docID, {
      "fuid": "",
    });
  }

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
                  widget.name,
                  style: GoogleFonts.inter(
                      fontSize: 14, color: sColor, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
            widget.isUser
                ? Container()
                : Positioned(
                    top: -13,
                    right: 0,
                    child: IconButton(
                      onPressed: () async {
                        await deleteMember();
                        widget.refresh();
                      },
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        size: 16,
                        color: Colors.red,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
