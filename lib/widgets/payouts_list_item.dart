import 'package:doggel_instructor/widgets/string_extension.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class PayoutsListItem extends StatelessWidget {
  final String amount;
  final String paymentType;
  final String status;

  const PayoutsListItem(
      {Key? key,
      required this.amount,
      required this.paymentType,
      required this.status})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: Card(
        elevation: 0.1,
        color: kPrimaryColor,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("\$$amount"),
              ),
            ),
            status == '1'
                ? Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(paymentType.capitalize()),
                    ),
                  )
                : const Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(right: 30.0),
                      child: Card(
                        elevation: 0.1,
                        margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        color: Colors.orange,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 2, bottom: 2.0),
                          child: Center(
                              child: Text(
                            'Pending',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
