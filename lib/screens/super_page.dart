import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:familist_2/constants.dart';
import 'package:familist_2/screens/home/home_page.dart';
import 'package:familist_2/screens/profile/profile_page.dart';
import 'package:familist_2/screens/reminders/reminders_page.dart';
import 'package:familist_2/screens/schedule/schedule_page.dart';
import 'package:familist_2/screens/shopping/shopping_page.dart';
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
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    widget.page == null ? null : _activePages = widget.page!;
    _pages = [
      HomePage(
        pageIndex: widget.subPage ?? 0,
      ),
      const ShoppingPage(),
      RemindersPage(
        pageIndex:
            widget.subPage ?? 0, // Use 0 as default value if subPage is null
      ),
      SchedulePage(
        pageIndex: widget.subPage ?? 0,
      ),
      const ProfilePage()
    ];
    _pages[2] = RemindersPage(
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
