// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:doggel_instructor/constants.dart';
import 'package:doggel_instructor/widgets/dialog.dart';
import 'package:doggel_instructor/screens/curriculum.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class DocumentAddScreen extends StatefulWidget {
  final dynamic type;
  final String courseId;
  final String courseTitle;
  final String token;

  const DocumentAddScreen(
      {Key? key,
      required this.type,
      required this.courseId,
      required this.courseTitle,
      required this.token})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DocumentAddScreenState createState() => _DocumentAddScreenState();
}

class _DocumentAddScreenState extends State<DocumentAddScreen> {
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  var lessonType = "Document";
  dynamic document;
  dynamic docType;

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
  String isFree = '';

  @override
  void initState() {
    super.initState();
    fetchSections();
  }

  fetchSections() async {
    var url =
        "$BASE_URL/api_instructor/sections?course_id=${widget.courseId}&auth_token=${widget.token}";
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
                              icon: const Icon(Icons.keyboard_arrow_down,
                                  color: Colors.black45),
                              iconSize: 32,
                              hint: const Text("Select type of document",
                                  style: TextStyle(color: kTextColor)),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          child: InkWell(
                            onTap: () {
                              chooseFile();
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                if (document != null)
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
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
                                      borderRadius: BorderRadius.circular(15.0),
                                      side:
                                          const BorderSide(color: kGreenColor),
                                    ),
                                    child: const Text("Pick File",
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

                      if (title.isNotEmpty &&
                          dropDownValueOne.isNotEmpty &&
                          docType.isNotEmpty &&
                          document.toString().isNotEmpty &&
                          summary.isNotEmpty) {
                        Dialogs.showLoadingDialog(context);

                        await uploadVideo(title, dropDownValueOne, docType,
                            document, summary, isFree);

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

  Future uploadVideo(String title, String sectionId, String lessonType, file,
      String summary, String isFree) async {
    String fileName = basename(file);
    // print("file base name:$fileName");
    const String apiUrl = "$BASE_URL/api_instructor/add_lesson";

    try {
      FormData formData = FormData.fromMap({
        'auth_token': widget.token,
        'title': title,
        'course_id': widget.courseId,
        'section_id': sectionId,
        'lesson_type': lessonType,
        'attachment': await MultipartFile.fromFile(file, filename: fileName),
        'summary': summary,
        // 'is_free': isFree,

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
