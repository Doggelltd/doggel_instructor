// ignore_for_file: use_build_context_synchronously

import 'package:doggel_instructor/models/course_pricing.dart';
import 'package:doggel_instructor/models/update_user_model.dart';
import 'package:doggel_instructor/providers/fetch_data.dart';
import 'package:doggel_instructor/providers/shared_pref_helper.dart';
import 'package:doggel_instructor/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import 'course_manager.dart';
import 'package:http/http.dart' as http;

class PricingScreen extends StatefulWidget {
  final String courseId;
  const PricingScreen({Key? key, required this.courseId}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PricingScreenState createState() => _PricingScreenState();
}

Future<UpdateUserModel?> updatePriceModel(String token, String courseId,
    String price, String disPrice, String disFlag, String isFree) async {
  const String apiUrl = "$BASE_URL/api_instructor/update_course_price";

  final response = await http.post(Uri.parse(apiUrl), body: {
    'auth_token': token,
    'course_id': courseId,
    'price': price,
    'discounted_price': disPrice,
    'discount_flag': disFlag,
    'is_free_course': isFree,
  });

  if (response.statusCode == 201) {
    final String responseString = response.body;

    return updateUserModelFromJson(responseString);
  } else {
    return null;
  }
}

class _PricingScreenState extends State<PricingScreen> {
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController priceController = TextEditingController();
  final TextEditingController discountPriceController = TextEditingController();

  var _isInit = true;
  var _isLoading = false;
  late CoursePricing pricing;
  bool checkFree = false;
  bool checkDis = false;
  bool checkDisTwo = true;

