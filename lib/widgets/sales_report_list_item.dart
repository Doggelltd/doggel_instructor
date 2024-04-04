import 'package:doggel_instructor/widgets/sales_course_detail.dart';
import 'package:doggel_instructor/widgets/string_extension.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class SalesReportListItem extends StatelessWidget {
  final String paymentId;
  final String amount;
  final String instructorRevenue;
  final String paymentType;

  const SalesReportListItem(
      {Key? key,
      required this.paymentId,
      required this.amount,
      required this.instructorRevenue,
      required this.paymentType})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.1,
      color: kPrimaryColor,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("\$$amount"),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(instructorRevenue),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(paymentType.capitalize()),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () => _showReportModal(context),
              color: kIconColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showReportModal(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      builder: (_) {
        return SalesCourseDetailsWidget(paymentId: paymentId);
      },
    );
  }
}
