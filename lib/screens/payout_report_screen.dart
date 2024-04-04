// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:doggel_instructor/constants.dart';
import 'package:doggel_instructor/providers/shared_pref_helper.dart';
import 'package:doggel_instructor/widgets/dialog.dart';
import 'package:doggel_instructor/models/payout_report_model.dart';
import 'package:doggel_instructor/widgets/custom_app_bar.dart';
import 'package:doggel_instructor/widgets/payouts_list_item.dart';
import 'package:doggel_instructor/widgets/withdrawal_dialog.dart';
import 'package:doggel_instructor/widgets/withdrawal_warning_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class PayoutReportScreen extends StatefulWidget {
  const PayoutReportScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PayoutReportScreenState createState() => _PayoutReportScreenState();
}

class _PayoutReportScreenState extends State<PayoutReportScreen> {
  Future<PayoutReportModel>? futurePayout;

  Future<PayoutReportModel> fetchPayoutReport() async {
    final authToken = await SharedPreferenceHelper().getAuthToken();
    var url = "$BASE_URL/api_instructor/payout_report?auth_token=$authToken";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return PayoutReportModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load...');
    }
  }

  @override
  void initState() {
    super.initState();
    futurePayout = fetchPayoutReport();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(),
      backgroundColor: Colors.white,
      body: FutureBuilder<PayoutReportModel>(
        future: futurePayout,
        builder: (context, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * .65,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            if (dataSnapshot.error != null) {
              //error
              return const Center(
                child: Text('Error Occured'),
              );
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          flex: 2,
                          child: Padding(
                            padding: EdgeInsets.only(left: 15.0, top: 4.0),
                            child: Text(
                              "MY RECORD",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        ButtonTheme(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2.0,
                              horizontal: 5.0), //adds padding inside the button
                          materialTapTargetSize: MaterialTapTargetSize
                              .shrinkWrap, //limits the touch area to the button area
                          minWidth: 0, //wraps child's width
                          height: 0,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: MaterialButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => dataSnapshot
                                              .data!.requestedWithdrawalAmount
                                              .toString() !=
                                          '0'
                                      ? const AddWithdrawalWarningDialog()
                                      : AddWithdrawalDialog(
                                          pendingAmount: dataSnapshot
                                              .data!.totalPendingAmoun
                                              .toString(),
                                        ),
                                );
                              },
                              color: kGreenColor,
                              elevation: 0.1,
                              textColor: Colors.white,
                              splashColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                side: const BorderSide(color: kGreenColor),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.attach_money_sharp,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    "Withdrawal",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Card(
                        elevation: 0.5,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .10,
                                child: const Card(
                                  color: kRedColor,
                                  child: Center(
                                    child: Text('PN',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(
                                        top: 8.0, left: 8.0, right: 8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            "Pending amount",
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 4.0, right: 4.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                "\$",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(right: 8.0),
                                          child: Icon(Icons.download_sharp),
                                        ),
                                        Text(
                                            "\$${dataSnapshot.data!.totalPendingAmoun}",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Card(
                        elevation: 0.5,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .10,
                                child: const Card(
                                  color: kGreenColor,
                                  child: Center(
                                    child: Text('PO',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(
                                        top: 8.0, left: 8.0, right: 8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            "Total payout amount",
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 4.0, right: 4.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                "\$",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(right: 8.0),
                                          child: Icon(Icons.download_sharp),
                                        ),
                                        Text(
                                            "\$${dataSnapshot.data!.totalPayoutAmount}",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Card(
                        elevation: 0.5,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .10,
                                child: const Card(
                                  color: kGreenColor,
                                  child: Center(
                                    child: Text('WR',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.0, right: 8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            "Withdrawal request",
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 4.0, right: 4.0),
                                              child: Text(
                                                "\$",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8.0),
                                    child: Row(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(right: 8.0),
                                          child: Icon(Icons.download_sharp),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: Text(
                                              "\$${dataSnapshot.data!.requestedWithdrawalAmount}",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        dataSnapshot.data!
                                                    .requestedWithdrawalAmount
                                                    .toString() !=
                                                '0'
                                            ? ButtonTheme(
                                                padding: const EdgeInsets
                                                        .symmetric(
                                                    vertical: 2.0,
                                                    horizontal:
                                                        10.0), //adds padding inside the button
                                                materialTapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap, //limits the touch area to the button area
                                                minWidth:
                                                    0, //wraps child's width
                                                height: 0,
                                                child: MaterialButton(
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            _buildPopupRemove(
                                                                context));
                                                  },
                                                  color: kGreenColor,
                                                  elevation: 0.1,
                                                  textColor: Colors.white,
                                                  splashColor:
                                                      Colors.blueAccent,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7.0),
                                                    side: const BorderSide(
                                                        color: kGreenColor),
                                                  ),
                                                  child: const Row(
                                                    children: [
                                                      Icon(
                                                        Icons.delete,
                                                        color: Colors.white,
                                                        size: 22,
                                                      ),
                                                      Text(
                                                        " Remove request",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : ButtonTheme(
                                                padding: const EdgeInsets
                                                        .symmetric(
                                                    vertical: 2.0,
                                                    horizontal:
                                                        10.0), //adds padding inside the button
                                                materialTapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap, //limits the touch area to the button area
                                                minWidth:
                                                    0, //wraps child's width
                                                height: 0,
                                                child: MaterialButton(
                                                  color: Colors.lightBlueAccent,
                                                  onPressed: () {},
                                                  child: const Row(
                                                    children: [],
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Card(
                            color: Color(0xffF3FFF2),
                            elevation: 0.1,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("Payout amount"),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("Payment type"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (ctx, index) {
                              return PayoutsListItem(
                                amount: dataSnapshot
                                    .data!.payouts![index].amount
                                    .toString(),
                                paymentType: dataSnapshot
                                    .data!.payouts![index].paymentType
                                    .toString(),
                                status: dataSnapshot
                                    .data!.payouts![index].status
                                    .toString(),
                              );
                            },
                            itemCount: dataSnapshot.data!.payouts!.length,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
          }
        },
      ),
    );
  }

  _buildPopupRemove(BuildContext context) {
    return AlertDialog(
      title: const Text("Heads up!"),
      titleTextStyle: const TextStyle(color: kRedColor, fontSize: 20),
      content: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Are you sure?"),
        ],
      ),
      actions: <Widget>[
        MaterialButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text(
            'No',
            style: TextStyle(color: kRedColor),
          ),
        ),
        MaterialButton(
          onPressed: () async {
            Dialogs.showLoadingDialog(context);
            dynamic authToken = await SharedPreferenceHelper().getAuthToken();
            var url =
                "$BASE_URL/api_instructor/delete_withdrawal_request?auth_token=$authToken";
            try {
              final response = await http.get(Uri.parse(url));
              final extractedData = json.decode(response.body);
              if (extractedData == null) {
                return;
              }
            } catch (error) {
              rethrow;
            }
            Navigator.of(context).pop();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return const PayoutReportScreen();
            }));
          },
          child: const Text(
            "Yes",
            style: TextStyle(color: Colors.green),
          ),
        ),
      ],
    );
    // return PopDialog.buildPopupDialog(context, extractedData);
  }
}
