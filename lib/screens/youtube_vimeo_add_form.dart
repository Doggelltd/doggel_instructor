// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:doggel_instructor/constants.dart';
import 'package:doggel_instructor/providers/shared_pref_helper.dart';
import 'package:doggel_instructor/widgets/dialog.dart';
import 'package:doggel_instructor/models/update_user_model.dart';
import 'package:doggel_instructor/screens/curriculum.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class YoutubeVimeoAddScreen extends StatefulWidget {
  final dynamic type;
  final String courseId;
  final String courseTitle;

  const YoutubeVimeoAddScreen(
      {Key? key,
      required this.type,
      required this.courseId,
      required this.courseTitle})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _YoutubeVimeoAddScreenState createState() => _YoutubeVimeoAddScreenState();
}

// ignore: non_constant_identifier_names
Future<UpdateUserModel?> CreateLesson(
    String token,
    String title,
    String courseId,
    String sectionId,
    String lessonType,
    String lessonProvider,
    String url,
    String summary,
    String isFree) async {
  const String apiUrl = "$BASE_URL/api_instructor/add_lesson";

  final response = await http.post(Uri.parse(apiUrl), body: {
    'auth_token': token,
    'title': title,
    'course_id': courseId,
    'section_id': sectionId,
    'lesson_type': lessonType,
    'lesson_provider': lessonProvider,
    'video_url': url,
    'summary': summary,
    'is_free': "1",
  });

  if (response.statusCode == 201) {
    final String responseString = response.body;

    return updateUserModelFromJson(responseString);
  } else {
    return null;
  }
}

class _YoutubeVimeoAddScreenState extends State<YoutubeVimeoAddScreen> {
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  dynamic lessonType;
  var lessonTypeValue = "video-url";
  dynamic lessonProvider;
  String isFree = '0';

  final _titleController = TextEditingController();
  final _urlController = TextEditingController();
  final _summaryController = TextEditingController();

  dynamic dropDownValueOne;
  List data = [];
  dynamic _authToken;

  @override
  void initState() {
    super.initState();
    fetchSections();
  }

  fetchSections() async {
    _authToken = await SharedPreferenceHelper().getAuthToken();
    var url =
        "$BASE_URL/api_instructor/sections?course_id=${widget.courseId}&auth_token=$_authToken";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var item = json.decode(response.body)['sections'];
      //print(items);
      setState(() {
        data = item;
      });
    } else {
      setState(() {
        data = [];
      });
    }
  }

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
      hintStyle: const TextStyle(color: kTextColor),
      hintText: hintext,
      fillColor: Colors.white,
      prefixIcon: Icon(
        iconData,
        color: const Color(0xFFc7c8ca),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 5),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type.toString() == "SingingCharacter.youtube") {
      setState(() {
        lessonType = "Youtube Video";
        lessonProvider = "youtube";
      });
    } else if (widget.type.toString() == "SingingCharacter.vimeo") {
      setState(() {
        lessonType = "Vimeo Video";
        lessonProvider = "vimeo";
      });
    }
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: const Text(
          "Add New Lesson",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: Form(
          key: globalFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                child: Text(
                  'Create Lesson: $lessonType',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: kTextColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(6.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Lesson Title',
                            style: TextStyle(
                              color: kTextColor,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      TextFormField(
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                        decoration: getInputDecoration(
                          'Title',
                          Icons.title,
                        ),
                        controller: _titleController,
                        // ignore: missing_return
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Lesson title cannot be empty';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _titleController.text = value!;
                        },
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Section',
                            style: TextStyle(
                              color: kTextColor,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      Card(
                        elevation: 0,
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton(
                              icon: const Icon(Icons.keyboard_arrow_down,
                                  color: Colors.black45),
                              iconSize: 32,
                              hint: const Text("Select Section",
                                  style: TextStyle(color: kTextColor)),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              value: dropDownValueOne,
                              onChanged: (newVal) {
                                dropDownValueOne = newVal;
                                setState(() {});
                              },
                              isExpanded: true,
                              items: data.map((cd) {
                                var val = cd['title'];
                                return DropdownMenuItem(
                                  value: cd['id'],
                                  child: Text(val),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Video Url',
                            style: TextStyle(
                              color: kTextColor,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      TextFormField(
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                        decoration: getInputDecoration(
                          'video-url',
                          Icons.add_link,
                        ),
                        controller: _urlController,
                        // ignore: missing_return
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Lesson title cannot be empty';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _urlController.text = value!;
                        },
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Summary',
                                style: TextStyle(
                                  color: kTextColor,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          TextFormField(
                            maxLines: 4,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                            decoration: getInputDecoration(
                              'Summary',
                              Icons.info_outline,
                            ),
                            controller: _summaryController,
                            onSaved: (value) {
                              _summaryController.text = value!;
                            },
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          // Row(
                          //   children: [
                          //     Checkbox(
                          //       onChanged: (value) {
                          //         setState(() {
                          //           value == true ? isFree = '1' : isFree = '0';
                          //         });
                          //       },
                          //       value: isFree == '1' ? true : false,
                          //     ),
                          //     const Text(
                          //       'Check if this course has discount',
                          //       style: TextStyle(color: Colors.black45),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: MaterialButton(
                    onPressed: () async {
                      if (!globalFormKey.currentState!.validate()) {
                        return;
                      }

                      var title = _titleController.text.toString();
                      var url = _urlController.text.toString();
                      var summary = _summaryController.text.toString();
                      // print(_authToken +
                      //     '\n' +
                      //     title +
                      //     '\n' +
                      //     widget.courseId +
                      //     '\n' +
                      //     dropDownValueOne +
                      //     '\n' +
                      //     lessonTypeValue +
                      //     '\n' +
                      //     lessonProvider +
                      //     '\n' +
                      //     url +
                      //     '\n' +
                      //     summary);
                      if (title.isNotEmpty &&
                          dropDownValueOne.isNotEmpty &&
                          url.isNotEmpty &&
                          summary.isNotEmpty) {
                        Dialogs.showLoadingDialog(context);
                        // print(_authToken + '\n' + title + '\n' + _courseId+ '\n' + dropDownValueOne + '\n' + lessonTypeValue + '\n' + lessonProvider + '\n' + url + '\n' + summary);

                        await CreateLesson(
                            _authToken,
                            title,
                            widget.courseId,
                            dropDownValueOne,
                            lessonTypeValue,
                            lessonProvider,
                            url,
                            summary,
                            isFree);
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return ManageLessons(
                              title: widget.courseTitle, id: widget.courseId);
                        }));
                      }
                    },
                    color: kGreenColor,
                    textColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    splashColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: const BorderSide(color: kGreenColor),
                    ),
                    child: const Text(
                      'Add Lesson',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}