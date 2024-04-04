// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:doggel_instructor/constants.dart';
import 'package:doggel_instructor/screens/on_boarding/on_boarding_screen.dart';
import 'package:doggel_instructor/screens/tabs_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_screen.dart';
import 'course_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  dynamic userData;
  dynamic token;
  dynamic boarding;
  @override
  void initState() {
    donLogin();
    super.initState();
  }

  void donLogin() {
    Future.delayed(const Duration(seconds: 3), () async {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        userData = (prefs.getString('userData') ?? '');
        boarding = (prefs.getString('boarding') ?? '');
        log(boarding.toString());
      });
      if (userData != null && userData.isNotEmpty) {
        final response = jsonDecode(userData);
        setState(() {
          token = response['token'];
        });
      }
      if (token != null && token.isNotEmpty) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => TabsScreen()));
      } else if (boarding != null && boarding.isNotEmpty) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const AuthScreen()));
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const OnboardingScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSplashBackgroundColor,
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Image.asset(
            'assets/images/splash.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
