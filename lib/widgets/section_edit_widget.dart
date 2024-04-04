// ignore_for_file: use_build_context_synchronously

import 'package:doggel_instructor/models/update_user_model.dart';
import 'package:doggel_instructor/providers/shared_pref_helper.dart';
import 'package:doggel_instructor/screens/curriculum.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../constants.dart';
import 'dialog.dart';

// ignore: non_constant_identifier_names
Future<UpdateUserModel?> DeleteSection(
    String token, String courseId, String sectionId) async {
  const String apiUrl = "$BASE_URL/api_instructor/delete_section";

  final response = await http.post(Uri.parse(apiUrl), body: {
    'auth_token': token,
    'course_id': courseId,
    'section_id': sectionId,
  });

  if (response.statusCode == 201) {
    final String responseString = response.body;

    return updateUserModelFromJson(responseString);
  } else {
    return null;
  }
}

// ignore: non_constant_identifier_names
Future<UpdateUserModel?> UpdateSection(
    String token, String sectionId, String sectionTitle) async {
  const String apiUrl = "$BASE_URL/api_instructor/update_section";

  final response = await http.post(Uri.parse(apiUrl), body: {
    'auth_token': token,
    'section_id': sectionId,
    'title': sectionTitle,
  });

  if (response.statusCode == 201) {
    final String responseString = response.body;

    return updateUserModelFromJson(responseString);
  } else {
    return null;
  }
}

// ignore: must_be_immutable
class EditSectionWidget extends StatelessWidget {
  final String courseId;
  final String courseTitle;
  final String sectionId;
  final String sectionTitle;

  EditSectionWidget(
      {Key? key,
      required this.courseId,
      required this.courseTitle,
      required this.sectionId,
      required this.sectionTitle})
      : super(key: key);

  dynamic _authToken;

  final GlobalKey<FormState> _formKey = GlobalKey();

  final _textController = TextEditingController();

  InputDecoration getInputDecoration(String hintext, IconData iconData) {
    return InputDecoration(
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: Colors.white),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: Color(0xFF3862FD)),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: Color(0xFFF65054)),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: Color(0xFFF65054)),
      ),
      filled: true,
      hintStyle: const TextStyle(color: Color(0xFFc7c8ca)),
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
    _textController.text = sectionTitle;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'Edit Section Form',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          iconTheme: const IconThemeData(
            color: kSecondaryColor, //change your color here
          ),
          backgroundColor: kBackgroundColor,
          actions: <Widget>[
            IconButton(
                icon: const Icon(
                  Icons.cancel,
                  color: kSecondaryColor,
                ),
                onPressed: () => Navigator.of(context).pop()),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Section Title',
                            style: TextStyle(
                              color: kTextColor,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      TextFormField(
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                        decoration: getInputDecoration(
                          'Section Title',
                          Icons.title,
                        ),
                        controller: _textController,
                        // ignore: missing_return
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Section title cannot be empty';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _textController.text = value!;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 5,
                            child: MaterialButton(
                              onPressed: () async {
                                _authToken = await SharedPreferenceHelper()
                                    .getAuthToken();
                                Dialogs.showLoadingDialog(context);
                                // ignore: unused_local_variable
                                await DeleteSection(
                                    _authToken, courseId, sectionId);
                                Navigator.of(context).pop();
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return ManageLessons(
                                      title: courseTitle, id: courseId);
                                }));
                              },
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              color: kGreenColor,
                              elevation: 0.1,
                              textColor: Colors.white,
                              splashColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                side: const BorderSide(color: kGreenColor),
                              ),
                              child: const Text(
                                'Delete Section',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ),
                          Expanded(flex: 1, child: Container()),
                          Expanded(
                            flex: 5,
                            child: MaterialButton(
                              onPressed: () async {
                                _authToken = await SharedPreferenceHelper()
                                    .getAuthToken();
                                var sectionTitle =
                                    _textController.text.toString();
                                if (sectionTitle.isNotEmpty) {
                                  Dialogs.showLoadingDialog(context);
                                  // ignore: unused_local_variable
                                  await UpdateSection(
                                      _authToken, sectionId, sectionTitle);
                                  Navigator.of(context).pop();
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) {
                                    return ManageLessons(
                                        title: courseTitle, id: courseId);
                                  }));
                                }
                              },
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              color: kGreenColor,
                              elevation: 0.1,
                              textColor: Colors.white,
                              splashColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                side: const BorderSide(color: kGreenColor),
                              ),
                              child: const Text(
                                'Update Section',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
