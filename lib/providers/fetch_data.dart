import 'dart:convert';
import 'dart:developer';
import 'package:doggel_instructor/constants.dart';
import 'package:doggel_instructor/models/categories.dart';
import 'package:doggel_instructor/models/course_pricing.dart';
import 'package:doggel_instructor/models/courses.dart';
import 'package:doggel_instructor/models/languages.dart';
import 'package:doggel_instructor/models/live_class.dart';
import 'package:doggel_instructor/models/sales_report.dart';
import 'package:doggel_instructor/models/zoom_settings.dart';
import 'package:flutter/cupertino.dart';
import 'shared_pref_helper.dart';
import 'package:http/http.dart' as http;

class FetchData with ChangeNotifier {
  List<Courses> _myCourses = [];
  List<Categories> _categories = [];
  List<Languages> _languages = [];
  List<SalesReport> _salesReport = [];
  late CoursePricing _pricing;
  late LiveClass _liveClass;
  late ZoomSettings _zoomSettings;
  String profileStatus = '';
  List<Courses> get myCourses {
    return [..._myCourses];
  }

  List<Categories> get categories {
    return [..._categories];
  }

  List<Languages> get languages {
    return [..._languages];
  }

  List<SalesReport> get salesReport {
    return [..._salesReport];
  }

  CoursePricing get pricing {
    return _pricing;
  }

  LiveClass get liveClass {
    return _liveClass;
  }

  ZoomSettings get zoomSettings {
    return _zoomSettings;
  }

  Future<void> fetchCourses() async {
    final authToken = await SharedPreferenceHelper().getAuthToken();
    var url = "$BASE_URL/api_instructor/courses?auth_token=$authToken";
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body)['courses'] as List;
      log(response.body.toString());
      final List<Courses> loadedDetails = [];

      // extractedData.forEach((catData) {});

      for (var catData in extractedData) {
        loadedDetails.add(Courses(
          id: catData['id'],
          title: catData['title'],
          userId: catData['user_id'],
          status: catData['status'],
          image: catData["course_thumbnail"],
          enrollStudents: catData["enrolled_students"],
        ));
      }
      _myCourses = loadedDetails;

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchInstructorStatus() async {
    final authToken = await SharedPreferenceHelper().getAuthToken();
    var url =
        "$BASE_URL/api_instructor/get_instructor_application_status?auth_token=$authToken";
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body);
      log(response.body.toString());
      profileStatus = extractedData["status"];
      print(profileStatus);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchCourseFormItems() async {
    var url = "$BASE_URL/api_instructor/add_course_form";
    try {
      var response = await http.get(Uri.parse(url));
      final extractedCategories =
          json.decode(response.body)['categories'] as List;

      if (extractedCategories.isEmpty) {
        return;
      }

      final List<Categories> loadedCategories = [];

      for (var catData in extractedCategories) {
        loadedCategories.add(Categories(
          id: catData['id'],
          name: catData['name'],
        ));
      }

      _categories = loadedCategories;

      notifyListeners();

      final extractedLanguages =
          json.decode(response.body)['languages'] as List;

      if (extractedLanguages.isEmpty) {
        return;
      }

      final List<Languages> loadedLanguages = [];

      for (var catData in extractedLanguages) {
        loadedLanguages.add(Languages(
          name: catData['name'],
        ));
      }

      _languages = loadedLanguages;

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchCoursePrice(String courseId) async {
    final authToken = await SharedPreferenceHelper().getAuthToken();
    var url =
        "$BASE_URL/api_instructor/course_pricing_form?course_id=$courseId&auth_token=$authToken";
    try {
      var response = await http.get(Uri.parse(url));
      final responseData = json.decode(response.body)['course_details'];

      final loadedPrice = CoursePricing(
        id: responseData['id'],
        price: responseData['price'],
        discountFlag: responseData['discount_flag'],
        discountedPrice: responseData['discounted_price'],
        isFreeCourse: responseData['is_free_course'],
        currency: responseData['currency'],
      );

      _pricing = loadedPrice;

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchSalesReport(String start, String end) async {
    final authToken = await SharedPreferenceHelper().getAuthToken();
    final url =
        "$BASE_URL/api_instructor/sales_report?auth_token=$authToken&date_range=${start}_$end";
    try {
      final response = await http.get(Uri.parse(url));
      final responseData = json.decode(response.body)['sales_report'] as List;

      final List<SalesReport> loadedReport = [];

      for (var catData in responseData) {
        loadedReport.add(SalesReport(
          id: catData['id'],
          userId: catData['user_id'],
          paymentType: catData['payment_type'],
          courseId: catData['course_id'],
          amount: catData['amount'],
          dateAdded: catData['date_added'],
          adminRevenue: catData['admin_revenue'],
          instructorRevenue: catData['instructor_revenue'],
          instructorPaymentStatus: catData['instructor_payment_status'],
          transactionId: catData['transaction_id'],
          sessionId: catData['session_id'],
          coupon: catData['coupon'],
        ));
      }
      _salesReport = loadedReport;

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchZoomLiveClassDetails(String courseId) async {
    final authToken = await SharedPreferenceHelper().getAuthToken();
    var url =
        "$BASE_URL/api_instructor/live_class?course_id=$courseId&auth_token=$authToken";
    try {
      var response = await http.get(Uri.parse(url));
      final responseData = json.decode(response.body)['live_class'];

      final emptyClass = LiveClass();

      if (responseData.isEmpty) {
        _liveClass = emptyClass;
        notifyListeners();
        return;
      }

      final loadedClass = LiveClass(
        id: responseData['id'],
        courseId: responseData['course_id'],
        date: responseData['date'],
        time: responseData['time'],
        zoomMeetingId: responseData['zoom_meeting_id'],
        zoomMeetingPassword: responseData['zoom_meeting_password'],
        noteToStudents: responseData['note_to_students'],
      );

      _liveClass = loadedClass;

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchZoomSettings() async {
    final authToken = await SharedPreferenceHelper().getAuthToken();
    var url =
        "$BASE_URL/api_instructor/live_class_settings?auth_token=$authToken";
    try {
      var response = await http.get(Uri.parse(url));
      final responseData = json.decode(response.body);

      final emptySettings = ZoomSettings();

      if (responseData['status'] == 403) {
        _zoomSettings = emptySettings;
        notifyListeners();
        return;
      }

      final loadedSettings = ZoomSettings(
        sdkKey: responseData['sdk_key'],
        sdkSecretKey: responseData['sdk_secret_key'],
        email: responseData['email'],
        password: responseData['password'],
        instructorName: responseData['instructor_name'],
        status: responseData['status'],
      );

      _zoomSettings = loadedSettings;

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
