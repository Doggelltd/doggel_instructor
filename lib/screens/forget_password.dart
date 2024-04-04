// ignore_for_file: use_build_context_synchronously

import 'package:doggel_instructor/constants.dart';
import 'package:doggel_instructor/models/common_functions.dart';
import 'package:doggel_instructor/models/update_user_model.dart';
import 'package:doggel_instructor/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'auth_screen.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final _emailController = TextEditingController();
  bool _isLoading = false;

  // ignore: non_constant_identifier_names
  Future<UpdateUserModel?> UpdateUser(String email) async {
    const String apiUrl = "$BASE_URL/api_instructor/forgot_password";

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(Uri.parse(apiUrl), body: {
        'email': email,
      });

      if (response.statusCode == 200) {
        final String responseString = response.body;

        return updateUserModelFromJson(responseString);
      } else {
        return null;
      }
    } catch (error) {
      const errorMsg = 'Could not reset password!';
      CommonFunctions.showErrorDialog(errorMsg, context);
    }
    setState(() {
      _isLoading = true;
    });
    return null;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Form(
              key: globalFormKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(height: 80),
                        Center(
                          child: Image.asset(
                            'assets/logo.png',
                            height: 55,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                    const Text(
                      "Forgot Password?",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xff373737),
                          fontSize: 18),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Don’t worry ! It happens. Please enter the email we will send the OTP in this email.",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Color(0xff5B5858),
                          fontSize: 12),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 0.0, right: 0, bottom: 8),
                      child: TextFormField(
                        style: const TextStyle(color: Colors.black),
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        // onSaved: (input) => _emailController.text = input,
                        validator: (input) =>
                            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                    .hasMatch(input!)
                                ? "Email Id should be valid"
                                : null,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(
                              color: Color(0xff858597),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(
                              color: Color(0xff858597),
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xff858597),
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                          filled: true,
                          hintStyle:
                              TextStyle(color: Colors.black54, fontSize: 14),
                          hintText: "Email",
                          fillColor: Color(0xFFF7F7F7),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 17, horizontal: 15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : MaterialButton(
                                onPressed: () async {
                                  final String email =
                                      _emailController.text.toString();
                                  if (!globalFormKey.currentState!.validate()) {
                                    return;
                                  }
                                  if (email.isNotEmpty) {
                                    final UpdateUserModel? user =
                                        await UpdateUser(email);

                                    CommonFunctions.showSuccessToast(
                                        user!.message.toString());

                                    Navigator.pop(context,
                                        'Password updated successfully');

                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const AuthScreen()),
                                        (Route<dynamic> route) => false);
                                  }
                                },
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 70, vertical: 10),
                                color: kGreenColor,
                                elevation: 0.1,
                                textColor: Colors.white,
                                splashColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  side: const BorderSide(color: kGreenColor),
                                ),
                                child: const Text(
                                  "Reset",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
