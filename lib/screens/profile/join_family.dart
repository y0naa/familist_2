import 'package:familist_2/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';
import '../../utils/profile.dart';

class JoinFamily extends StatefulWidget {
  const JoinFamily({
    super.key,
  });

  @override
  State<JoinFamily> createState() => _JoinFamilyState();
}

class _JoinFamilyState extends State<JoinFamily> {
  // variables
  bool validate = false;

  // text controllers
  final TextEditingController _inputIDController = TextEditingController();

  Future updateData(String res) async {
    bool checked = await Profile().doesFamilyExist(res);
    if (checked) {
      String id = await Profile().getUserID();
      await Profile().updateData(id, {"fuid": res});
      if (context.mounted) {
        GoRouter.of(context).pushReplacement("/profile");
      }
    } else {
      if (context.mounted) {
        dialog(context, "no data found");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Add Member",
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
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 15, left: 32, right: 32),
                child: Text(
                  "Insert ID Below",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: sColor,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextField(
                  controller: _inputIDController,
                  decoration: InputDecoration(
                    errorText: validate ? "Value cannot be empty" : null,
                    suffixIcon: IconButton(
                      onPressed: () async {
                        if (_inputIDController.text.trim().isEmpty) {
                          setState(() {
                            validate = true;
                          });
                        } else {
                          await updateData(_inputIDController.text.trim());
                        }
                      },
                      icon: const Icon(
                        Icons.save_rounded,
                        color: sColor,
                      ),
                    ),
                    border: InputBorder.none,
                    hintText: "Input ID here",
                    filled: false,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 32, bottom: 32),
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                            const Color(0xFF0A369D).withOpacity(0.8)),
                      ),
                      onPressed: () => GoRouter.of(context).push('/scanQR'),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: Text(
                          "Scan QR Code",
                          style: GoogleFonts.inter(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                          const Color.fromARGB(255, 238, 0, 0).withOpacity(0.5),
                        ),
                      ),
                      onPressed: () =>
                          GoRouter.of(context).pushReplacement('/profile'),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.inter(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
