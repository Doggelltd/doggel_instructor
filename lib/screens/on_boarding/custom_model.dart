import 'package:flutter/material.dart';

class CustomOnboardingPageViewModel extends StatelessWidget {
  const CustomOnboardingPageViewModel({
    Key? key,
    required this.imageUrl,
    required this.modelTitle,
    required this.modelDescription,
  }) : super(key: key);

  final String imageUrl, modelTitle, modelDescription;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Container(
            height: 400,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imageUrl),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            modelTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 23.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            modelDescription,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xff7C7C7C),
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }
}
