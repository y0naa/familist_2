import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void dialog(BuildContext context, String m, {String? route}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Saved Successfully"),
        actions: <Widget>[
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
              route != null
                  ? GoRouter.of(context).pushReplacement(route)
                  : null;
            },
          ),
        ],
      );
    },
  );
}
