import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/styles/buttonstyle.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:ascoop/web_ui/utils/alertdialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class PayBtn extends StatefulWidget {
  String subId, loanId, docId, coopId;
  int month;
  double initial, amountPayable;
  PayBtn({
    super.key,
    required this.subId,
    required this.month,
    required this.amountPayable,
    required this.loanId,
    required this.docId,
    required this.coopId,
    required this.initial,
  });

  @override
  State<PayBtn> createState() => _PayBtnState();
}

class _PayBtnState extends State<PayBtn> {
  late final SharedPreferences prefs;
  late final prefsFuture =
      SharedPreferences.getInstance().then((v) => prefs = v);
  var amount;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: prefsFuture,
        builder: (context, prefs) {
          if (prefs.hasError) {
            return onWait;
          } else {
            switch (prefs.connectionState) {
              case ConnectionState.waiting:
                return onWait;
              default:
                return AlertDialog(
                  content: SizedBox(
                    width: 200,
                    height: 80,
                    child: Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp('[0-9.]+')),
                          ],
                          controller: amount = TextEditingController(
                              text: widget.initial.toStringAsFixed(2)),
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                FontAwesomeIcons.pesoSign,
                                color: Colors.grey[800],
                                size: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 0, 105, 92),
                                  width: 2.0,
                                ),
                              ),
                              labelText: 'Payment Amount',
                              labelStyle: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                  letterSpacing: 1)),
                          style: const TextStyle(
                              fontFamily: FontNameDefault,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: Colors.black,
                              letterSpacing: 1),
                          onTap: () {
                            amount.clear();
                          },
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () async {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => AlertDialog(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              content: onWait),
                        );
                        //process of update

                        WriteBatch batch = FirebaseFirestore.instance.batch();
                        double paidAmt = double.parse(amount.text);
                        prefs.data!.setDouble('paidAmount', paidAmt);
                        int count = 0;

