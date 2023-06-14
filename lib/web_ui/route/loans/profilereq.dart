import 'dart:developer';

import 'package:ascoop/style.dart';
import 'package:ascoop/web_ui/1.deductionFormula.dart';
import 'package:ascoop/web_ui/1.loan_formula.dart';
import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/route/loans/approve.dart';
import 'package:ascoop/web_ui/route/loans/subprof.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ascoop/web_ui/global_var.dart' as globals;

class LoanProfileReq extends StatefulWidget {
  String loanId;

  LoanProfileReq({
    super.key,
    required this.loanId,
  });

  @override
  State<LoanProfileReq> createState() => _LoanProfileReqState();
}

class _LoanProfileReqState extends State<LoanProfileReq> {
  late int loanprofIndex;
  @override
  void initState() {
    loanprofIndex = 0;
    super.initState();
  }

  @override
  void dispose() {
    widget.loanId;
    super.dispose();
  }

  callback(int x) {
    setState(() {
      loanprofIndex = x;
    });
  }

  int index = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.loanId.isNotEmpty) {
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
                    LoanDetailsAct(
                      loanid: widget.loanId,
                    ),
                    SubProf(loanId: widget.loanId)
                  ],
                ),
              ),
            )
          ],
        ),
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/click_showprof.gif',
            color: Colors.black,
            scale: 3,
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          const Text(
            "Select a loan to view the details",
            style: TextStyle(
                fontFamily: FontNameDefault,
                fontSize: 25,
                fontWeight: FontWeight.w600),
          ),
        ],
      );
    }
  }
}

class LoanDetailsAct extends StatefulWidget {
  String loanid;
  LoanDetailsAct({super.key, required this.loanid});

  @override
  State<LoanDetailsAct> createState() => _LoanDetailsActState();
}

