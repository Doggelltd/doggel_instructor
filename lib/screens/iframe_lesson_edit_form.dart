// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:doggel_instructor/constants.dart';
import 'package:doggel_instructor/models/update_user_model.dart';
import 'package:doggel_instructor/providers/shared_pref_helper.dart';
import 'package:doggel_instructor/widgets/dialog.dart';
import 'package:doggel_instructor/models/lesson_model.dart';
import 'package:doggel_instructor/screens/curriculum.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class IframeLessonEditScreen extends StatefulWidget {
  final String courseId;
  final String courseTitle;
  final String lessonId;
  final String sectionId;
  final String sectionTitle;

  const IframeLessonEditScreen(
      {Key? key,
      required this.courseId,
      required this.courseTitle,
      required this.lessonId,
      required this.sectionId,
      required this.sectionTitle})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _IframeLessonEditScreenState createState() => _IframeLessonEditScreenState();
}

// ignore: non_constant_identifier_names
Future<UpdateUserModel?> UpdateLesson(
    String token,
    String title,
    String lessonId,
    String sectionId,
    String lessonType,
    String url,
    String summary,
    String isFree) async {
  const String apiUrl = "$BASE_URL/api_instructor/update_lesson";

  final response = await http.post(Uri.parse(apiUrl), body: {
    'auth_token': token,
    'title': title,
    'lesson_id': lessonId,
    'section_id': sectionId,
    'lesson_type': lessonType,
    'iframe_source': url,
    'summary': summary,
    // 'is_free': isFree,
    'is_free': "1",
  });

  if (response.statusCode == 201) {
    final String responseString = response.body;

    return updateUserModelFromJson(responseString);
  } else {
    return null;
  }
}

class _IframeLessonEditScreenState extends State<IframeLessonEditScreen> {
  var lessonType = "other-iframe";

  final _titleController = TextEditingController();
  final _urlController = TextEditingController();
  final _summaryController = TextEditingController();

  dynamic dropDownValueOne;
  dynamic dropDownValueTwo;
  List data = [];
  String check = '0';
  String checkTwo = '1';
  String? isFree;

  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<LessonDetails>? futureLessonData;

