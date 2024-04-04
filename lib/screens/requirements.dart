// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:doggel_instructor/constants.dart';
import 'package:doggel_instructor/models/update_user_model.dart';
import 'package:doggel_instructor/providers/repository.dart';
import 'package:doggel_instructor/providers/shared_pref_helper.dart';
import 'package:doggel_instructor/screens/course_manager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Requirements extends StatefulWidget {
  final String courseId;

  const Requirements({Key? key, required this.courseId}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _RequirementsState createState() => _RequirementsState();
}

// ignore: non_constant_identifier_names
Future<UpdateUserModel?> UpdateRequirements(
    String token, String courseId, List requirements) async {
  const String apiUrl = "$BASE_URL/api_instructor/update_course_requirements";

  // final removedBrackets = requirements.substring(1, requirements.length - 1);
  // final parts = removedBrackets.split(', ');
  //
  List joined = requirements.map((part) => '"$part"').toList();

  final response = await http.post(Uri.parse(apiUrl), body: {
    'auth_token': token,
    'course_id': courseId,
    'requirements': joined.toString(),
  });

  if (response.statusCode == 201) {
    final String responseString = response.body;

    return updateUserModelFromJson(responseString);
  } else {
    return null;
  }
}

class _RequirementsState extends State<Requirements> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _requirementsController;

  // ignore: prefer_final_fields
  static List<dynamic> _requirementList = [];
  List<String> requirements = [];
  bool _isInitial = true;
  // ignore: unused_field
  bool _showLoadingContainer = false;

  dynamic _authToken;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchRequirements();
    _requirementList.clear();
    _requirementsController = TextEditingController();
  }

  @override
  void dispose() {
    _requirementsController.dispose();
    super.dispose();
  }

  fetchRequirements() async {
    _authToken = await SharedPreferenceHelper().getAuthToken();
    var serverResponse = await Repository()
        .fetchRequirements(courseId: widget.courseId, token: _authToken);
    // _requirementList.clear();
    _requirementList.addAll(serverResponse.requirements!);
    _isInitial = false;
    _showLoadingContainer = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: const Text("Requiremesnt"),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: buildRequirementList(),
          ),
        ),
      ),
    );
  }

  /// remove button
  Widget _removeButton(bool add, int index) {
    return InkWell(
      onTap: () {
        _requirementList.removeAt(index);
        setState(() {});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: kRedColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(
          Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }

  buildRequirementList() {
    if (_isInitial && _requirementList.isEmpty) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * .5,
        child: const Center(child: CircularProgressIndicator()),
      );
    } else if (_requirementList.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Requirements',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: _requirementList.length,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                      // controller: _requirementController,
                      initialValue: _requirementList[index],
                      onChanged: (v) => _requirementList[index] = v,
                      onSaved: (v) => _requirementList[index] = v,
                      decoration: const InputDecoration(
                          hintText: 'Provide requirements'),
                      validator: (v) {
                        if (v!.trim().isEmpty) return 'Please enter something';
                        return null;
                      },
                    )),
                    const SizedBox(
                      width: 16,
                    ),
                    // we need add button at last friends row
                    // _addRemoveButton(i == requirementsList.length-1, i),
                    _removeButton(false, index),
                  ],
                ),
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: MaterialButton(
                  elevation: 0.1,
                  onPressed: () async {
                    _requirementList.insert(_requirementList.length, '');
                    setState(() {});
                  },
                  splashColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: const BorderSide(color: kGreenColor),
                  ),
                  color: kGreenColor,
                  child: const Text(
                    '+Add',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(),
              ),
              Expanded(
                flex: 1,
                child: MaterialButton(
                  elevation: 0.1,
                  onPressed: () async {
                    _authToken = await SharedPreferenceHelper().getAuthToken();
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    for (int i = 0; i < _requirementList.length; i++) {
                      requirements.insert(i, _requirementList[i]);
                    }
                    // List joined = requirements.map((part) => "'$part'").toList();
                    // print(joined);
                    // Dialogs.showLoadingDialog(context);

                    // ignore: unused_local_variable
                    final UpdateUserModel? user = await UpdateRequirements(
                        _authToken, widget.courseId, requirements);
                    requirements.removeRange(0, requirements.length - 1);
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return CourseManagerScreen();
                    }));
                  },
                  splashColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: const BorderSide(color: kGreenColor),
                  ),
                  color: kGreenColor,
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return Center(
          child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: MaterialButton(
                  elevation: 0.1,
                  onPressed: () async {
                    _requirementList.insert(_requirementList.length, '');
                    setState(() {});
                  },
                  splashColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: const BorderSide(color: kGreenColor),
                  ),
                  color: kGreenColor,
                  child: const Text(
                    '+Add',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(),
              ),
              Expanded(
                flex: 1,
                child: MaterialButton(
                  elevation: 0.1,
                  onPressed: () async {
                    _authToken = await SharedPreferenceHelper().getAuthToken();
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    for (int i = 0; i < _requirementList.length; i++) {
                      requirements.insert(i, _requirementList[i]);
                    }
                    // List joined = requirements.map((part) => "'$part'").toList();
                    // print(joined);
                    // Dialogs.showLoadingDialog(context);

                    // ignore: unused_local_variable
                    final UpdateUserModel? user = await UpdateRequirements(
                        _authToken, widget.courseId, requirements);
                    requirements.removeRange(0, requirements.length - 1);
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return CourseManagerScreen();
                    }));
                  },
                  splashColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: const BorderSide(color: kGreenColor),
                  ),
                  color: kGreenColor,
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      )); // should never be happening
    }
  }
}

class RequirementTextFields extends StatefulWidget {
  final int index;
  const RequirementTextFields(this.index, {Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _RequirementTextFieldsState createState() => _RequirementTextFieldsState();
}

class _RequirementTextFieldsState extends State<RequirementTextFields> {
  late TextEditingController _requirementController;

  @override
  void initState() {
    super.initState();
    _requirementController = TextEditingController();
  }

  @override
  void dispose() {
    _requirementController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _requirementController.text =
          _RequirementsState._requirementList[widget.index] ?? '';
    });

    return TextFormField(
      controller: _requirementController,
      onChanged: (v) => _RequirementsState._requirementList[widget.index] = v,
      onSaved: (v) => _RequirementsState._requirementList[widget.index] = v,
      decoration: const InputDecoration(hintText: 'Provide requirements'),
      validator: (v) {
        if (v!.trim().isEmpty) return 'Please enter something';
        return null;
      },
    );
  }
}
