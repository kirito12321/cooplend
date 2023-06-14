import 'dart:developer';

import 'package:ascoop/web_ui/1.deductionFormula.dart';
import 'package:ascoop/web_ui/1.loan_formula.dart';
import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/route/loans/subprof.dart';
import 'package:ascoop/web_ui/styles/buttonstyle.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:ascoop/web_ui/utils/alertdialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ascoop/web_ui/global_var.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileLoanConf extends StatefulWidget {
  String loanid, subId, staffid, context, docid;
  ProfileLoanConf({
    super.key,
    required this.docid,
    required this.loanid,
    required this.subId,
    required this.staffid,
    required this.context,
  });

  @override
  State<ProfileLoanConf> createState() => _ProfileLoanConfState();
}

class _ProfileLoanConfState extends State<ProfileLoanConf> {
  late int subprofIndex;
  @override
  void initState() {
    subprofIndex = 0;
    globals.listSubProfHead = [true, false];
    super.initState();
  }

  @override
  callbacks(int x, int n) {
    setState(() {
      subprofIndex = x;

      for (int i = 0; i < globals.listSubProfHead.length; i++) {
        if (i != n) {
          globals.listSubProfHead[i] = false;
        } else {
          globals.listSubProfHead[i] = true;
        }
      }
    });
  }

  var _loan = <bool>[];
  int cnt = 0;
  listloan(int count) {
    cnt = count;
    for (int a = 0; a < cnt; a++) {
      _loan.add(false);
    }
  }

  selectloan(int num) {
    for (int i = 0; i < cnt; i++) {
      if (i != num) {
        _loan[i] = false;
      } else {
        _loan[i] = true;
      }
    }
  }

  List list = [true, false];
  void select(int n) {
    for (int i = 0; i < list.length; i++) {
      if (i != n) {
        list[i] = false;
      } else {
        list[i] = true;
      }
    }
  }

  callback(int x) {
    setState(() {
      loanprofIndex = x;
    });
  }

  late final SharedPreferences prefs;
  late final prefsFuture =
      SharedPreferences.getInstance().then((v) => prefs = v);

  int index = 0;
  int loanprofIndex = 0;

  getBal(double bal) {
    for (int a = 0; a < 1; a++) {
      globals.totBalance = bal.toDouble();
    }
  }

  double? getTotPayment(
      double amount, double interest, int noMonths, String coopid) {
    globals.totPayment = 0;
    double emp, emi, ap;
    double totBal = amount;
    if (coopid == '7JcfdmGdC4O5mmfYuCkPONQMPAy1') {
      for (int a = 0; a < noMonths; a++) {
        if (a < 12) {
          emi = amount * interest;
          ap = amount / noMonths;
          emp = emi + ap;
          totBal = totBal - ap;
        } else {
          emi = totBal * interest;

          ap = amount / noMonths;
          totBal = totBal - ap;
          emp = emi + ap;
        }
        globals.totPayment = globals.totPayment + emp;
      }
      return globals.totPayment;
    } else {
      for (int a = 0; a < noMonths; a++) {
        if (a == 0) {
          emi = amount * interest;
          ap = amount / noMonths;
          emp = emi + ap;
          totBal = totBal - ap;
        } else {
          emi = totBal * interest;

          ap = amount / noMonths;
          totBal = totBal - ap;
          emp = emi + ap;
        }
        globals.totPayment = globals.totPayment + emp;
      }
      return globals.totPayment;
    }
  }

