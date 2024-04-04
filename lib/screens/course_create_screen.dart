// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:doggel_instructor/models/categories.dart';
import 'package:doggel_instructor/models/languages.dart';
import 'package:doggel_instructor/models/update_user_model.dart';
import 'package:doggel_instructor/providers/fetch_data.dart';
import 'package:doggel_instructor/providers/shared_pref_helper.dart';
import 'package:doggel_instructor/screens/tabs_screen.dart';
import 'package:doggel_instructor/widgets/custom_app_bar.dart';
import 'package:doggel_instructor/widgets/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'course_manager.dart';

class CourseCreateScreen extends StatefulWidget {
  String? checkStatus;
  CourseCreateScreen({this.checkStatus});

  @override
  // ignore: library_private_types_in_public_api
  _CourseCreateScreenState createState() => _CourseCreateScreenState();
}

// ignore: non_constant_identifier_names
Future<UpdateUserModel?> CreateCourse(
    String token,
    String title,
    String language,
    String id,
    String price,
    String discountFlag,
    String discountedPrice,
    String level,
    String isFreeCourse,
    String isTopCourse) async {
  const String apiUrl = "$BASE_URL/api_instructor/add_course";

  log("");
  final response = await http.post(Uri.parse(apiUrl), body: {
    'auth_token': token,
    'title': title,
    'language': language,
    'sub_category_id': id,
    'price': price,
    'discount_flag': discountFlag,
    'discounted_price': discountedPrice,
    'level': level,
    // 'is_free_course': isFreeCourse,
    'is_free_course': "1",
    'is_top_course': isTopCourse,
  });
  log(response.body);

  if (response.statusCode == 201) {
    final String responseString = response.body;

    return updateUserModelFromJson(responseString);
  } else {
    return null;
  }
}

class _CourseCreateScreenState extends State<CourseCreateScreen> {
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  var _isInit = true;
  List<Categories> categories = [];
  List<Languages> languages = [];

  final _textControllerOne = TextEditingController();
  final _textControllerTwo = TextEditingController();
  final _textControllerThree = TextEditingController();

  dynamic dropDownValueOne;
  dynamic dropDownValueOneID;
  dynamic dropDownValueTwo;
  dynamic dropDownValueThree;
  dynamic disFlag;
  dynamic disPrice;
  dynamic isFree = '1';
  dynamic isTop;
  dynamic _authToken;

  bool checkedTop = false;
  bool checked = false;
  bool checkedDis = false;

