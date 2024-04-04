import 'package:doggel_instructor/constants.dart';
import 'package:flutter/material.dart';

class AddWithdrawalWarningDialog extends StatelessWidget {
  const AddWithdrawalWarningDialog({Key? key}) : super(key: key);

  InputDecoration getInputDecoration(String hintext, IconData iconData) {
    return InputDecoration(
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: Colors.white),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: Color(0xFF3862FD)),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: Color(0xFFF65054)),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: Color(0xFFF65054)),
      ),
      filled: true,
      hintStyle: const TextStyle(color: Color(0xFFc7c8ca)),
      hintText: hintext,
      fillColor: const Color(0xFFF7F7F7),
      prefixIcon: Icon(
        iconData,
        color: const Color(0xFFc7c8ca),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 17),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Request a new withdrawal"),
      content: Card(
        elevation: 0.1,
        color: kCardColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'Oops!',
                style: TextStyle(
                    color: kRedColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '\nYou already requested a withdrawal',
                style: TextStyle(
                    color: kRedColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '\nIf you want to make another, You have to delete the requested one first',
                style: TextStyle(color: kRedColor, fontSize: 15),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        MaterialButton(
          elevation: 0.1,
          onPressed: () {
            Navigator.of(context).pop();
          },
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 7),
          color: kRedColor,
          splashColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: const Text(
            "Close",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