  double? getTotRate(
      double amount, double interest, int noMonths, String coopid) {
    globals.totInterest = 0;
    double emp, emi, ap;
    double totBal = amount;
    if (coopid == '7JcfdmGdC4O5mmfYuCkPONQMPAy1') {
      for (int a = 0; a < noMonths; a++) {
        if (a < 12) {
          emi = amount * interest;
          ap = amount / noMonths;
          emp = emi + ap;
          totBal = totBal - ap;
        } else {
          emi = totBal * interest;

          ap = amount / noMonths;
          totBal = totBal - ap;
          emp = emi + ap;
        }
        globals.totInterest = globals.totInterest + emi;
      }
      return globals.totInterest;
    } else {
      for (int a = 0; a < noMonths; a++) {
        if (a == 0) {
          emi = amount * interest;
          ap = amount / noMonths;
          emp = emi + ap;
          totBal = totBal - ap;
        } else {
          emi = totBal * interest;

          ap = amount / noMonths;
          totBal = totBal - ap;
          emp = emi + ap;
        }
        globals.totInterest = globals.totInterest + emi;
      }
      return globals.totInterest;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LoanProfHeader(
            callback: callback,
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: grey4,
                    spreadRadius: 0.2,
                    blurStyle: BlurStyle.normal,
                    blurRadius: 0.6,
                  ),
                ],
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: IndexedStack(
                index: loanprofIndex,
                children: [
                  FutureBuilder(
                      future: prefsFuture,
                      builder: (context, prefs) {
                        if (prefs.hasError) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          switch (prefs.connectionState) {
                            case ConnectionState.waiting:
                              return onWait;
                            default:
                              return StreamBuilder(
                                  stream: myDb
                                      .collection('loans')
                                      .where('loanId', isEqualTo: widget.loanid)
                                      .where('userId', isEqualTo: widget.subId)
                                      .where('coopId',
                                          isEqualTo:
                                              prefs.data!.getString('coopId'))
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    try {
                                      final data = snapshot.data!.docs;
                                      if (snapshot.hasError) {
                                        log('snapshot.hasError (coopdash): ${snapshot.error}');
                                        return Container();
                                      } else if (snapshot.hasData &&
                                          data.isNotEmpty) {
                                        switch (snapshot.connectionState) {
                                          case ConnectionState.waiting:
                                            return onWait;
                                          default:
                                            return SingleChildScrollView(
                                              scrollDirection: Axis.vertical,
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Column(
                                                              children: [
                                                                const Text(
                                                                  'LOAN NUMBER',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        FontNameDefault,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  '${data[0]['loanId']}',
                                                                  style:
                                                                      const TextStyle(
                                                                    fontFamily:
                                                                        FontNameDefault,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                const Text(
                                                                  'DATE REQUESTED',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        FontNameDefault,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  DateFormat(
                                                                          'MMM d, yyyy')
                                                                      .format(data[0]
                                                                              [
                                                                              'createdAt']
                                                                          .toDate())
                                                                      .toUpperCase(),
                                                                  style:
                                                                      const TextStyle(
                                                                    fontFamily:
                                                                        FontNameDefault,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                const Text(
                                                                  'LOAN TYPE',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        FontNameDefault,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  '${data[0]['loanType']} LOAN'
                                                                      .toUpperCase(),
                                                                  style:
                                                                      const TextStyle(
                                                                    fontFamily:
                                                                        FontNameDefault,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                const Text(
                                                                  'EST. TOTAL PAYMENT',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        FontNameDefault,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                                FutureBuilder(
                                                                  //monthlyinterest
                                                                  future: myDb
                                                                      .collection(
                                                                          'coops')
                                                                      .doc(prefs
                                                                          .data!
                                                                          .getString(
                                                                              'coopId'))
                                                                      .collection(
                                                                          'loanTypes')
                                                                      .doc(data[
                                                                              0]
                                                                          [
                                                                          'loanType'])
                                                                      .get(),
                                                                  builder: (context,
                                                                      snapshot) {
                                                                    if (snapshot
                                                                        .hasError) {
                                                                      return const Center(
                                                                          child:
                                                                              CircularProgressIndicator());
                                                                    } else {
                                                                      switch (snapshot
                                                                          .connectionState) {
                                                                        case ConnectionState
                                                                              .waiting:
                                                                          return onWait;
                                                                        default:
                                                                          double? totPay = getTotPayment(
                                                                              data[0]['loanAmount'],
                                                                              snapshot.data!.data()!['interest'],
                                                                              data[0]['noMonths'],
                                                                              prefs.data!.getString('coopId').toString());

                                                                          return Text(
                                                                            'PHP ${NumberFormat('###,###,###,###,###.##').format(totPay)}',
                                                                            style:
                                                                                const TextStyle(
                                                                              fontFamily: FontNameDefault,
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w700,
                                                                              color: Colors.black,
                                                                            ),
                                                                          );
                                                                      }
                                                                    }
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                const Text(
                                                                  'LOAN AMOUNT',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        FontNameDefault,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  'PHP ${NumberFormat('###,###,###,###.##').format(data[0]['loanAmount'])}'
                                                                      .toUpperCase(),
                                                                  style:
                                                                      const TextStyle(
                                                                    fontFamily:
                                                                        FontNameDefault,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                    color: Colors
                                                                        .black,
                                                                    letterSpacing:
                                                                        1.5,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Column(
                                                              children: [
                                                                const Text(
                                                                  'LOAN TENURE',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        FontNameDefault,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  '${NumberFormat('###,##0').format(data[0]['noMonths'])} MONTHS',
                                                                  style:
                                                                      const TextStyle(
                                                                    fontFamily:
                                                                        FontNameDefault,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                const Text(
                                                                  'INTEREST RATE',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        FontNameDefault,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                                FutureBuilder(
                                                                  future: myDb
                                                                      .collection(
                                                                          'coops')
                                                                      .doc(prefs
                                                                          .data!
                                                                          .getString(
                                                                              'coopId'))
                                                                      .collection(
                                                                          'loanTypes')
                                                                      .doc(data[
                                                                              0]
                                                                          [
                                                                          'loanType'])
                                                                      .get(),
                                                                  builder: (context,
                                                                      snapshot) {
                                                                    if (snapshot
                                                                        .hasError) {
                                                                      log(snapshot
                                                                          .error
                                                                          .toString());
                                                                      return onWait;
                                                                    } else {
                                                                      switch (snapshot
                                                                          .connectionState) {
                                                                        case ConnectionState
                                                                              .waiting:
                                                                          return onWait;
                                                                        default:
                                                                          return Text(
                                                                            '${NumberFormat('###.##').format(snapshot.data!.data()!['interest'].toDouble() * 100)} %',
                                                                            style:
                                                                                const TextStyle(
                                                                              fontFamily: FontNameDefault,
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w700,
                                                                              color: Colors.black,
                                                                            ),
                                                                          );
                                                                      }
                                                                    }
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                const Text(
                                                                  'EST. TOTAL INTEREST',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        FontNameDefault,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                                FutureBuilder(
                                                                  //monthlyinterest
                                                                  future: myDb
                                                                      .collection(
                                                                          'coops')
                                                                      .doc(prefs
                                                                          .data!
                                                                          .getString(
                                                                              'coopId'))
                                                                      .collection(
                                                                          'loanTypes')
                                                                      .doc(data[
                                                                              0]
                                                                          [
                                                                          'loanType'])
                                                                      .get(),
                                                                  builder: (context,
                                                                      snapshot) {
                                                                    if (snapshot
                                                                        .hasError) {
                                                                      return const Center(
                                                                          child:
                                                                              CircularProgressIndicator());
                                                                    } else {
                                                                      switch (snapshot
                                                                          .connectionState) {
                                                                        case ConnectionState
                                                                              .waiting:
                                                                          return onWait;
                                                                        default:
                                                                          double? totRate = getTotRate(
                                                                              data[0]['loanAmount'],
                                                                              snapshot.data!.data()!['interest'],
                                                                              data[0]['noMonths'],
                                                                              prefs.data!.getString('coopId').toString());

                                                                          return Text(
                                                                            'PHP ${NumberFormat('###,###,###,###,###.##').format(totRate)}',
                                                                            style:
                                                                                const TextStyle(
                                                                              fontFamily: FontNameDefault,
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w700,
                                                                              color: Colors.black,
                                                                            ),
                                                                          );
                                                                      }
                                                                    }
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  const Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 15)),
                                                  FutureBuilder(
                                                      future: myDb
                                                          .collection('coops')
                                                          .doc(prefs.data!
                                                              .getString(
                                                                  'coopId'))
                                                          .collection(
                                                              'loanTypes')
                                                          .doc(data[0]
                                                              ['loanType'])
                                                          .get(),
                                                      builder:
                                                          (context, snapshot) {
                                                        try {
                                                          final snap = snapshot
                                                              .data!
                                                              .data()!;
                                                          if (snapshot
                                                              .hasError) {
                                                            log('snapshot.hasError (coopdash): ${snapshot.error}');
                                                            return Container();
                                                          } else if (snapshot
                                                                  .hasData &&
                                                              data.isNotEmpty) {
                                                            switch (snapshot
                                                                .connectionState) {
                                                              case ConnectionState
                                                                    .waiting:
                                                                return onWait;
                                                              default:
                                                                return Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    const Text(
                                                                      '- DEDUCTIONS -',
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            FontNameDefault,
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceEvenly,
                                                                      children: [
                                                                        Column(
                                                                          children: [
                                                                            Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                const Text(
                                                                                  'CAPITAL SHARE PAID-UP',
                                                                                  style: TextStyle(
                                                                                    fontFamily: FontNameDefault,
                                                                                    fontSize: 12,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    color: Colors.black,
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  'PHP ${NumberFormat('###,###,###,###.##').format(DeductionFormula().forDedCapital(data[0]['loanAmount'], snap['capitalFee']))}',
                                                                                  style: const TextStyle(
                                                                                    fontFamily: FontNameDefault,
                                                                                    fontSize: 16,
                                                                                    fontWeight: FontWeight.w800,
                                                                                    color: Colors.black,
                                                                                    letterSpacing: 1.5,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                                                                            Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                const Text(
                                                                                  'SAVINGS PAID-UP',
                                                                                  style: TextStyle(
                                                                                    fontFamily: FontNameDefault,
                                                                                    fontSize: 12,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    color: Colors.black,
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  'PHP ${NumberFormat('###,###,###,###.##').format(DeductionFormula().forDedSavings(data[0]['loanAmount'], snap['savingsFee']))}',
                                                                                  style: const TextStyle(
                                                                                    fontFamily: FontNameDefault,
                                                                                    fontSize: 16,
                                                                                    fontWeight: FontWeight.w800,
                                                                                    color: Colors.black,
                                                                                    letterSpacing: 1.5,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                                                                            Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                const Text(
                                                                                  'TOTAL NET PROCEEDS',
                                                                                  style: TextStyle(
                                                                                    fontFamily: FontNameDefault,
                                                                                    fontSize: 12,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    color: Colors.black,
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  'PHP ${NumberFormat('###,###,###,###.##').format(DeductionFormula().forNetProceed(data[0]['loanAmount'], ((data[0]['loanAmount'] * snap['capitalFee']) + (data[0]['loanAmount'] * snap['savingsFee']) + (data[0]['loanAmount'] * snap['serviceFee']) + ((data[0]['loanAmount'] / snap['insuranceFee']) * snap['insuranceRate'] * data[0]['noMonths']))))}',
                                                                                  style: const TextStyle(
                                                                                    fontFamily: FontNameDefault,
                                                                                    fontSize: 16,
                                                                                    fontWeight: FontWeight.w800,
                                                                                    color: Colors.black,
                                                                                    letterSpacing: 1.5,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Column(
                                                                          children: [
                                                                            Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                const Text(
                                                                                  'SERVICE FEE',
                                                                                  style: TextStyle(
                                                                                    fontFamily: FontNameDefault,
                                                                                    fontSize: 12,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    color: Colors.black,
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  'PHP ${NumberFormat('###,###,###,###.##').format(DeductionFormula().forDedService(data[0]['loanAmount'], snap['serviceFee']))}',
                                                                                  style: const TextStyle(
                                                                                    fontFamily: FontNameDefault,
                                                                                    fontSize: 16,
                                                                                    fontWeight: FontWeight.w800,
                                                                                    color: Colors.black,
                                                                                    letterSpacing: 1.5,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                                                                            Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                const Text(
                                                                                  'INSURANCE FEE',
                                                                                  style: TextStyle(
                                                                                    fontFamily: FontNameDefault,
                                                                                    fontSize: 12,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    color: Colors.black,
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  'PHP ${NumberFormat('###,###,###,###.##').format(DeductionFormula().forDedInsurance(data[0]['loanAmount'], snap['insuranceFee'], snap['insuranceRate'], data[0]['noMonths']))}',
                                                                                  style: const TextStyle(
                                                                                    fontFamily: FontNameDefault,
                                                                                    fontSize: 16,
                                                                                    fontWeight: FontWeight.w800,
                                                                                    color: Colors.black,
                                                                                    letterSpacing: 1.5,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                                                                            Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                const Text(
                                                                                  'TOTAL DEDUCTIONS',
                                                                                  style: TextStyle(
                                                                                    fontFamily: FontNameDefault,
                                                                                    fontSize: 12,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    color: Colors.black,
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  'PHP ${NumberFormat('###,###,###,###.##').format(DeductionFormula().forTotDed((data[0]['loanAmount'] * snap['savingsFee']), (data[0]['loanAmount'] * snap['capitalFee']), (data[0]['loanAmount'] * snap['serviceFee']), ((data[0]['loanAmount'] / snap['insuranceFee']) * snap['insuranceRate'] * data[0]['noMonths'])))}',
                                                                                  style: const TextStyle(
                                                                                    fontFamily: FontNameDefault,
                                                                                    fontSize: 16,
                                                                                    fontWeight: FontWeight.w800,
                                                                                    color: Colors.black,
                                                                                    letterSpacing: 1.5,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                );
                                                            }
                                                          }
                                                        } catch (e) {}
                                                        return onWait;
                                                      }),
                                                  const Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10)),
                                                  widget.context.toString() ==
                                                          'approveloantoadmin'
                                                      ? Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                FutureBuilder(
                                                                  future: myDb
                                                                      .collection(
                                                                          'staffs')
                                                                      .where(
                                                                          'staffID',
                                                                          isEqualTo:
                                                                              widget.staffid)
                                                                      .get(),
                                                                  builder: (context,
                                                                      snapshot) {
                                                                    try {
                                                                      final staff = snapshot
                                                                          .data!
                                                                          .docs;

                                                                      if (snapshot
                                                                          .hasError) {
                                                                        log('snapshot.hasError (pending.dart): ${snapshot.error}');
                                                                        return Container();
                                                                      } else if (snapshot
                                                                              .hasData &&
                                                                          data.isNotEmpty) {
                                                                        switch (
                                                                            snapshot.connectionState) {
                                                                          case ConnectionState.waiting:
                                                                            return onWait;
                                                                          default:
                                                                            return Column(
                                                                              children: [
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  children: [
                                                                                    CircleAvatar(
                                                                                      backgroundImage: NetworkImage(staff[0]['profilePic']),
                                                                                      radius: 14,
                                                                                      backgroundColor: Colors.transparent,
                                                                                    ),
                                                                                    const Padding(padding: EdgeInsets.symmetric(horizontal: 1)),
                                                                                    Container(
                                                                                      width: 215,
                                                                                      alignment: Alignment.centerLeft,
                                                                                      child: RichText(
                                                                                        text: TextSpan(
                                                                                          text: '${staff[0]['firstname']} ${staff[0]['lastname']} ',
                                                                                          style: const TextStyle(
                                                                                            fontFamily: FontNameDefault,
                                                                                            color: Colors.black,
                                                                                            fontSize: 13,
                                                                                            fontWeight: FontWeight.w800,
                                                                                            letterSpacing: 0.5,
                                                                                          ),
                                                                                          children: const [
                                                                                            TextSpan(
                                                                                              text: 'request to approve this loan request',
                                                                                              style: TextStyle(
                                                                                                fontFamily: FontNameDefault,
                                                                                                color: Colors.black,
                                                                                                fontSize: 13,
                                                                                                fontWeight: FontWeight.w500,
                                                                                                letterSpacing: 0.5,
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                const Padding(padding: EdgeInsets.symmetric(vertical: 6)),
                                                                                Row(
                                                                                  children: [
                                                                                    const Padding(padding: EdgeInsets.only(left: 8)),
                                                                                    ElevatedButton(
                                                                                      onPressed: () {
                                                                                        WriteBatch batch = FirebaseFirestore.instance.batch();
                                                                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                                                                          showDialog(
                                                                                              context: context,
                                                                                              builder: (context) {
                                                                                                return AlertDialog(
                                                                                                  title: const Text(
                                                                                                    'Approve Confirmation',
                                                                                                    style: alertDialogTtl,
                                                                                                  ),
                                                                                                  content: Text(
                                                                                                    "Are you sure you want to approve ${data[index]['loanId']}?",
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
                                                                                                      onPressed: () {
                                                                                                        DateTime due = DateTime.now();

                                                                                                        myDb.collection('loans').doc(data[index].id).get().then((loandata) {
                                                                                                          myDb.collection('coops').doc(prefs.data!.getString('coopId')).collection('loanTypes').doc(loandata.data()!['loanType'].toString().toLowerCase()).get().then((coopdata) {
                                                                                                            globals.totBalance = loandata.data()!['loanAmount'];
                                                                                                            for (int a = 0; a < loandata.data()!['noMonths'].toInt(); a++) {
                                                                                                              due = DateTime(due.year, due.month + 1, due.day);
                                                                                                              myDb.collection('loans').doc(data[index].id).collection('tenure').doc((a + 1).toString()).set({
                                                                                                                'amountPayable': LoanFormula().getAmountPayable(
                                                                                                                  loandata.data()!['loanAmount'],
                                                                                                                  coopdata.data()!['interest'],
                                                                                                                  loandata.data()!['noMonths'],
                                                                                                                  prefs.data!.getString('coopId')!,
                                                                                                                  a,
                                                                                                                ),
                                                                                                                'monthInterest': LoanFormula().getMonthlyInterest(
                                                                                                                  loandata.data()!['loanAmount'],
                                                                                                                  coopdata.data()!['interest'],
                                                                                                                  loandata.data()!['noMonths'],
                                                                                                                  prefs.data!.getString('coopId')!,
                                                                                                                  a,
                                                                                                                ),
                                                                                                                'payment': LoanFormula().getMonthlyPayment(
                                                                                                                  loandata.data()!['loanAmount'],
                                                                                                                  coopdata.data()!['interest'],
                                                                                                                  loandata.data()!['noMonths'],
                                                                                                                  prefs.data!.getString('coopId')!,
                                                                                                                  a,
                                                                                                                ),
                                                                                                                'balance': LoanFormula().getBalance(
                                                                                                                  loandata.data()!['loanAmount'],
                                                                                                                  coopdata.data()!['interest'],
                                                                                                                  loandata.data()!['noMonths'],
                                                                                                                  prefs.data!.getString('coopId')!,
                                                                                                                  a,
                                                                                                                ),
                                                                                                                'penalty': 0,
                                                                                                                'coopId': prefs.data!.getString('coopId'),
                                                                                                                'dueDate': due,
                                                                                                                'loanId': widget.loanid,
                                                                                                                'month': a + 1,
                                                                                                                'status': 'pending',
                                                                                                                'userId': widget.subId,
                                                                                                                'payDate': null,
                                                                                                                'payMethod': null,
                                                                                                                'paidAmount': 0,
                                                                                                                'monthlyPay': LoanFormula().getMonthlyPayment(
                                                                                                                  loandata.data()!['loanAmount'],
                                                                                                                  coopdata.data()!['interest'],
                                                                                                                  loandata.data()!['noMonths'],
                                                                                                                  prefs.data!.getString('coopId')!,
                                                                                                                  a,
                                                                                                                ),
                                                                                                              });
                                                                                                            }

                                                                                                            batch.update(myDb.collection('loans').doc(data[index].id), {
                                                                                                              'loanStatus': 'unreceived',
                                                                                                              'activeAt': DateTime.now(),
                                                                                                              'acceptedBy': FirebaseAuth.instance.currentUser!.uid,
                                                                                                              'montlyPayment': 0,
                                                                                                              'totalPenalty': 0,
                                                                                                              'totalPayment': globals.totPayment,
                                                                                                              'totalInterest': globals.totInterest,
                                                                                                              'totalBalance': loandata.data()!['loanAmount'],
                                                                                                              'paidAmount': 0,
                                                                                                              'noMonthsPaid': 0,
                                                                                                              'capitalFee': DeductionFormula().forDedCapital(data[0]['loanAmount'], coopdata.data()!['capitalFee']),
                                                                                                              'serviceFee': DeductionFormula().forDedService(data[0]['loanAmount'], coopdata.data()!['serviceFee']),
                                                                                                              'insuranceFee': DeductionFormula().forDedInsurance(data[0]['loanAmount'], coopdata.data()!['insuranceFee'], coopdata.data()!['insuranceRate'], data[0]['noMonths']),
                                                                                                              'savingsFee': DeductionFormula().forDedSavings(data[0]['loanAmount'], coopdata.data()!['savingsFee']),
                                                                                                              'netProceed': DeductionFormula().forNetProceed(data[0]['loanAmount'], (data[0]['loanAmount'] * coopdata.data()!['capitalFee']) + (data[0]['loanAmount'] * coopdata.data()!['serviceFee']) + (data[0]['loanAmount'] * coopdata.data()!['savingsFee']) + ((data[0]['loanAmount'] / coopdata.data()!['insuranceFee']) * coopdata.data()!['insuranceRate'] * data[0]['noMonths'])),
                                                                                                              'totalDeduction': (data[0]['loanAmount'] * coopdata.data()!['capitalFee']) + (data[0]['loanAmount'] * coopdata.data()!['serviceFee']) + (data[0]['loanAmount'] * coopdata.data()!['savingsFee']) + ((data[0]['loanAmount'] / coopdata.data()!['insuranceFee']) * coopdata.data()!['insuranceRate'] * data[0]['noMonths']),
                                                                                                            });
                                                                                                            //add capital and savings data
                                                                                                            myDb.collection('subscribers').doc('${prefs.data!.getString('coopId')}_${widget.subId}').collection('coopAccDetails').doc('Data').get().then((value) async {
                                                                                                              await myDb.collection('subscribers').doc('${prefs.data!.getString('coopId')}_${widget.subId}').collection('coopAccDetails').doc('Data').update({
                                                                                                                'capitalShare': value.data()!['capitalShare'] + (data[0]['loanAmount'] * coopdata.data()!['capitalFee']),
                                                                                                                'savings': value.data()!['savings'] + (data[0]['loanAmount'] * coopdata.data()!['savingsFee']),
                                                                                                              });
                                                                                                              await myDb.collection('subscribers').doc('${prefs.data!.getString('coopId')}_${widget.subId}').collection('coopAccDetails').doc('Data').collection('shareLedger').doc(DateFormat('yyyyMMddHHmmsss').format(DateTime.now())).set({
                                                                                                                'timestamp': DateTime.now(),
                                                                                                                'deposits': (data[0]['loanAmount'] * coopdata.data()!['capitalFee']),
                                                                                                                'withdrawals': 0,
                                                                                                                'balance': value.data()!['capitalShare'] + (data[0]['loanAmount'] * coopdata.data()!['capitalFee']),
                                                                                                              });
                                                                                                              await myDb.collection('subscribers').doc('${prefs.data!.getString('coopId')}_${widget.subId}').collection('coopAccDetails').doc('Data').collection('savingsLedger').doc(DateFormat('yyyyMMddHHmmsss').format(DateTime.now())).set({
                                                                                                                'timestamp': DateTime.now(),
                                                                                                                'deposits': (data[0]['loanAmount'] * coopdata.data()!['savingsFee']),
                                                                                                                'withdrawals': 0,
                                                                                                                'balance': value.data()!['savings'] + (data[0]['loanAmount'] * coopdata.data()!['savingsFee']),
                                                                                                              });
                                                                                                            });

                                                                                                            batch.set(myDb.collection('staffs').doc(FirebaseAuth.instance.currentUser!.uid).collection('transactions').doc(DateFormat('yyyyMMddHHmmss').format(DateTime.now())), {
                                                                                                              'timestamp': DateTime.now(),
                                                                                                              'context': 'Loans',
                                                                                                              'content': 'You approved loan request Loan No. ${widget.loanid}.',
                                                                                                              'title': 'Approved Loan Request',
                                                                                                              'staffId': FirebaseAuth.instance.currentUser!.uid,
                                                                                                            });
                                                                                                            batch.commit().then((value) async {
                                                                                                              await myDb.collection('staffs').where('coopID', isEqualTo: prefs.data!.getString('coopId')).where('staffID', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid).get().then((data) async {
                                                                                                                if (data.size > 0) {
                                                                                                                  for (int a = 0; a < data.size; a++) {
                                                                                                                    await myDb.collection('notifications').doc(prefs.data!.getString('coopId')).collection(data.docs[a]['staffID']).doc(DateFormat('yyyyMMddHHmmss').format(DateTime.now())).set({
                                                                                                                      'context': 'subscriber',
                                                                                                                      'coopId': prefs.data!.getString('coopId'),
                                                                                                                      'title': 'Approved Loan Request',
                                                                                                                      'content': "The Administrator has approved Loan No. ${widget.loanid}.",
                                                                                                                      'notifBy': FirebaseAuth.instance.currentUser!.uid,
                                                                                                                      'notifId': data.docs[a]['staffID'],
                                                                                                                      'timestamp': DateTime.now(),
                                                                                                                      'status': 'unread',
                                                                                                                    });
                                                                                                                  }
                                                                                                                }
                                                                                                              });

                                                                                                              myDb.collection('staffs').where('coopID', isEqualTo: prefs.data!.getString('coopId')).where('role', isEqualTo: 'Administrator').get().then((data) async {
                                                                                                                if (data.size > 0) {
                                                                                                                  for (int a = 0; a < data.size; a++) {
                                                                                                                    await myDb.collection('notifications').doc(prefs.data!.getString('coopId')).collection(data.docs[a]['staffID']).where('context', isEqualTo: 'approveloantoadmin').where('userId', isEqualTo: widget.subId).where('loanId', isEqualTo: widget.loanid).get().then((value) async {
                                                                                                                      if (value.size > 0) {
                                                                                                                        for (int b = 0; b < value.size; b++) {
                                                                                                                          await myDb.collection('notifications').doc(prefs.data!.getString('coopId')).collection(data.docs[a]['staffID']).doc(value.docs[b].id).delete();
                                                                                                                        }
                                                                                                                      }
                                                                                                                    });
                                                                                                                  }
                                                                                                                }
                                                                                                              });
                                                                                                            });
                                                                                                          });
                                                                                                        }).whenComplete(() {
                                                                                                          okDialog(context, 'Approved Successfully', 'Loan No. ${widget.loanid} is been approved.').whenComplete(() {
                                                                                                            Navigator.pop(context);
                                                                                                            Navigator.pop(context);
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
                                                                                      },
                                                                                      style: ForTealButton,
                                                                                      child: Text(
                                                                                        'Confirm'.toUpperCase(),
                                                                                        style: const TextStyle(
                                                                                          fontFamily: FontNameDefault,
                                                                                          color: Colors.white,
                                                                                          fontSize: 14,
                                                                                          fontWeight: FontWeight.w800,
                                                                                          letterSpacing: 1,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    const Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                                                                                    ElevatedButton(
                                                                                      onPressed: () {
                                                                                        WriteBatch batch = FirebaseFirestore.instance.batch();
                                                                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                                                                          showDialog(
                                                                                              context: context,
                                                                                              builder: (context) {
                                                                                                return AlertDialog(
                                                                                                  title: const Text(
                                                                                                    'Decline Confirmation',
                                                                                                    style: alertDialogTtl,
                                                                                                  ),
                                                                                                  content: Text(
                                                                                                    "Are you sure you want to decline the confirmation request?",
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
                                                                                                        await myDb.collection('notifications').doc(prefs.data!.getString('coopId')).collection(FirebaseAuth.instance.currentUser!.uid).where('context', isEqualTo: 'approveloantoadmin').where('userId', isEqualTo: widget.subId).where('loanId', isEqualTo: widget.loanid).where('coopId', isEqualTo: prefs.data!.getString('coopId')).get().then((value) {
                                                                                                          if (value.size != 0) {
                                                                                                            for (int a = 0; a < value.size; a++) {
                                                                                                              myDb.collection('notifications').doc(prefs.data!.getString('coopId')).collection(FirebaseAuth.instance.currentUser!.uid).doc(value.docs[a].id).delete();
                                                                                                            }
                                                                                                          }
                                                                                                        }).then((val) {
                                                                                                          myDb.collection('loans').doc(data[index].id).update({
                                                                                                            'loanStatus': 'pending',
                                                                                                          });
                                                                                                          myDb.collection('notifications').doc(prefs.data!.getString('coopId')).collection(widget.staffid).doc(DateFormat('yyyyMMddHHmmss').format(DateTime.now())).set({
                                                                                                            'context': 'loans',
                                                                                                            'coopId': prefs.data!.getString('coopId'),
                                                                                                            'title': 'Decline Confirmation Request',
                                                                                                            'content': "The Administrator has decline your decline request for Loan Request No. ${widget.loanid}.",
                                                                                                            'notifBy': widget.staffid,
                                                                                                            'notifId': widget.staffid,
                                                                                                            'timestamp': DateTime.now(),
                                                                                                            'status': 'unread',
                                                                                                          });
                                                                                                          myDb.collection('staffs').doc(FirebaseAuth.instance.currentUser!.uid).collection('transactions').doc(DateFormat('yyyyMMddHHmmss').format(DateTime.now())).set({
                                                                                                            'timestamp': DateTime.now(),
                                                                                                            'context': 'Subscriber',
                                                                                                            'content': 'You declined approbation request for Loan Request No. ${widget.loanid}.',
                                                                                                            'title': 'Decline Confirmation Request',
                                                                                                            'staffId': FirebaseAuth.instance.currentUser!.uid,
                                                                                                          });
                                                                                                        }, onError: (e) {
                                                                                                          okDialog(context, 'An Error Occured', 'Please try again. Later!');
                                                                                                        }).whenComplete(() {
                                                                                                          okDialog(context, 'Decline Successfully', "Request for Approbation of Loan Request has been declined").whenComplete(() {
                                                                                                            Navigator.pop(context);
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
                                                                                      },
                                                                                      style: ForRedButton,
                                                                                      child: Text(
                                                                                        'Decline'.toUpperCase(),
                                                                                        style: const TextStyle(
                                                                                          fontFamily: FontNameDefault,
                                                                                          color: Colors.white,
                                                                                          fontSize: 14,
                                                                                          fontWeight: FontWeight.w800,
                                                                                          letterSpacing: 1,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                )
                                                                              ],
                                                                            );
                                                                        }
                                                                      }
                                                                    } catch (e) {}
                                                                    return onWait;
                                                                  },
                                                                )
                                                              ],
                                                            ),
                                                          ],
                                                        )
                                                      : Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                FutureBuilder(
                                                                  future: myDb
                                                                      .collection(
                                                                          'staffs')
                                                                      .where(
                                                                          'staffID',
                                                                          isEqualTo:
                                                                              widget.staffid)
                                                                      .get(),
                                                                  builder: (context,
                                                                      snapshot) {
                                                                    try {
                                                                      final staff = snapshot
                                                                          .data!
                                                                          .docs;

                                                                      if (snapshot
                                                                          .hasError) {
                                                                        log('snapshot.hasError (pending.dart): ${snapshot.error}');
                                                                        return Container();
                                                                      } else if (snapshot
                                                                              .hasData &&
                                                                          data.isNotEmpty) {
                                                                        switch (
                                                                            snapshot.connectionState) {
                                                                          case ConnectionState.waiting:
                                                                            return onWait;
                                                                          default:
                                                                            return Column(
                                                                              children: [
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  children: [
                                                                                    CircleAvatar(
                                                                                      backgroundImage: NetworkImage(staff[0]['profilePic']),
                                                                                      radius: 14,
                                                                                      backgroundColor: Colors.transparent,
                                                                                    ),
                                                                                    const Padding(padding: EdgeInsets.symmetric(horizontal: 1)),
                                                                                    Container(
                                                                                      width: 215,
                                                                                      alignment: Alignment.centerLeft,
                                                                                      child: RichText(
                                                                                        text: TextSpan(
                                                                                          text: '${staff[0]['firstname']} ${staff[0]['lastname']} ',
                                                                                          style: const TextStyle(
                                                                                            fontFamily: FontNameDefault,
                                                                                            color: Colors.black,
                                                                                            fontSize: 13,
                                                                                            fontWeight: FontWeight.w800,
                                                                                            letterSpacing: 0.5,
                                                                                          ),
                                                                                          children: const [
                                                                                            TextSpan(
                                                                                              text: 'request to decline this loan request',
                                                                                              style: TextStyle(
                                                                                                fontFamily: FontNameDefault,
                                                                                                color: Colors.black,
                                                                                                fontSize: 13,
                                                                                                fontWeight: FontWeight.w500,
                                                                                                letterSpacing: 0.5,
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                const Padding(padding: EdgeInsets.symmetric(vertical: 6)),
                                                                                Row(
                                                                                  children: [
                                                                                    const Padding(padding: EdgeInsets.only(left: 8)),
                                                                                    ElevatedButton(
                                                                                      onPressed: () {
                                                                                        WriteBatch batch = FirebaseFirestore.instance.batch();
                                                                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                                                                          showDialog(
                                                                                              context: context,
                                                                                              builder: (context) {
                                                                                                return AlertDialog(
                                                                                                  title: const Text(
                                                                                                    'Decline Confirmation',
                                                                                                    style: alertDialogTtl,
                                                                                                  ),
                                                                                                  content: Text(
                                                                                                    "Are you sure you want to decline Request Loan No. ${widget.loanid}?",
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
                                                                                                        await myDb.collection('loans').doc(data[index].id).get().then((loandata) {
                                                                                                          myDb.collection('coops').doc(prefs.data!.getString('coopId')).collection('loanTypes').doc(loandata.data()!['loanType'].toString().toLowerCase()).get().then((coopdata) {
                                                                                                            batch.update(myDb.collection('loans').doc(data[index].id), {'loanStatus': 'pending'});
                                                                                                            batch.set(myDb.collection('staffs').doc(FirebaseAuth.instance.currentUser!.uid).collection('transactions').doc(DateFormat('yyyyMMddHHmmss').format(DateTime.now())), {
                                                                                                              'timestamp': DateTime.now(),
                                                                                                              'context': 'Loans',
                                                                                                              'content': 'You decline loan request Loan No. ${widget.loanid}.',
                                                                                                              'title': 'Decline Loan Request',
                                                                                                              'staffId': FirebaseAuth.instance.currentUser!.uid,
                                                                                                            });
                                                                                                            batch.commit().then((value) {
                                                                                                              myDb.collection('staffs').where('coopID', isEqualTo: prefs.data!.getString('coopId')).where('staffID', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid).get().then((data) async {
                                                                                                                if (data.size > 0) {
                                                                                                                  for (int a = 0; a < data.size; a++) {
                                                                                                                    await myDb.collection('notifications').doc(prefs.data!.getString('coopId')).collection(data.docs[a]['staffID']).doc(DateFormat('yyyyMMddHHmmss').format(DateTime.now())).set({
                                                                                                                      'context': 'subscriber',
                                                                                                                      'coopId': prefs.data!.getString('coopId'),
                                                                                                                      'title': 'Decline Loan Request',
                                                                                                                      'content': "The Administrator has decline Loan No. ${widget.loanid}.",
                                                                                                                      'notifBy': FirebaseAuth.instance.currentUser!.uid,
                                                                                                                      'notifId': data.docs[a]['staffID'],
                                                                                                                      'timestamp': DateTime.now(),
                                                                                                                      'status': 'unread',
                                                                                                                    });
                                                                                                                  }
                                                                                                                }
                                                                                                              });
                                                                                                              myDb.collection('staffs').where('coopID', isEqualTo: prefs.data!.getString('coopId')).where('role', isEqualTo: 'Administrator').get().then((data) async {
                                                                                                                if (data.size > 0) {
                                                                                                                  for (int a = 0; a < data.size; a++) {
                                                                                                                    await myDb.collection('notifications').doc(prefs.data!.getString('coopId')).collection(data.docs[a]['staffID']).where('context', isEqualTo: 'declineloantoadmin').where('userId', isEqualTo: widget.subId).where('loanId', isEqualTo: widget.loanid).get().then((value) async {
                                                                                                                      if (value.size > 0) {
                                                                                                                        for (int b = 0; b < value.size; b++) {
                                                                                                                          await myDb.collection('notifications').doc(prefs.data!.getString('coopId')).collection(data.docs[a]['staffID']).doc(value.docs[b].id).delete();
                                                                                                                        }
                                                                                                                      }
                                                                                                                    });
                                                                                                                  }
                                                                                                                }
                                                                                                              });
                                                                                                            }).whenComplete(() {
                                                                                                              Navigator.pop(context);
                                                                                                              okDialog(context, 'Decline Successfully', 'You decline Loan No. ${widget.loanid}.');
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
                                                                                      },
                                                                                      style: ForTealButton,
                                                                                      child: Text(
                                                                                        'Confirm'.toUpperCase(),
                                                                                        style: const TextStyle(
                                                                                          fontFamily: FontNameDefault,
                                                                                          color: Colors.white,
                                                                                          fontSize: 14,
                                                                                          fontWeight: FontWeight.w800,
                                                                                          letterSpacing: 1,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    const Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                                                                                    ElevatedButton(
                                                                                      onPressed: () {
                                                                                        WriteBatch batch = FirebaseFirestore.instance.batch();
                                                                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                                                                          showDialog(
                                                                                              context: context,
                                                                                              builder: (context) {
                                                                                                return AlertDialog(
                                                                                                  title: const Text(
                                                                                                    'Decline Confirmation',
                                                                                                    style: alertDialogTtl,
                                                                                                  ),
                                                                                                  content: Text(
                                                                                                    "Are you sure you want to decline the confirmation request?",
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
                                                                                                        await myDb.collection('notifications').doc(prefs.data!.getString('coopId')).collection(FirebaseAuth.instance.currentUser!.uid).where('context', isEqualTo: 'declineloantoadmin').where('userId', isEqualTo: widget.subId).where('loanId', isEqualTo: widget.loanid).where('coopId', isEqualTo: prefs.data!.getString('coopId')).get().then((value) {
                                                                                                          if (value.size != 0) {
                                                                                                            for (int a = 0; a < value.size; a++) {
                                                                                                              myDb.collection('notifications').doc(prefs.data!.getString('coopId')).collection(FirebaseAuth.instance.currentUser!.uid).doc(value.docs[a].id).delete();
                                                                                                            }
                                                                                                          }
                                                                                                        }).then((val) {
                                                                                                          myDb.collection('notifications').doc(prefs.data!.getString('coopId')).collection(widget.staffid).doc(DateFormat('yyyyMMddHHmmss').format(DateTime.now())).set({
                                                                                                            'context': 'loans',
                                                                                                            'coopId': prefs.data!.getString('coopId'),
                                                                                                            'title': 'Decline Confirmation Request',
                                                                                                            'content': "The Administrator has decline your decline request for Loan Request No. ${widget.loanid}.",
                                                                                                            'notifBy': widget.staffid,
                                                                                                            'notifId': widget.staffid,
                                                                                                            'timestamp': DateTime.now(),
                                                                                                            'status': 'unread',
                                                                                                          });
                                                                                                          myDb.collection('staffs').doc(FirebaseAuth.instance.currentUser!.uid).collection('transactions').doc(DateFormat('yyyyMMddHHmmss').format(DateTime.now())).set({
                                                                                                            'timestamp': DateTime.now(),
                                                                                                            'context': 'Loans',
                                                                                                            'content': 'You declined decline request for Loan Request No. ${widget.loanid}.',
                                                                                                            'title': 'Decline Confirmation Request',
                                                                                                            'staffId': FirebaseAuth.instance.currentUser!.uid,
                                                                                                          });
                                                                                                        }, onError: (e) {
                                                                                                          okDialog(context, 'An Error Occured', 'Please try again. Later!');
                                                                                                        }).whenComplete(() {
                                                                                                          okDialog(context, 'Decline Successfully', "Request for Decline Loan Request has been declined").whenComplete(() {
                                                                                                            Navigator.pop(context);
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
                                                                                      },
                                                                                      style: ForRedButton,
                                                                                      child: Text(
                                                                                        'Decline'.toUpperCase(),
                                                                                        style: const TextStyle(
                                                                                          fontFamily: FontNameDefault,
                                                                                          color: Colors.white,
                                                                                          fontSize: 14,
                                                                                          fontWeight: FontWeight.w800,
                                                                                          letterSpacing: 1,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                )
                                                                              ],
                                                                            );
                                                                        }
                                                                      }
                                                                    } catch (e) {}
                                                                    return onWait;
                                                                  },
                                                                )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                  const Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 15)),
                                                  Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: const [
                                                          Icon(
                                                              Feather.calendar),
                                                          Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          4)),
                                                          Text(
                                                            'Payment Schedule',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  FontNameDefault,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color:
                                                                  Colors.black,
                                                              letterSpacing: 1,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Text(
                                                        '${data[0]['noMonths']} Months To Pay',
                                                        style: const TextStyle(
                                                          fontFamily:
                                                              FontNameDefault,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black,
                                                          letterSpacing: 1.3,
                                                        ),
                                                      ),
                                                      ScrollConfiguration(
                                                        behavior:
                                                            MyCustomScrollBehavior(),
                                                        child:
                                                            SingleChildScrollView(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              DataTable(
                                                                headingTextStyle:
                                                                    const TextStyle(
                                                                  fontFamily:
                                                                      FontNameDefault,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                dataTextStyle:
                                                                    const TextStyle(
                                                                  fontFamily:
                                                                      FontNameDefault,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .black,
                                                                  letterSpacing:
                                                                      1,
                                                                ),
                                                                columns: const [
                                                                  DataColumn(
                                                                      label: Text(
                                                                          'Month')),
                                                                  DataColumn(
                                                                      label: Text(
                                                                          'Est. Amount Payable')),
                                                                  DataColumn(
                                                                      label: Text(
                                                                          'Est. Monthly Interest')),
                                                                  DataColumn(
                                                                      label: Text(
                                                                          'Est. Monthly Payment')),
                                                                  DataColumn(
                                                                      label: Text(
                                                                          'Est. Balance')),
                                                                ],
                                                                rows: List
                                                                    .generate(
                                                                  data[0]['noMonths']
                                                                      .toInt(),
                                                                  (int loandetIndex) =>
                                                                      DataRow(
                                                                    cells: [
                                                                      DataCell(
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Text((loandetIndex + 1).toString()),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      DataCell(
                                                                        FutureBuilder(
                                                                          //amountpayable
                                                                          future: myDb
                                                                              .collection('coops')
                                                                              .doc(prefs.data!.getString('coopId'))
                                                                              .collection('loanTypes')
                                                                              .doc(data[0]['loanType'])
                                                                              .get(),
                                                                          builder:
                                                                              (context, snapshot) {
                                                                            if (snapshot.hasError) {
                                                                              return const Center(child: CircularProgressIndicator());
                                                                            } else {
                                                                              switch (snapshot.connectionState) {
                                                                                case ConnectionState.waiting:
                                                                                  return onWait;
                                                                                default:
                                                                                  double? amountPay = LoanFormula().getAmountPayable(data[0]['loanAmount'], snapshot.data!.data()!['interest'], data[0]['noMonths'], prefs.data!.getString('coopId').toString(), loandetIndex);

                                                                                  return Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [
                                                                                      Text(
                                                                                        'PHP ${NumberFormat('###,###,###,###,###.##').format(amountPay)}',
                                                                                        style: const TextStyle(
                                                                                          fontFamily: FontNameDefault,
                                                                                          fontSize: 16,
                                                                                          fontWeight: FontWeight.w700,
                                                                                          color: Colors.black,
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  );
                                                                              }
                                                                            }
                                                                          },
                                                                        ),
                                                                      ),
                                                                      DataCell(
                                                                        FutureBuilder(
                                                                          //monthlyinterest
                                                                          future: myDb
                                                                              .collection('coops')
                                                                              .doc(prefs.data!.getString('coopId'))
                                                                              .collection('loanTypes')
                                                                              .doc(data[0]['loanType'])
                                                                              .get(),
                                                                          builder:
                                                                              (context, snapshot) {
                                                                            if (snapshot.hasError) {
                                                                              return const Center(child: CircularProgressIndicator());
                                                                            } else {
                                                                              switch (snapshot.connectionState) {
                                                                                case ConnectionState.waiting:
                                                                                  return onWait;
                                                                                default:
                                                                                  double? monthlyRate = LoanFormula().getMonthlyInterest(data[0]['loanAmount'], snapshot.data!.data()!['interest'], data[0]['noMonths'], prefs.data!.getString('coopId').toString(), loandetIndex);

                                                                                  return Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [
                                                                                      Text(
                                                                                        'PHP ${NumberFormat('###,###,###,###,###.##').format(monthlyRate)}',
                                                                                        style: const TextStyle(
                                                                                          fontFamily: FontNameDefault,
                                                                                          fontSize: 16,
                                                                                          fontWeight: FontWeight.w700,
                                                                                          color: Colors.black,
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  );
                                                                              }
                                                                            }
                                                                          },
                                                                        ),
                                                                      ),
                                                                      DataCell(
                                                                        FutureBuilder(
                                                                          //payment
                                                                          future: myDb
                                                                              .collection('coops')
                                                                              .doc(prefs.data!.getString('coopId'))
                                                                              .collection('loanTypes')
                                                                              .doc(data[0]['loanType'])
                                                                              .get(),
                                                                          builder:
                                                                              (context, snapshot) {
                                                                            if (snapshot.hasError) {
                                                                              return const Center(child: CircularProgressIndicator());
                                                                            } else {
                                                                              switch (snapshot.connectionState) {
                                                                                case ConnectionState.waiting:
                                                                                  return onWait;
                                                                                default:
                                                                                  double? monthPay = LoanFormula().getMonthlyPayment(data[0]['loanAmount'], snapshot.data!.data()!['interest'], data[0]['noMonths'], prefs.data!.getString('coopId').toString(), loandetIndex);

                                                                                  return Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [
                                                                                      Text(
                                                                                        'PHP ${NumberFormat('###,###,###,###,###.##').format(monthPay)}',
                                                                                        style: const TextStyle(
                                                                                          fontFamily: FontNameDefault,
                                                                                          fontSize: 16,
                                                                                          fontWeight: FontWeight.w700,
                                                                                          color: Colors.black,
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  );
                                                                              }
                                                                            }
                                                                          },
                                                                        ),
                                                                      ),
                                                                      DataCell(
                                                                        FutureBuilder(
                                                                          //monthlyinterest
                                                                          future: myDb
                                                                              .collection('coops')
                                                                              .doc(prefs.data!.getString('coopId'))
                                                                              .collection('loanTypes')
                                                                              .doc(data[0]['loanType'])
                                                                              .get(),
                                                                          builder:
                                                                              (context, snapshot) {
                                                                            if (snapshot.hasError) {
                                                                              return const Center(child: CircularProgressIndicator());
                                                                            } else {
                                                                              switch (snapshot.connectionState) {
                                                                                case ConnectionState.waiting:
                                                                                  return onWait;
                                                                                default:
                                                                                  double? bal = LoanFormula().getBalance(data[0]['loanAmount'], snapshot.data!.data()!['interest'], data[0]['noMonths'], prefs.data!.getString('coopId').toString(), loandetIndex);

                                                                                  return Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [
                                                                                      Text(
                                                                                        'PHP ${NumberFormat('###,###,###,###,###.##').format(bal)}',
                                                                                        style: TextStyle(
                                                                                          fontFamily: FontNameDefault,
                                                                                          fontSize: 16,
                                                                                          fontWeight: FontWeight.w700,
                                                                                          color: Colors.red[800],
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
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                        }
                                      }
                                    } catch (e) {
                                      log('profile.dart error (stream): ${e}');
                                    }
                                    return Container();
                                  });
                          }
                        }
                      }),
                  SubProf(loanId: widget.loanid),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SubProfHeader extends StatefulWidget {
  Function callback;
  String fname, status;
  SubProfHeader(
      {super.key,
      required this.callback,
      required this.fname,
      required this.status});

  @override
  State<SubProfHeader> createState() => _SubProfHeaderState();
}

class _SubProfHeaderState extends State<SubProfHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 30, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            hoverColor: Colors.transparent,
            onTap: () {
              setState(() {
                widget.callback(0, 0);
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                color: globals.listSubProfHead[0] == true
                    ? Colors.teal[800]
                    : Colors.white,
                boxShadow: const [
                  BoxShadow(
                      color: Color.fromARGB(255, 174, 171, 171),
                      spreadRadius: 0,
                      blurStyle: BlurStyle.normal,
                      blurRadius: 0.9),
                ],
              ),
              child: Text(
                "Personal Information",
                style: TextStyle(
                    fontFamily: FontNameDefault,
                    color: globals.listSubProfHead[0] == true
                        ? Colors.white
                        : Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Visibility(
            visible: widget.status == 'pending' || widget.status == 'process'
                ? false
                : true,
            child: InkWell(
              hoverColor: Colors.transparent,
              onTap: () {
                setState(() {
                  widget.callback(1, 1);
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  color: globals.listSubProfHead[1] == true
                      ? Colors.teal[800]
                      : Colors.white,
                  boxShadow: const [
                    BoxShadow(
                        color: Color.fromARGB(255, 174, 171, 171),
                        spreadRadius: 0,
                        blurStyle: BlurStyle.normal,
                        blurRadius: 0.9),
                  ],
                ),
                child: Text(
                  "Loan Records",
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      color: globals.listSubProfHead[1] == true
                          ? Colors.white
                          : Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoanProfHeader extends StatefulWidget {
  Function callback;
  LoanProfHeader({super.key, required this.callback});

  @override
  State<LoanProfHeader> createState() => _LoanProfHeaderState();
}

class _LoanProfHeaderState extends State<LoanProfHeader> {
  List list = [true, false];
  void select(int n) {
    for (int i = 0; i < list.length; i++) {
      if (i != n) {
        list[i] = false;
      } else {
        list[i] = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 30, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            hoverColor: Colors.transparent,
            onTap: () {
              setState(() {
                select(0);
                widget.callback(0);
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                color: list[0] == true ? Colors.teal[800] : Colors.white,
                boxShadow: const [
                  BoxShadow(
                      color: Color.fromARGB(255, 174, 171, 171),
                      spreadRadius: 0,
                      blurStyle: BlurStyle.normal,
                      blurRadius: 0.9),
                ],
              ),
              child: Text(
                'Loan Details (Preview)',
                style: TextStyle(
                    fontFamily: FontNameDefault,
                    color: list[0] == true ? Colors.white : Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          InkWell(
            hoverColor: Colors.transparent,
            onTap: () {
              setState(() {
                select(1);
                widget.callback(1);
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                color: list[1] == true ? Colors.teal[800] : Colors.white,
                boxShadow: const [
                  BoxShadow(
                      color: Color.fromARGB(255, 174, 171, 171),
                      spreadRadius: 0,
                      blurStyle: BlurStyle.normal,
                      blurRadius: 0.9),
                ],
              ),
              child: Text(
                "Subscriber's Profile",
                style: TextStyle(
                    fontFamily: FontNameDefault,
                    color: list[1] == true ? Colors.white : Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
