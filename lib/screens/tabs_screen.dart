import 'dart:convert';
import 'package:doggel_instructor/screens/payout_report_screen.dart';
import 'package:doggel_instructor/screens/sales_report_screen.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../providers/fetch_data.dart';
import 'account_screen.dart';
import 'course_create_screen.dart';
import 'course_manager.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/home';
  int? index;
  TabsScreen({Key? key, this.index}) : super(key: key);

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final searchController = TextEditingController();
  String? profileStatus;

  int _selectedPageIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    changeIndex();
    print(_selectedPageIndex);
  }

  void changeIndex() {
    setState(() {
      if (widget.index != null) {
        _selectedPageIndex = widget.index!;
      }
    });
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<FetchData>(context).fetchInstructorStatus().then((_) {
        setState(() {
          _isLoading = false;
          profileStatus =
              Provider.of<FetchData>(context, listen: false).profileStatus;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      CourseManagerScreen(
        checkStatus: profileStatus,
      ),
      const PayoutReportScreen(),
      CourseCreateScreen(
        checkStatus: profileStatus,
      ),
      const SalesReportScreen(),
      // _showFilterModal(context),
      const AccountScreen(),
    ];
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Do you want to exit app?'),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('No'),
                ),
              ],
            );
          },
        );
        return shouldPop!;
      },
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: SafeArea(child: _pages[_selectedPageIndex]),
        bottomNavigationBar: ConvexAppBar(
          initialActiveIndex: _selectedPageIndex,
          onTap: _selectPage,
          color: Colors.black26,
          activeColor: kBlueColor,
          height: 50,
          cornerRadius: 20,
          top: -30,
          curveSize: 100,
          style: TabStyle.fixedCircle,
          shadowColor: Colors.white,
          items: const [
            TabItem(
              icon: Icon(
                Icons.home,
                color: Colors.black26,
              ),
              activeIcon: Icon(
                Icons.home,
                color: kBlueColor,
              ),
              title: 'Home',
            ),
            TabItem(
              icon: Icon(
                Icons.attach_money,
                color: Colors.black26,
              ),
              activeIcon: Icon(
                Icons.attach_money,
                color: kBlueColor,
              ),
              title: 'Record',
            ),
            TabItem(
              title: "Add",
              icon: Icon(
                Icons.add,
                size: 35,
                color: kBlueColor,
              ),
              activeIcon: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
            TabItem(
              icon: Icon(
                Icons.double_arrow_sharp,
                color: Colors.black26,
              ),
              activeIcon: Icon(
                Icons.double_arrow_sharp,
                color: kBlueColor,
              ),
              title: 'Sales',
            ),
            TabItem(
              icon: Icon(
                Icons.person,
                color: Colors.black26,
              ),
              activeIcon: Icon(
                Icons.person,
                color: kBlueColor,
              ),
              title: 'Profile',
            )
          ],
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