  Future<LessonDetails> fetchLessonDetail() async {
    var url =
        "$BASE_URL/api_instructor/lesson_all_data?lesson_id=${widget.lessonId}";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return LessonDetails.fromJson(
          jsonDecode(response.body)['lesson_details']);
    } else {
      throw Exception('Failed to load...');
    }
  }

  fetchSections() async {
    var token = await SharedPreferenceHelper().getAuthToken();
    var url =
        "$BASE_URL/api_instructor/sections?course_id=${widget.courseId}&auth_token=$token";
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

  @override
  void initState() {
    super.initState();
    fetchSections();
    futureLessonData = fetchLessonDetail();
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
      contentPadding: const EdgeInsets.symmetric(vertical: 17),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: const Text(
          "Edit Lesson",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: FutureBuilder<LessonDetails>(
            future: futureLessonData,
            builder: (context, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * .65,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                if (dataSnapshot.error != null) {
                  //error
                  return const Center(
                    child: Text('Error Occured'),
                  );
                } else {
                  _urlController.text = dataSnapshot.data!.attachment!;
                  _summaryController.text = dataSnapshot.data!.summary!;
                  return Form(
                    key: globalFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding:
                              EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                          child: Text(
                            'Lesson Type: Iframe',
                            style: TextStyle(
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
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                  decoration: getInputDecoration(
                                    'Title',
                                    Icons.title,
                                  ),
                                  // controller: _titleController,
                                  // ignore: missing_return
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Lesson title cannot be empty';
                                    }
                                    return null;
                                  },
                                  initialValue: dataSnapshot.data!.title,
                                  onTap: () {
                                    FocusManager.instance.primaryFocus!
                                        .unfocus();
                                  },

                                  onChanged: (value) {
                                    setState(
                                        () => _titleController.text = value);
                                  },

                                  // onSaved: (value) {
                                  //   _titleController.text = value;
                                  // },
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
                                        icon: const Icon(
                                            Icons.keyboard_arrow_down,
                                            color: Colors.black45),
                                        iconSize: 32,
                                        hint: Text(widget.sectionTitle,
                                            style: const TextStyle(
                                                color: Colors.black)),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                        value: dropDownValueOne,
                                        onTap: () {
                                          FocusManager.instance.primaryFocus!
                                              .unfocus();
                                        },
                                        onChanged: (newVal) {
                                          dropDownValueOne = newVal;
                                          // _sectionId = dropDownValueOne;
                                          setState(() {});
                                        },
                                        isExpanded: true,
                                        items: data.map((cd) {
                                          var val = cd['title'];
                                          return DropdownMenuItem(
                                            // value: dataSnapshot.data.sectionId,
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
                                      'Iframe Url',
                                      style: TextStyle(
                                        color: kTextColor,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                  decoration: getInputDecoration(
                                    'iframe-url',
                                    Icons.add_link,
                                  ),
                                  controller: _urlController,
                                  // ignore: missing_return
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Iframe url cannot be empty';
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
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                      decoration: getInputDecoration(
                                        'Summary',
                                        Icons.info_outline,
                                      ),
                                      controller: _summaryController,
                                      onSaved: (value) {
                                        setState(() {
                                          _summaryController.text = value!;
                                        });
                                      },
                                    ),
                                    // if (dataSnapshot.data!.isFree! == '1')
                                    //   Row(
                                    //     children: [
                                    //       Checkbox(
                                    //         onChanged: (value) {
                                    //           setState(() {
                                    //             value == true
                                    //                 ? checkTwo = '1'
                                    //                 : checkTwo = '0';
                                    //           });
                                    //         },
                                    //         value:
                                    //             checkTwo == '1' ? true : false,
                                    //       ),
                                    //       const Text(
                                    //         'Check if this course is free',
                                    //         style: TextStyle(
                                    //             color: Colors.black45),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // if (dataSnapshot.data!.isFree! == '0')
                                    //   Row(
                                    //     children: [
                                    //       Checkbox(
                                    //         onChanged: (value) {
                                    //           setState(() {
                                    //             value == true
                                    //                 ? check = '1'
                                    //                 : check = '0';
                                    //           });
                                    //         },
                                    //         value: check == '1' ? true : false,
                                    //       ),
                                    //       const Text(
                                    //         'Check if this course has discount',
                                    //         style: TextStyle(
                                    //             color: Colors.black45),
                                    //       ),
                                    //     ],
                                    //   ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: MaterialButton(
                                  onPressed: () async {
                                    var token = await SharedPreferenceHelper()
                                        .getAuthToken();
                                    Dialogs.showLoadingDialog(context);
                                    var url =
                                        "$BASE_URL/api_instructor/delete_lesson?lesson_id=${widget.lessonId}&auth_token=$token";
                                    try {
                                      final response =
                                          await http.get(Uri.parse(url));
                                      final extractedData =
                                          json.decode(response.body);
                                      if (extractedData == null) {
                                        return;
                                      }
                                    } catch (error) {
                                      rethrow;
                                    }
                                    Navigator.of(context).pop();
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ManageLessons(
                                          title: widget.courseTitle,
                                          id: widget.courseId);
                                    }));
                                  },
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  color: kGreenColor,
                                  elevation: 0.1,
                                  textColor: Colors.white,
                                  splashColor: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    side: const BorderSide(color: kGreenColor),
                                  ),
                                  child: const Text(
                                    'Delete Lesson',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                              Expanded(flex: 1, child: Container()),
                              Expanded(
                                flex: 5,
                                child: MaterialButton(
                                  onPressed: () async {
                                    var authToken =
                                        await SharedPreferenceHelper()
                                            .getAuthToken();
                                    if (!globalFormKey.currentState!
                                        .validate()) {
                                      return;
                                    }

                                    var title =
                                        _titleController.text.toString();
                                    if (title.isEmpty) {
                                      title = dataSnapshot.data!.title!;
                                    }
                                    if (dataSnapshot.data!.isFree == '1') {
                                      checkTwo == '1'
                                          ? isFree = '1'
                                          : isFree = '0';
                                    } else {
                                      check == '1'
                                          ? isFree = '1'
                                          : isFree = '0';
                                    }
                                    dynamic sectionId;
                                    if (dropDownValueOne.toString() == 'null') {
                                      sectionId = widget.sectionId;
                                    } else {
                                      sectionId = dropDownValueOne;
                                    }
                                    var url = _urlController.text.toString();
                                    var summary =
                                        _summaryController.text.toString();
                                    if (summary.isEmpty) {
                                      summary = dataSnapshot.data!.summary!;
                                    }

                                    if (title.isNotEmpty &&
                                        sectionId.isNotEmpty &&
                                        url.isNotEmpty &&
                                        summary.isNotEmpty) {
                                      Dialogs.showLoadingDialog(context);

                                      await UpdateLesson(
                                          authToken!,
                                          title,
                                          widget.lessonId,
                                          sectionId,
                                          lessonType,
                                          url,
                                          summary,
                                          isFree!);

                                      Navigator.of(context).pop();
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (context) {
                                        return ManageLessons(
                                            title: widget.courseTitle,
                                            id: widget.courseId);
                                      }));
                                    }
                                  },
                                  color: kGreenColor,
                                  elevation: 0.1,
                                  textColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  splashColor: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    side: const BorderSide(color: kGreenColor),
                                  ),
                                  child: const Text(
                                    'Update Lesson',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }
            }),
      ),
    );
  }
}
