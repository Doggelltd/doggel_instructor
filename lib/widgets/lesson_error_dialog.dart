import 'package:flutter/material.dart';

class LessonErrorDialog extends StatefulWidget {
  const LessonErrorDialog({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LessonErrorDialogState createState() => _LessonErrorDialogState();
}

class _LessonErrorDialogState extends State<LessonErrorDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Warning!"),
      titleTextStyle: const TextStyle(color: Colors.red, fontSize: 20),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text("No Lesson Found!"),
        ],
      ),
      actions: <Widget>[
        MaterialButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            "Close",
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
