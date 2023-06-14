import 'package:ascoop/web_ui/1.loan_formula.dart';
import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/styles/buttonstyle.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:ascoop/web_ui/utils/alertdialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ascoop/web_ui/global_var.dart' as globals;

class ApproveLoan extends StatefulWidget {
  String coopId, loanId, userId, docId, status;
  double capital, savings, insurance, service, netproceed, totDed;
  int index;
  ApproveLoan({
    super.key,
    required this.capital,
    required this.savings,
    required this.insurance,
    required this.service,
    required this.netproceed,
    required this.totDed,
    required this.status,
    required this.coopId,
    required this.loanId,
    required this.userId,
    required this.docId,
    required this.index,
  });

  @override
  State<ApproveLoan> createState() => _ApproveLoanState();
}

class _ApproveLoanState extends State<ApproveLoan> {
  late final SharedPreferences prefs;
  late final prefsFuture =
      SharedPreferences.getInstance().then((v) => prefs = v);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: prefsFuture,
        builder: (context, prefs) {
          if (prefs.hasError) {
            return const Center(child: CircularProgressIndicator());
          } else {
            switch (prefs.connectionState) {
              case ConnectionState.waiting:
                return onWait;
              default:
                if (widget.savings != null) {
                  if (widget.status.toString().toLowerCase() != 'process' ||
                      prefs.data!
                              .getString('myRole')
                              .toString()
                              .toLowerCase() ==
                          'administrator') {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            WriteBatch batch =
                                FirebaseFirestore.instance.batch();
                            if (prefs.data!
                                    .getString('myRole')
                                    .toString()
                                    .toLowerCase() ==
                                'administrator') {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      var capital = TextEditingController(
                                          text: 0.toString());
                                      return AlertDialog(
                                        title: const Text(
                                          'Approve Confirmation',
                                          style: alertDialogTtl,
                                        ),
                                        content: Text(
                                          "Are you sure you want to approve Loan No. ${widget.loanId}?",
                                          style: alertDialogContent,
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            style: ForRedButton,
                                            child: const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                'No',
                                                style: alertDialogBtn,
                                              ),
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              DateTime due = DateTime.now();

                                              myDb
                                                  .collection('loans')
                                                  .doc(widget.docId)
                                                  .get()
                                                  .then((loandata) {
                                                myDb
                                                    .collection('coops')
                                                    .doc(widget.coopId)
                                                    .collection('loanTypes')
                                                    .doc(loandata
                                                        .data()!['loanType']
                                                        .toString()
                                                        .toLowerCase())
                                                    .get()
                                                    .then((coopdata) {
                                                  globals.totBalance = loandata
                                                      .data()!['loanAmount'];
                                                  for (int a = 0;
                                                      a <
                                                          loandata
                                                              .data()![
                                                                  'noMonths']
                                                              .toInt();
                                                      a++) {
                                                    due = DateTime(due.year,
                                                        due.month + 1, due.day);
                                                    myDb
                                                        .collection('loans')
                                                        .doc(widget.docId)
                                                        .collection('tenure')
                                                        .doc((a + 1).toString())
                                                        .set({
                                                      'amountPayable':
                                                          LoanFormula()
                                                              .getAmountPayable(
                                                        loandata.data()![
                                                            'loanAmount'],
                                                        coopdata.data()![
                                                            'interest'],
                                                        loandata.data()![
                                                            'noMonths'],
                                                        widget.coopId,
                                                        a,
                                                      ),
                                                      'monthInterest':
                                                          LoanFormula()
                                                              .getMonthlyInterest(
                                                        loandata.data()![
                                                            'loanAmount'],
                                                        coopdata.data()![
                                                            'interest'],
                                                        loandata.data()![
                                                            'noMonths'],
                                                        widget.coopId,
                                                        a,
                                                      ),
                                                      'payment': LoanFormula()
                                                          .getMonthlyPayment(
                                                        loandata.data()![
                                                            'loanAmount'],
                                                        coopdata.data()![
                                                            'interest'],
                                                        loandata.data()![
                                                            'noMonths'],
                                                        widget.coopId,
                                                        a,
                                                      ),
                                                      'balance': LoanFormula()
                                                          .getBalance(
                                                        loandata.data()![
                                                            'loanAmount'],
                                                        coopdata.data()![
                                                            'interest'],
                                                        loandata.data()![
                                                            'noMonths'],
                                                        widget.coopId,
                                                        a,
                                                      ),
                                                      'penalty': 0,
                                                      'coopId': widget.coopId,
                                                      'dueDate': due,
                                                      'loanId': widget.loanId,
                                                      'month': a + 1,
                                                      'status': 'pending',
                                                      'userId': widget.userId,
                                                      'payDate': null,
                                                      'payMethod': null,
                                                      'paidAmount': 0,
                                                      'monthlyPay': LoanFormula()
                                                          .getMonthlyPayment(
                                                        loandata.data()![
                                                            'loanAmount'],
                                                        coopdata.data()![
                                                            'interest'],
                                                        loandata.data()![
                                                            'noMonths'],
                                                        widget.coopId,
                                                        a,
                                                      ),
                                                    });
                                                  }

                                                  batch.update(
                                                      myDb
                                                          .collection('loans')
                                                          .doc(widget.docId),
                                                      {
                                                        'loanStatus':
                                                            'unreceived',
                                                        'activeAt':
                                                            DateTime.now(),
                                                        'acceptedBy':
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid,
                                                        'montlyPayment': 0,
                                                        'totalPenalty': 0,
                                                        'totalPayment':
                                                            globals.totPayment,
                                                        'totalInterest':
                                                            globals.totInterest,
                                                        'totalBalance':
                                                            loandata.data()![
                                                                'loanAmount'],
                                                        'paidAmount': 0,
                                                        'noMonthsPaid': 0,
                                                        'capitalFee':
                                                            widget.capital,
                                                        'serviceFee':
                                                            widget.service,
                                                        'insuranceFee':
                                                            widget.insurance,
                                                        'savingsFee':
                                                            widget.savings,
                                                        'netProceed':
                                                            widget.netproceed,
                                                        'totalDeduction':
                                                            widget.totDed,
                                                      });
                                                  //add capital and savings data

                                                  batch.set(
                                                      myDb
                                                          .collection('staffs')
                                                          .doc(FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid)
                                                          .collection(
                                                              'transactions')
                                                          .doc(DateFormat(
                                                                  'yyyyMMddHHmmss')
                                                              .format(DateTime
                                                                  .now())),
                                                      {
                                                        'timestamp':
                                                            DateTime.now(),
                                                        'context': 'Loans',
                                                        'content':
                                                            'You approved loan request Loan No. ${widget.loanId}.',
                                                        'title':
                                                            'Approved Loan Request',
                                                        'staffId': FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid,
                                                      });
                                                  batch
                                                      .commit()
                                                      .then((value) async {
                                                    await myDb
                                                        .collection(
                                                            'subscribers')
                                                        .doc(
                                                            '${prefs.data!.getString('coopId')}_${widget.userId}')
                                                        .collection(
                                                            'coopAccDetails')
                                                        .doc('Data')
                                                        .get()
                                                        .then((value) async {
                                                      await myDb
                                                          .collection(
                                                              'subscribers')
                                                          .doc(
                                                              '${prefs.data!.getString('coopId')}_${widget.userId}')
                                                          .collection(
                                                              'coopAccDetails')
                                                          .doc('Data')
                                                          .update({
                                                        'capitalShare': value
                                                                    .data()![
                                                                'capitalShare'] +
                                                            widget.capital,
                                                        'savings':
                                                            value.data()![
                                                                    'savings'] +
                                                                widget.savings,
                                                      });
                                                      await myDb
                                                          .collection(
                                                              'subscribers')
                                                          .doc(
                                                              '${prefs.data!.getString('coopId')}_${widget.userId}')
                                                          .collection(
                                                              'coopAccDetails')
                                                          .doc('Data')
                                                          .collection(
                                                              'shareLedger')
                                                          .doc(DateFormat(
                                                                  'yyyyMMddHHmmsss')
                                                              .format(DateTime
                                                                  .now()))
                                                          .set({
                                                        'timestamp':
                                                            DateTime.now(),
                                                        'deposits':
                                                            widget.capital,
                                                        'withdrawals': 0,
                                                        'balance': value
                                                                    .data()![
                                                                'capitalShare'] +
                                                            widget.capital,
                                                      });
                                                      await myDb
                                                          .collection(
                                                              'subscribers')
                                                          .doc(
                                                              '${prefs.data!.getString('coopId')}_${widget.userId}')
                                                          .collection(
                                                              'coopAccDetails')
                                                          .doc('Data')
                                                          .collection(
                                                              'savingsLedger')
                                                          .doc(DateFormat(
                                                                  'yyyyMMddHHmmsss')
                                                              .format(DateTime
                                                                  .now()))
                                                          .set({
                                                        'timestamp':
                                                            DateTime.now(),
                                                        'deposits':
                                                            widget.savings,
                                                        'withdrawals': 0,
                                                        'balance':
                                                            value.data()![
                                                                    'savings'] +
                                                                widget.savings,
                                                      });
                                                    });
                                                    await myDb
                                                        .collection('staffs')
                                                        .where('coopID',
                                                            isEqualTo:
                                                                widget.coopId)
                                                        .where('staffID',
                                                            isNotEqualTo:
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid)
                                                        .get()
                                                        .then((data) async {
                                                      if (data.size > 0) {
                                                        for (int a = 0;
                                                            a < data.size;
                                                            a++) {
                                                          await myDb
                                                              .collection(
                                                                  'notifications')
                                                              .doc(
                                                                  widget.coopId)
                                                              .collection(data
                                                                      .docs[a]
                                                                  ['staffID'])
                                                              .doc(DateFormat(
                                                                      'yyyyMMddHHmmss')
                                                                  .format(DateTime
                                                                      .now()))
                                                              .set({
                                                            'context':
                                                                'subscriber',
                                                            'coopId':
                                                                widget.coopId,
                                                            'title':
                                                                'Approved Loan Request',
                                                            'content':
                                                                "The Administrator has approved Loan No. ${widget.loanId}.",
                                                            'notifBy':
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid,
                                                            'notifId':
                                                                data.docs[a]
                                                                    ['staffID'],
                                                            'timestamp':
                                                                DateTime.now(),
                                                            'status': 'unread',
                                                          });
                                                        }
                                                      }
                                                    });

                                                    myDb
                                                        .collection('staffs')
                                                        .where('coopID',
                                                            isEqualTo: prefs
                                                                .data!
                                                                .getString(
                                                                    'coopId'))
                                                        .where('role',
                                                            isEqualTo:
                                                                'Administrator')
                                                        .get()
                                                        .then((data) async {
                                                      if (data.size > 0) {
                                                        for (int a = 0;
                                                            a < data.size;
                                                            a++) {
                                                          await myDb
                                                              .collection(
                                                                  'notifications')
                                                              .doc(prefs.data!
                                                                  .getString(
                                                                      'coopId'))
                                                              .collection(data
                                                                      .docs[a]
                                                                  ['staffID'])
                                                              .where('context',
                                                                  isEqualTo:
                                                                      'approveloantoadmin')
                                                              .where('userId',
                                                                  isEqualTo:
                                                                      widget
                                                                          .userId)
                                                              .where('loanId',
                                                                  isEqualTo:
                                                                      widget
                                                                          .loanId)
                                                              .get()
                                                              .then(
                                                                  (value) async {
                                                            if (value.size >
                                                                0) {
                                                              for (int b = 0;
                                                                  b <
                                                                      value
                                                                          .size;
                                                                  b++) {
                                                                await myDb
                                                                    .collection(
                                                                        'notifications')
                                                                    .doc(prefs
                                                                        .data!
                                                                        .getString(
                                                                            'coopId'))
                                                                    .collection(
                                                                        data.docs[a]
                                                                            [
                                                                            'staffID'])
                                                                    .doc(value
                                                                        .docs[b]
                                                                        .id)
                                                                    .delete();
                                                              }
                                                            }
                                                          });
                                                        }
                                                      }
                                                    });
                                                  });
                                                });
                                              }).whenComplete(() {
                                                okDialog(
                                                        context,
                                                        'Approved Successfully',
                                                        'Loan No. ${widget.loanId} is been approved.')
                                                    .whenComplete(() {
                                                  Navigator
                                                      .pushReplacementNamed(
                                                          context,
                                                          '/loans/request');
                                                });
                                              });
                                            },
                                            style: ForTealButton,
                                            child: const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                'Yes',
                                                style: alertDialogBtn,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              });
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    var capital = TextEditingController(
                                        text: 0.toString());
                                    return AlertDialog(
                                      title: const Text(
                                        'Approve Confirmation',
                                        style: alertDialogTtl,
                                      ),
                                      content: Text(
                                        "Are you sure you want to approve Loan No. ${widget.loanId}?",
                                        style: alertDialogContent,
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          style: ForRedButton,
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              'No',
                                              style: alertDialogBtn,
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            await myDb
                                                .collection('loans')
                                                .doc(widget.docId)
                                                .get()
                                                .then((loandata) {
                                              myDb
                                                  .collection('coops')
                                                  .doc(widget.coopId)
                                                  .collection('loanTypes')
                                                  .doc(loandata
                                                      .data()!['loanType']
                                                      .toString()
                                                      .toLowerCase())
                                                  .get()
                                                  .then((coopdata) {
                                                batch.update(
                                                    myDb
                                                        .collection('loans')
                                                        .doc(widget.docId),
                                                    {'loanStatus': 'process'});

                                                batch.set(
                                                    myDb
                                                        .collection('staffs')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid)
                                                        .collection(
                                                            'transactions')
                                                        .doc(DateFormat(
                                                                'yyyyMMddHHmmss')
                                                            .format(DateTime
                                                                .now())),
                                                    {
                                                      'timestamp':
                                                          DateTime.now(),
                                                      'context': 'Loans',
                                                      'content':
                                                          'You submitted confirmation for approving loan request of Loan No. ${widget.loanId}.',
                                                      'title':
                                                          'Decline Loan Request',
                                                      'staffId': FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .uid,
                                                    });
                                                batch.commit().then((value) {
                                                  myDb
                                                      .collection('staffs')
                                                      .where('coopID',
                                                          isEqualTo:
                                                              widget.coopId)
                                                      .where('role',
                                                          isEqualTo:
                                                              'Administrator')
                                                      .get()
                                                      .then((data) async {
                                                    if (data.size > 0) {
                                                      for (int a = 0;
                                                          a < data.size;
                                                          a++) {
                                                        await myDb
                                                            .collection(
                                                                'notifications')
                                                            .doc(widget.coopId)
                                                            .collection(
                                                                data.docs[a]
                                                                    ['staffID'])
                                                            .doc(DateFormat(
                                                                    'yyyyMMddHHmmss')
                                                                .format(DateTime
                                                                    .now()))
                                                            .set({
                                                          'context':
                                                              'approveloantoadmin',
                                                          'coopId':
                                                              widget.coopId,
                                                          'title':
                                                              'Confirmation for Approbation of Loan Request',
                                                          'content':
                                                              "has submitted approve confirmation for Loan No. ${widget.loanId}.",
                                                          'notifBy':
                                                              FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid,
                                                          'notifId':
                                                              data.docs[a]
                                                                  ['staffID'],
                                                          'timestamp':
                                                              DateTime.now(),
                                                          'status': 'unread',
                                                          'userId':
                                                              widget.userId,
                                                          'loanId':
                                                              widget.loanId,
                                                        });
                                                      }
                                                    }
                                                  });
                                                }).whenComplete(() {
                                                  Navigator.pop(context);
                                                  okDialog(
                                                      context,
                                                      'Submitted Confirmation',
                                                      "Please wait for the response of administrator.");
                                                });
                                              });
                                            });
                                          },
                                          style: ForTealButton,
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              'Yes',
                                              style: alertDialogBtn,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                            }
                          },
                          style: ForTealButton,
                          child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              'Approve',
                              style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6)),
                        ElevatedButton(
                          onPressed: () {
                            WriteBatch batch =
                                FirebaseFirestore.instance.batch();
                            if (prefs.data!
                                    .getString('myRole')
                                    .toString()
                                    .toLowerCase() ==
                                'administrator') {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      var capital = TextEditingController(
                                          text: 0.toString());
                                      return AlertDialog(
                                        title: const Text(
                                          'Decline Confirmation',
                                          style: alertDialogTtl,
                                        ),
                                        content: Text(
                                          "Are you sure you want to decline Loan No. ${widget.loanId}?",
                                          style: alertDialogContent,
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            style: ForRedButton,
                                            child: const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                'No',
                                                style: alertDialogBtn,
                                              ),
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              await myDb
                                                  .collection('loans')
                                                  .doc(widget.docId)
                                                  .get()
                                                  .then((loandata) {
                                                myDb
                                                    .collection('coops')
                                                    .doc(widget.coopId)
                                                    .collection('loanTypes')
                                                    .doc(loandata
                                                        .data()!['loanType']
                                                        .toString()
                                                        .toLowerCase())
                                                    .get()
                                                    .then((coopdata) {
                                                  batch.delete(
                                                    myDb
                                                        .collection('loans')
                                                        .doc(widget.docId),
                                                  );
                                                  batch.set(
                                                      myDb
                                                          .collection('staffs')
                                                          .doc(FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid)
                                                          .collection(
                                                              'transactions')
                                                          .doc(DateFormat(
                                                                  'yyyyMMddHHmmss')
                                                              .format(DateTime
                                                                  .now())),
                                                      {
                                                        'timestamp':
                                                            DateTime.now(),
                                                        'context': 'Loans',
                                                        'content':
                                                            'You decline loan request Loan No. ${widget.loanId}.',
                                                        'title':
                                                            'Decline Loan Request',
                                                        'staffId': FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid,
                                                      });
                                                  batch.commit().then((value) {
                                                    myDb
                                                        .collection('staffs')
                                                        .where('coopID',
                                                            isEqualTo:
                                                                widget.coopId)
                                                        .where('staffID',
                                                            isNotEqualTo:
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid)
                                                        .get()
                                                        .then((data) async {
                                                      if (data.size > 0) {
                                                        for (int a = 0;
                                                            a < data.size;
                                                            a++) {
                                                          await myDb
                                                              .collection(
                                                                  'notifications')
                                                              .doc(
                                                                  widget.coopId)
                                                              .collection(data
                                                                      .docs[a]
                                                                  ['staffID'])
                                                              .doc(DateFormat(
                                                                      'yyyyMMddHHmmss')
                                                                  .format(DateTime
                                                                      .now()))
                                                              .set({
                                                            'context':
                                                                'subscriber',
                                                            'coopId':
                                                                widget.coopId,
                                                            'title':
                                                                'Decline Loan Request',
                                                            'content':
                                                                "The Administrator has decline Loan No. ${widget.loanId}.",
                                                            'notifBy':
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid,
                                                            'notifId':
                                                                data.docs[a]
                                                                    ['staffID'],
                                                            'timestamp':
                                                                DateTime.now(),
                                                            'status': 'unread',
                                                          });
                                                        }
                                                      }
                                                    });
                                                    myDb
                                                        .collection('staffs')
                                                        .where('coopID',
                                                            isEqualTo: prefs
                                                                .data!
                                                                .getString(
                                                                    'coopId'))
                                                        .where('role',
                                                            isEqualTo:
                                                                'Administrator')
                                                        .get()
                                                        .then((data) async {
                                                      if (data.size > 0) {
                                                        for (int a = 0;
                                                            a < data.size;
                                                            a++) {
                                                          await myDb
                                                              .collection(
                                                                  'notifications')
                                                              .doc(prefs.data!
                                                                  .getString(
                                                                      'coopId'))
                                                              .collection(data
                                                                      .docs[a]
                                                                  ['staffID'])
                                                              .where('context',
                                                                  isEqualTo:
                                                                      'declineloantoadmin')
                                                              .where('userId',
                                                                  isEqualTo:
                                                                      widget
                                                                          .userId)
                                                              .where('loanId',
                                                                  isEqualTo:
                                                                      widget
                                                                          .loanId)
                                                              .get()
                                                              .then(
                                                                  (value) async {
                                                            if (value.size >
                                                                0) {
                                                              for (int b = 0;
                                                                  b <
                                                                      value
                                                                          .size;
                                                                  b++) {
                                                                await myDb
                                                                    .collection(
                                                                        'notifications')
                                                                    .doc(prefs
                                                                        .data!
                                                                        .getString(
                                                                            'coopId'))
                                                                    .collection(
                                                                        data.docs[a]
                                                                            [
                                                                            'staffID'])
                                                                    .doc(value
                                                                        .docs[b]
                                                                        .id)
                                                                    .delete();
                                                              }
                                                            }
                                                          });
                                                        }
                                                      }
                                                    });
                                                  }).whenComplete(() {
                                                    Navigator.pop(context);
                                                    okDialog(
                                                        context,
                                                        'Decline Successfully',
                                                        'You decline Loan No. ${widget.loanId}.');
                                                  });
                                                });
                                              });
                                            },
                                            style: ForTealButton,
                                            child: const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                'Yes',
                                                style: alertDialogBtn,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              });
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    var capital = TextEditingController(
                                        text: 0.toString());
                                    return AlertDialog(
                                      title: const Text(
                                        'Decline Confirmation',
                                        style: alertDialogTtl,
                                      ),
                                      content: Text(
                                        "Are you sure you want to decline Loan No. ${widget.loanId}?",
                                        style: alertDialogContent,
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          style: ForRedButton,
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              'No',
                                              style: alertDialogBtn,
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            await myDb
                                                .collection('loans')
                                                .doc(widget.docId)
                                                .get()
                                                .then((loandata) {
                                              myDb
                                                  .collection('coops')
                                                  .doc(widget.coopId)
                                                  .collection('loanTypes')
                                                  .doc(loandata
                                                      .data()!['loanType']
                                                      .toString()
                                                      .toLowerCase())
                                                  .get()
                                                  .then((coopdata) {
                                                batch.update(
                                                    myDb
                                                        .collection('loans')
                                                        .doc(widget.docId),
                                                    {'loanStatus': 'process'});

                                                batch.set(
                                                    myDb
                                                        .collection('staffs')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid)
                                                        .collection(
                                                            'transactions')
                                                        .doc(DateFormat(
                                                                'yyyyMMddHHmmss')
                                                            .format(DateTime
                                                                .now())),
                                                    {
                                                      'timestamp':
                                                          DateTime.now(),
                                                      'context': 'Loans',
                                                      'content':
                                                          'You submitted confirmation for declining loan request of Loan No. ${widget.loanId}.',
                                                      'title':
                                                          'Decline Loan Request',
                                                      'staffId': FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .uid,
                                                    });
                                                batch.commit().then((value) {
                                                  myDb
                                                      .collection('staffs')
                                                      .where('coopID',
                                                          isEqualTo:
                                                              widget.coopId)
                                                      .where('role',
                                                          isEqualTo:
                                                              'Administrator')
                                                      .get()
                                                      .then((data) async {
                                                    if (data.size > 0) {
                                                      for (int a = 0;
                                                          a < data.size;
                                                          a++) {
                                                        await myDb
                                                            .collection(
                                                                'notifications')
                                                            .doc(widget.coopId)
                                                            .collection(
                                                                data.docs[a]
                                                                    ['staffID'])
                                                            .doc(DateFormat(
                                                                    'yyyyMMddHHmmss')
                                                                .format(DateTime
                                                                    .now()))
                                                            .set({
                                                          'context':
                                                              'declineloantoadmin',
                                                          'coopId':
                                                              widget.coopId,
                                                          'title':
                                                              'Confirmation for Declining Loan Request',
                                                          'content':
                                                              "has submitted decline confirmation for Loan No. ${widget.loanId}.",
                                                          'notifBy':
                                                              FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid,
                                                          'notifId':
                                                              data.docs[a]
                                                                  ['staffID'],
                                                          'timestamp':
                                                              DateTime.now(),
                                                          'status': 'unread',
                                                          'userId':
                                                              widget.userId,
                                                          'loanId':
                                                              widget.loanId,
                                                        });
                                                      }
                                                    }
                                                  });
                                                }).whenComplete(() {
                                                  Navigator.pop(context);
                                                  okDialog(
                                                      context,
                                                      'Submitted Confirmation',
                                                      "Please wait for the response of administrator.");
                                                });
                                              });
                                            });
                                          },
                                          style: ForTealButton,
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              'Yes',
                                              style: alertDialogBtn,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                            }
                          },
                          style: ForRedButton,
                          child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              'Decline',
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
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Text(
                          'Waiting For Confirmation...',
                          style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                              color: Colors.black),
                        ),
                      ],
                    );
                  }
                } else {
                  return onWait;
                }
            }
          }
        });
  }
}
