import 'dart:convert';
import 'dart:io';
import 'package:doggel_instructor/constants.dart';
import 'package:doggel_instructor/models/course_model.dart';
import 'package:doggel_instructor/providers/shared_pref_helper.dart';
import 'package:doggel_instructor/widgets/dialog.dart';
import 'package:doggel_instructor/screens/course_manager.dart';
import 'package:doggel_instructor/widgets/custom_app_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:doggel_instructor/widgets/string_extension.dart';
import 'package:http/http.dart' as http;

class CourseUpdateScreen extends StatefulWidget {
  final String courseId;
  const CourseUpdateScreen({Key? key, required this.courseId})
      : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _CourseUpdateScreenState createState() => _CourseUpdateScreenState();
}

class _CourseUpdateScreenState extends State<CourseUpdateScreen> {
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController shortDesController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  final TextEditingController metaKeywordsController = TextEditingController();
  final TextEditingController metaDesController = TextEditingController();
  final TextEditingController thumbnailController = TextEditingController();

  dynamic dropDownValueOne;
  dynamic dropDownValueOneID;
  dynamic category;
  dynamic level;
  dynamic language;
  dynamic dropDownValueTwo;
  dynamic dropDownValueThree;
  dynamic dropDownValueFour;
  dynamic provider;
  dynamic isFree;
  dynamic isTop;
  File? _image;
  final ImagePicker _picker = ImagePicker();

  final List<String> _level = <String>['Beginner', 'Intermediate', 'Advanced'];

  final List<String> _videoType = <String>['Youtube', 'Vimeo', 'Html5'];

  bool checked = false;
  bool checkedTwo = true;

  List data = [];
  List data3 = [];
  bool isLoading = false;

  Future<CourseModel>? futureCourseData;

