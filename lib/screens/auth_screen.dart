import 'dart:io';
import 'package:doggel_instructor/models/common_functions.dart';
import 'package:doggel_instructor/models/login_model.dart';
import 'package:doggel_instructor/providers/auth.dart';
import 'package:doggel_instructor/screens/signup_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import 'forget_password.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: SizedBox(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: const AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  bool hidePassword = true;
  bool isApiCallProcess = false;
  // String data;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  late LoginRequestModel loginRequestModel;

  @override
  void initState() {
    super.initState();
    loginRequestModel = LoginRequestModel();
  }

  Future<void> _submit() async {
    if (!globalFormKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    globalFormKey.currentState!.save();

    setState(() {
      isApiCallProcess = true;
    });
    try {
      // Log user in
      await Provider.of<Auth>(context, listen: false).login(loginRequestModel);

      // ignore: use_build_context_synchronously
      Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
      CommonFunctions.showSuccessToast('Login Successful');
    } on HttpException {
      var errorMsgTitle = 'Authentication Failed!';
      var errorMsg = 'The username or password you entered is incorrect.';
      CommonFunctions.dynamicErrorDialog(errorMsg, context, errorMsgTitle);
    } catch (error) {
      var errorMsgTitle = 'The username or password you entered is incorrect.';
      const errorMsg = 'Could not authenticate!';
      CommonFunctions.dynamicErrorDialog(errorMsg, context, errorMsgTitle);
    }
    setState(() {
      isApiCallProcess = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Form(
          key: globalFormKey,
          child: Column(
            children: <Widget>[
              ListTile(
                title: Column(
                  children: [
                    const SizedBox(height: 100),
                    Center(
                      child: Image.asset(
                        'assets/logo.png',
                        height: 55,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 40),
                    // const Text(
                    //   "Sign In To Manage Your Course",
                    //   style: TextStyle(
                    //       color: Colors.black,
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 18),
                    // ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, top: 0.0, right: 15.0, bottom: 8.0),
                child: TextFormField(
                  style: const TextStyle(color: Colors.black),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (input) => loginRequestModel.email = input,
                  validator: (input) =>
                      !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                              .hasMatch(input!)
                          ? "Email Id should be valid"
                          : null,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      borderSide: BorderSide(
                        color: Color(0xff858597),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
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
                    hintStyle: TextStyle(color: Colors.black54, fontSize: 14),
                    hintText: "Email Address ",
                    fillColor: Color(0xFFF7F7F7),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 17, horizontal: 15),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, top: 0.0, right: 15.0, bottom: 8.0),
                child: TextFormField(
                  style: const TextStyle(color: Colors.black),
                  keyboardType: TextInputType.text,
                  onSaved: (input) => loginRequestModel.password = input,
                  validator: (input) => input!.length < 3
                      ? "Password should be more than 3 characters"
                      : null,
                  obscureText: hidePassword,
                  cursorColor: Colors.blueAccent,
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
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff858597),
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                    filled: true,
                    hintStyle:
                        const TextStyle(color: Colors.black54, fontSize: 14),
                    hintText: "Password",
                    fillColor: const Color(0xFFF7F7F7),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 17, horizontal: 15),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                      color: Colors.black,
                      icon: Icon(hidePassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: isApiCallProcess
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : MaterialButton(
                          onPressed: _submit,
                          height: 50,
                          color: kPrimaryBtnColor,
                          textColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 12),
                          splashColor: const Color(0xff64BF26),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side: const BorderSide(color: kPrimaryBtnColor),
                          ),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ForgetPassword()),
                      );
                    },
                    child: const Text(
                      "Forget Password?",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: kPrimaryBtnColor,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // New InkWell for Signup link

              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account?',
                      style: TextStyle(
                        color: kTextLowBlackColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpScreen()),
                        );
                      },
                      child: const Text(
                        ' Sign Up',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
