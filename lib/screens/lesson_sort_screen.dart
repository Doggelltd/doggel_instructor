// ignore_for_file: use_build_context_synchronously

import 'package:doggel_instructor/models/update_user_model.dart';
import 'package:doggel_instructor/providers/shared_pref_helper.dart';
import 'package:doggel_instructor/screens/curriculum.dart';
import 'package:doggel_instructor/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class LessonSortScreen extends StatefulWidget {
  final List lessons;
  final String courseId;
  final String courseTitle;

  const LessonSortScreen(
      {Key? key,
      required this.lessons,
      required this.courseId,
      required this.courseTitle})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LessonSortScreenState createState() => _LessonSortScreenState();
}

// ignore: non_constant_identifier_names
Future<UpdateUserModel?> SortLesson(String token, List sortArray) async {
  const String apiUrl = "$BASE_URL/api_instructor/sort";

  // final removedBrackets = requirements.substring(1, requirements.length - 1);
  // final parts = removedBrackets.split(', ');
  //
  List joined = sortArray.map((part) => '"$part"').toList();

  final response = await http.post(Uri.parse(apiUrl), body: {
    'auth_token': token,
    'type': 'lesson',
    'item_json': joined.toString(),
  });

  if (response.statusCode == 201) {
    final String responseString = response.body;

    return updateUserModelFromJson(responseString);
  } else {
    return null;
  }
}

class _LessonSortScreenState extends State<LessonSortScreen> {
  dynamic _authToken;
  List data = [];
  bool changeOrder = false;
  List<String> sortArray = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: const Text(
          "Sort Lesson",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 15.0),
                child: Row(
                  children: const [
                    Icon(Icons.info_outline, color: kIconColor),
                    Text(
                      " Drag & drop to sort lessons",
                      style: TextStyle(color: kTextColor, fontSize: 17),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .75,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ReorderableListView(
                  children: widget.lessons
                      .map((item) => Card(
                            key: Key("${item.id}"),
                            color: kPrimaryColor,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0,
                                        right: 8.0,
                                        top: 12.0,
                                        bottom: 12.0),
                                    child: Text(
                                      "${item.title}",
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(Icons.menu, color: kIconColor),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                  onReorder: (int start, int current) {
                    // dragging from top to bottom
                    if (start < current) {
                      setState(() {
                        changeOrder = true;
                      });
                      int end = current - 1;
                      var startItem = widget.lessons[start];
                      int i = 0;
                      int local = start;
                      do {
                        widget.lessons[local] = widget.lessons[++local];
                        i++;
                      } while (i < end - start);
                      widget.lessons[end] = startItem;
                    }
                    // dragging from bottom to top
                    else if (start > current) {
                      setState(() {
                        changeOrder = true;
                      });
                      var startItem = widget.lessons[start];
                      for (int i = start; i > current; i--) {
                        widget.lessons[i] = widget.lessons[i - 1];
                      }
                      widget.lessons[current] = startItem;
                    }
                    setState(() {});
                  },
                ),
              ),
            ),
            MaterialButton(
              onPressed: changeOrder
                  ? () async {
                      _authToken =
                          await SharedPreferenceHelper().getAuthToken();
                      for (int i = 0; i < widget.lessons.length; i++) {
                        sortArray.insert(i, widget.lessons[i].id);
                        // print(sortArray[i]);
                      }
                      Dialogs.showLoadingDialog(context);

                      // ignore: unused_local_variable
                      await SortLesson(_authToken, sortArray);
                      sortArray.removeRange(0, sortArray.length - 1);
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return ManageLessons(
                            id: widget.courseId, title: widget.courseTitle);
                      }));
                    }
                  : null,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
              color: kGreenColor,
              textColor: Colors.white,
              splashColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.0),
              ),
              child: const Text(
                'Update',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
