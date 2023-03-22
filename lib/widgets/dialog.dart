import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void dialog(BuildContext context, String m, {String? route}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
        ),
        title: const Text("Attention"),
        content: Text(m),
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

Future<bool?> confirmDismissDialog(
    BuildContext context, Function onDismissed) async {
  return await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Confirm"),
        content: const Text("Are you sure you wish to delete this item?"),
        actions: [
          TextButton(
              onPressed: () {
                onDismissed();
                Navigator.of(context).pop(true);
              },
              child: const Text("Delete")),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
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
        title: const Text("Confirm"),
        content: const Text("Are you sure you wish to delete this item?"),
        actions: <Widget>[
          TextButton(
            child: const Text("DELETE"),
            onPressed: () {
              Navigator.of(context).pop();
              completer.complete(true);
            },
          ),
          TextButton(
            child: const Text("CANCEl"),
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
