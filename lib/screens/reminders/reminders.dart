import 'package:familist_2/utils/remindersHelper.dart';
import 'package:flutter/material.dart';

class Reminders extends StatefulWidget {
  final Widget list;
  const Reminders({
    super.key,
    required this.list,
  });

  @override
  State<Reminders> createState() => _RemindersState();
}

class _RemindersState extends State<Reminders> {
  @override
  Widget build(BuildContext context) {
    return widget.list;
  }
}
