import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:math_expressions/math_expressions.dart';

class ShowWalletViewOption {
  final BuildContext context;
  final String coopId;
  final String userId;
  final ocCy =
      NumberFormat.currency(decimalDigits: 2, customPattern: '#,###,###.00');
  ShowWalletViewOption(
      {required this.context, required this.coopId, required this.userId});

  Future<bool?> showOptionDialog() async {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please select which one you want to view'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 50,
                width: 160,
                child: ElevatedButton(
                    onPressed: () {
                      // '/user/capitalsharehistory/'
                      Navigator.of(context).pushNamed(
                          // '/coop/loanview/',
                          //  '/coop/loantenureview',
                          '/user/capitalsharehistory/',
                          arguments: {'coopId': coopId, 'userId': userId});
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[600],
                        shape: const StadiumBorder()),
                    child: const Text('Capital Share')),
              ),
            ),
            const Divider(
              color: Color.fromARGB(255, 19, 13, 13), //color of divider
              height: 0, //height spacing of divider
              thickness: 1, //thickness of divier line
              indent: 0, //spacing at the start of divider
              endIndent: 0, //spacing at the end of divider
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 50,
                width: 160,
                child: ElevatedButton(
                    onPressed: () {
                      // '/user/savingshistory/'
                      Navigator.of(context).pushNamed('/user/savingshistory/',
                          arguments: {'coopId': coopId, 'userId': userId});
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[600],
                        shape: const StadiumBorder()),
                    child: const Text('Savings')),
              ),
            )
          ],
        ),
      ),
    );
  }
}
