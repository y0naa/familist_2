import 'package:familist_2/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../utils/profile.dart';

class ScanQR extends StatefulWidget {
  const ScanQR({super.key});

  @override
  State<ScanQR> createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  String? text;
  QRViewController? controller;

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        text = result!.code;
      });
      try {
        if (result != null) {
          updateData(result!.code!, context);
        }
      } catch (e) {
        dialog(context, e.toString());
      }
    });
  }

  void updateData(String res, BuildContext context) async {
    bool checked = await Profile().doesFamilyExist(res);
    if (checked) {
      String id = await Profile().getUserID();
      await Profile().updateData(id, {"fuid": res});
      if (context.mounted) {
        GoRouter.of(context).pushReplacement("/profile");
      }
    } else {
      setState(() {
        text = "No data found";
      });
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    controller!.pauseCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
                child: (result != null)
                    ? Text(
                        'Data: $text',
                        style: GoogleFonts.inter(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                      )
                    : Container()),
          ),
          TextButton(
            onPressed: () =>
                GoRouter.of(context).pushReplacement("/joinFamily"),
            style: const ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll<Color>(Color(0xFFD26F6F)),
            ),
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
        ],
      ),
    );
  }
}
