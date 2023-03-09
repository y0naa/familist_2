// ignore_for_file: file_names

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:familist_2/constants.dart';
import 'package:familist_2/screens/home/homePage.dart';
import 'package:familist_2/screens/profile/profilePage.dart';
import 'package:familist_2/screens/reminders/remindersPage.dart';
import 'package:familist_2/screens/schedule/schedulePage.dart';
import 'package:familist_2/screens/shopping/shoppingPage.dart';
import 'package:flutter/material.dart';

class SuperPage extends StatefulWidget {
  final int? page;
  final int? subPage;
  const SuperPage({super.key, this.page, this.subPage});

  @override
  State<SuperPage> createState() => _SuperPageState();
}

class _SuperPageState extends State<SuperPage> {
  int _activePages = 0;
  final List<Widget> _pages = [
    const HomePage(),
    const ShoppingPage(),
    const RemindersPage(),
    const SchedulePage(),
    const ProfilePage()
  ];

  @override
  void initState() {
    super.initState();
    widget.page == null ? null : _activePages = widget.page!;
    widget.subPage == null
        ? null
        : _pages[2] = RemindersPage(
            pageIndex: widget.subPage,
          );
    print("routing ${widget.subPage}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_activePages],
      // change this
      // nav bar
      bottomNavigationBar: CurvedNavigationBar(
        index: widget.page ?? 0,
        animationDuration: const Duration(milliseconds: 300),
        backgroundColor: bgColor,
        color: pColor,
        onTap: (index) {
          setState(() {
            _activePages = index;
          });
        },
        items: const [
          Icon(
            Icons.home_rounded,
            color: Colors.white,
          ),
          Icon(
            Icons.shopping_bag_rounded,
            color: Colors.white,
          ),
          Icon(
            Icons.notifications,
            color: Colors.white,
          ),
          Icon(
            Icons.calendar_month_rounded,
            color: Colors.white,
          ),
          Icon(
            Icons.person,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
