// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:convert';
import 'package:doggel_instructor/constants.dart';
import 'package:doggel_instructor/providers/shared_pref_helper.dart';
import 'package:doggel_instructor/widgets/dialog.dart';
import 'package:doggel_instructor/models/lesson_model.dart';
import 'package:doggel_instructor/screens/curriculum.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class DocumentLessonEditScreen extends StatefulWidget {
  final String courseId;
  final String courseTitle;
  final String lessonId;
  final String sectionId;
  final String sectionTitle;

  const DocumentLessonEditScreen(
      {Key? key,
      required this.courseId,
      required this.courseTitle,
      required this.lessonId,
      required this.sectionId,
      required this.sectionTitle})
      : super(key: key);

  @override
  _DocumentLessonEditScreenState createState() =>
      _DocumentLessonEditScreenState();
}

class _DocumentLessonEditScreenState extends State<DocumentLessonEditScreen> {
  var lessonType = "Document";
  dynamic document;
  dynamic docType;
  dynamic docName;

  final _titleController = TextEditingController();
  final _summaryController = TextEditingController();

  final List<String> _fileType = <String>[
    'Text file',
    'Pdf file',
    'Document file'
  ];

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

  chooseFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;

      // print(file.name);
      // print(file.bytes);
      // print(file.size);
      // print(file.extension);
      // print(file.path);
      setState(() {
        document = file.path;
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
                  docName = dataSnapshot.data!.attachmentType;
                  if (dataSnapshot.data!.attachmentType == "txt") {
                    docName = "Text file";
                  } else if (dataSnapshot.data!.attachmentType == "pdf") {
                    docName = "Pdf file";
                  } else {
                    docName = "Document file";
                  }
                  return Form(
                    key: globalFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding:
                              EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                          child: Text(
                            'Lesson Type: Document',
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
                                      'Document type',
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
                                        hint: Text(docName,
                                            style: const TextStyle(
                                                color: Colors.black)),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                        value: dropDownValueTwo,
                                        onChanged: (newVal) {
                                          if (newVal == "Text file") {
                                            docType = "other-txt";
                                          } else if (newVal == "Pdf file") {
                                            docType = "other-pdf";
                                          } else {
                                            docType = "other-doc";
                                          }
                                          dropDownValueTwo = newVal;
                                          setState(() {});
                                        },
                                        isExpanded: true,
                                        items: _fileType.map((val) {
                                          return DropdownMenuItem(
                                            value: val,
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
                                      'Upload file',
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0))),
                                    child: InkWell(
                                      onTap: () {
                                        chooseFile();
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          if (document != null)
                                            ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(8.0),
                                                topRight: Radius.circular(8.0),
                                              ),
                                              child: Text(document),
                                            ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 80),
                                            child: MaterialButton(
                                              color: kGreenColor,
                                              onPressed: () {
                                                chooseFile();
                                              },
                                              splashColor: Colors.blueAccent,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                                side: const BorderSide(
                                                    color: kGreenColor),
                                              ),
                                              child: const Text("Pick File",
                                                  style: TextStyle(
                                                      color: Colors.white)),
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
                                      // controller: _summaryController,
                                      // ignore: missing_return
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Lesson summary cannot be empty';
                                        }
                                        return null;
                                      },
                                      initialValue: dataSnapshot.data!.summary,
                                      onTap: () {
                                        FocusManager.instance.primaryFocus!
                                            .unfocus();
                                      },

                                      onChanged: (value) {
                                        setState(() =>
                                            _summaryController.text = value);
                                      },

                                      // onSaved: (value) {
                                      //   _summaryController.text = value;
                                      // },
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
                                    if (docType.toString() == 'null') {
                                      docType =
                                          '${dataSnapshot.data!.lessonType!}-${dataSnapshot.data!.attachmentType!}';
                                    }
                                    var summary =
                                        _summaryController.text.toString();
                                    if (summary.isEmpty) {
                                      summary = dataSnapshot.data!.summary!;
                                    }

                                    if (title.isNotEmpty &&
                                        sectionId.isNotEmpty &&
                                        summary.isNotEmpty) {
                                      Dialogs.showLoadingDialog(context);

                                      await uploadVideo(title, widget.lessonId,
                                          sectionId, docType, summary, isFree!);

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

  Future uploadVideo(String title, String lessonId, String sectionId,
      String docType, String summary, String isFree) async {
    dynamic file;
    const String apiUrl = "$BASE_URL/api_instructor/update_lesson";
    var token = await SharedPreferenceHelper().getAuthToken();
    // print("videoFile:$file");
    if (document != null) {
      try {
        String fileName = basename(document);
        // print("file base name:$fileName");
        file = await MultipartFile.fromFile(document, filename: fileName);
        // print("videoFile:$file");
        FormData formData = FormData.fromMap({
          'auth_token': token,
          'title': title,
          'lesson_id': lessonId,
          'section_id': sectionId,
          'lesson_type': docType,
          'attachment': file,
          'summary': summary,
          // 'is_free': isFree,

          'is_free': "1",
        });

        await Dio().post(apiUrl, data: formData);
      }
      // print("File upload response: $response");
      catch (e) {
        // print("expectation Caugch: $e");
        rethrow;
      }
    } else {
      FormData formData = FormData.fromMap({
        'auth_token': token,
        'title': title,
        'lesson_id': lessonId,
        'section_id': sectionId,
        'lesson_type': docType,
        'summary': summary,
        // 'is_free': isFree,
        'is_free': "1",
      });

      await Dio().post(apiUrl, data: formData);
    }
  }
}
