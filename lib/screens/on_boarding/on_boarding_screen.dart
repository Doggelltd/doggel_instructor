import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import '../../constants.dart';
import '../../providers/shared_pref_helper.dart';
import '../auth_screen.dart';
import '../auth_screen_private.dart';
import 'custom_model.dart';

class OnboardingScreen extends StatefulWidget {
  static const String id = "onboarding screen";
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  List<Widget> getPages() {
    return [
      const CustomOnboardingPageViewModel(
        imageUrl: 'assets/board1.png',
        modelTitle: 'Welcome to Doggel Instructor',
        modelDescription:
            'We\'re delighted that you\'ve joined our platform dedicated to education.Doggel Instructor enables you to share your expertise while earning rewards based on its popularity.Let\'s begin this professional journey together!',
      ),
      const CustomOnboardingPageViewModel(
        imageUrl: 'assets/board2.png',
        modelTitle: 'Share Your Expertise',
        modelDescription:
            'As a Doggel Instructor, you have the unique opportunity to craft courses tailored specifically to yourarea of expertise - be it mathematics, literature, science or any other. Start building out courses and sections now to enrich the learning experiences for students worldwide!',
      ),
      const CustomOnboardingPageViewModel(
          imageUrl: 'assets/board3.png',
          modelTitle: 'Gain Recognition for Your Impact',
          modelDescription:
              'As a Doggel Instructor, we value your commitment to education. Every view of your courses contributes to your earnings - reflecting its impactful content - while as more views come through, so will your earning potential. Keep providing top-quality lessons and watch as both your community impact and monetary earnings expand exponentially!'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IntroductionScreen(
          rawPages: getPages(),
          onSkip: () async {
            await SharedPreferenceHelper().setBoarding("boarding");
            String board;
            board = SharedPreferenceHelper().setBoarding("boarding").toString();
            log(board);
            if (mounted) {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const AuthScreen()));
            }
          },
          onDone: () async {
            await SharedPreferenceHelper().setBoarding("boarding");
            String board;
            board = SharedPreferenceHelper().setBoarding("boarding").toString();
            log(board);
            if (mounted) {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const AuthScreen()));
            }
          },
          done: const Text(
            'Get Started',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: kGreenColor,
            ),
          ),
          showSkipButton: true,
          skip: const Text(
            'Skip',
            style: TextStyle(color: kGreenColor, fontSize: 16),
          ),
          next: const Text(
            'Next',
            style: TextStyle(
              fontSize: 16,
              color: kGreenColor,
            ),
          ),
          dotsDecorator: const DotsDecorator(
            activeColor: kGreenColor,
          ),
        ),
      ),
    );
  }
}
