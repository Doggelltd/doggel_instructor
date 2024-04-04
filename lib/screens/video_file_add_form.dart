// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:doggel_instructor/constants.dart';
import 'package:doggel_instructor/providers/shared_pref_helper.dart';
import 'package:doggel_instructor/widgets/dialog.dart';
import 'package:doggel_instructor/screens/curriculum.dart';
import 'package:dio/dio.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class VideoFileAddScreen extends StatefulWidget {
  final dynamic type;
  final String courseId;
  final String courseTitle;

  const VideoFileAddScreen(
      {Key? key,
      required this.type,
      required this.courseId,
      required this.courseTitle})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _VideoFileAddScreenState createState() => _VideoFileAddScreenState();
}

class _VideoFileAddScreenState extends State<VideoFileAddScreen> {
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  var lessonTypeValue = "system-video";
  var lessonType = "Video File";
  var lessonProvider = "system_video";
  dynamic videoUrl;

  final Duration _duration = const Duration(hours: 0, minutes: 0, seconds: 0);

  final _titleController = TextEditingController();
  final _summaryController = TextEditingController();
  final _durationController = TextEditingController();

  dynamic dropDownValueOne;
  List data = [];
  String isFree = '1';

  @override
  void initState() {
    super.initState();
    fetchSections();
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

  chooseVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;

      // print(file.name);
      // print(file.bytes);
      // print(file.size);
      // print(file.extension);
      // print(file.path);
      setState(() {
        videoUrl = file.path;
      });
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
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
                            'Upload system video file',
                            style: TextStyle(
                              color: kTextColor,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(4.0),
                        child: Card(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          child: InkWell(
                            onTap: () {
                              chooseVideo();
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                if (videoUrl != null)
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(8.0),
                                      topRight: Radius.circular(8.0),
                                    ),
                                    child: Text(videoUrl),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 80),
                                  child: MaterialButton(
                                    elevation: 0,
                                    color: kGreenColor,
                                    onPressed: () {
                                      chooseVideo();
                                    },
                                    splashColor: Colors.blueAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      side:
                                          const BorderSide(color: kGreenColor),
                                    ),
                                    child: const Text("Pick Video",
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      // DurationPicker(
                      //   duration: _duration,
                      //   onChange: (val) {
                      //     setState(() => _duration = val);
                      //   },
                      //   snapToMins: 5.0,
                      // ),
                      const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Video Duration',
                            style: TextStyle(
                              color: kTextColor,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),

                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: InkWell(
                              onTap: () async {
                                var resultingDuration =
                                    await showDurationPicker(
                                  context: context,
                                  initialTime: const Duration(minutes: 00),
                                );
                                setState(() {
                                  _durationController.text =
                                      resultingDuration.toString();
                                });
                              },
                              child: Card(
                                elevation: 0.5,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14, horizontal: 10),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.access_time,
                                        color: Color(0xFFc7c8ca),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          _durationController.text.isNotEmpty
                                              ? _durationController.text
                                              : _duration.toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Card(
                              elevation: 0.5,
                              color: kGreenColor,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () async {
                                    var resultingDuration =
                                        await showDurationPicker(
                                      context: context,
                                      initialTime: const Duration(minutes: 00),
                                    );
                                    setState(() {
                                      _durationController.text =
                                          resultingDuration.toString();
                                    });
                                    // ScaffoldMessenger.of(context).showSnackBar(
                                    //     SnackBar(
                                    //         content: Text(
                                    //             'Chose duration: $resultingDuration')));
                                  },
                                  icon: const Icon(
                                    Icons.access_time,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
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
                      var summary = _summaryController.text.toString();
                      var duration = _durationController.text.isNotEmpty
                          ? _durationController.text
                          : _duration.toString();

                      if (title.isNotEmpty &&
                          dropDownValueOne.isNotEmpty &&
                          videoUrl.toString().isNotEmpty &&
                          summary.isNotEmpty) {
                        Dialogs.showLoadingDialog(context);

                        await uploadVideo(title, dropDownValueOne, videoUrl,
                            duration, summary, isFree);

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

  Future uploadVideo(String title, String sectionId, videoFile, String duration,
      String summary, String isFree) async {
    String fileName = basename(videoFile);
    // print("file base name:$fileName");
    const String apiUrl = "$BASE_URL/api_instructor/add_lesson";
    var token = await SharedPreferenceHelper().getAuthToken();
    try {
      FormData formData = FormData.fromMap({
        'auth_token': token,
        'title': title,
        'course_id': widget.courseId,
        'section_id': sectionId,
        'lesson_type': "system-video",
        'lesson_provider': "system_video",
        'system_video_file':
            await MultipartFile.fromFile(videoFile, filename: fileName),
        'system_video_file_duration': duration,
        'summary': summary,
        'is_free': "1",
      });

      await Dio().post(apiUrl, data: formData);
      // print("File upload response: $response");
    } catch (e) {
      // print("expectation Caugch: $e");
      rethrow;
    }
  }
}
