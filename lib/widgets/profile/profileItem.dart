import 'package:familist_2/widgets/profile/memberCard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../constants.dart';

class ProfileItem extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isFamily;
  final Function()? ontap;

  const ProfileItem({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.isFamily,
    this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 15),
      child: InkWell(
        onTap: () => isFamily
            ? showBarModalBottomSheet(
                context: context,
                builder: (context) => StatefulBuilder(
                  builder: (BuildContext context, setState) {
                    return SingleChildScrollView(
                      controller: ModalScrollController.of(context),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Family Wibowo",
                                  style: GoogleFonts.inter(
                                    fontSize: 24,
                                    color: sColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Icon(
                                    Icons.edit,
                                    color: sColor,
                                    size: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                            // show and scan qr
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: null,
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStatePropertyAll<Color>(
                                      tagBgColor.withOpacity(0),
                                    ),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    "Show QR",
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      color: sColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                TextButton(
                                  onPressed: null,
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStatePropertyAll<Color>(
                                      tagBgColor.withOpacity(0),
                                    ),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    "Scan QR",
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      color: sColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15, left: 32),
                              child: Text(
                                "Members",
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: sColor,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 24, right: 24, top: 14, bottom: 32),
                              child: Column(
                                children: const [
                                  Member(name: "Jowna Alynsah"),
                                  Member(name: "Vicky Wibowo"),
                                  Member(name: "Musi Asratih"),
                                  Member(name: "Triunggo Beryesta")
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            : null,
        child: Card(
          elevation: 7,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      icon,
                      color: sColor,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              color: sColor,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          description,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: sColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  top: 10,
                  right: 0,
                  child: isFamily
                      ? const Icon(
                          Icons.keyboard_arrow_right_rounded,
                          size: 16,
                          color: sColor,
                        )
                      : const Icon(
                          Icons.edit,
                          size: 16,
                          color: sColor,
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
