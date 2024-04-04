import 'dart:convert';
import 'package:doggel_instructor/models/user.dart';
import 'package:doggel_instructor/providers/auth.dart';
import 'package:doggel_instructor/widgets/acoount_list_tile.dart';
import 'package:doggel_instructor/widgets/custom_app_bar.dart';
import 'package:doggel_instructor/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class AccountScreen extends StatefulWidget {
  static const routeName = '/account-screen-test';

  const AccountScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  // ignore: unused_field
  User _user = User();
  bool _isInit = true;
  bool _isLoading = false;
  bool liveClassStatus = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Auth>(context).getUserInfo().then((_) {
        setState(() {
          _user = Provider.of<Auth>(context, listen: false).user;
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> addonStatus() async {
    var url =
        '$BASE_URL/api_instructor/addon_status?unique_identifier=live-class';
    final response = await http.get(Uri.parse(url));
    setState(() {
      liveClassStatus = json.decode(response.body)['status'];
    });
  }

  @override
  void initState() {
    super.initState();
    addonStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: CustomAppBar(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Consumer<Auth>(builder: (context, authData, child) {
              final user = authData.user;
              return SingleChildScrollView(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          "Profile",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(user.image.toString()),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Customtext(
                            text: '${user.firstName} ${user.lastName}',
                            colors: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              const AccountListTile(
                                titleText: 'Edit Profile',
                                icon: Icons.account_circle,
                                actionType: 'edit',
                              ),
                              const SizedBox(height: 20),
                              const AccountListTile(
                                titleText: 'Change Password',
                                icon: Icons.vpn_key,
                                actionType: 'change_password',
                              ),
                              const SizedBox(height: 20),
                              if (liveClassStatus == true)
                                const AccountListTile(
                                  titleText: 'Zoom Settings',
                                  icon: Icons.videocam_outlined,
                                  actionType: 'zmSettings',
                                ),
                              if (liveClassStatus == true)
                                const SizedBox(height: 20),
                              const AccountListTile(
                                titleText: 'Log Out',
                                icon: Icons.exit_to_app,
                                actionType: 'logout',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
    );
  }
}
