// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:doggel_instructor/models/common_functions.dart';
import 'package:doggel_instructor/models/update_user_model.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
//import 'package:path/path.dart';
import '../constants.dart';
import 'auth_screen.dart';
import 'verification_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signup';
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SignUpScreenState createState() => _SignUpScreenState();
}

Future<UpdateUserModel> signUp(
  String firstName,
  String lastName,
  String email,
  String password,
  String phone,
  String message,
  document,
) async {
  const String apiUrl = "$BASE_URL/api_instructor/signup";
  FormData formdata = FormData.fromMap({
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'password': password,
    'phone': phone,
    'message': message,
    'document':
        await MultipartFile.fromFile(document, filename: "InstructorDocument")
  });
  final response = await Dio().post(apiUrl, data: formdata);
  if (response.statusCode == 200) {
    final String responseString = response.toString();

    return updateUserModelFromJson(responseString);
  } else {
    throw Exception('Failed to load data');
  }
}

class _SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  dynamic documentFile;
  bool hidePassword = true;
  bool _isLoading = false;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();
  final _selectedFileController = TextEditingController();
  String? fullPhoneNumber;
  Future<void> _submit() async {
    if (!globalFormKey.currentState!.validate()) {
      log(" Invalid!");
      return;
    }
    globalFormKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });
    // Request external storage permission if not already granted
    // if (!await Permission.storage.isGranted) {
    //   var status = await Permission.storage.request();
    //   if (!status.isGranted) {
    //     print("permission");
    //     // User denied the permission, handle it accordingly (show a message or ask again)
    //     setState(() {
    //       _isLoading = false;
    //     });
    //     return;
    //   }
    // }
    if (documentFile != null && fullPhoneNumber != null) {
      try {
        final UpdateUserModel user = await signUp(
            _firstNameController.text,
            _lastNameController.text,
            _emailController.text,
            _passwordController.text,
            // _phoneController.text,
            fullPhoneNumber!,
            _messageController.text,
            documentFile);

        if (user.emailVerification == 'enable') {
          log("case1");
          if (user.message ==
              "You have already signed up. Please check your inbox to verify your email address") {
            log("case2");
            // Navigator.of(context).pushNamed(VerificationScreen.routeName,
            //     arguments: _emailController.text);
            CommonFunctions.showSuccessToast(user.message.toString());
          } else if (user.message == "This email userdata already exists") {
            CommonFunctions.showSuccessToast(
              user.message.toString(),
            );
          } else {
            log("case3");
            Navigator.of(context).pushNamed(VerificationScreen.routeName,
                arguments: _emailController.text);
            CommonFunctions.showSuccessToast(
              user.message.toString(),
            );
          }
        } else {
          log("case4");
          Navigator.of(context).pushNamed(AuthScreen.routeName);
          CommonFunctions.showSuccessToast('Signup Successful');
        }
      } catch (error) {
        log("case5");
        const errorMsg = 'Could not register!';
        log(error.toString());
        CommonFunctions.showErrorDialog(errorMsg, context);
      }
    } else if (fullPhoneNumber == null) {
      CommonFunctions.showErrorDialog(
          "Please enter your phone number. Thank you!", context);
    } else {
      CommonFunctions.showErrorDialog(
          "Please upload your resume or educational document to proceed with your application. Thank you!",
          context);
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> chooseImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'doc', 'docx', 'pdf'],
    );
    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        documentFile = file.path;
        _selectedFileController.text = file.name;
      });
    } else {}
  }

  InputDecoration getInputDecoration(String hintext, [IconData? iconData]) {
    return InputDecoration(
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
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        borderSide: BorderSide(
          color: Color(0xff858597),
        ),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        borderSide: BorderSide(color: Color(0xFFF65054)),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        borderSide: BorderSide(color: Color(0xFFF65054)),
      ),
      filled: true,
      prefixIcon: Icon(
        iconData,
        color: kTextLowBlackColor,
      ),
      hintStyle: const TextStyle(color: Colors.black54, fontSize: 14),
      hintText: hintext,
      fillColor: kBackgroundColor,
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        key: scaffoldKey,
        toolbarHeight: 35,
        elevation: 0,
        iconTheme: const IconThemeData(color: kSelectItemColor),
        backgroundColor: kBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Form(
                key: globalFormKey,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/logo.png',
                          height: 55,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // CircleAvatar(
                      //   radius: 45,
                      //   backgroundColor: kBackgroundColor,
                      //   child: Image.asset(
                      //     'assets/logo.png',
                      //     height: 65,
                      //     fit: BoxFit.contain,
                      //   ),
                      // ),
                      // const Text(
                      //   'Sign Up',
                      //   style: TextStyle(
                      //     fontSize: 22,
                      //     fontWeight: FontWeight.w400,
                      //   ),
                      // ),
                      // const SizedBox(height: 10),
                      // const Align(
                      //   alignment: Alignment.centerLeft,
                      //   child: Padding(
                      //     padding: EdgeInsets.only(left: 17.0, bottom: 5.0),
                      //     child: Text(
                      //       'First Name',
                      //       style: TextStyle(
                      //         fontSize: 16,
                      //         fontWeight: FontWeight.w400,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, top: 0.0, right: 15.0, bottom: 8.0),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 14),
                          decoration:
                              getInputDecoration('First Name', Icons.person),
                          keyboardType: TextInputType.name,
                          controller: _firstNameController,
                          // ignore: missing_return
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'First name cannot be empty';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            // _authData['email'] = value.toString();
                            _firstNameController.text = value as String;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, top: 5.0, right: 15.0, bottom: 8.0),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 14),
                          decoration: getInputDecoration(
                            'Last Name',
                            Icons.person,
                          ),
                          keyboardType: TextInputType.name,
                          controller: _lastNameController,
                          // ignore: missing_return
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Last name cannot be empty';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            // _authData['email'] = value.toString();
                            _lastNameController.text = value as String;
                          },
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(
                      //       left: 15.0, top: 0.0, right: 15.0, bottom: 8.0),
                      //   child: TextFormField(
                      //     style: const TextStyle(fontSize: 14),
                      //     decoration: getInputDecoration('Phone', Icons.call),
                      //     keyboardType: TextInputType.number,
                      //     inputFormatters: [
                      //       FilteringTextInputFormatter
                      //           .digitsOnly, // Allow only digits
                      //       LengthLimitingTextInputFormatter(
                      //           15), // Set minimum length to 11
                      //     ],
                      //     controller: _phoneController,
                      //     // ignore: missing_return
                      //     validator: (value) {
                      //       if (value!.isEmpty) {
                      //         return 'Phone number cannot be empty';
                      //       } else if (value.length < 11) {
                      //         return 'Phone number should be at least 11 digits';
                      //       }
                      //       return null;
                      //     },
                      //     onSaved: (value) {
                      //       _phoneController.text = value as String;
                      //     },
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, top: 5.0, right: 15.0, bottom: 8.0),
                        child: IntlPhoneField(
                          decoration: getInputDecoration('Phone', Icons.call),
                          initialCountryCode: 'PK',
                          invalidNumberMessage: 'Enter Valid Phone Number',
                          showDropdownIcon: false,
                          controller: _phoneController,
                          flagsButtonPadding: const EdgeInsets.only(
                            left: 5.0,
                          ),
                          onChanged: (phone) {
                            // _phoneController.text = phone as String;
                            setState(() {
                              fullPhoneNumber = phone.completeNumber;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, top: 0.0, right: 15.0, bottom: 8.0),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 14),
                          decoration: getInputDecoration(
                            'Email',
                            Icons.email_outlined,
                          ),
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (input) =>
                              !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                      .hasMatch(input!)
                                  ? "Email Id should be valid"
                                  : null,
                          onSaved: (value) {
                            // _authData['email'] = value.toString();
                            _emailController.text = value as String;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, top: 5.0, right: 15.0, bottom: 4.0),
                        child: TextFormField(
                          style: const TextStyle(color: Colors.black),
                          keyboardType: TextInputType.text,
                          controller: _passwordController,
                          onSaved: (input) {
                            // _authData['password'] = input.toString();
                            _passwordController.text = input as String;
                          },
                          validator: (input) => input!.length < 3
                              ? "Password should be more than 3 characters"
                              : null,
                          obscureText: hidePassword,
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              borderSide: BorderSide(
                                color: Color(0xff858597),
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              borderSide: BorderSide(
                                color: Color(0xff858597),
                              ),
                            ),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              borderSide: BorderSide(
                                color: Color(0xff858597),
                              ),
                            ),
                            filled: true,
                            hintStyle: const TextStyle(
                                color: Colors.black54, fontSize: 14),
                            hintText: "password",
                            fillColor: kBackgroundColor,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 18, horizontal: 15),
                            prefixIcon: const Icon(
                              Icons.lock_outlined,
                              color: kTextLowBlackColor,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              },
                              color: kTextLowBlackColor,
                              icon: Icon(hidePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined),
                            ),
                          ),
                        ),
                      ),

                      // File Input
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, top: 10.0, right: 15.0, bottom: 8.0),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              borderSide: BorderSide(
                                color: Color(0xff858597),
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              borderSide: BorderSide(
                                color: Color(0xff858597),
                              ),
                            ),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              borderSide: BorderSide(
                                color: Color(0xff858597),
                              ),
                            ),
                            filled: true,
                            hintStyle: const TextStyle(
                                color: Colors.black54, fontSize: 14),
                            hintText: 'Upload Qualifications Document',
                            fillColor: kBackgroundColor,
                            suffixIcon: IconButton(
                              onPressed: () async {
                                var status = await Permission.storage.status;
                                if (!status.isGranted) {
                                  await Permission.storage.request();
                                }
                                // FilePickerResult? result =
                                //     await FilePicker.platform.pickFiles(
                                //   type: FileType.custom,
                                //   allowedExtensions: [
                                //     'jpg',
                                //     'jpeg',
                                //     'png',
                                //     'doc',
                                //     'docx',
                                //     'pdf'
                                //   ],
                                // );

                                // if (result != null) {
                                //File file = File(result.files.single.path!);
                                chooseImage();
                                // }
                              },
                              color: kTextLowBlackColor,
                              icon: const Icon(Icons.add_circle_outline,
                                  color: kSelectItemColor),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          readOnly: true,
                          controller: _selectedFileController,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, top: 5.0, right: 15.0, bottom: 8.0),
                        child: TextFormField(
                          style: const TextStyle(
                            fontSize: 14,
                            height:
                                1.5, // Adjust this value to increase/decrease line spacing
                          ),
                          maxLines: 3, // Set the maximum number of lines to 3
                          decoration: getInputDecoration('Message...'),
                          keyboardType: TextInputType.text,
                          controller: _messageController,
                          // ignore: missing_return
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Message content cannot be empty';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            // _authData['email'] = value.toString();
                            _messageController.text = value as String;
                          },
                        ),
                      ),

                      SizedBox(
                        width: double.infinity,
                        child: _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, right: 15, top: 10, bottom: 10),
                                child: MaterialButton(
                                  elevation: 0,
                                  onPressed: _submit,
                                  color: kBlueColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadiusDirectional.circular(10),
                                    // side: const BorderSide(color: kRedColor),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Sign up',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account?',
                    style: TextStyle(
                      color: kTextLowBlackColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      print(fullPhoneNumber);
                      Navigator.of(context).pushNamed(AuthScreen.routeName);
                    },
                    child: const Text(
                      ' Log In',
                      style: TextStyle(
                          color: kBlueColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
