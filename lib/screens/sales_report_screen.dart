import 'dart:async';

import 'package:doggel_instructor/models/sales_report.dart';
import 'package:doggel_instructor/providers/fetch_data.dart';
import 'package:doggel_instructor/widgets/custom_app_bar.dart';
import 'package:doggel_instructor/widgets/sales_report_list_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../constants.dart';

class SalesReportScreen extends StatefulWidget {
  static const routeName = '/complete-order';
  const SalesReportScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SalesReportScreenState createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends State<SalesReportScreen> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  Future<void> _selectdate(BuildContext context) async {
    final DateTime? seldate = await showDatePicker(
        context: context,
        initialDate: _startDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2090),
        builder: (context, child) {
          return SingleChildScrollView(
            child: child,
          );
        });
    if (seldate != null) {
      setState(() {
        _startDate = seldate;
      });
    }
  }

  Future<void> _selectdatetwo(BuildContext context) async {
    final DateTime? seldate = await showDatePicker(
        context: context,
        initialDate: _endDate,
        firstDate: DateTime(1990),
        lastDate: DateTime(2090),
        builder: (context, child) {
          return SingleChildScrollView(
            child: child,
          );
        });
    if (seldate != null) {
      setState(() {
        _endDate = seldate;
      });
    }
  }

  var _isInit = true;
  bool _isInitial = true;
  dynamic start;
  dynamic end;
  List<SalesReport> salesReport = [];

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        start = DateFormat('dd-MMM-yyyy').format(_startDate);
        end = DateFormat('dd-MMM-yyyy').format(_endDate);
      });

      Provider.of<FetchData>(context).fetchSalesReport(start, end).then((_) {
        setState(() {
          _isInitial = false;
          salesReport =
              Provider.of<FetchData>(context, listen: false).salesReport;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  fetchReport() async {
    Provider.of<FetchData>(context, listen: false)
        .fetchSalesReport(start, end)
        .then((_) {
      setState(() {
        salesReport =
            Provider.of<FetchData>(context, listen: false).salesReport;
      });
    });
  }

  reset() {
    setState(() {
      _isInitial = true;
      salesReport.clear();
    });
  }

  // void startTimer() {
  //   Timer.periodic(const Duration(seconds: 2), (t) {
  //     setState(() {
  //       _isInitial = false; //set loading to false
  //     });
  //     t.cancel(); //stops the timer
  //   });
  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
                child: Text(
                  "My Deals: ",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Start Date',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 8.0),
                        child: Text(
                          'End Date',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () => _selectdate(context),
                      child: Card(
                        color: Color(0XFFF3FFF2),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1000)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                color: Colors.black54,
                              ),
                              Text(DateFormat('dd MMM, yy').format(_startDate)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () => _selectdatetwo(context),
                      child: Card(
                        color: Color(0XFFF3FFF2),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1000)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                color: Colors.black54,
                              ),
                              Text(DateFormat('dd MMM, yy').format(_endDate)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: MaterialButton(
                    onPressed: () {
                      setState(() {
                        start = DateFormat('dd-MMM-yyyy').format(_startDate);
                        end = DateFormat('dd-MMM-yyyy').format(_endDate);
                        salesReport.clear();
                      });
                      reset();
                      fetchReport();
                    },
                    color: kGreenColor,
                    textColor: Colors.white,
                    elevation: 0.1,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    splashColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: const BorderSide(color: kGreenColor),
                    ),
                    child: const Text(
                      'Find',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                  ),
                ),
              ),
              buildSalesList(),
            ],
          ),
        ),
      ),
    );
  }

  buildSalesList() {
    if (_isInitial && salesReport.isEmpty) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * .5,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return salesReport.isEmpty
          ? Center(
              child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * .10),
                CircleAvatar(
                    maxRadius: 120,
                    backgroundColor: const Color(0xffF3FFF2),
                    child: Image.asset("assets/empty-box.png", height: 140)),
                const SizedBox(height: 30),
                const Text('Empty Sales'),
              ],
            ))
          : SingleChildScrollView(
              child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      flex: 3,
                      child: Padding(
                        padding: EdgeInsets.only(left: 12.0, top: 15),
                        child: Text(
                          "Total",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15, left: 10),
                        child: Text("${salesReport.length} Sales",
                            style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87)),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 0.1,
                    child: Row(
                      children: const [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Amount"),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Revenue"),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Payment"),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Text("Details"),
                            ),
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
                    itemCount: salesReport.length,
                    itemBuilder: (ctx, index) {
                      return SalesReportListItem(
                        paymentId: salesReport[index].id.toString(),
                        amount: salesReport[index].amount.toString(),
                        instructorRevenue:
                            salesReport[index].instructorRevenue.toString(),
                        paymentType: salesReport[index].paymentType.toString(),
                      );
                    },
                  ),
                ),
              ],
            ));
    }
  }
}
