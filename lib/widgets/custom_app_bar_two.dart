import 'package:doggel_instructor/screens/course_manager.dart';
import 'package:flutter/material.dart';

class CustomAppBarTwo extends StatefulWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String title;

  CustomAppBarTwo({Key? key, required this.title})
      : preferredSize = const Size.fromHeight(70.0),
        super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CustomAppBarTwoState createState() => _CustomAppBarTwoState();
}

class _CustomAppBarTwoState extends State<CustomAppBarTwo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 18),
        Container(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return CourseManagerScreen();
                  }));
                },
              ),
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 75,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.title,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
