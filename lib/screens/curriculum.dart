import 'dart:convert';
import 'package:doggel_instructor/models/section_and_lesson_model.dart';
import 'package:doggel_instructor/providers/shared_pref_helper.dart';
import 'package:doggel_instructor/widgets/course_detail_list_item.dart';
import 'package:doggel_instructor/widgets/custom_app_bar_two.dart';
import 'package:doggel_instructor/widgets/lesson_add_dialog.dart';
import 'package:doggel_instructor/widgets/section_add_dialog.dart';
import 'package:doggel_instructor/widgets/section_error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'section_sort_screen.dart';

enum SingingCharacter { youtube, vimeo, videoFile, document }

class ManageLessons extends StatefulWidget {
  static const routeName = '/managelesson-screen';
  final String title;
  final String id;

  const ManageLessons({Key? key, required this.title, required this.id})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ManageLessonsState createState() => _ManageLessonsState();
}

class _ManageLessonsState extends State<ManageLessons> {
  dynamic data;
  dynamic token;
  bool isLoading = false;
  List courseData = [];
  bool checkBoxValue = false;

  Future<SectionAndLessonModel>? futureCourseData;

  courseDetails() async {
    var authToken = await SharedPreferenceHelper().getAuthToken();
    setState(() {
      token = authToken;
      isLoading = true;
    });
    var url =
        "$BASE_URL/api_instructor/section_and_lesson?course_id=${widget.id}&auth_token=$authToken";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var itemCourseDetails = json.decode(response.body)['section_and_lesson'];
      var item = json.decode(response.body);
      setState(() {
        courseData = itemCourseDetails;
        data = item;
        isLoading = false;
      });
    } else {
      setState(() {
        data = [];
        isLoading = false;
      });
    }
  }

  Future<SectionAndLessonModel> fetchCourseDetail() async {
    var authToken = await SharedPreferenceHelper().getAuthToken();
    var url =
        "$BASE_URL/api_instructor/section_and_lesson?course_id=${widget.id}&auth_token=$authToken";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return SectionAndLessonModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load...');
    }
  }

  @override
  void initState() {
    super.initState();
    futureCourseData = fetchCourseDetail();
    courseDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarTwo(title: widget.title),
      resizeToAvoidBottomInset: false,
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 45,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(
                    flex: 1,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Manage Lessons",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 15,
                    ),
                    child: SpeedDial(
                      curve: Curves.bounceInOut,
                      direction: SpeedDialDirection.down,
                      animatedIcon: AnimatedIcons.menu_close,
                      animatedIconTheme:
                          const IconThemeData(color: Colors.white),
                      activeBackgroundColor: kRedColor,
                      backgroundColor: kGreenColor,
                      foregroundColor: Colors.white70,
                      shape: const CircleBorder(),
                      children: [
                        SpeedDialChild(
                            child: const Icon(Icons.add),
                            foregroundColor: Colors.white,
                            backgroundColor: kGreenColor,
                            labelBackgroundColor: kGreenColor,
                            labelStyle: const TextStyle(color: Colors.white),
                            label: "Add Chapter",
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AddSectionDialog(
                                    id: widget.id, courseTitle: widget.title),
                              );
                            }),
                        SpeedDialChild(
                            child: const Icon(Icons.wrap_text),
                            foregroundColor: Colors.white,
                            backgroundColor: kGreenColor,
                            labelBackgroundColor: kGreenColor,
                            labelStyle: const TextStyle(color: Colors.white),
                            label: "Add Lesson",
                            onTap: () {
                              courseData.isNotEmpty
                                  ? Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                      return LessonAddDialog(
                                          courseId: widget.id,
                                          courseTitle: widget.title);
                                    }))
                                  : showDialog(
                                      context: context,
                                      builder: (ctx) =>
                                          const SectionErrorDialog(),
                                    );
                            }),
                        SpeedDialChild(
                            child: const Icon(Icons.menu),
                            foregroundColor: Colors.white,
                            backgroundColor: kGreenColor,
                            labelBackgroundColor: kGreenColor,
                            labelStyle: const TextStyle(color: Colors.white),
                            label: "Arrange Section",
                            onTap: () {
                              courseData.isNotEmpty
                                  ? Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                      return SectionSortScreen(
                                          courseId: widget.id,
                                          courseTitle: widget.title);
                                    }))
                                  : showDialog(
                                      context: context,
                                      builder: (ctx) =>
                                          const SectionErrorDialog(),
                                    );
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            FutureBuilder<SectionAndLessonModel>(
              future: futureCourseData,
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
                    return dataSnapshot.data!.validity == 1
                        ? SizedBox(
                            child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount:
                                    dataSnapshot.data!.sectionAndLesson!.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  var unescape = HtmlUnescape();
                                  var sectionTitle = unescape.convert(
                                      dataSnapshot
                                          .data!.sectionAndLesson![index].title
                                          .toString());
                                  return CourseDetailListItem(
                                    courseId: widget.id,
                                    courseTitle: widget.title,
                                    sectionId: dataSnapshot
                                        .data!.sectionAndLesson![index].id
                                        .toString(),
                                    sectionTitle: sectionTitle,
                                    lessons: dataSnapshot
                                        .data!
                                        .sectionAndLesson![index]
                                        .lessons as List,
                                    token: token,
                                  );
                                }),
                          )
                        : Container();
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
