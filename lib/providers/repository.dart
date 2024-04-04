import 'dart:convert';
import 'package:doggel_instructor/constants.dart';
import 'package:doggel_instructor/models/outcomes_model.dart';
import 'package:doggel_instructor/models/requirements_model.dart';
import 'package:http/http.dart' as http;

class Repository {
  Future<RequirementsModel> fetchRequirements(
      {required String courseId, String? token}) async {
    final response = await http.get(Uri.parse(
        "$BASE_URL/api_instructor/edit_course_requirements?course_id=$courseId&auth_token=$token"));
    return RequirementsModel.fromJson(jsonDecode(response.body));
  }

  Future<OutcomesModel> fetchOutcomes(
      {required String courseId, String? token}) async {
    final response = await http.get(Uri.parse(
        "$BASE_URL/api_instructor/edit_course_outcomes?course_id=$courseId&auth_token=$token"));
    return OutcomesModel.fromJson(jsonDecode(response.body));
  }
}
