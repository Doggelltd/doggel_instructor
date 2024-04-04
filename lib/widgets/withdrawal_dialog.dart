// ignore_for_file: use_build_context_synchronously

import 'package:doggel_instructor/constants.dart';
import 'package:doggel_instructor/providers/shared_pref_helper.dart';
import 'package:doggel_instructor/widgets/dialog.dart';
import 'package:doggel_instructor/models/update_user_model.dart';
import 'package:doggel_instructor/screens/payout_report_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ignore: non_constant_identifier_names
Future<UpdateUserModel?> CreateCourse(String token, String amount) async {
  const String apiUrl = "$BASE_URL/api_instructor/add_withdrawal_request";

  final response = await http.post(Uri.parse(apiUrl), body: {
    'auth_token': token,
    'withdrawal_amount': amount,
  });

  if (response.statusCode == 201) {
    final String responseString = response.body;

    return updateUserModelFromJson(responseString);
  } else {
    return null;
  }
}

// ignore: must_be_immutable
class AddWithdrawalDialog extends StatelessWidget {
  final String pendingAmount;

  AddWithdrawalDialog({Key? key, required this.pendingAmount})
      : super(key: key);

  final _textController = TextEditingController();

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
      hintStyle: const TextStyle(color: Color(0xFF858597), fontSize: 14),
      hintText: hintext,
      fillColor: const Color(0xFFF7F7F7),
      prefixIcon: Icon(
        iconData,
        color: const Color(0xFF858597),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 17),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Request a new withdrawal",
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Withdrawal amount",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          ),
          TextFormField(
            style: const TextStyle(fontSize: 16),
            decoration: getInputDecoration(
              'Withdrawal amount',
              Icons.attach_money_outlined,
            ),
            controller: _textController,
            keyboardType: TextInputType.number,
            // ignore: missing_return
            validator: (value) {
              if (value!.isEmpty) {
                return 'Withdrawal amount cannot be empty';
              }
              return null;
            },
            onSaved: (value) {
              _textController.text = value!;
            },
          ),
          SizedBox(height: 10),
          Text(
            "Withdrawal amount has to be less than or equal to $pendingAmount",
            style: const TextStyle(color: Color(0xff858597), fontSize: 12),
          ),
          const SizedBox(height: 10),
        ],
      ),
      actions: <Widget>[
        MaterialButton(
          elevation: 0.1,
          onPressed: () async {
            dynamic authToken = await SharedPreferenceHelper().getAuthToken();
            if (_textController.text.isNotEmpty) {
              var amount = _textController.text.toString();
              Dialogs.showLoadingDialog(context);
              // ignore: unused_local_variable
              final UpdateUserModel? user =
                  await CreateCourse(authToken, amount);
              Navigator.of(context).pop();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return const PayoutReportScreen();
              }));
            }
          },
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
          color: kGreenColor,
          splashColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(color: kGreenColor),
          ),
          child: const Text(
            "Request",
            style: TextStyle(color: Colors.white),
          ),
        ),
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
