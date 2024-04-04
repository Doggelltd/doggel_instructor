import 'dart:convert';
import 'package:doggel_instructor/models/sales_course_details_model.dart';
import 'package:doggel_instructor/widgets/string_extension.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:http/http.dart' as http;

class SalesCourseDetailsWidget extends StatefulWidget {
  final String paymentId;

  const SalesCourseDetailsWidget({Key? key, required this.paymentId})
      : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _SalesCourseDetailsWidgetState createState() =>
      _SalesCourseDetailsWidgetState();
}

class _SalesCourseDetailsWidgetState extends State<SalesCourseDetailsWidget> {
  Future<SalesCourseDetailsModel>? futureSalesDetails;

  Future<SalesCourseDetailsModel> fetchSalesDetails() async {
    var url =
        "$BASE_URL/api_instructor/details_of_sales_report?payment_id=${widget.paymentId}";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return SalesCourseDetailsModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load...');
    }
  }

  @override
  void initState() {
    super.initState();
    futureSalesDetails = fetchSalesDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 30,
          ),
          AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              'Course Sales',
              style: TextStyle(
                fontSize: 16,
                color: kTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: const IconThemeData(
              color: kSecondaryColor, //change your color here
            ),
            backgroundColor: kBackgroundColor,
            actions: <Widget>[
              IconButton(
                  icon: const Icon(
                    Icons.cancel,
                    color: kSecondaryColor,
                  ),
                  onPressed: () => Navigator.of(context).pop()),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: FutureBuilder<SalesCourseDetailsModel>(
              future: futureSalesDetails,
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
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(bottom: 25, left: 5),
                                child: Text(
                                  "Title : ",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: kTextColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    dataSnapshot.data!.courseTitle.toString(),
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Student : ",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: kTextColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  dataSnapshot.data!.enrolledStudent.toString(),
                                  style: const TextStyle(
                                      fontSize: 17, color: Colors.black54),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          "Course Price: ",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: kTextColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        dataSnapshot
                                            .data!.paymentDetails!.amount
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black54),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          "Purchase Date: ",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: kTextColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        dataSnapshot.data!.paymentDate
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black54),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Card(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          "Payment type: ",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: kTextColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        dataSnapshot
                                            .data!.paymentDetails!.paymentType!
                                            .capitalize(),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black54),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          "Instructor revenue: ",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: kTextColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        dataSnapshot.data!.paymentDetails!
                                            .instructorRevenue
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black54),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          "Admin revenue: ",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: kTextColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        dataSnapshot
                                            .data!.paymentDetails!.adminRevenue
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black54),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