  Future<CourseModel> fetchCourseDetail() async {
    var authToken = await SharedPreferenceHelper().getAuthToken();
    var url =
        "$BASE_URL/api_instructor/edit_course_form?course_id=${widget.courseId}&auth_token=$authToken";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return CourseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load...');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCourseFormItems();
    futureCourseData = fetchCourseDetail();
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  fetchCourseFormItems() async {
    setState(() {
      isLoading = true;
    });
    var authToken = await SharedPreferenceHelper().getAuthToken();
    var url =
        "$BASE_URL/api_instructor/edit_course_form?course_id=${widget.courseId}&auth_token=$authToken";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var item = json.decode(response.body)['categories'];
      var items = json.decode(response.body)['languages'];
      //print(items);
      setState(() {
        data = item;
        data3 = items;
        isLoading = false;
      });
    } else {
      setState(() {
        data = [];
        data3 = [];
        isLoading = false;
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
      contentPadding: const EdgeInsets.symmetric(vertical: 17),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(),
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: FutureBuilder<CourseModel>(
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
                dataSnapshot.data!.courseOverviewProvider == null
                    ? provider = "Select provider"
                    : provider = dataSnapshot.data!.courseOverviewProvider
                        .toString()
                        .capitalize();
                thumbnailController.text =
                    dataSnapshot.data!.courseMediaImages!.courseThumbnail!;
                for (int i = 0;
                    i < dataSnapshot.data!.categories!.length;
                    i++) {
                  if (dataSnapshot.data!.subCategoryId ==
                      dataSnapshot.data!.categories![i].id) {
                    category = dataSnapshot.data!.categories![i].name;
                    dropDownValueOneID = dataSnapshot.data!.categories![i].id;
                  }
                }
                return Form(
                  key: globalFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Padding(
                        padding:
                            EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                        child: Text(
                          'Modify Course',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
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
                                    'Course Title',
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
                                  'Course Title',
                                  Icons.title,
                                ),
                                // controller: titleController,
                                keyboardType: TextInputType.text,
                                // ignore: missing_return
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Course title cannot be empty';
                                  }
                                  return null;
                                },
                                initialValue: dataSnapshot.data!.title,
                                onTap: () {
                                  FocusManager.instance.primaryFocus!.unfocus();
                                },

                                onChanged: (value) {
                                  setState(() => titleController.text = value);
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
                                    'Course detail content',
                                    style: TextStyle(
                                      color: kTextColor,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                              TextFormField(
                                maxLines: 4,
                                textAlignVertical: TextAlignVertical.bottom,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                                decoration: getInputDecoration(
                                  'Course detail content',
                                  Icons.info_outline,
                                ),
                                // controller: descriptionController,
                                // ignore: missing_return
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Course description cannot be empty';
                                  }
                                  return null;
                                },
                                initialValue:
                                    dataSnapshot.data!.description.toString(),
                                onTap: () {
                                  FocusManager.instance.primaryFocus!.unfocus();
                                },

                                onChanged: (value) {
                                  setState(
                                      () => descriptionController.text = value);
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
                                    'Course overview',
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
                                  'Course overview',
                                  Icons.info_outline,
                                ),
                                // controller: shortDesController,
                                // ignore: missing_return
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Course short description cannot be empty';
                                  }
                                  return null;
                                },
                                initialValue: dataSnapshot
                                    .data!.shortDescription
                                    .toString(),
                                onTap: () {
                                  FocusManager.instance.primaryFocus!.unfocus();
                                },

                                onChanged: (value) {
                                  setState(
                                      () => shortDesController.text = value);
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
                                    'Category',
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
                                      hint: Text(category,
                                          style: const TextStyle(
                                              color: Colors.black)),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      value: dropDownValueOne,
                                      onChanged: (newVal) {
                                        dropDownValueOne = newVal;
                                        dropDownValueOneID = newVal;
                                        setState(() {});
                                      },
                                      isExpanded: true,
                                      items: data.map((cd) {
                                        var val = cd['name'];
                                        var id = cd['id'];
                                        return DropdownMenuItem(
                                          value: id,
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
                                    'Course difficulty',
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
                                      hint: Text(
                                          dataSnapshot.data!.level!
                                              .capitalize(),
                                          style: const TextStyle(
                                              color: Colors.black)),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      value: dropDownValueTwo,
                                      onChanged: (newVal) {
                                        dropDownValueTwo = newVal;
                                        setState(() {});
                                      },
                                      isExpanded: true,
                                      items: _level.map((val) {
                                        level = val;
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

                              // const Padding(
                              //   padding: EdgeInsets.all(4.0),
                              //   child: Align(
                              //     alignment: Alignment.centerLeft,
                              //     child: Text(
                              //       'Language',
                              //       style: TextStyle(
                              //         color: kTextColor,
                              //         fontSize: 15,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              // Card(
                              //   elevation: 0,
                              //   child: DropdownButtonHideUnderline(
                              //     child: ButtonTheme(
                              //       alignedDropdown: true,
                              //       child: DropdownButton(
                              //         icon: const Icon(
                              //             Icons.keyboard_arrow_down,
                              //             color: Colors.black45),
                              //         iconSize: 32,
                              //         hint: Text(
                              //             dataSnapshot.data!.language
                              //                 .toString()
                              //                 .capitalize(),
                              //             style: const TextStyle(
                              //                 color: Colors.black)),
                              //         style: const TextStyle(
                              //             color: Colors.black,
                              //             fontWeight: FontWeight.bold),
                              //         value: dropDownValueThree,
                              //         onChanged: (value) {
                              //           setState(() {
                              //             dropDownValueThree = value;
                              //             setState(() {});
                              //           });
                              //         },
                              //         isExpanded: true,
                              //         items: data3.map((cd) {
                              //           var val =
                              //               cd['name'].toString().capitalize();
                              //           return DropdownMenuItem(
                              //             value: val,
                              //             child: Text(val),
                              //           );
                              //         }).toList(),
                              //       ),
                              //     ),
                              //   ),
                              // ),

                              // const SizedBox(
                              //   height: 5,
                              // ),

                              const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Course Overview Provider',
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
                                      hint: Text(provider,
                                          style: const TextStyle(
                                              color: Colors.black)),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      value: dropDownValueFour,
                                      onChanged: (newVal) {
                                        dropDownValueFour = newVal;
                                        setState(() {});
                                      },
                                      isExpanded: true,
                                      items: _videoType.map((val) {
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
                                    'Course Overview Url',
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
                                  'Url',
                                  Icons.info_outline,
                                ),
                                // controller: urlController,
                                // ignore: missing_return
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Course Url cannot be empty';
                                  }
                                  return null;
                                },
                                initialValue:
                                    dataSnapshot.data!.videoUrl.toString(),
                                onTap: () {
                                  FocusManager.instance.primaryFocus!.unfocus();
                                },

                                onChanged: (value) {
                                  setState(() => urlController.text = value);
                                },
                              ),

                              // const SizedBox(
                              //   height: 5,
                              // ),

                              // const Padding(
                              //   padding: EdgeInsets.all(4.0),
                              //   child: Align(
                              //     alignment: Alignment.centerLeft,
                              //     child: Text(
                              //       'Meta Keywords',
                              //       style: TextStyle(
                              //         color: kTextColor,
                              //         fontSize: 15,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              // TextFormField(
                              //   style: const TextStyle(
                              //       fontSize: 14, fontWeight: FontWeight.bold),
                              //   decoration: getInputDecoration(
                              //     'Meta Keywords',
                              //     Icons.add_comment_rounded,
                              //   ),
                              //   // controller: metaKeywordsController,
                              //   // ignore: missing_return
                              //   validator: (value) {
                              //     if (value!.isEmpty) {
                              //       return 'Course meta-keywords cannot be empty';
                              //     }
                              //     return null;
                              //   },
                              //   initialValue:
                              //       dataSnapshot.data!.metaKeywords.toString(),
                              //   onTap: () {
                              //     FocusManager.instance.primaryFocus!.unfocus();
                              //   },

                              //   onChanged: (value) {
                              //     setState(() =>
                              //         metaKeywordsController.text = value);
                              //   },
                              // ),

                              // const SizedBox(
                              //   height: 5,
                              // ),

                              // const Padding(
                              //   padding: EdgeInsets.all(4.0),
                              //   child: Align(
                              //     alignment: Alignment.centerLeft,
                              //     child: Text(
                              //       'Meta Description',
                              //       style: TextStyle(
                              //         color: kTextColor,
                              //         fontSize: 15,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              // TextFormField(
                              //   style: const TextStyle(
                              //       fontSize: 14, fontWeight: FontWeight.bold),
                              //   decoration: getInputDecoration(
                              //     'Meta Description',
                              //     Icons.info_outline,
                              //   ),
                              //   // controller: metaDesController,
                              //   // ignore: missing_return
                              //   validator: (value) {
                              //     if (value!.isEmpty) {
                              //       return 'Course meta-description cannot be empty';
                              //     }
                              //     return null;
                              //   },
                              //   initialValue: dataSnapshot.data!.metaDescription
                              //       .toString(),
                              //   onTap: () {
                              //     FocusManager.instance.primaryFocus!.unfocus();
                              //   },

                              //   onChanged: (value) {
                              //     setState(
                              //         () => metaDesController.text = value);
                              //   },
                              // ),

                              const SizedBox(
                                height: 5,
                              ),
                              // dataSnapshot.data.isTopCourse == '1'
                              //     ? checkedTwo = true
                              //     : checkedTwo = false;
                              if (dataSnapshot.data!.isTopCourse == '1')
                                Row(
                                  children: [
                                    Checkbox(
                                      onChanged: (value) {
                                        setState(() {
                                          checkedTwo = value!;
                                        });
                                      },
                                      value: checkedTwo,
                                    ),
                                    const Text(
                                      'Check if this is a top course',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),

                              // if (dataSnapshot.data!.isTopCourse == '0')
                              //   Row(
                              //     children: [
                              //       Checkbox(
                              //         onChanged: (value) {
                              //           setState(() {
                              //             checked = value!;
                              //           });
                              //         },
                              //         value: checked,
                              //       ),
                              //       const Text(
                              //         'Check if this is a top course',
                              //         style: TextStyle(color: Colors.black),
                              //       ),
                              //     ],
                              //   ),

                              const SizedBox(
                                height: 5,
                              ),

                              const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Course Image',
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
                                      showModalBottomSheet(
                                        context: context,
                                        builder: ((builder) =>
                                            bottomSheet(context)),
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(8.0),
                                            topRight: Radius.circular(8.0),
                                          ),
                                          child: _image == null
                                              ? Image.network(
                                                  dataSnapshot
                                                      .data!
                                                      .courseMediaImages!
                                                      .courseThumbnail
                                                      .toString(),
                                                  height: 150,
                                                  fit: BoxFit.fill,
                                                )
                                              : Image.file(_image!,
                                                  width: 350, height: 350),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 80),
                                          child: MaterialButton(
                                            elevation: 0.1,
                                            color: kGreenColor,
                                            onPressed: () {
                                              showModalBottomSheet(
                                                context: context,
                                                builder: ((builder) =>
                                                    bottomSheet(context)),
                                              );
                                            },
                                            splashColor: Colors.blueAccent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              side: const BorderSide(
                                                  color: kGreenColor),
                                            ),
                                            child: const Text("Add Thumbnail",
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

                              var title = titleController.text.toString();
                              if (title.isEmpty) {
                                title = dataSnapshot.data!.title!;
                              }
                              var description =
                                  descriptionController.text.toString();
                              if (description.isEmpty) {
                                description =
                                    dataSnapshot.data!.description.toString();
                              }
                              var shortDes = shortDesController.text.toString();
                              if (shortDes.isEmpty) {
                                shortDes = dataSnapshot.data!.shortDescription
                                    .toString();
                              }
                              var url = urlController.text.toString();
                              if (url.isEmpty) {
                                url = dataSnapshot.data!.videoUrl.toString();
                              }
                              // var metaKeyWords =
                              //     metaKeywordsController.text.toString();
                              // if (metaKeyWords.isEmpty) {
                              //   metaKeyWords =
                              //       dataSnapshot.data!.metaKeywords.toString();
                              // }
                              // var metaDes = metaDesController.text.toString();
                              // if (metaDes.isEmpty) {
                              //   metaDes = dataSnapshot.data!.metaDescription
                              //       .toString();
                              // }
                              dynamic category;
                              dynamic level;
                              dynamic language;
                              dynamic provider;
                              if (dropDownValueOne.toString() == 'null') {
                                category = dropDownValueOneID;
                              } else {
                                category = dropDownValueOne;
                              }
                              if (dropDownValueTwo.toString() == 'null') {
                                level = dataSnapshot.data!.level;
                              } else {
                                level = dropDownValueTwo;
                              }
                              // if (dropDownValueThree.toString() == 'null') {
                              //   language = dataSnapshot.data!.language;
                              // } else {
                              //   language = dropDownValueThree.toLowerCase();
                              // }
                              if (dropDownValueFour.toString() == 'null') {
                                provider = dataSnapshot
                                    .data!.courseOverviewProvider
                                    .toString();
                              } else {
                                if (dropDownValueFour == "Youtube") {
                                  provider = 'youtube';
                                } else if (dropDownValueFour == "Vimeo") {
                                  provider = 'vimeo';
                                } else {
                                  provider = 'html5';
                                }
                              }
                              if (dataSnapshot.data!.isTopCourse == '1') {
                                checkedTwo ? isTop = '1' : isTop = '0';
                              } else {
                                checked ? isTop = '1' : isTop = '0';
                              }

                              if (title.isNotEmpty &&
                                      description.isNotEmpty &&
                                      shortDes.isNotEmpty &&
                                      url.isNotEmpty
                                  // &&
                                  // metaKeyWords.isNotEmpty &&
                                  // metaDes.isNotEmpty
                                  ) {
                                Dialogs.showLoadingDialog(context);
                                await _uploadFile(
                                    widget.courseId,
                                    title,
                                    shortDes,
                                    description,
                                    // language,
                                    "English",
                                    category,
                                    level.toLowerCase(),
                                    provider,
                                    url,
                                    // metaKeyWords,
                                    // metaDes,
                                    isTop);

                                // ignore: use_build_context_synchronously
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CourseManagerScreen(),
                                  ),
                                );
                              }
                            },
                            color: kGreenColor,
                            textColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            splashColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              side: const BorderSide(color: kBlueColor),
                            ),
                            child: const Text(
                              'Update',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }

  Widget bottomSheet(BuildContext context) {
    return Container(
      height: 100,
      // width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          const Text(
            "Choose thumbnail photo",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(kGreenColor)),
                onPressed: () {
                  Navigator.of(context).pop();
                  takePhoto(ImageSource.camera);
                },
                icon:
                    const Icon(Icons.camera_alt_outlined, color: Colors.white),
                label: const Text(
                  "Camera",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(kGreenColor)),
                onPressed: () {
                  Navigator.of(context).pop();
                  takePhoto(ImageSource.gallery);
                },
                icon: const Icon(
                  Icons.image_outlined,
                  color: Colors.white,
                ),
                label: const Text(
                  "Gallery",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
    );
    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  Future<void> _uploadFile(
    String courseId,
    String title,
    String shortDes,
    String description,
    String language,
    String subCatId,
    String level,
    String provider,
    String url,
    String isTopCourse,
    // String metaKeyWords,
    // String metaDes,
  ) async {
    var authToken = await SharedPreferenceHelper().getAuthToken();
    try {
      if (_image != null) {
        String fileName = basename(_image!.path);
        print(fileName);
        print(_image!.path);
        FormData formData = FormData.fromMap({
          "auth_token": authToken,
          "course_id": widget.courseId,
          "title": title,
          "short_description": shortDes,
          "description": description,
          "language": "English",
          "sub_category_id": subCatId,
          "level": level,
          "course_overview_provider": provider,
          "course_overview_url": url,
          // "meta_keywords": metaKeyWords,
          // "meta_description": metaDes,
          "is_top_course": isTopCourse,
          'is_free_course': "1",
          "course_thumbnail":
              await MultipartFile.fromFile(_image!.path, filename: fileName),
        });

        await Dio()
            .post("$BASE_URL/api_instructor/update_course", data: formData);
      } else {
        FormData formData = FormData.fromMap({
          "auth_token": authToken,
          "course_id": widget.courseId,
          "title": title,
          "short_description": shortDes,
          "description": description,
          "language": language,
          "sub_category_id": subCatId,
          "level": level,
          "course_overview_provider": provider,
          "course_overview_url": url,
          "meta_keywords": null,
          "meta_description": null,
          "is_top_course": isTopCourse,
          'is_free_course': "1",
        });

        await Dio()
            .post("$BASE_URL/api_instructor/update_course", data: formData);
      }
    } catch (e) {
      rethrow;
    }
  }
}
