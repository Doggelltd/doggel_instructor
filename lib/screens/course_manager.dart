import 'dart:convert';
import 'package:doggel_instructor/models/common_functions.dart';
import 'package:doggel_instructor/models/courses.dart';
import 'package:doggel_instructor/providers/auth.dart';
import 'package:doggel_instructor/providers/fetch_data.dart';
import 'package:doggel_instructor/widgets/courses_list_item.dart';
import 'package:doggel_instructor/widgets/custom_app_bar.dart';
import 'package:doggel_instructor/widgets/nav_drawer.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class CourseManagerScreen extends StatefulWidget {
  static const routeName = '/coursemanager';
  String? checkStatus;
  CourseManagerScreen({Key? key, this.checkStatus}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CourseManagerScreenState createState() => _CourseManagerScreenState();
}

class _CourseManagerScreenState extends State<CourseManagerScreen> {
  var _isInit = true;
  var _isLoading = false;
  List<Courses> myCourses = [];
  dynamic liveClassStatus = false;
  dynamic user;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<FetchData>(context).fetchCourses().then((_) {
        setState(() {
          myCourses = Provider.of<FetchData>(context, listen: false).myCourses;
          _isLoading = false;
        });
      });
      Provider.of<Auth>(context).getUserInfo().then((_) {
        setState(() {
          user = Provider.of<Auth>(context, listen: false).user;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> addonStatus() async {
    var url =
        '$BASE_URL/api_instructor/addon_status?unique_identifier=live-class';
    final response = await http.get(Uri.parse(url));
    setState(() {
      liveClassStatus = json.decode(response.body)['status'];
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    addonStatus();
  }

  Future<void> refreshList() async {
    try {
      setState(() {
        _isLoading = true;
      });

      Provider.of<FetchData>(context, listen: false).fetchCourses().then((_) {
        setState(() {
          myCourses = Provider.of<FetchData>(context, listen: false).myCourses;
          _isLoading = false;
        });
      });

      Provider.of<Auth>(context, listen: false).getUserInfo().then((_) {
        setState(() {
          user = Provider.of<Auth>(context, listen: false).user;
        });
      });
    } catch (error) {
      const errorMsg = 'Could not refresh!';
      CommonFunctions.showErrorDialog(errorMsg, context);
    }

    return;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.white,
      // drawer: NavDrawer(
      //   checkStatus: widget.checkStatus.toString(),
      // ),
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
          : RefreshIndicator(
              onRefresh: refreshList,
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                            child: Text(
                              "Total ${myCourses.length} Lessons",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: myCourses.length,
                              itemBuilder: (ctx, index) {
                                var unescape = HtmlUnescape();
                                var title = unescape
                                    .convert(myCourses[index].title.toString());
                                return CoursesListItem(
                                    image: myCourses[index].image.toString(),
                                    enrollStudents: myCourses[index]
                                        .enrollStudents
                                        .toString(),
                                    id: myCourses[index].id.toString(),
                                    title: title,
                                    status: myCourses[index].status.toString(),
                                    addonStatus: liveClassStatus);
                              },
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: MediaQuery.of(context)
                                        .size
                                        .width /
                                    (MediaQuery.of(context).size.height / 1.25),
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