class _LoanDetailsActState extends State<LoanDetailsAct> {
  late final SharedPreferences prefs;
  late final prefsFuture =
      SharedPreferences.getInstance().then((v) => prefs = v);

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
                return StreamBuilder(
                    stream: myDb
                        .collection('loans')
                        .where('loanId', isEqualTo: widget.loanid)
                        .where('coopId',
                            isEqualTo: prefs.data!.getString('coopId'))
                        .snapshots(),
                    builder: (context, snapshot) {
                      try {
                        final data = snapshot.data!.docs;
                        getBal(data[0]['loanAmount']);
                        if (snapshot.hasError) {
                          log('snapshot.hasError (coopdash): ${snapshot.error}');
                          return Container();
                        } else if (snapshot.hasData && data.isNotEmpty) {
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
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  const Text(
                                                    'LOAN NUMBER',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          FontNameDefault,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${data[0]['loanId']}',
                                                    style: const TextStyle(
                                                      fontFamily:
                                                          FontNameDefault,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const Text(
                                                    'DATE REQUESTED',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          FontNameDefault,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                    DateFormat('MMM d, yyyy')
                                                        .format(data[0]
                                                                ['createdAt']
                                                            .toDate())
                                                        .toUpperCase(),
                                                    style: const TextStyle(
                                                      fontFamily:
                                                          FontNameDefault,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const Text(
                                                    'LOAN TYPE',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          FontNameDefault,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${data[0]['loanType']} LOAN'
                                                        .toUpperCase(),
                                                    style: const TextStyle(
                                                      fontFamily:
                                                          FontNameDefault,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const Text(
                                                    'EST. TOTAL PAYMENT',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          FontNameDefault,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  FutureBuilder(
                                                    //monthlyinterest
                                                    future: myDb
                                                        .collection('coops')
                                                        .doc(prefs.data!
                                                            .getString(
                                                                'coopId'))
                                                        .collection('loanTypes')
                                                        .doc(
                                                            data[0]['loanType'])
                                                        .get(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasError) {
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
                                                                data[0][
                                                                    'loanAmount'],
                                                                snapshot.data!
                                                                        .data()![
                                                                    'interest'],
                                                                data[0][
                                                                    'noMonths'],
                                                                prefs.data!
                                                                    .getString(
                                                                        'coopId')
                                                                    .toString());

                                                            return Text(
                                                              'PHP ${NumberFormat('###,###,###,###,###.##').format(totPay)}',
                                                              style:
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
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const Text(
                                                    'LOAN AMOUNT',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          FontNameDefault,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                    'PHP ${NumberFormat('###,###,###,###.##').format(data[0]['loanAmount'])}'
                                                        .toUpperCase(),
                                                    style: const TextStyle(
                                                      fontFamily:
                                                          FontNameDefault,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: Colors.black,
                                                      letterSpacing: 1.5,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  const Text(
                                                    'LOAN TENURE',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          FontNameDefault,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${NumberFormat('###,##0').format(data[0]['noMonths'])} MONTHS',
                                                    style: const TextStyle(
                                                      fontFamily:
                                                          FontNameDefault,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const Text(
                                                    'INTEREST RATE',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          FontNameDefault,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  FutureBuilder(
                                                    future: myDb
                                                        .collection('coops')
                                                        .doc(prefs.data!
                                                            .getString(
                                                                'coopId'))
                                                        .collection('loanTypes')
                                                        .doc(
                                                            data[0]['loanType'])
                                                        .get(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasError) {
                                                        log(snapshot.error
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
                                                                fontFamily:
                                                                    FontNameDefault,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Colors
                                                                    .black,
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
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const Text(
                                                    'EST. TOTAL INTEREST',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          FontNameDefault,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  FutureBuilder(
                                                    //monthlyinterest
                                                    future: myDb
                                                        .collection('coops')
                                                        .doc(prefs.data!
                                                            .getString(
                                                                'coopId'))
                                                        .collection('loanTypes')
                                                        .doc(
                                                            data[0]['loanType'])
                                                        .get(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasError) {
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
                                                                data[0][
                                                                    'loanAmount'],
                                                                snapshot.data!
                                                                        .data()![
                                                                    'interest'],
                                                                data[0][
                                                                    'noMonths'],
                                                                prefs.data!
                                                                    .getString(
                                                                        'coopId')
                                                                    .toString());

                                                            return Text(
                                                              'PHP ${NumberFormat('###,###,###,###,###.##').format(totRate)}',
                                                              style:
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
                                            EdgeInsets.symmetric(vertical: 15)),
                                    FutureBuilder(
                                        future: myDb
                                            .collection('coops')
                                            .doc(
                                                prefs.data!.getString('coopId'))
                                            .collection('loanTypes')
                                            .doc(data[0]['loanType'])
                                            .get(),
                                        builder: (context, snapshot) {
                                          try {
                                            final snap = snapshot.data!.data()!;
                                            if (snapshot.hasError) {
                                              log('snapshot.hasError (coopdash): ${snapshot.error}');
                                              return Container();
                                            } else if (snapshot.hasData &&
                                                data.isNotEmpty) {
                                              switch (
                                                  snapshot.connectionState) {
                                                case ConnectionState.waiting:
                                                  return onWait;
                                                default:
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Text(
                                                        '- DEDUCTIONS -',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              FontNameDefault,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black,
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
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  const Text(
                                                                    'CAPITAL SHARE PAID-UP',
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
                                                                  Text(
                                                                    'PHP ${NumberFormat('###,###,###,###.##').format(DeductionFormula().forDedCapital(data[0]['loanAmount'], snap['capitalFee']))}',
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
                                                              const Padding(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              8)),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  const Text(
                                                                    'SAVINGS PAID-UP',
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
                                                                  Text(
                                                                    'PHP ${NumberFormat('###,###,###,###.##').format(DeductionFormula().forDedSavings(data[0]['loanAmount'], snap['savingsFee']))}',
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
                                                              const Padding(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              8)),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  const Text(
                                                                    'TOTAL NET PROCEEDS',
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
                                                                  Text(
                                                                    'PHP ${NumberFormat('###,###,###,###.##').format(DeductionFormula().forNetProceed(data[0]['loanAmount'], ((data[0]['loanAmount'] * snap['capitalFee']) + (data[0]['loanAmount'] * snap['savingsFee']) + (data[0]['loanAmount'] * snap['serviceFee']) + ((data[0]['loanAmount'] / snap['insuranceFee']) * snap['insuranceRate'] * data[0]['noMonths']))))}',
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
                                                            ],
                                                          ),
                                                          Column(
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  const Text(
                                                                    'SERVICE FEE',
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
                                                                  Text(
                                                                    'PHP ${NumberFormat('###,###,###,###.##').format(DeductionFormula().forDedService(data[0]['loanAmount'], snap['serviceFee']))}',
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
                                                              const Padding(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              8)),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  const Text(
                                                                    'INSURANCE FEE',
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
                                                                  Text(
                                                                    'PHP ${NumberFormat('###,###,###,###.##').format(DeductionFormula().forDedInsurance(data[0]['loanAmount'], snap['insuranceFee'], snap['insuranceRate'], data[0]['noMonths']))}',
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
                                                              const Padding(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              8)),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  const Text(
                                                                    'TOTAL DEDUCTIONS',
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
                                                                  Text(
                                                                    'PHP ${NumberFormat('###,###,###,###.##').format(DeductionFormula().forTotDed((data[0]['loanAmount'] * snap['savingsFee']), (data[0]['loanAmount'] * snap['capitalFee']), (data[0]['loanAmount'] * snap['serviceFee']), ((data[0]['loanAmount'] / snap['insuranceFee']) * snap['insuranceRate'] * data[0]['noMonths'])))}',
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
                                            EdgeInsets.symmetric(vertical: 10)),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Approve this loan?',
                                          style: TextStyle(
                                            fontFamily: FontNameDefault,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Transform.scale(
                                              scale: 0.8,
                                              child: FutureBuilder(
                                                  future: myDb
                                                      .collection('coops')
                                                      .doc(prefs.data!
                                                          .getString('coopId'))
                                                      .collection('loanTypes')
                                                      .doc(data[0]['loanType'])
                                                      .get(),
                                                  builder: (context, snapshot) {
                                                    try {
                                                      final snap = snapshot
                                                          .data!
                                                          .data()!;

                                                      if (snapshot.hasError) {
                                                        log('snapshot.hasError (listloan): ${snapshot.error}');
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
                                                            int index = 0;
                                                            return ApproveLoan(
                                                              status: data[0][
                                                                  'loanStatus'],
                                                              coopId: data[0]
                                                                  ['coopId'],
                                                              loanId: data[0]
                                                                  ['loanId'],
                                                              userId: data[0]
                                                                  ['userId'],
                                                              docId: data[0].id,
                                                              index: 0,
                                                              capital: DeductionFormula()
                                                                  .forDedCapital(
                                                                      data[index]
                                                                          [
                                                                          'loanAmount'],
                                                                      snap[
                                                                          'capitalFee'])!,
                                                              service: DeductionFormula()
                                                                  .forDedService(
                                                                      data[index]
                                                                          [
                                                                          'loanAmount'],
                                                                      snap[
                                                                          'serviceFee'])!,
                                                              savings: DeductionFormula()
                                                                  .forDedSavings(
                                                                      data[index]
                                                                          [
                                                                          'loanAmount'],
                                                                      snap[
                                                                          'savingsFee'])!,
                                                              insurance: DeductionFormula().forDedInsurance(
                                                                  data[index][
                                                                      'loanAmount'],
                                                                  snap[
                                                                      'insuranceFee'],
                                                                  snap[
                                                                      'insuranceRate'],
                                                                  data[index][
                                                                      'noMonths'])!,
                                                              totDed: DeductionFormula().forTotDed(
                                                                  (data[index][
                                                                          'loanAmount'] *
                                                                      snap[
                                                                          'savingsFee']),
                                                                  (data[index][
                                                                          'loanAmount'] *
                                                                      snap[
                                                                          'capitalFee']),
                                                                  (data[index][
                                                                          'loanAmount'] *
                                                                      snap[
                                                                          'serviceFee']),
                                                                  ((data[index][
                                                                              'loanAmount'] /
                                                                          snap[
                                                                              'insuranceFee']) *
                                                                      snap[
                                                                          'insuranceRate'] *
                                                                      data[index]
                                                                          [
                                                                          'noMonths']))!,
                                                              netproceed: DeductionFormula().forNetProceed(
                                                                  data[index][
                                                                      'loanAmount'],
                                                                  ((data[index]
                                                                              [
                                                                              'loanAmount'] *
                                                                          snap[
                                                                              'capitalFee']) +
                                                                      (data[index]
                                                                              [
                                                                              'loanAmount'] *
                                                                          snap[
                                                                              'savingsFee']) +
                                                                      (data[index]
                                                                              [
                                                                              'loanAmount'] *
                                                                          snap[
                                                                              'serviceFee']) +
                                                                      ((data[index]['loanAmount'] /
                                                                              snap['insuranceFee']) *
                                                                          snap['insuranceRate'] *
                                                                          data[index]['noMonths'])))!,
                                                            );
                                                        }
                                                      }
                                                    } catch (e) {}
                                                    return onWait;
                                                  }),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 15)),
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(Feather.calendar),
                                            Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 4)),
                                            Text(
                                              'Payment Schedule',
                                              style: TextStyle(
                                                fontFamily: FontNameDefault,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black,
                                                letterSpacing: 1,
                                              ),
                                            )
                                          ],
                                        ),
                                        Text(
                                          '${data[0]['noMonths']} Months To Pay',
                                          style: const TextStyle(
                                            fontFamily: FontNameDefault,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                            letterSpacing: 1.3,
                                          ),
                                        ),
                                        ScrollConfiguration(
                                          behavior: MyCustomScrollBehavior(),
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                DataTable(
                                                  headingTextStyle:
                                                      const TextStyle(
                                                    fontFamily: FontNameDefault,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.black,
                                                  ),
                                                  dataTextStyle:
                                                      const TextStyle(
                                                    fontFamily: FontNameDefault,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                    letterSpacing: 1,
                                                  ),
                                                  columns: const [
                                                    DataColumn(
                                                        label: Text('Month')),
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
                                                  rows: List.generate(
                                                    data[0]['noMonths'].toInt(),
                                                    (int loandetIndex) =>
                                                        DataRow(
                                                      cells: [
                                                        DataCell(
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text((loandetIndex +
                                                                      1)
                                                                  .toString()),
                                                            ],
                                                          ),
                                                        ),
                                                        DataCell(
                                                          FutureBuilder(
                                                            //amountpayable
                                                            future: myDb
                                                                .collection(
                                                                    'coops')
                                                                .doc(prefs.data!
                                                                    .getString(
                                                                        'coopId'))
                                                                .collection(
                                                                    'loanTypes')
                                                                .doc(data[0][
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
                                                                    double? amountPay = LoanFormula().getAmountPayable(
                                                                        data[0][
                                                                            'loanAmount'],
                                                                        snapshot.data!.data()![
                                                                            'interest'],
                                                                        data[0][
                                                                            'noMonths'],
                                                                        prefs
                                                                            .data!
                                                                            .getString('coopId')
                                                                            .toString(),
                                                                        loandetIndex);

                                                                    return Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                          'PHP ${NumberFormat('###,###,###,###,###.##').format(amountPay)}',
                                                                          style:
                                                                              const TextStyle(
                                                                            fontFamily:
                                                                                FontNameDefault,
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                            color:
                                                                                Colors.black,
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
                                                                .collection(
                                                                    'coops')
                                                                .doc(prefs.data!
                                                                    .getString(
                                                                        'coopId'))
                                                                .collection(
                                                                    'loanTypes')
                                                                .doc(data[0][
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
                                                                    double? monthlyRate = LoanFormula().getMonthlyInterest(
                                                                        data[0][
                                                                            'loanAmount'],
                                                                        snapshot.data!.data()![
                                                                            'interest'],
                                                                        data[0][
                                                                            'noMonths'],
                                                                        prefs
                                                                            .data!
                                                                            .getString('coopId')
                                                                            .toString(),
                                                                        loandetIndex);

                                                                    return Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                          'PHP ${NumberFormat('###,###,###,###,###.##').format(monthlyRate)}',
                                                                          style:
                                                                              const TextStyle(
                                                                            fontFamily:
                                                                                FontNameDefault,
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                            color:
                                                                                Colors.black,
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
                                                                .collection(
                                                                    'coops')
                                                                .doc(prefs.data!
                                                                    .getString(
                                                                        'coopId'))
                                                                .collection(
                                                                    'loanTypes')
                                                                .doc(data[0][
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
                                                                    double? monthPay = LoanFormula().getMonthlyPayment(
                                                                        data[0][
                                                                            'loanAmount'],
                                                                        snapshot.data!.data()![
                                                                            'interest'],
                                                                        data[0][
                                                                            'noMonths'],
                                                                        prefs
                                                                            .data!
                                                                            .getString('coopId')
                                                                            .toString(),
                                                                        loandetIndex);

                                                                    return Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                          'PHP ${NumberFormat('###,###,###,###,###.##').format(monthPay)}',
                                                                          style:
                                                                              const TextStyle(
                                                                            fontFamily:
                                                                                FontNameDefault,
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                            color:
                                                                                Colors.black,
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
                                                                .collection(
                                                                    'coops')
                                                                .doc(prefs.data!
                                                                    .getString(
                                                                        'coopId'))
                                                                .collection(
                                                                    'loanTypes')
                                                                .doc(data[0][
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
                                                                    double? bal = LoanFormula().getBalance(
                                                                        data[0][
                                                                            'loanAmount'],
                                                                        snapshot.data!.data()![
                                                                            'interest'],
                                                                        data[0][
                                                                            'noMonths'],
                                                                        prefs
                                                                            .data!
                                                                            .getString('coopId')
                                                                            .toString(),
                                                                        loandetIndex);

                                                                    return Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                          'PHP ${NumberFormat('###,###,###,###,###.##').format(bal)}',
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                FontNameDefault,
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                            color:
                                                                                Colors.red[800],
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
                      } catch (e) {}
                      return Container();
                    });
            }
          }
        });
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
