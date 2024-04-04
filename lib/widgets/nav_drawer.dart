import 'dart:convert';

import 'package:doggel_instructor/models/user.dart';
import 'package:doggel_instructor/providers/auth.dart';
import 'package:doggel_instructor/screens/account_screen.dart';
import 'package:doggel_instructor/screens/course_create_screen.dart';
import 'package:doggel_instructor/screens/course_manager.dart';
import 'package:doggel_instructor/screens/payout_report_screen.dart';
import 'package:doggel_instructor/screens/sales_report_screen.dart';
import 'package:doggel_instructor/screens/tabs_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class NavDrawer extends StatefulWidget {
  String checkStatus;
  NavDrawer({required this.checkStatus});

  @override
  // ignore: library_private_types_in_public_api
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  // ignore: unused_field
  User _user = User();
  bool _isInit = true;
  dynamic userName;
  dynamic userEmail;
  dynamic userImage;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      await Provider.of<Auth>(context).getUserInfo().then((_) {
        if (mounted) {
          setState(() {
            _user = Provider.of<Auth>(context, listen: false).user;
          });
        }
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> getUserInfo() async {
    dynamic userData;
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userData = (prefs.getString('userData') ?? '');
    });
    if (userData != null && userData.isNotEmpty) {
      final response = jsonDecode(userData);
      setState(() {
        userName = response['first_name'] + " " + response['last_name'];
        userEmail = response['email'];
        userImage = response['image'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color.fromRGBO(244, 244, 244, 1),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, bottom: 10.0, top: 10),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: userImage == null
                      ? const CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              AssetImage('assets/loading_animated.gif'),
                          backgroundColor: Colors.grey,
                        )
                      : CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(userImage),
                          backgroundColor: Colors.grey,
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 15.0,
                ),
                child: userName == null
                    ? const Text('')
                    : Text(
                        userName,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: userEmail == null
                    ? const Text('')
                    : Text(
                        userEmail,
                        style: const TextStyle(color: Colors.black54),
                      ),
              ),
              const Divider(
                color: Colors.black45,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.pushAndRemoveUntil<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) => TabsScreen(
                              index: 0,
                            )),
                    (route) => false,
                  );
                  // Navigator.pushAndRemoveUntil(context,
                  //     MaterialPageRoute(builder: (context) {
                  //   return TabsScreen(
                  //     index: 0,
                  //   );
                  // }));
                },
                child: const ListTile(
                  title: Align(
                      alignment: Alignment(-1.35, 0),
                      child: Text('Course Management')),
                  leading: Icon(
                    Icons.auto_stories_outlined,
                    //  color: Colors.black45,
                    color: kBlueColor,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (widget.checkStatus == "0") {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: kBlueColor,
                        margin:
                            EdgeInsets.only(bottom: 30.0, left: 10, right: 10),
                        content: Center(
                            child: Text(
                          "We are currently reviewing your profile.\nPlease allow some time for approval. If you have any questions, please contact our support team",
                          textAlign: TextAlign.center,
                        ))));
                  } else {
                    Navigator.of(context).pop();
                    Navigator.pushAndRemoveUntil<dynamic>(
                      context,
                      MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) => TabsScreen(
                                index: 2,
                              )),
                      (route) => false,
                    );
                  }
                },
                child: const ListTile(
                  title: Align(
                      alignment: Alignment(-1.30, 0),
                      child: Text('Create Course')),
                  leading: Icon(
                    Icons.edit_note_outlined,
                    color: kBlueColor,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.pushAndRemoveUntil<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) => TabsScreen(
                              index: 3,
                            )),
                    (route) => false,
                  );
                },
                child: const ListTile(
                  title: Align(
                      alignment: Alignment(-1.25, 0), child: Text('My Sales')),
                  leading: Icon(
                    Icons.double_arrow_sharp,
                    color: kBlueColor,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.pushAndRemoveUntil<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) => TabsScreen(
                              index: 1,
                            )),
                    (route) => false,
                  );
                },
                child: const ListTile(
                  title: Align(
                      alignment: Alignment(-1.25, 0), child: Text('My Report')),
                  leading: Icon(
                    Icons.payment,
                    color: kBlueColor,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(AccountScreen.routeName);
                },
                child: const ListTile(
                  title: Align(
                      alignment: Alignment(-1.15, 0), child: Text('Profile')),
                  leading: Icon(Icons.person, color: kBlueColor),
                ),
              ),
              const Divider(
                color: Colors.black45,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  Provider.of<Auth>(context, listen: false).logout().then((_) =>
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/auth', (r) => false));
                },
                child: const ListTile(
                  title: Align(
                      alignment: Alignment(-1.15, 0), child: Text('Sign Out')),
                  leading: Icon(Icons.logout, color: kBlueColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
