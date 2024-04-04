// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:doggel_instructor/constants.dart';
import 'package:doggel_instructor/models/update_user_model.dart';
import 'package:doggel_instructor/providers/repository.dart';
import 'package:doggel_instructor/providers/shared_pref_helper.dart';
import 'package:doggel_instructor/screens/course_manager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Outcomes extends StatefulWidget {
  final String courseId;

  const Outcomes({Key? key, required this.courseId}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _OutcomesState createState() => _OutcomesState();
}

// ignore: non_constant_identifier_names
Future<UpdateUserModel?> UpdateOutcomes(
    String token, String courseId, List outcomes) async {
  const String apiUrl = "$BASE_URL/api_instructor/update_course_outcomes";

  List joined = outcomes.map((part) => '"$part"').toList();

  final response = await http.post(Uri.parse(apiUrl), body: {
    'auth_token': token,
    'course_id': courseId,
    'outcomes': joined.toString(),
  });

  if (response.statusCode == 201) {
    final String responseString = response.body;
    return updateUserModelFromJson(responseString);
  } else {
    return null;
  }
}

class _OutcomesState extends State<Outcomes> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _outcomesController;
  // ignore: prefer_final_fields
  static List<dynamic> _outcomeList = [];
  List<String> outcomes = [];
  bool _isInitial = true;
  // ignore: unused_field
  bool _showLoadingContainer = false;

  dynamic _authToken;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchOutcomes();
    _outcomeList.clear();
    _outcomesController = TextEditingController();
  }

  @override
  void dispose() {
    _outcomesController.dispose();
    super.dispose();
  }

  fetchOutcomes() async {
    _authToken = await SharedPreferenceHelper().getAuthToken();
    if (_authToken == null) {
      setState(() {
        _authToken = '';
      });
    }
    var serverResponse = await Repository()
        .fetchOutcomes(courseId: widget.courseId, token: _authToken);
    _outcomeList.addAll(serverResponse.outcomes!);
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
        title: const Text("Outcomes"),
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
            child: buildOutcomeList(),
          ),
        ),
      ),
    );
  }

  /// remove button
  Widget _removeButton(bool add, int index) {
    return InkWell(
      onTap: () {
        _outcomeList.removeAt(index);
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

  buildOutcomeList() {
    if (_isInitial && _outcomeList.isEmpty) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * .5,
        child: const Center(child: CircularProgressIndicator()),
      );
    } else if (_outcomeList.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Outcomes',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: _outcomeList.length,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                      initialValue: _outcomeList[index],
                      onChanged: (v) => _outcomeList[index] = v,
                      onSaved: (v) => _outcomeList[index] = v,
                      decoration:
                          const InputDecoration(hintText: 'Provide outcomes'),
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
                    _outcomeList.insert(_outcomeList.length, '');
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
                    for (int i = 0; i < _outcomeList.length; i++) {
                      outcomes.insert(i, _outcomeList[i]);
                    }

                    // ignore: unused_local_variable
                    final UpdateUserModel? user = await UpdateOutcomes(
                        _authToken, widget.courseId, outcomes);
                    outcomes.removeRange(0, outcomes.length - 1);
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
                    _outcomeList.insert(_outcomeList.length, '');
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
                    for (int i = 0; i < _outcomeList.length; i++) {
                      outcomes.insert(i, _outcomeList[i]);
                    }

                    // ignore: unused_local_variable
                    final UpdateUserModel? user = await UpdateOutcomes(
                        _authToken, widget.courseId, outcomes);
                    outcomes.removeRange(0, outcomes.length - 1);
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

class OutcomeTextFields extends StatefulWidget {
  final int index;
  const OutcomeTextFields(this.index, {Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _OutcomeTextFieldsState createState() => _OutcomeTextFieldsState();
}

class _OutcomeTextFieldsState extends State<OutcomeTextFields> {
  late TextEditingController _outcomeController;

  @override
  void initState() {
    super.initState();
    _outcomeController = TextEditingController();
  }

  @override
  void dispose() {
    _outcomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _outcomeController.text = _OutcomesState._outcomeList[widget.index] ?? '';
    });

    return TextFormField(
      controller: _outcomeController,
      onChanged: (v) => _OutcomesState._outcomeList[widget.index] = v,
      onSaved: (v) => _OutcomesState._outcomeList[widget.index] = v,
      decoration: const InputDecoration(hintText: 'Provide outcomes'),
      validator: (v) {
        if (v!.trim().isEmpty) return 'Please enter something';
        return null;
      },
    );
  }
}
