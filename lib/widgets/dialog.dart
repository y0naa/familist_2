import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void dialog(BuildContext context, String m, {String? route}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(m),
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

Future<bool> deleteDialog(BuildContext context) async {
  Completer<bool> completer = Completer<bool>();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Are you sure you want to delete item?"),
        actions: <Widget>[
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
              completer.complete(true);
            },
          ),
          TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
              completer.complete(false);
            },
          ),
        ],
      );
    },
  );

  return completer.future;
}
