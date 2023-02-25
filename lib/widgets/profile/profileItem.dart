import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familist_2/widgets/profile/famlilyBuilder.dart';
import 'package:familist_2/widgets/profile/memberCard.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../constants.dart';
import '../../screens/auth/signIn.dart';
import '../../utils/auth.dart';
import '../../utils/profile.dart';

class ProfileItem extends StatefulWidget {
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
  State<ProfileItem> createState() => _ProfileItemState();
}

class _ProfileItemState extends State<ProfileItem> {
  //List<String> familiesIDs = [];
  final box = GetStorage();
  List<dynamic> userIDs = [];
  String _familyName = "";

  Future getData() async {
    // familiesIDs = await Profile().getFamiliesId();
    userIDs = await Profile().getUsersId();
  }

  Future getFamilyName() async {
    String fuid = "";
    // print("current user: ${Auth().currentUser!.email}");
    await FirebaseFirestore.instance
        .collection("users")
        .where(
          "email",
          isEqualTo: Auth().currentUser!.email!.trim(),
        )
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              fuid = document.get("fuid");
              print("fuid: $fuid");
            },
          ),
        );
    await Profile().getFamilyName(fuid).then((value) => _familyName = value);
    print("family name: $_familyName");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    getFamilyName();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 15),
      child: InkWell(
        onTap: () => widget.isFamily
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
                                  _familyName,
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
                                  left: 20, right: 24, top: 14, bottom: 32),
                              child: Column(
                                children: [
                                  FutureBuilder(
                                    future: getData(),
                                    builder: (context, snapshot) {
                                      return ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: userIDs.length,
                                        itemBuilder: (context, uindex) {
                                          return FamilyBuilder(
                                            usersId: userIDs[uindex],
                                          );
                                        },
                                      );
                                    },
                                  ),
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
                      widget.icon,
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
                          widget.title,
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              color: sColor,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          widget.description,
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
                  child: widget.isFamily
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
