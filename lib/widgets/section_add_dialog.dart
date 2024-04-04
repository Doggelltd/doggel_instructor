// ignore_for_file: use_build_context_synchronously

import 'package:doggel_instructor/constants.dart';
import 'package:doggel_instructor/models/update_user_model.dart';
import 'package:doggel_instructor/providers/shared_pref_helper.dart';
import 'package:doggel_instructor/screens/curriculum.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dialog.dart';

// ignore: non_constant_identifier_names
Future<UpdateUserModel?> CreateCourse(
    String token, String id, String title) async {
  const String apiUrl = "$BASE_URL/api_instructor/add_section";

  final response = await http.post(Uri.parse(apiUrl), body: {
    'auth_token': token,
    'course_id': id,
    'title': title,
  });

  if (response.statusCode == 201) {
    final String responseString = response.body;

    return updateUserModelFromJson(responseString);
  } else {
    return null;
  }
}

// ignore: must_be_immutable
class AddSectionDialog extends StatelessWidget {
  final String id;
  final String courseTitle;

  AddSectionDialog({Key? key, required this.id, required this.courseTitle})
      : super(key: key);

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
      fillColor: const Color(0xFFF7F7F7),
      prefixIcon: Icon(
        iconData,
        color: const Color(0xFFc7c8ca),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 17),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add New Section"),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Title"),
          TextFormField(
            style: const TextStyle(fontSize: 16),
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
          const SizedBox(height: 10),
          MaterialButton(
            elevation: 0.1,
            onPressed: () async {
              dynamic authToken = await SharedPreferenceHelper().getAuthToken();
              if (_textController.text.isNotEmpty) {
                var title = _textController.text.toString();
                Dialogs.showLoadingDialog(context);

                await CreateCourse(authToken, id, title);

                Navigator.of(context).pop();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return ManageLessons(title: courseTitle, id: id);
                }));
              }
            },
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            color: kGreenColor,
            splashColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: const BorderSide(color: kGreenColor),
            ),
            child: const Text(
              "Submit",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        MaterialButton(
          elevation: 0.1,
          onPressed: () {
            Navigator.of(context).pop();
          },
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          color: kRedColor,
          splashColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: const Text(
            "Close",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
