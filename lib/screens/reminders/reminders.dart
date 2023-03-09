import 'package:familist_2/utils/remindersHelper.dart';
import 'package:flutter/material.dart';

class Reminders extends StatefulWidget {
  final Function callback;
  final Function refreshParent;
  const Reminders({
    super.key,
    required this.callback,
    required this.refreshParent,
  });

  @override
  State<Reminders> createState() => _RemindersState();
}

class _RemindersState extends State<Reminders> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RemindersHelpers()
            .remindersFuture(context, widget.callback, widget.refreshParent),
      ],
    );
  }
}
