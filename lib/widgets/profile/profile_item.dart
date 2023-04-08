import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familist_2/widgets/profile/family_builder.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../constants.dart';
import '../../utils/profile.dart';
import '../dialog.dart';

class ProfileItem extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isFamily;
  final bool isEditable;
  final Function()? ontap;
  final VoidCallback refresh;

  const ProfileItem({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.isFamily,
    this.ontap,
    required this.isEditable,
    required this.refresh,
  });
  @override
  State<ProfileItem> createState() => _ProfileItemState();
}

class _ProfileItemState extends State<ProfileItem> {
  // booleans
  bool editMode = false;
  bool familyEditMode = false;
  bool showQr = false;

  // variables
  List<dynamic> userIDs = [];
  String fuid = "";
  String userID = "";

  // controllers
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _familyNameController = TextEditingController();
  final FocusNode _focus = FocusNode();
  final FocusNode _focus2 = FocusNode();

  Future getData() async {
    // familiesIDs = await Profile().getFamiliesId();
    userID = await Profile.getUserID();
    userIDs = await Profile().getUsersId();
    fuid = await Profile().getFamilyID();
  }

  Future updateFamilyName() async {
    try {
      if (_familyNameController.text.trim().isEmpty) {
        dialog(context, "Please enter a valid family name");
        return false;
      }
      await Profile().updateFamilyName(
        _familyNameController.text.trim(),
      );
      return true;
    } on FirebaseException catch (e) {
      dialog(context, e.message.toString());
      return false;
    }
  }

  Future leaveFamily() async {
    try {
      await Profile().updateData(userID, {
        'fuid': "",
      });
      widget.refresh();
    } catch (e) {
      dialog(context, e.toString());
    }
  }

  Future updatePhoneNumber() async {
    try {
      String id = "";
      await Profile.getUserID().then((value) => id = value);
      await Profile().updateData(
        id,
        {"telephone": _controller.text.trim()},
      );
    } on FirebaseException catch (e) {
      dialog(context, e.message.toString());
    }
  }

  void _onFocusChanged() {
    if (!_focus.hasFocus) {
      setState(() {
        editMode = false;
      });
    } else {
      setState(() {
        editMode = true;
      });
    }
  }

  void _onFocusChanged2() {
    if (!_focus2.hasFocus) {
      setState(() {
        familyEditMode = false;
      });
    } else {
      setState(() {
        familyEditMode = true;
      });
    }
  }

  @override
  void initState() {
    getData();
    _focus.addListener(_onFocusChanged);
    _focus2.addListener(_onFocusChanged2);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChanged);
    _focus2.removeListener(_onFocusChanged2);
    _focus.dispose();
    _focus2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 15),
      child: InkWell(
        onTap: () => widget.isFamily
            ? showBarModalBottomSheet(
                context: context,
                builder: (context) => StatefulBuilder(
                  builder: (BuildContext context, setState) {
                    return showQr
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Center(
                                child: Text(
                                  "ID: $fuid",
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    color: sColor,
                                  ),
                                ),
                              ),
                              Center(
                                child: QrImage(
                                  data: fuid,
                                  version: QrVersions.auto,
                                  size: 200,
                                ),
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: TextButton(
                                  onPressed: () {
                                    setState(
                                      () {
                                        showQr = false;
                                      },
                                    );
                                  },
                                  style: const ButtonStyle(
                                    backgroundColor:
                                        MaterialStatePropertyAll<Color>(sColor),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    child: Text(
                                      "Close",
                                      style: GoogleFonts.inter(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: SingleChildScrollView(
                              controller: ModalScrollController.of(context),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 24),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      children: [
                                        const Spacer(),
                                        familyEditMode
                                            ? SizedBox(
                                                height: 30,
                                                width: 200,
                                                child: TextField(
                                                  controller:
                                                      _familyNameController,
                                                  autofocus: true,
                                                  focusNode: _focus2,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                      horizontal: 0,
                                                    ),
                                                    suffixIcon: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        SizedBox(
                                                          width: 25,
                                                          child: IconButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                familyEditMode =
                                                                    false;
                                                              });
                                                            },
                                                            icon: const Icon(
                                                              Icons.clear,
                                                              size: 20,
                                                            ),
                                                          ),
                                                        ),
                                                        IconButton(
                                                          onPressed: () async {
                                                            bool update =
                                                                await updateFamilyName();
                                                            if (update &&
                                                                mounted) {
                                                              Navigator.pop(
                                                                  context);
                                                              widget.refresh();
                                                            }
                                                          },
                                                          icon: Icon(
                                                            Icons.save_rounded,
                                                            color: Colors
                                                                .green[400],
                                                            size: 20,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Text(
                                                widget.description,
                                                style: GoogleFonts.inter(
                                                  fontSize: 24,
                                                  color: sColor,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 15),
                                            child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  familyEditMode = true;
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.edit,
                                                color: sColor,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 32,
                                    ),
                                    // show and scan qr
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              showQr = true;
                                            });
                                          },
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
                                            "Show QR & ID",
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
                                          onPressed: () {
                                            print("go fuid $fuid");
                                            GoRouter.of(context).push(
                                              "/joinFamily",
                                            );
                                          },
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
                                            "Join Family",
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600,
                                              color: sColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15, left: 32),
                                      child: Text(
                                        "Members",
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          color: sColor,
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          left: 20,
                                          right: 24,
                                          top: 14,
                                          bottom: 14),
                                      child: Column(
                                        children: [FamilyBuilder()],
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await leaveFamily();
                                        if (context.mounted) {
                                          GoRouter.of(context)
                                              .pushReplacement("/profile");
                                        }
                                      },
                                      style: const ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll<Color>(
                                                Color(0xFFD26F6F)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Text(
                                          "Leave Family",
                                          style: GoogleFonts.inter(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
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
                        editMode
                            ? Row(
                                children: [
                                  SizedBox(
                                    width: size.width * 0.5,
                                    height: 30,
                                    child: TextField(
                                      controller: _controller,
                                      autofocus: true,
                                      focusNode: _focus,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 0,
                                        ),
                                        suffixIcon: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              width: 25,
                                              child: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    editMode = false;
                                                  });
                                                },
                                                icon: const Icon(
                                                  Icons.clear,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () async {
                                                await updatePhoneNumber();
                                                widget.refresh();
                                              },
                                              icon: Icon(
                                                Icons.save_rounded,
                                                color: Colors.green[400],
                                                size: 20,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Text(
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
                  top: -5,
                  right: 0,
                  child: widget.isFamily
                      ? const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 15,
                          ),
                          child: Icon(
                            Icons.keyboard_arrow_right_rounded,
                            size: 16,
                            color: sColor,
                          ),
                        )
                      : widget.isEditable
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  editMode = true;
                                });
                              },
                              icon: const Row(
                                children: [
                                  Icon(
                                    Icons.edit,
                                    size: 16,
                                    color: sColor,
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
