import 'dart:convert';
import 'dart:io';
import 'package:doggel_instructor/constants.dart';
import 'package:doggel_instructor/models/login_model.dart';
import 'package:doggel_instructor/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'shared_pref_helper.dart';

class Auth with ChangeNotifier {
  String? _token;
  late User _user;

  String? get token {
    if (_token != null) {
      return _token;
    }
    return null;
  }

  User get user {
    return _user;
  }

  Future<void> login(LoginRequestModel requestModel) async {
    String url = "$BASE_URL/api_instructor/login";
    try {
      final response =
          await http.post(Uri.parse(url), body: requestModel.toJson());
      final responseData = json.decode(response.body);

      // print(responseData['validity']);
      if (responseData['validity'] == 0) {
        throw const HttpException('Auth Failed');
      }

      _token = responseData['token'];

      final loadedUser = User(
        userId: responseData['user_id'],
        firstName: responseData['first_name'],
        lastName: responseData['last_name'],
        email: responseData['email'],
        role: responseData['role'],
        image: responseData['image'],
        validity: responseData['validity'],
        token: responseData['token'],
      );

      _user = loadedUser;

      notifyListeners();

      await SharedPreferenceHelper().setAuthToken(token.toString());

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': loadedUser.token,
        'first_name': loadedUser.firstName,
        'last_name': loadedUser.lastName,
        'email': loadedUser.email,
        'image': loadedUser.image,
        'role': loadedUser.role,
        'validity': loadedUser.validity,
      });
      prefs.setString('userData', userData);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    _token = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    prefs.clear();
  }

  Future<void> getUserInfo() async {
    final authToken = await SharedPreferenceHelper().getAuthToken();
    var url = '$BASE_URL/api_instructor/userdata?auth_token=$authToken';
    try {
      if (authToken == null) {
        throw const HttpException('No Auth User');
      }
      final response = await http.get(Uri.parse(url));
      final responseData = json.decode(response.body);

      final loadedUser = User(
        userId: responseData['user_id'],
        firstName: responseData['first_name'],
        lastName: responseData['last_name'],
        email: responseData['email'],
        image: responseData['image'],
        facebook: responseData['facebook'],
        twitter: responseData['twitter'],
        linkedin: responseData['linkedin'],
        biography: responseData['biography'],
        message: responseData['message'],
        status: responseData['status'],
        validity: responseData['validity'],
      );

      _user = loadedUser;

      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': authToken,
        'first_name': responseData['first_name'],
        'last_name': responseData['last_name'],
        'email': responseData['email'],
        'image': responseData['image'],
        'validity': responseData['validity'],
      });
      prefs.setString('userData', userData);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> userImageUpload(File image) async {
    dynamic token = await SharedPreferenceHelper().getAuthToken();
    var url = '$BASE_URL/api_instructor/change_profile_photo';
    var uri = Uri.parse(url);
    var request = http.MultipartRequest('POST', uri);
    request.fields['auth_token'] = token;

    request.files.add(http.MultipartFile(
        'user_image', image.readAsBytes().asStream(), image.lengthSync(),
        filename: basename(image.path)));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        response.stream.transform(utf8.decoder).listen((value) {
          final responseData = json.decode(value);
          if (responseData['status'] != 200) {
            throw const HttpException('Upload Failed');
          }
          _user.image = responseData['photo'];
          notifyListeners();
        });
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateUserData(User user) async {
    dynamic token = await SharedPreferenceHelper().getAuthToken();
    const url = '$BASE_URL/api_instructor/update_userdata';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'auth_token': token,
          'first_name': user.firstName,
          'last_name': user.lastName,
          'email': user.email,
          'biography': user.biography,
          'twitter_link': user.twitter,
          'facebook_link': user.facebook,
          'linkedin_link': user.linkedin,
        },
      );

      final responseData = json.decode(response.body);
      if (responseData['status'] == 'failed') {
        throw const HttpException('Update Failed');
      }

      _user.firstName = responseData['first_name'];
      _user.lastName = responseData['last_name'];
      _user.email = responseData['email'];
      _user.image = responseData['image'];
      _user.twitter = responseData['twitter'];
      _user.linkedin = responseData['linkedin'];
      _user.biography = responseData['biography'];

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
