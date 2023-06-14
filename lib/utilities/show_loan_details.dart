import 'package:ascoop/services/database/data_loan.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:math_expressions/math_expressions.dart';

class ShowLoanInfoDialog {
  final BuildContext context;
  final DataLoan loan;
  final ocCy =
      NumberFormat.currency(decimalDigits: 2, customPattern: '#,###,###.00');
  ShowLoanInfoDialog({required this.context, required this.loan});

  Future<bool?> showLoanDataDialog() async {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text('Loan Code: ${loan.loanId}'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  'Paid-up Capital Share: ${ocCy.format(loan.capitalFee)}'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Savings Deposit: ${ocCy.format(loan.savingsFee)}'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Service Fee: ${ocCy.format(loan.serviceFee)}'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Text('CLIMBS INSURANCE: ${ocCy.format(loan.insuranceFee)}'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Text('Total Deduction: ${ocCy.format(loan.totalDeduction)}'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('NET PROCEED: ${ocCy.format(loan.netProceed)}'),
            ),
            const SizedBox(
              width: 12,
            ),
            ElevatedButton(
                onPressed: () {
                  // double amount = double.parse(_payment.text);
                  // try {
                  //   DataService.database()
                  //       .payLoan(tenure: tenure, amount: amount)
                  //       .then((value) => Navigator.of(context).pop(true));
                  // } catch (e) {
                  Navigator.of(context).pop(false);
                  // }
                },
                child: const Text('Close')),
          ],
        ),
      ),
    );
  }

  // double formulaCalculated() {
  //   String finalString = amount.toString() + coop.formula + months.toString();
  //   Parser p = Parser();
  //   Expression exp = p.parse(finalString);
  //   ContextModel cm = ContextModel();
  //   double eval = exp.evaluate(EvaluationType.REAL, cm);

  //   return eval;
  // }

  // double totalAmountDeducted() {
  //   double pcs = (coop.paidUpCS / 100) * amount;
  //   double sd = (coop.savingDeposit / 100) * amount;
  //   double sf = (coop.serviceFee / 100) * amount;
  //   double formula1 = formulaCalculated();

  //   double totalDed = pcs + sd + sf + formula1;

  //   return totalDed;
  // }
}
