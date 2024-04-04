import 'package:flutter/material.dart';

class SectionErrorDialog extends StatefulWidget {
  const SectionErrorDialog({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SectionErrorDialogState createState() => _SectionErrorDialogState();
}

class _SectionErrorDialogState extends State<SectionErrorDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Warning!"),
      titleTextStyle: const TextStyle(color: Colors.red, fontSize: 20),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text("No section Created!"),
        ],
      ),
      actions: <Widget>[
        MaterialButton(
          color: Colors.black26,
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            "Close",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