  dynamic price;
  dynamic disPrice;
  dynamic disFlag;
  dynamic isFree;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<FetchData>(context)
          .fetchCoursePrice(widget.courseId)
          .then((_) {
        setState(() {
          _isLoading = false;
          pricing = Provider.of<FetchData>(context, listen: false).pricing;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

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
      hintStyle: const TextStyle(color: kTextColor),
      hintText: hintext,
      fillColor: Colors.white,
      prefixIcon: Icon(
        iconData,
        color: const Color(0xFFc7c8ca),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 17),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // priceController.text = pricing.price.toString();
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: const Text("Pricing"),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: kBackgroundColor,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Form(
                key: globalFormKey,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          checkFree = !checkFree;
                        });
                      },
                      child: Row(
                        children: [
                          Checkbox(
                            onChanged: (value) {
                              setState(() {
                                checkFree = value!;
                              });
                            },
                            value: checkFree,
                          ),
                          const Text(
                            'Check if this is a free course',
                            style: TextStyle(color: Colors.black45),
                          ),
                        ],
                      ),
                    ),
                    !checkFree
                        ? Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Course price (${pricing.currency})',
                                    style: const TextStyle(
                                      color: kTextColor,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                  decoration: getInputDecoration(
                                    'Enter course price',
                                    Icons.monetization_on_outlined,
                                  ),
                                  // controller: priceController,
                                  initialValue: pricing.price,
                                  keyboardType: TextInputType.number,
                                  // ignore: missing_return
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Course price cannot be empty';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    setState(
                                        () => priceController.text = value);
                                  },
                                ),
                              ),
                              if (pricing.discountFlag == '1')
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          checkDisTwo = !checkDisTwo;
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            onChanged: (value) {
                                              setState(() {
                                                checkDisTwo = value!;
                                              });
                                            },
                                            value: checkDisTwo,
                                          ),
                                          const Text(
                                            'Check if this course has discount',
                                            style: TextStyle(
                                                color: Colors.black45),
                                          ),
                                        ],
                                      ),
                                    ),
                                    checkDisTwo
                                        ? Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    'Discounted Price (${pricing.currency})',
                                                    style: const TextStyle(
                                                      color: kTextColor,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: TextFormField(
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  decoration:
                                                      getInputDecoration(
                                                    'Course Discount(%)',
                                                    Icons
                                                        .monetization_on_outlined,
                                                  ),
                                                  // controller: discountPriceController,
                                                  initialValue:
                                                      pricing.discountedPrice,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  // ignore: missing_return
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Course discount price cannot be empty';
                                                    }
                                                    return null;
                                                  },
                                                  onChanged: (value) {
                                                    setState(() =>
                                                        discountPriceController
                                                            .text = value);
                                                  },
                                                ),
                                              ),
                                            ],
                                          )
                                        : Container(),
                                  ],
                                ),
                              if (pricing.discountFlag == '0')
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          checkDis = !checkDis;
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            onChanged: (value) {
                                              setState(() {
                                                checkDis = value!;
                                              });
                                            },
                                            value: checkDis,
                                          ),
                                          const Text(
                                            'Check if this course has discount',
                                            style: TextStyle(
                                                color: Colors.black45),
                                          ),
                                        ],
                                      ),
                                    ),
                                    checkDis
                                        ? Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    'Discounted Price (${pricing.currency})',
                                                    style: const TextStyle(
                                                      color: kTextColor,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: TextFormField(
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  decoration:
                                                      getInputDecoration(
                                                    'Course Discount(%)',
                                                    Icons
                                                        .monetization_on_outlined,
                                                  ),
                                                  // controller: discountPriceController,
                                                  initialValue:
                                                      pricing.discountedPrice,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  // ignore: missing_return
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Course discount price cannot be empty';
                                                    }
                                                    return null;
                                                  },
                                                  onChanged: (value) {
                                                    setState(() =>
                                                        discountPriceController
                                                            .text = value);
                                                  },
                                                ),
                                              ),
                                            ],
                                          )
                                        : Container(),
                                  ],
                                ),
                            ],
                          )
                        : Container(),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: MaterialButton(
                          onPressed: () async {
                            if (!globalFormKey.currentState!.validate()) {
                              return;
                            }
                            final authToken =
                                await SharedPreferenceHelper().getAuthToken();

                            if (!checkFree) {
                              isFree = '0';
                              price = priceController.text.toString();
                              if (price.isEmpty) {
                                price = pricing.price;
                              }
                              if (pricing.discountFlag == '0') {
                                if (checkDis) {
                                  disPrice =
                                      discountPriceController.text.toString();
                                  if (disPrice.isEmpty) {
                                    disPrice = pricing.discountedPrice;
                                  }
                                  disFlag = '1';
                                } else {
                                  disPrice = '0';
                                  disFlag = '0';
                                }
                              }
                              if (pricing.discountFlag == '1') {
                                if (checkDisTwo) {
                                  disPrice =
                                      discountPriceController.text.toString();
                                  if (disPrice.isEmpty) {
                                    disPrice = pricing.discountedPrice;
                                  }
                                  disFlag = '1';
                                } else {
                                  disPrice = '0';
                                  disFlag = '0';
                                }
                              }

                              Dialogs.showLoadingDialog(context);

                              // ignore: unused_local_variable
                              final UpdateUserModel? user =
                                  await updatePriceModel(
                                      authToken.toString(),
                                      widget.courseId,
                                      price,
                                      disPrice,
                                      disFlag,
                                      isFree);

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CourseManagerScreen(),
                                ),
                              );
                            } else {
                              price = '0';
                              disPrice = '0';
                              disFlag = '0';
                              isFree = '1';

                              Dialogs.showLoadingDialog(context);

                              // ignore: unused_local_variable
                              final UpdateUserModel? user =
                                  await updatePriceModel(
                                      authToken.toString(),
                                      widget.courseId,
                                      price,
                                      disPrice,
                                      disFlag,
                                      isFree);

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CourseManagerScreen(),
                                ),
                              );
                            }
                          },
                          color: kGreenColor,
                          textColor: Colors.white,
                          elevation: 0.1,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 12),
                          splashColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side: const BorderSide(color: kGreenColor),
                          ),
                          child: const Text(
                            'Update',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