//update first the payment
                        await myDb
                            .collection('loans')
                            .where('loanId', isEqualTo: widget.loanId)
                            .where('coopId', isEqualTo: widget.coopId)
                            .get()
                            .then((value) {
                          myDb
                              .collection('loans')
                              .doc(
                                  '${widget.coopId}_${widget.subId}_${widget.loanId}')
                              .update({
                            'paidAmount': paidAmt + value.docs[0]['paidAmount'],
                          });
                        });
                        //process
                        if (paidAmt >
                            double.parse(widget.initial.toStringAsFixed(2))) {
                          int month = widget.month;
                          double paid = paidAmt;
                          while (prefs.data!.getDouble('paidAmount')! > 0) {
                            await myDb
                                .collectionGroup('tenure')
                                .where('coopId', isEqualTo: widget.coopId)
                                .where('loanId', isEqualTo: widget.loanId)
                                .where('month', isEqualTo: month)
                                .get()
                                .then((tenure) async {
                              await myDb
                                  .collection('loans')
                                  .where('loanId', isEqualTo: widget.loanId)
                                  .where('coopId', isEqualTo: widget.coopId)
                                  .get()
                                  .then((loan) async {
                                //var
                                double newMi, newAp, newMp;
                                newMi = paid -
                                    tenure.docs[0]['monthInterest'].toDouble();
                                newAp = newMi -
                                    tenure.docs[0]['amountPayable'].toDouble();
                                newMp =
                                    paid - tenure.docs[0]['payment'].toDouble();
                                //var---

                                if (month == loan.docs[0]['noMonths']) {
                                  //if last month na diri
                                  if (paid >=
                                      double.parse(tenure.docs[0]['payment']
                                          .toStringAsFixed(2))) {
                                    //sobra or exact amount
                                    await myDb
                                        .collection('loans')
                                        .doc(
                                            '${widget.coopId}_${widget.subId}_${widget.loanId}')
                                        .collection('tenure')
                                        .doc((month).toString())
                                        .update({
                                      'paidAmount':
                                          paid + tenure.docs[0]['paidAmount'],
                                      'payment': 0,
                                      'payDate': DateTime.now(),
                                      'payMethod': 'Local Payment',
                                      'status': 'paid',
                                    });
                                    await myDb
                                        .collection('loans')
                                        .doc(
                                            '${widget.coopId}_${widget.subId}_${widget.loanId}')
                                        .update({
                                      'noMonthsPaid':
                                          1 + loan.docs[0]['noMonthsPaid'],
                                      'completeAt': DateTime.now(),
                                      'loanStatus': 'completed'
                                    });
                                    await myDb
                                        .collection('payment')
                                        .doc(
                                            '${widget.coopId}_${widget.subId}_${DateFormat('yyyyMMddHHmmsss').format(DateTime.now())}${widget.loanId.toUpperCase()}$month')
                                        .set({
                                      'amount': paid,
                                      'monthlyPay': tenure.docs[0]['payment'],
                                      'coopId': widget.coopId,
                                      'dueDate':
                                          tenure.docs[0]['dueDate'].toDate(),
                                      'invoiceNo':
                                          '${DateFormat('yyyyMMdd').format(DateTime.now())}${widget.loanId.toUpperCase()}$month',
                                      'loanId': widget.loanId,
                                      'payStatus': DateTime.now()
                                                  .difference(tenure.docs[0]
                                                          ['dueDate']
                                                      .toDate())
                                                  .inHours <
                                              0
                                          ? 'paid'
                                          : 'overdue',
                                      'payerId': widget.subId,
                                      'paymentMethod': 'Local Payment',
                                      'receivedBy': FirebaseAuth
                                          .instance.currentUser!.uid,
                                      'tenureId': month.toString(),
                                      'timestamp': DateTime.now(),
                                    });

                                    myDb
                                        .collection('staffs')
                                        .where('coopID',
                                            isEqualTo: widget.coopId)
                                        .get()
                                        .then((data) async {
                                      if (data.size > 0) {
                                        for (int a = 0; a < data.size; a++) {
                                          await myDb
                                              .collection('notifications')
                                              .doc(widget.coopId)
                                              .collection(
                                                  data.docs[a]['staffID'])
                                              .doc(DateFormat('yyyyMMddHHmmss')
                                                  .format(DateTime.now()))
                                              .set({
                                            'context': 'loan',
                                            'coopId': widget.coopId,
                                            'title': 'Completed Loan',
                                            'content':
                                                "Congratulations! Loan No. ${widget.loanId} is now finished.",
                                            'notifBy': FirebaseAuth
                                                .instance.currentUser!.uid,
                                            'notifId': data.docs[a]['staffID'],
                                            'timestamp': DateTime.now(),
                                            'status': 'unread',
                                          });
                                        }
                                      }
                                    });

                                    prefs.data!
                                        .setDouble('paidAmount', 0)
                                        .whenComplete(() {
                                      Navigator.pop(context);
                                      okDialog(context, 'Loan Complete',
                                          'Congratulation Loan No. ${widget.loanId} is now complete.');
                                    });
                                  } else {
                                    //kung partial ra
                                    await myDb
                                        .collection('loans')
                                        .doc(
                                            '${widget.coopId}_${widget.subId}_${widget.loanId}')
                                        .collection('tenure')
                                        .doc((month).toString())
                                        .update({
                                      'paidAmount':
                                          paid + tenure.docs[0]['paidAmount'],
                                      'payment': newMp.abs(),
                                    });

                                    await myDb
                                        .collection('payment')
                                        .doc(
                                            '${widget.coopId}_${widget.subId}_${DateFormat('yyyyMMddHHmmsss').format(DateTime.now())}${widget.loanId.toUpperCase()}$month')
                                        .set({
                                      'amount': paid,
                                      'monthlyPay': tenure.docs[0]['payment'],
                                      'coopId': widget.coopId,
                                      'dueDate':
                                          tenure.docs[0]['dueDate'].toDate(),
                                      'invoiceNo':
                                          '${DateFormat('yyyyMMdd').format(DateTime.now())}${widget.loanId.toUpperCase()}$month',
                                      'loanId': widget.loanId,
                                      'payStatus': 'partial',
                                      'payerId': widget.subId,
                                      'paymentMethod': 'Local Payment',
                                      'receivedBy': FirebaseAuth
                                          .instance.currentUser!.uid,
                                      'tenureId': month.toString(),
                                      'timestamp': DateTime.now(),
                                    });
                                  }
                                } else if (month < loan.docs[0]['noMonths'] &&
                                    month > 0) {
                                  //if dili last month
                                  if (paid >=
                                      double.parse(tenure.docs[0]['payment']
                                          .toStringAsFixed(2))) {
                                    //check penalty
                                    if (DateTime.now()
                                            .difference(tenure.docs[0]
                                                    ['dueDate']
                                                .toDate())
                                            .inHours >
                                        0) {
                                      await myDb
                                          .collection('coops')
                                          .doc(widget.coopId)
                                          .get()
                                          .then((cp) async {
                                        await myDb
                                            .collection('loans')
                                            .doc(
                                                '${widget.coopId}_${widget.subId}_${widget.loanId}')
                                            .collection('tenure')
                                            .doc((month + 1).toString())
                                            .get()
                                            .then((ten) async {
                                          await myDb
                                              .collection('loans')
                                              .doc(
                                                  '${widget.coopId}_${widget.subId}_${widget.loanId}')
                                              .collection('tenure')
                                              .doc((month + 1).toString())
                                              .update({
                                            'penalty': cp.data()!['penalty'] *
                                                ten.data()!['monthInterest'],
                                            'payment': double.parse((cp.data()![
                                                            'penalty'] *
                                                        tenure.docs[0]
                                                            ['monthInterest'])
                                                    .toStringAsFixed(2)) +
                                                ten.data()!['payment'],
                                          });
                                        });
                                      });
                                    }
                                    //---
                                    //sobra or exact amount
                                    await myDb
                                        .collection('loans')
                                        .doc(
                                            '${widget.coopId}_${widget.subId}_${widget.loanId}')
                                        .collection('tenure')
                                        .doc((month).toString())
                                        .update({
                                      'paidAmount':
                                          paid + tenure.docs[0]['paidAmount'],
                                      'payment': 0,
                                      'payDate': DateTime.now(),
                                      'payMethod': 'Local Payment',
                                      'status': 'paid',
                                    });
                                    await myDb
                                        .collection('loans')
                                        .doc(
                                            '${widget.coopId}_${widget.subId}_${widget.loanId}')
                                        .update({
                                      'noMonthsPaid':
                                          1 + loan.docs[0]['noMonthsPaid'],
                                    });
                                    await myDb
                                        .collection('payment')
                                        .doc(
                                            '${widget.coopId}_${widget.subId}_${DateFormat('yyyyMMddHHmmsss').format(DateTime.now())}${widget.loanId.toUpperCase()}$month')
                                        .set({
                                      'amount': paid,
                                      'monthlyPay': tenure.docs[0]['payment'],
                                      'coopId': widget.coopId,
                                      'dueDate':
                                          tenure.docs[0]['dueDate'].toDate(),
                                      'invoiceNo':
                                          '${DateFormat('yyyyMMdd').format(DateTime.now())}${widget.loanId.toUpperCase()}$month',
                                      'loanId': widget.loanId,
                                      'payStatus': DateTime.now()
                                                  .difference(tenure.docs[0]
                                                          ['dueDate']
                                                      .toDate())
                                                  .inHours <
                                              0
                                          ? 'paid'
                                          : 'overdue',
                                      'payerId': widget.subId,
                                      'paymentMethod': 'Local Payment',
                                      'receivedBy': FirebaseAuth
                                          .instance.currentUser!.uid,
                                      'tenureId': month.toString(),
                                      'timestamp': DateTime.now(),
                                    });
                                  } else {
                                    //kung partial ra
                                    await myDb
                                        .collection('loans')
                                        .doc(
                                            '${widget.coopId}_${widget.subId}_${widget.loanId}')
                                        .collection('tenure')
                                        .doc((month).toString())
                                        .update({
                                      'paidAmount':
                                          paid + tenure.docs[0]['paidAmount'],
                                      'payment': newMp.abs(),
                                    });

                                    await myDb
                                        .collection('payment')
                                        .doc(
                                            '${widget.coopId}_${widget.subId}_${DateFormat('yyyyMMddHHmmsss').format(DateTime.now())}${widget.loanId.toUpperCase()}$month')
                                        .set({
                                      'amount': paid,
                                      'monthlyPay': tenure.docs[0]['payment'],
                                      'coopId': widget.coopId,
                                      'dueDate':
                                          tenure.docs[0]['dueDate'].toDate(),
                                      'invoiceNo':
                                          '${DateFormat('yyyyMMdd').format(DateTime.now())}${widget.loanId.toUpperCase()}$month',
                                      'loanId': widget.loanId,
                                      'payStatus': 'partial',
                                      'payerId': widget.subId,
                                      'paymentMethod': 'Local Payment',
                                      'receivedBy': FirebaseAuth
                                          .instance.currentUser!.uid,
                                      'tenureId': month.toString(),
                                      'timestamp': DateTime.now(),
                                    });
                                  }
                                }
                                if (prefs.data!.getDouble('paidAmount')! > 0) {
                                  ++month;
                                  paid -= double.parse(tenure.docs[0]['payment']
                                      .toStringAsFixed(2));
                                  prefs.data!.setDouble('paidAmount', paid);
                                }
                              });
                            });
                          }
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                          Navigator.pop(context);
                          okDialog(context, 'Payment Successful',
                              'Payment PHP ${amount.text} is deducted to Loan No. ${widget.loanId}.');
                        }
                        // kung partial
                        else if (paidAmt <
                                double.parse(
                                    widget.initial.toStringAsFixed(2)) &&
                            paidAmt > 0) {
                          // kung partial
                          int month = widget.month;
                          double paid = paidAmt;
                          await myDb
                              .collectionGroup('tenure')
                              .where('coopId', isEqualTo: widget.coopId)
                              .where('loanId', isEqualTo: widget.loanId)
                              .where('month', isEqualTo: month)
                              .get()
                              .then((tenure) async {
                            await myDb
                                .collection('loans')
                                .where('loanId', isEqualTo: widget.loanId)
                                .where('coopId', isEqualTo: widget.coopId)
                                .get()
                                .then((loan) async {
                              //var
                              double newMi, newAp, newMp;
                              newMi = paid -
                                  tenure.docs[0]['monthInterest'].toDouble();
                              newAp = newMi -
                                  tenure.docs[0]['amountPayable'].toDouble();
                              newMp =
                                  paid - tenure.docs[0]['payment'].toDouble();
                              //var---

                              //if last month na diri

                              await myDb
                                  .collection('loans')
                                  .doc(
                                      '${widget.coopId}_${widget.subId}_${widget.loanId}')
                                  .collection('tenure')
                                  .doc((month).toString())
                                  .update({
                                'paidAmount':
                                    paid + tenure.docs[0]['paidAmount'],
                                'payment': newMp.abs(),
                              });

                              await myDb
                                  .collection('payment')
                                  .doc(
                                      '${widget.coopId}_${widget.subId}_${DateFormat('yyyyMMddHHmmsss').format(DateTime.now())}${widget.loanId.toUpperCase()}$month')
                                  .set({
                                'amount': paid,
                                'monthlyPay': tenure.docs[0]['payment'],
                                'coopId': widget.coopId,
                                'dueDate': tenure.docs[0]['dueDate'].toDate(),
                                'invoiceNo':
                                    '${DateFormat('yyyyMMdd').format(DateTime.now())}${widget.loanId.toUpperCase()}$month',
                                'loanId': widget.loanId,
                                'payStatus': 'partial',
                                'payerId': widget.subId,
                                'paymentMethod': 'Local Payment',
                                'receivedBy':
                                    FirebaseAuth.instance.currentUser!.uid,
                                'tenureId': month.toString(),
                                'timestamp': DateTime.now(),
                              });
                            });
                          }).whenComplete(() {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            okDialog(context, 'Payment Successful',
                                'Payment PHP ${amount.text} is partialy deducted to Loan No. ${widget.loanId} Month $month.');
                          });
                        } else if (paidAmt ==
                            double.parse(widget.initial.toStringAsFixed(2))) {
                          //kung exact amount

                          int month = widget.month;
                          double paid = paidAmt;
                          await myDb
                              .collectionGroup('tenure')
                              .where('coopId', isEqualTo: widget.coopId)
                              .where('loanId', isEqualTo: widget.loanId)
                              .where('month', isEqualTo: month)
                              .get()
                              .then((tenure) async {
                            await myDb
                                .collection('loans')
                                .where('loanId', isEqualTo: widget.loanId)
                                .where('coopId', isEqualTo: widget.coopId)
                                .get()
                                .then((loan) async {
                              //var
                              double newMi, newAp, newMp;
                              newMi = paid -
                                  tenure.docs[0]['monthInterest'].toDouble();
                              newAp = newMi -
                                  tenure.docs[0]['amountPayable'].toDouble();
                              newMp =
                                  paid - tenure.docs[0]['payment'].toDouble();
                              //var---
                              if (month == loan.docs[0]['noMonths']) {
                                await myDb
                                    .collection('loans')
                                    .doc(
                                        '${widget.coopId}_${widget.subId}_${widget.loanId}')
                                    .collection('tenure')
                                    .doc((month).toString())
                                    .update({
                                  'paidAmount':
                                      paid + tenure.docs[0]['paidAmount'],
                                  'payment': 0,
                                  'payDate': DateTime.now(),
                                  'payMethod': 'Local Payment',
                                  'status': 'paid',
                                });
                                await myDb
                                    .collection('loans')
                                    .doc(
                                        '${widget.coopId}_${widget.subId}_${widget.loanId}')
                                    .update({
                                  'noMonthsPaid':
                                      1 + loan.docs[0]['noMonthsPaid'],
                                  'completeAt': DateTime.now(),
                                  'loanStatus': 'completed'
                                });
                                await myDb
                                    .collection('payment')
                                    .doc(
                                        '${widget.coopId}_${widget.subId}_${DateFormat('yyyyMMddHHmmsss').format(DateTime.now())}${widget.loanId.toUpperCase()}$month')
                                    .set({
                                  'amount': paid,
                                  'monthlyPay': tenure.docs[0]['payment'],
                                  'coopId': widget.coopId,
                                  'dueDate': tenure.docs[0]['dueDate'].toDate(),
                                  'invoiceNo':
                                      '${DateFormat('yyyyMMdd').format(DateTime.now())}${widget.loanId.toUpperCase()}$month',
                                  'loanId': widget.loanId,
                                  'payStatus': DateTime.now()
                                              .difference(tenure.docs[0]
                                                      ['dueDate']
                                                  .toDate())
                                              .inHours <
                                          0
                                      ? 'paid'
                                      : 'overdue',
                                  'payerId': widget.subId,
                                  'paymentMethod': 'Local Payment',
                                  'receivedBy':
                                      FirebaseAuth.instance.currentUser!.uid,
                                  'tenureId': month.toString(),
                                  'timestamp': DateTime.now(),
                                });
                                myDb
                                    .collection('staffs')
                                    .where('coopID', isEqualTo: widget.coopId)
                                    .get()
                                    .then((data) async {
                                  if (data.size > 0) {
                                    for (int a = 0; a < data.size; a++) {
                                      await myDb
                                          .collection('notifications')
                                          .doc(widget.coopId)
                                          .collection(data.docs[a]['staffID'])
                                          .doc(DateFormat('yyyyMMddHHmmss')
                                              .format(DateTime.now()))
                                          .set({
                                        'context': 'loan',
                                        'coopId': widget.coopId,
                                        'title': 'Completed Loan',
                                        'content':
                                            "Congratulations! Loan No. ${widget.loanId} is now finished.",
                                        'notifBy': FirebaseAuth
                                            .instance.currentUser!.uid,
                                        'notifId': data.docs[a]['staffID'],
                                        'timestamp': DateTime.now(),
                                        'status': 'unread',
                                      });
                                    }
                                  }
                                });

                                prefs.data!
                                    .setDouble('paidAmount', 0)
                                    .whenComplete(() {
                                  Navigator.pop(context);
                                  okDialog(context, 'Loan Complete',
                                          'Congratulation Loan No. ${widget.loanId} is now complete.')
                                      .whenComplete(() =>
                                          Navigator.pushReplacementNamed(
                                              context, 'loans/active'));
                                });
                              } else {
                                //check penalty
                                if (DateTime.now()
                                        .difference(
                                            tenure.docs[0]['dueDate'].toDate())
                                        .inHours >
                                    0) {
                                  await myDb
                                      .collection('coops')
                                      .doc(widget.coopId)
                                      .get()
                                      .then((cp) async {
                                    await myDb
                                        .collection('loans')
                                        .doc(
                                            '${widget.coopId}_${widget.subId}_${widget.loanId}')
                                        .get()
                                        .then((ln) async {
                                      await myDb
                                          .collection('loans')
                                          .doc(
                                              '${widget.coopId}_${widget.subId}_${widget.loanId}')
                                          .collection('tenure')
                                          .doc((month + 1).toString())
                                          .get()
                                          .then((ten) async {
                                        await myDb
                                            .collection('loans')
                                            .doc(
                                                '${widget.coopId}_${widget.subId}_${widget.loanId}')
                                            .collection('tenure')
                                            .doc((month + 1).toString())
                                            .update({
                                          'penalty': cp.data()!['penalty'] *
                                              ten.data()!['monthInterest'],
                                          'payment': double.parse(
                                                  (cp.data()!['penalty'] *
                                                          tenure.docs[0]
                                                              ['monthInterest'])
                                                      .toStringAsFixed(2)) +
                                              ten.data()!['payment'],
                                        });
                                        await myDb
                                            .collection('loans')
                                            .doc(
                                                '${widget.coopId}_${widget.subId}_${widget.loanId}')
                                            .update({
                                          'totalPenalty': ln
                                                  .data()!['totalPenalty'] +
                                              (cp.data()!['penalty'] *
                                                  ten.data()!['monthInterest']),
                                        });
                                      });
                                    });
                                  });
                                }
                                //---
                                await myDb
                                    .collection('loans')
                                    .doc(
                                        '${widget.coopId}_${widget.subId}_${widget.loanId}')
                                    .collection('tenure')
                                    .doc((month).toString())
                                    .update({
                                  'paidAmount':
                                      paid + tenure.docs[0]['paidAmount'],
                                  'payment': 0,
                                  'payDate': DateTime.now(),
                                  'payMethod': 'Local Payment',
                                  'status': 'paid',
                                });
                                await myDb
                                    .collection('loans')
                                    .doc(
                                        '${widget.coopId}_${widget.subId}_${widget.loanId}')
                                    .update({
                                  'noMonthsPaid':
                                      1 + loan.docs[0]['noMonthsPaid'],
                                });
                                await myDb
                                    .collection('payment')
                                    .doc(
                                        '${widget.coopId}_${widget.subId}_${DateFormat('yyyyMMddHHmmsss').format(DateTime.now())}${widget.loanId.toUpperCase()}$month')
                                    .set({
                                  'amount': paid,
                                  'monthlyPay': tenure.docs[0]['payment'],
                                  'coopId': widget.coopId,
                                  'dueDate': tenure.docs[0]['dueDate'].toDate(),
                                  'invoiceNo':
                                      '${DateFormat('yyyyMMdd').format(DateTime.now())}${widget.loanId.toUpperCase()}$month',
                                  'loanId': widget.loanId,
                                  'payStatus': DateTime.now()
                                              .difference(tenure.docs[0]
                                                      ['dueDate']
                                                  .toDate())
                                              .inHours <
                                          0
                                      ? 'paid'
                                      : 'overdue',
                                  'payerId': widget.subId,
                                  'paymentMethod': 'Local Payment',
                                  'receivedBy':
                                      FirebaseAuth.instance.currentUser!.uid,
                                  'tenureId': month.toString(),
                                  'timestamp': DateTime.now(),
                                });
                              }
                            });
                          }).whenComplete(() {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            okDialog(context, 'Payment Successful',
                                'Payment PHP ${amount.text} is fully deducted to Loan No. ${widget.loanId}.');
                          });
                        }

                        myDb
                            .collection('subscribers')
                            .where('userId', isEqualTo: widget.subId)
                            .where('coopId',
                                isEqualTo: prefs.data!.getString('coopId'))
                            .get()
                            .then((sub) {
                          myDb
                              .collection('staffs')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection('transactions')
                              .doc(DateFormat('yyyyMMddHHmmss')
                                  .format(DateTime.now()))
                              .set({
                            'timestamp': DateTime.now(),
                            'context': 'Payment',
                            'content':
                                'Receives payment amount of PHP ${NumberFormat('###,###,###,###.##').format(double.parse(amount.text))} from ${sub.docs[0]['userFirstName']} ${sub.docs[0]['userMiddleName']} ${sub.docs[0]['userLastName']} (${sub.docs[0]['userEmail']}) for Loan No. ${widget.loanId}',
                            'title': 'Received Loan Payment',
                            'staffId': FirebaseAuth.instance.currentUser!.uid,
                          });
                        });
                      },
                      //end of onpress
                      style: ForTealButton,
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          'Checkout',
                          style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                );
            }
          }
        });
  }
}
