import 'package:flutter/material.dart';

void dialog(BuildContext context, String m) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Text(
          m,
        ),
      );
    },
  );
}
