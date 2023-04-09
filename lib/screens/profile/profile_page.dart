import 'dart:io';
import 'package:familist_2/constants.dart';
import 'package:familist_2/widgets/dialog.dart';
import 'package:familist_2/widgets/profile/profile_item.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import '../../utils/auth.dart';
import '../../utils/notif.dart';
import '../../utils/profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoading = false;

  // text controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  // user details
  String _familyName = "";
  String _name = "";
  String _bio = "";
  String _telephone = "";
  String _imageURL = "";
  final String _email = Auth().currentUser!.email!.trim();

  //temp
  File? photo;

  Future uploadProfile(File imagePath) async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("files/${p.basename(imagePath.path)}");
    var upload = ref.putFile(imagePath);
    final snapshot = await upload.whenComplete(() {});
    _imageURL = await snapshot.ref.getDownloadURL();

    photo = imagePath;
  }

  Future updateProfile() async {
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }

      String id = "";
      if (photo != null) {
        await uploadProfile(photo!);
      }
      await Profile.getUserID().then((value) => id = value);
      await Profile().updateData(
        id,
        {
          "full name": _nameController.text.trim(),
          "bio": _bioController.text.trim(),
          "imageUrl": _imageURL,
        },
      );
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } on Exception catch (e) {
      dialog(context, e.toString());
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future getUserDetails() async {
    Map<String, String> data = <String, String>{};
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    await Profile().getUserDetails().then((value) => data = value);
    _name = data["full name"]!;
    _bio = data["bio"]!;
    _telephone = data["telephone"]!;
    _imageURL = data["imageUrl"]!;
    _nameController.text = _name;
    _bioController.text = _bio;

    if (data["fuid"] != "") {
      await Profile()
          .getFamilyName(data["fuid"]!)
          .then((value) => _familyName = value);
    }
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> signOut() async {
    try {
      await NotificationApi
          .cancelAll(); // cancel first because it requires auth
      if (context.mounted) {
        GoRouter.of(context).pushReplacement("/");
        await Auth().signOut();
      }
    } catch (e) {
      dialog(context, e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      getUserDetails();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: isLoading
          ? Container(
              color: bgColor,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(top: 64),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: Center(
                          child: Text(
                            "Profile",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 28,
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () {
                            GoRouter.of(context).push("/info");
                          },
                          icon: const Icon(
                            Icons.info,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Container(
                            height: double.infinity,
                            decoration: const BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(70),
                                topRight: Radius.circular(70),
                              ),
                            ),
                            child:
                                // main column for white area
                                Padding(
                              padding: EdgeInsets.only(
                                  top: size.height *
                                      0.25), // pading to keep it from the elevated stack
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // continue from card
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        ProfileItem(
                                          title: "Email",
                                          description: _email,
                                          icon: Icons.mail_outline_rounded,
                                          isFamily: false,
                                          isEditable: false,
                                          refresh: () {
                                            if (mounted) {
                                              setState(() {});
                                            }
                                          },
                                        ),
                                        ProfileItem(
                                          title: "Phone Number",
                                          description: _telephone,
                                          icon: Icons.phone_outlined,
                                          isFamily: false,
                                          isEditable: true,
                                          refresh: () {
                                            if (mounted) {
                                              setState(() {
                                                getUserDetails();
                                              });
                                            }
                                          },
                                        ),
                                        ProfileItem(
                                          title: "Family",
                                          description: _familyName,
                                          icon: Icons.family_restroom_outlined,
                                          isFamily: true,
                                          isEditable: true,
                                          refresh: () {
                                            if (mounted) {
                                              setState(() {
                                                getUserDetails();
                                              });
                                            }
                                          },
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 24, left: 24),
                                          child: TextButton(
                                            onPressed: signOut,
                                            style: const ButtonStyle(
                                              backgroundColor:
                                                  MaterialStatePropertyAll<
                                                      Color>(Color(0xFFD26F6F)),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 16, bottom: 16),
                                              child: Text(
                                                "Sign Out",
                                                style: GoogleFonts.inter(
                                                    fontSize: 18,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // show list
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // elevated
                        Align(
                          alignment: const Alignment(0, -1.1),
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(70),
                                topRight: Radius.circular(70),
                              ),
                            ),
                            width: size.width * 0.8,
                            height: size.height * 0.3,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                                //set border radius more than 50% of height and width to make circle
                              ),
                              elevation: 12,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 24, right: 24, top: 24),
                                child: Column(
                                  children: [
                                    Material(
                                      borderRadius: BorderRadius.circular(50),
                                      elevation: 10,
                                      child: _imageURL == ""
                                          ? const CircleAvatar(
                                              radius: 45,
                                              backgroundColor: tColor,
                                            )
                                          : CircleAvatar(
                                              radius: 45,
                                              backgroundColor: tColor,
                                              child: ClipOval(
                                                child: Image.network(
                                                  _imageURL,
                                                  width: 90,
                                                  height: 90,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Stack(
                                      children: [
                                        Align(
                                          child: Column(
                                            children: [
                                              Text(
                                                _name,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.inter(
                                                  fontSize: 18,
                                                  color: sColor,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                _bio,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.inter(
                                                  fontSize: 16,
                                                  color: sColor,
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  editProfileModal(context, () {
                                                    getUserDetails();
                                                  });
                                                },
                                                child:
                                                    const Text("Edit profile"),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<dynamic> editProfileModal(
      BuildContext context, final VoidCallback refresh) {
    final ImagePicker picker = ImagePicker();

    return showBarModalBottomSheet(
      context: context,
      builder: (context) =>
          StatefulBuilder(builder: (BuildContext context, setState) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            controller: ModalScrollController.of(context),
            child: Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Text(
                      "Edit Profile",
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        color: sColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  photo == null
                      ? CircleAvatar(
                          radius: 45,
                          backgroundColor: tColor,
                          child: _imageURL == ""
                              ? Container()
                              : ClipOval(
                                  child: Image.network(
                                    _imageURL,
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        )
                      : CircleAvatar(
                          radius: 45,
                          backgroundColor: tColor,
                          child: ClipOval(
                            child: Image.file(
                              photo!,
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                  Center(
                    child: TextButton(
                      onPressed: () async {
                        final temp = await picker.pickImage(
                          source: ImageSource.gallery,
                          maxWidth: 200.0,
                          maxHeight: 300.0,
                        );
                        temp == null
                            ? null
                            : mounted
                                ? setState(
                                    () {
                                      photo = File(temp.path);
                                    },
                                  )
                                : null;
                      },
                      child: const Text("Choose Image"),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 32),
                    child: Text(
                      "Name",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: sColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 32, right: 32, top: 14, bottom: 32),
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: "Change your name here",
                        filled: true,
                        fillColor: Colors.grey.shade100.withOpacity(0.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                              color: Colors.grey.shade100, width: 0.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 32),
                    child: Text(
                      "Bio",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: sColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 32, right: 32, top: 14, bottom: 14),
                    child: TextField(
                      controller: _bioController,
                      minLines: 2,
                      maxLines: 2,
                      maxLength: 100,
                      decoration: InputDecoration(
                        hintText: "Edit your bio here",
                        filled: true,
                        fillColor: Colors.grey.shade100.withOpacity(0.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                              color: Colors.grey.shade100, width: 0.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 10,
                    ),
                    child: TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await updateProfile();
                        refresh();
                      },
                      style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(sColor),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: Text(
                          "Save",
                          style: GoogleFonts.inter(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