  final List<String> _level = <String>['Beginner', 'Advanced', 'Intermediate'];

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<FetchData>(context).fetchCourseFormItems().then((_) {
        setState(() {
          categories =
              Provider.of<FetchData>(context, listen: false).categories;
          languages = Provider.of<FetchData>(context, listen: false).languages;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  InputDecoration getInputDecoration(String hintext, IconData iconData) {
    return InputDecoration(
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        borderSide: BorderSide(
          color: Color(0xff858597),
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        borderSide: BorderSide(
          color: Color(0xff858597),
        ),
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
      hintStyle: const TextStyle(
        color: Color(0xff858597),
      ),
      hintText: hintext,
      fillColor: Colors.white,
      prefixIcon: Icon(
        iconData,
        color: const Color(0xff858597),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 17),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      // appBar: CustomAppBar(),
      backgroundColor: kBackgroundColor,
      body: widget.checkStatus == "0"
          ? Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/verify.png",
                    height: 300,
                    width: 300,
                  ),
                  const Column(
                    children: [
                      Text(
                        "We are currently reviewing your profile.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: kBlueColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Text(
                          "Please allow some time for approval. If you have any questions, please contact our support team",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: kBlueColor),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Form(
                key: globalFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/logo.png',
                        height: 45,
                      ),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Text(
                        'Create New Lesson',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Lesson Title',
                                  style: TextStyle(
                                    color: Color(0xff858597),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            TextFormField(
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                              decoration: getInputDecoration(
                                'Lesson Title',
                                Icons.title,
                              ),
                              controller: _textControllerOne,
                              // ignore: missing_return
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Course title cannot be empty';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _textControllerOne.text = value!;
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
                                    color: Color(0xff858597),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            Card(
                                elevation: 0,
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.all(5),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)))),
                                  child: DropdownButtonHideUnderline(
                                    child: ButtonTheme(
                                      alignedDropdown: true,
                                      child: DropdownButton(
                                        icon: const Icon(
                                            Icons.keyboard_arrow_down,
                                            color: Colors.black45),
                                        iconSize: 32,
                                        hint: const Text("Select",
                                            style: TextStyle(
                                                color: Color(0xff1F1F39),
                                                fontSize: 14)),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400),
                                        value: dropDownValueOne,
                                        onChanged: (newVal) {
                                          dropDownValueOne = newVal;
                                          dropDownValueOneID = newVal;
                                          // print(dropDownValueOne);
                                          setState(() {});
                                        },
                                        isExpanded: true,
                                        items: categories.map((cd) {
                                          var unescape = HtmlUnescape();
                                          var val = unescape.convert(cd.name!);
                                          var id = cd.id;
                                          return DropdownMenuItem(
                                            value: id,
                                            child: Text(val),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                )),
                            const SizedBox(
                              height: 5,
                            ),
                            const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Strength',
                                  style: TextStyle(
                                    color: Color(0xff858597),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            Card(
                                elevation: 0,
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.all(5),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)))),
                                  child: DropdownButtonHideUnderline(
                                    child: ButtonTheme(
                                      alignedDropdown: true,
                                      child: DropdownButton(
                                        icon: const Icon(
                                            Icons.keyboard_arrow_down,
                                            color: Colors.black45),
                                        iconSize: 32,
                                        hint: const Text("Select Level",
                                            style: TextStyle(
                                                color: Color(0xff1F1F39))),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400),
                                        value: dropDownValueTwo,
                                        onChanged: (newVal) {
                                          dropDownValueTwo = newVal;
                                          setState(() {});
                                        },
                                        isExpanded: true,
                                        items: _level.map((val) {
                                          return DropdownMenuItem(
                                            value: val,
                                            child: Text(val),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                )),
                            const SizedBox(
                              height: 5,
                            ),
                            const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Language',
                                  style: TextStyle(
                                    color: Color(0xff858597),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            Card(
                                elevation: 0,
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.all(5),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)))),
                                  child: DropdownButtonHideUnderline(
                                    child: ButtonTheme(
                                      alignedDropdown: true,
                                      child: DropdownButton(
                                        icon: const Icon(
                                            Icons.keyboard_arrow_down,
                                            color: Colors.black45),
                                        iconSize: 32,
                                        hint: const Text('Select Language',
                                            style: TextStyle(
                                                color: Color(0xff1F1F39))),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400),
                                        value: dropDownValueThree,
                                        onChanged: (value) {
                                          setState(() {
                                            dropDownValueThree = value;
                                            setState(() {});
                                            // print(dropDownValueThree);
                                          });
                                        },
                                        isExpanded: true,
                                        items: languages.map((cd) {
                                          var val =
                                              cd.name.toString().capitalize();
                                          return DropdownMenuItem(
                                            value: val,
                                            child: Text(val),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                )),
                            const SizedBox(
                              height: 5,
                            ),
                            // InkWell(
                            //   onTap: () {
                            //     setState(() {
                            //       checkedTop = !checkedTop;
                            //     });
                            //   },
                            //   child: Row(
                            //     children: [
                            //       Checkbox(
                            //         onChanged: (value) {
                            //           setState(() {
                            //             checkedTop = value!;
                            //           });
                            //         },
                            //         value: checkedTop,
                            //       ),
                            //       const Text(
                            //         'Check if this is a top course',
                            //         style: TextStyle(color: Colors.black45),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            const SizedBox(
                              height: 5,
                            ),
                            // InkWell(
                            //   onTap: () {
                            //     setState(() {
                            //       checked = !checked;
                            //     });
                            //   },
                            //   child: Row(
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
                            //         'Check if this is a free course',
                            //         style: TextStyle(color: Colors.black45),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // checked
                            //     ? Container()
                            //     : Column(
                            //         children: [
                            //           const Padding(
                            //             padding: EdgeInsets.all(4.0),
                            //             child: Align(
                            //               alignment: Alignment.centerLeft,
                            //               child: Text(
                            //                 'Course Price',
                            //                 style: TextStyle(
                            //                   color: kTextColor,
                            //                   fontSize: 15,
                            //                 ),
                            //               ),
                            //             ),
                            //           ),
                            //           TextFormField(
                            //             style: const TextStyle(
                            //                 fontSize: 14,
                            //                 fontWeight: FontWeight.bold),
                            //             decoration: getInputDecoration(
                            //               'Course Price',
                            //               Icons.monetization_on_outlined,
                            //             ),
                            //             controller: _textControllerTwo,
                            //             // ignore: missing_return
                            //             validator: (value) {
                            //               if (value!.isEmpty) {
                            //                 return 'Course price cannot be empty or select course as free';
                            //               }
                            //               return null;
                            //             },
                            //             onSaved: (value) {
                            //               _textControllerTwo.text = value!;
                            //             },
                            //           ),
                            //           const SizedBox(
                            //             height: 5,
                            //           ),
                            //           Row(
                            //             children: [
                            //               Checkbox(
                            //                 onChanged: (value) {
                            //                   setState(() {
                            //                     checkedDis = value!;
                            //                   });
                            //                 },
                            //                 value: checkedDis,
                            //               ),
                            //               const Text(
                            //                 'Check if this course has discount',
                            //                 style: TextStyle(color: Colors.black45),
                            //               ),
                            //             ],
                            //           ),
                            //           checkedDis
                            //               ? Column(
                            //                   children: [
                            //                     const Padding(
                            //                       padding: EdgeInsets.all(4.0),
                            //                       child: Align(
                            //                         alignment: Alignment.centerLeft,
                            //                         child: Text(
                            //                           'Discounted Price',
                            //                           style: TextStyle(
                            //                             color: kTextColor,
                            //                             fontSize: 15,
                            //                           ),
                            //                         ),
                            //                       ),
                            //                     ),
                            //                     Padding(
                            //                       padding: const EdgeInsets.only(
                            //                           bottom: 8.0),
                            //                       child: TextFormField(
                            //                         style: const TextStyle(
                            //                             fontSize: 14,
                            //                             fontWeight: FontWeight.bold),
                            //                         decoration: getInputDecoration(
                            //                           'Course Discount(%)',
                            //                           Icons.monetization_on_outlined,
                            //                         ),
                            //                         controller: _textControllerThree,
                            //                         // ignore: missing_return
                            //                         validator: (value) {
                            //                           if (value!.isEmpty) {
                            //                             return 'Course discount price cannot be empty';
                            //                           }
                            //                           return null;
                            //                         },
                            //                         onSaved: (value) {
                            //                           _textControllerThree.text =
                            //                               value!;
                            //                         },
                            //                       ),
                            //                     ),
                            //                   ],
                            //                 )
                            //               : Container(),
                            //    ],
                            //    ),
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
                            if (checkedTop) {
                              isTop = '1';
                            } else {
                              isTop = '0';
                            }
                            _authToken =
                                await SharedPreferenceHelper().getAuthToken();
                            final String title =
                                _textControllerOne.text.toString();

                            // if (checked) {
                            _textControllerTwo.text = '0';
                            disFlag = '0';
                            disPrice = '0';
                            isFree = '1';
                            final String price =
                                _textControllerTwo.text.toString();
                            if (_authToken.isNotEmpty &&
                                title.isNotEmpty &&
                                dropDownValueOneID.isNotEmpty &&
                                dropDownValueTwo.isNotEmpty &&
                                dropDownValueThree.isNotEmpty) {
                              // ignore: unused_local_variable
                              final UpdateUserModel? user = await CreateCourse(
                                  _authToken,
                                  title,
                                  dropDownValueThree.toLowerCase(),
                                  dropDownValueOneID,
                                  price,
                                  disFlag,
                                  disPrice,
                                  dropDownValueTwo.toLowerCase(),
                                  isFree,
                                  isTop);

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TabsScreen(
                                          index: 0,
                                        )),
                              );
                            }
                            // } else {
                            //   final String price = _textControllerTwo.text.toString();
                            //   String disPrice = _textControllerThree.text.toString();
                            //   if (checkedDis) {
                            //     setState(() {
                            //       disFlag = '1';
                            //       isFree = '0';
                            //     });
                            //   } else {
                            //     setState(() {
                            //       disFlag = '0';
                            //       disPrice = '0';
                            //       isFree = '0';
                            //     });
                            //   }
                            //   if (_authToken.isNotEmpty &&
                            //       title.isNotEmpty &&
                            //       dropDownValueOneID.isNotEmpty &&
                            //       dropDownValueTwo.isNotEmpty &&
                            //       dropDownValueThree.isNotEmpty &&
                            //       price.isNotEmpty) {
                            //     // ignore: unused_local_variable
                            //     final UpdateUserModel? user = await CreateCourse(
                            //         _authToken,
                            //         title,
                            //         dropDownValueThree.toLowerCase(),
                            //         dropDownValueOneID,
                            //         price,
                            //         disFlag,
                            //         disPrice,
                            //         dropDownValueTwo.toLowerCase(),
                            //         isFree,
                            //         isTop);

                            //     Navigator.pushReplacement(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (context) =>
                            //               const CourseManagerScreen()),
                            //     );
                            //   }
                            // }
                          },
                          height: 50,
                          color: kGreenColor,
                          textColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 12),
                          splashColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side: const BorderSide(color: kGreenColor),
                          ),
                          child: const Text(
                            'Create Lesson',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
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
