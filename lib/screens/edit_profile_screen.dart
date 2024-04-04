// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:doggel_instructor/screens/account_screen.dart';
import 'package:doggel_instructor/widgets/user_image_picker.dart';
import 'package:doggel_instructor/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../constants.dart';
import '../widgets/custom_text.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:io';
import '../models/user.dart';
import '../models/common_functions.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = '/edit-profile';

  const EditProfileScreen({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;
  final Map<String, String> _userData = {
    'first_name': '',
    'last_name': '',
    'email': '',
    'bio': '',
    'twitter': '',
    'facebook': '',
    'linkedin': '',
  };

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      // Log user in
      final updateUser = User(
        firstName: _userData['first_name'],
        lastName: _userData['last_name'],
        email: _userData['email'],
        biography: _userData['bio'],
        twitter: _userData['twitter'],
        facebook: _userData['facebook'],
        linkedin: _userData['linkedin'],
      );
      await Provider.of<Auth>(context, listen: false)
          .updateUserData(updateUser);

      Navigator.of(context).pop();
      Navigator.of(context).pushNamed(AccountScreen.routeName);

      CommonFunctions.showSuccessToast('User updated Successfully');
    } on HttpException {
      var errorMsg = 'Update failed';
      CommonFunctions.showErrorDialog(errorMsg, context);
    } catch (error) {
      const errorMsg = 'Update failed!';
      CommonFunctions.showErrorDialog(errorMsg, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  InputDecoration getInputDecoration(String hintext, IconData iconData) {
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
          color: Color(0xff858597), fontSize: 12, fontWeight: FontWeight.w300),
      hintText: hintext,
      fillColor: Colors.white,
      prefixIcon: Icon(
        iconData,
        color: const Color(0xFFc7c8ca),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 17),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<Auth>(context, listen: false).user;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        toolbarHeight: 30,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: Provider.of<Auth>(context, listen: false).getUserInfo(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.error != null) {
              //error
              return const Center(
                child: Text('Error Occured'),
              );
            } else {
              return Consumer<Auth>(builder: (context, authData, child) {
                final user = authData.user;
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Update Profile Picture",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: UserImagePicker(image: user.image),
                      ),
                      _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10.0),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const Text(
                                      "First Name",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xff858597)),
                                    ),
                                    const SizedBox(height: 5),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 14),
                                      initialValue: user.firstName,
                                      decoration: getInputDecoration(
                                        'First Name',
                                        Icons.account_circle,
                                      ),
                                      keyboardType: TextInputType.text,
                                      // ignore: missing_return
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Can not be empty';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _userData['first_name'] = value!;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Last Name",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xff858597)),
                                    ),
                                    const SizedBox(height: 5),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 14),
                                      initialValue: user.lastName,
                                      decoration: getInputDecoration(
                                        'Last Name',
                                        Icons.account_circle,
                                      ),
                                      keyboardType: TextInputType.text,
                                      // ignore: missing_return
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Can not be empty';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _userData['last_name'] = value!;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Email",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xff858597)),
                                    ),
                                    const SizedBox(height: 5),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 14),
                                      initialValue: user.email,
                                      decoration: getInputDecoration(
                                        'Email',
                                        Icons.email,
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      // ignore: missing_return
                                      validator: (value) {
                                        if (value!.isEmpty ||
                                            !value.contains('@')) {
                                          return 'Invalid email!';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _userData['email'] = value!;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Biography",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xff858597)),
                                    ),
                                    const SizedBox(height: 5),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 14),
                                      initialValue: user.biography,
                                      decoration: getInputDecoration(
                                        'Biography',
                                        Icons.edit,
                                      ),
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: 5,
                                      onSaved: (value) {
                                        _userData['bio'] = value!;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Social links",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xff858597)),
                                    ),
                                    const SizedBox(height: 5),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 14),
                                      initialValue: user.facebook,
                                      decoration: getInputDecoration(
                                        'Facebook Link',
                                        MdiIcons.facebook,
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      onSaved: (value) {
                                        _userData['facebook'] = value!;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 14),
                                      initialValue: user.twitter,
                                      decoration: getInputDecoration(
                                        'Twitter Link',
                                        MdiIcons.twitter,
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      onSaved: (value) {
                                        _userData['twitter'] = value!;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 14),
                                      initialValue: user.linkedin,
                                      decoration: getInputDecoration(
                                        'LinkedIn Link',
                                        MdiIcons.linkedin,
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      onSaved: (value) {
                                        _userData['linkedin'] = value!;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: MaterialButton(
                                        onPressed: () {
                                          if (_userData['first_name']!
                                              .isEmpty) {
                                            _userData['first_name'] =
                                                user.firstName!;
                                          }
                                          if (_userData['last_name']!.isEmpty) {
                                            _userData['last_name'] =
                                                user.lastName!;
                                          }
                                          if (_userData['email']!.isEmpty) {
                                            _userData['email'] = user.email!;
                                          }
                                          if (_userData['email']!.isEmpty) {
                                            _userData['email'] = user.email!;
                                          }
                                          if (_userData['bio']!.isEmpty) {
                                            _userData['bio'] = user.biography!;
                                          }
                                          if (_userData['twitter']!.isEmpty) {
                                            _userData['twitter'] =
                                                user.twitter!;
                                          }
                                          if (_userData['facebook']!.isEmpty) {
                                            _userData['facebook'] =
                                                user.facebook!;
                                          }
                                          if (_userData['linkedin']!.isEmpty) {
                                            _userData['linkedin'] =
                                                user.linkedin!;
                                          }
                                          _submit();
                                        },
                                        color: kGreenColor,
                                        textColor: Colors.white,
                                        elevation: 0.1,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 12),
                                        splashColor: Colors.blueAccent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          side: const BorderSide(
                                              color: kGreenColor),
                                        ),
                                        child: const Text(
                                          'UPDATE',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                            )
                    ],
                  ),
                );
              });
            }
          }
        },
      ),
    );
  }
}
