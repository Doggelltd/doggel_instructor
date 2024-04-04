// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:doggel_instructor/providers/shared_pref_helper.dart';
import 'package:doggel_instructor/screens/course_manager.dart';
import 'package:doggel_instructor/screens/course_update_screen.dart';
import 'package:doggel_instructor/screens/curriculum.dart';
import 'package:doggel_instructor/screens/outcomes.dart';
import 'package:doggel_instructor/screens/pricing_screen.dart';
import 'package:doggel_instructor/screens/requirements.dart';
import 'package:doggel_instructor/screens/zoom_live_class_screen.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'dialog.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class CoursesListItem extends StatelessWidget {
  final String id;
  final String title;
  final String image;
  final String enrollStudents;
  final String status;
  final bool addonStatus;

  CoursesListItem(
      {Key? key,
      required this.id,
      required this.title,
      required this.status,
      required this.addonStatus,
      required this.enrollStudents,
      required this.image})
      : super(key: key);

  dynamic iconColor;
  dynamic text;

  @override
  Widget build(BuildContext context) {
    if (status == 'active') {
      iconColor = kGreenColor;
      text = "A";
    } else if (status == 'pending') {
      iconColor = kRedColor;
      text = "P";
    } else {
      iconColor = kGreenColor;
      text = "D";
    }
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ManageLessons(title: title, id: id);
        }));
      },
      child: Card(
        // ignore: prefer_const_constructors
        color: Color.fromARGB(255, 240, 247, 239),
        elevation: 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * .18,
                  child: Image.network(
                    image,
                    fit: BoxFit.cover,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                title,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Students",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                  ),
                  Text(
                    enrollStudents.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 13),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 65,
                  width: 40,
                  child: Card(
                    color: iconColor,
                    child: Center(
                      child: Text(text,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                Text(
                  status.toUpperCase(),
                  style:
                      TextStyle(color: iconColor, fontWeight: FontWeight.w600),
                ),
                PopupMenuButton(
                    onSelected: (value) {
                      if (value == 'managelesson') {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ManageLessons(title: title, id: id);
                        }));
                      } else if (value == 'zmLiveClass') {
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) {
                        //   return ZoomLiveClassScreen(courseId: id);
                        // }));
                      } else if (value == 'editCourse') {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return CourseUpdateScreen(courseId: id);
                        }));
                      } else if (value == 'requirements') {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Requirements(courseId: id);
                        }));
                      } else if (value == 'outcomes') {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Outcomes(courseId: id);
                        }));
                      } else if (value == 'remove') {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _buildPopupRemove(context));
                      }
                      //  else if (value == 'price') {
                      //   Navigator.push(context,
                      //       MaterialPageRoute(builder: (context) {
                      //     return PricingScreen(courseId: id);
                      //   }));
                      // }
                      else if (value == 'draft' ||
                          value == 'active' ||
                          value == 'pending') {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _buildPopupStatus(context, value));
                      }
                      // else {
                      //   Share.share(myLoadedCourse.shareableLink);
                      // }
                    },
                    icon: const Icon(
                      Icons.more_vert,
                      color: kIconColor,
                    ),
                    itemBuilder: (_) => [
                          const PopupMenuItem(
                            value: 'managelesson',
                            child: Text('ManageLessons'),
                          ),
                          if (addonStatus == true)
                            const PopupMenuItem(
                              value: 'zmLiveClass',
                              child: Text('Zoom Live Class'),
                            ),
                          const PopupMenuItem(
                            value: 'editCourse',
                            child: Text('Edit Course'),
                          ),
                          const PopupMenuItem(
                            value: 'requirements',
                            child: Text('Requirements'),
                          ),
                          const PopupMenuItem(
                            value: 'outcomes',
                            child: Text('Outcomes'),
                          ),
                          // const PopupMenuItem(
                          //   value: 'price',
                          //   child: Text('Pricing'),
                          // ),
                          if (status == 'active')
                            const PopupMenuItem(
                              value: 'draft',
                              child: Text('Mark As Drafted'),
                            ),
                          if (status == 'draft')
                            const PopupMenuItem(
                              value: 'active',
                              child: Text('Publish this course'),
                            ),
                          if (status == 'pending')
                            const PopupMenuItem(
                              value: 'draft',
                              child: Text('Mark As Drafted'),
                            ),
                          const PopupMenuItem(
                            value: 'remove',
                            child: Text('Delete Course'),
                          ),
                        ]),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildPopupRemove(BuildContext context) {
    return AlertDialog(
      title: const Text("Warning!"),
      titleTextStyle: const TextStyle(color: Colors.red, fontSize: 20),
      content: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Do you want to remove it?"),
        ],
      ),
      actions: <Widget>[
        MaterialButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text(
            'No',
            style: TextStyle(color: Colors.red),
          ),
        ),
        MaterialButton(
          onPressed: () async {
            Dialogs.showLoadingDialog(context);
            final authToken = await SharedPreferenceHelper().getAuthToken();
            var url =
                "$BASE_URL/api_instructor/delete_course?course_id=$id&auth_token=$authToken";
            try {
              final response = await http.get(Uri.parse(url));
              final extractedData = json.decode(response.body);
              if (extractedData == null) {
                return;
              }
            } catch (error) {
              rethrow;
            }
            Navigator.of(context).pop();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return CourseManagerScreen();
            }));
          },
          child: const Text(
            "Yes",
            style: TextStyle(color: Colors.green),
          ),
        ),
      ],
    );
  }

  _buildPopupStatus(BuildContext context, value) {
    return AlertDialog(
      title: const Text("Heads Up!"),
      titleTextStyle: const TextStyle(color: Colors.red, fontSize: 20),
      content: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Are you sure?"),
        ],
      ),
      actions: <Widget>[
        MaterialButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.red),
          ),
        ),
        MaterialButton(
          onPressed: () async {
            Dialogs.showLoadingDialog(context);
            final authToken = await SharedPreferenceHelper().getAuthToken();
            var url =
                "$BASE_URL/api_instructor/update_course_status?course_id=$id&status=$value&auth_token=$authToken";
            try {
              final response = await http.get(Uri.parse(url));
              final extractedData = json.decode(response.body);
              if (extractedData == null) {
                return;
              }
            } catch (error) {
              rethrow;
            }
            Navigator.of(context).pop();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return CourseManagerScreen();
            }));
          },
          child: const Text(
            "Continue",
            style: TextStyle(color: Colors.green),
          ),
        ),
      ],
    );
  }
}
