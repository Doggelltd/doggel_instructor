import 'package:doggel_instructor/screens/change_password.dart';
import 'package:doggel_instructor/screens/edit_profile_screen.dart';
import 'package:doggel_instructor/screens/zoom_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import './custom_text.dart';
import '../providers/auth.dart';

class AccountListTile extends StatelessWidget {
  final String titleText;
  final IconData icon;
  final String actionType;

  const AccountListTile({
    Key? key,
    required this.titleText,
    required this.icon,
    required this.actionType,
  }) : super(key: key);

  void _actionHandler(BuildContext context) {
    if (actionType == 'logout') {
      Provider.of<Auth>(context, listen: false).logout().then((_) =>
          Navigator.pushNamedAndRemoveUntil(context, '/auth', (r) => false));
    } else if (actionType == 'edit') {
      Navigator.of(context).pushNamed(EditProfileScreen.routeName);
    } else if (actionType == 'change_password') {
      Navigator.of(context).pushNamed(ChangePassword.routeName);
    } else if (actionType == 'zmSettings') {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const ZoomSettingsScreen();
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xffF3FFF2), borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Padding(
          padding: const EdgeInsets.all(6),
          child: FittedBox(
            child: Icon(
              icon,
              color: kGreenColor,
            ),
          ),
        ),
        title: Customtext(
          text: titleText,
          colors: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        onTap: () => _actionHandler(context),
        trailing: IconButton(
          icon: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Color(0XFF858597),
          ),
          onPressed: () => _actionHandler(context),
          color: kIconColor,
        ),
      ),
    );
  }
}
