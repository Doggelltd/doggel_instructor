import 'package:doggel_instructor/constants.dart';
import 'package:doggel_instructor/models/common_functions.dart';
import 'package:doggel_instructor/providers/shared_pref_helper.dart';
import 'package:doggel_instructor/widgets/dialog.dart';
import 'package:doggel_instructor/models/update_user_model.dart';
import 'package:doggel_instructor/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChangePassword extends StatefulWidget {
  static const routeName = '/edit-password';

  const ChangePassword({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _ChangePasswordState createState() => _ChangePasswordState();
}

// ignore: non_constant_identifier_names
Future<UpdateUserModel?> UpdateUser(String authToken, String currentPass,
    String newPass, String confirmNewPass) async {
  const String apiUrl = "$BASE_URL/api_instructor/change_password";

  final response = await http.post(Uri.parse(apiUrl), body: {
    'auth_token': authToken,
    'current_password': currentPass,
    'new_password': newPass,
    'confirm_password': confirmNewPass,
  });

  if (response.statusCode == 200) {
    final String responseString = response.body;

    return updateUserModelFromJson(responseString);
  } else {
    return null;
  }
}

class _ChangePasswordState extends State<ChangePassword> {
  bool hideOldPassword = true;
  bool hideNewPassword = true;
  bool hideConfirmPassword = true;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final _passwordControllerOld = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordControllerValidate = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F5F5),
      appBar: AppBar(
        toolbarHeight: 30,
        backgroundColor: Color(0xffF5F5F5),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.asset(
              "assets/logo.png",
              height: 50,
            ),
            SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Update Password?',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: globalFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(
                            color: Color(0xff858597),
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(
                            color: Color(0xff858597),
                          ),
                        ),
                        focusedErrorBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(
                            color: Color(0xff858597),
                          ),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Color(0xFFF65054)),
                        ),
                        filled: true,
                        hintStyle: const TextStyle(
                            color: Color(0xff1F1F39), fontSize: 12),
                        hintText: 'Current password',
                        fillColor: Colors.white,
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Color(0xff1F1F39),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              hideOldPassword = !hideOldPassword;
                            });
                          },
                          color: Colors.black,
                          icon: Icon(hideOldPassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 17),
                      ),
                      obscureText: hideOldPassword,
                      controller: _passwordControllerOld,
                      // ignore: missing_return
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Can not be empty';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _passwordControllerOld.text = value!;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(
                            color: Color(0xff858597),
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(
                            color: Color(0xff858597),
                          ),
                        ),
                        focusedErrorBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(
                            color: Color(0xff858597),
                          ),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Color(0xFFF65054)),
                        ),
                        filled: true,
                        hintStyle: const TextStyle(
                            color: Color(0xff1F1F39), fontSize: 12),
                        hintText: 'New password',
                        fillColor: Colors.white,
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Color(0xff1F1F39),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              hideNewPassword = !hideNewPassword;
                            });
                          },
                          color: Colors.black,
                          icon: Icon(hideNewPassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 17),
                      ),
                      obscureText: hideNewPassword,
                      controller: _passwordController,
                      // ignore: missing_return
                      validator: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return 'Password is too short!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _passwordController.text = value!;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(
                            color: Color(0xff858597),
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(
                            color: Color(0xff858597),
                          ),
                        ),
                        focusedErrorBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(
                            color: Color(0xff858597),
                          ),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Color(0xFFF65054)),
                        ),
                        filled: true,
                        hintStyle: const TextStyle(
                            color: Color(0xff1F1F39), fontSize: 12),
                        hintText: 'Confirm password',
                        fillColor: Colors.white,
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Color(0xff1F1F39),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              hideConfirmPassword = !hideConfirmPassword;
                            });
                          },
                          color: Colors.black,
                          icon: Icon(hideConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 17),
                      ),
                      obscureText: hideConfirmPassword,
                      controller: _passwordControllerValidate,
                      // ignore: missing_return
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return 'Passwords do not match!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _passwordControllerValidate.text = value!;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  onPressed: () async {
                    final String currentPass =
                        _passwordControllerOld.text.toString();
                    final String newPass = _passwordController.text.toString();
                    final String confirmNewPass =
                        _passwordControllerValidate.text.toString();
                    final authToken =
                        await SharedPreferenceHelper().getAuthToken();
                    if (!globalFormKey.currentState!.validate()) {
                      return;
                    }
                    if (currentPass.isNotEmpty &&
                        newPass.isNotEmpty &&
                        confirmNewPass.isNotEmpty &&
                        authToken!.isNotEmpty) {
                      // ignore: use_build_context_synchronously
                      Dialogs.showLoadingDialog(context);
                      final UpdateUserModel? user = await UpdateUser(
                          authToken, currentPass, newPass, confirmNewPass);

                      CommonFunctions.showSuccessToast(
                          user!.message.toString());

                      // ignore: use_build_context_synchronously
                      Navigator.pop(context, 'Passwprd updated successfully');
                    }
                  },
                  color: kGreenColor,
                  textColor: Colors.white,
                  elevation: 0.1,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  splashColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: const BorderSide(color: kGreenColor),
                  ),
                  child: const Text(
                    'Reset',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
