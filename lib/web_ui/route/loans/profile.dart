import 'dart:developer';

import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/route/loans/pay.dart';
import 'package:ascoop/web_ui/route/loans/subprof.dart';
import 'package:ascoop/web_ui/route/pdfModel/loancompdf.dart';
import 'package:ascoop/web_ui/route/pdfModel/loanpdf.dart';
import 'package:ascoop/web_ui/styles/buttonstyle.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoanProfile extends StatefulWidget {
  String loanId;
  LoanProfile({
    super.key,
    required this.loanId,
  });

  @override
  State<LoanProfile> createState() => _LoanProfileState();
}

class _LoanProfileState extends State<LoanProfile> {
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
                        .snapshots(),
                    builder: (context, snapshot) {
                      try {
                        final data = snapshot.data!.docs;
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
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Text(
                                                'LOAN NUMBER',
                                                style: TextStyle(
                                                  fontFamily: FontNameDefault,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Text(
                                                '${data[0]['loanId']}',
                                                style: const TextStyle(
                                                  fontFamily: FontNameDefault,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    const Text(
                                                      'DATE ACTIVE',
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
                                                padding:
                                                    const EdgeInsets.all(8),
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
                                                padding:
                                                    const EdgeInsets.all(8),
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
                                                    Text(
                                                      'PHP ${NumberFormat('###,###,###,###.##').format(data[0]['totalPayment'])}',
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
                                                    const EdgeInsets.all(8),
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
                                                            FontWeight.w500,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    Text(
                                                      'PHP ${NumberFormat('###,###,###,###.##').format(data[0]['totalInterest'])}',
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
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  'LOAN AMOUNT',
                                                  style: TextStyle(
                                                    fontFamily: FontNameDefault,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  'PHP ${NumberFormat('###,###,###,###.##').format(data[0]['loanAmount'])}'
                                                      .toUpperCase(),
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
                                              padding: const EdgeInsets.all(8),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const Text(
                                                    "INTEREST RATE",
                                                    style: TextStyle(
                                                      fontFamily:
                                                          FontNameDefault,
                                                      fontSize: 12,
                                                      letterSpacing: 1,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  FutureBuilder(
                                                    future: myDb
                                                        .collection('coops')
                                                        .doc(data[0]['coopId'])
                                                        .collection('loanTypes')
                                                        .doc(
                                                            data[0]['loanType'])
                                                        .get(),
                                                    builder:
                                                        (context, snapshot) {
                                                      try {
                                                        if (snapshot.hasError) {
                                                          log('snapshot.hasError (coopdash): ${snapshot.error}');
                                                          return Container();
                                                        } else if (snapshot
                                                            .hasData) {
                                                          switch (snapshot
                                                              .connectionState) {
                                                            case ConnectionState
                                                                  .waiting:
                                                              return onWait;
                                                            default:
                                                              return Text(
                                                                '${NumberFormat('###.##').format(snapshot.data!.data()!['interest'] * 100)} %',
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
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              );
                                                          }
                                                        }
                                                      } catch (e) {
                                                        log(e.toString());
                                                      }
                                                      return Container();
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
                                                    'ACCEPTED BY',
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
                                                      future: FirebaseFirestore
                                                          .instance
                                                          .collection('staffs')
                                                          .doc(data[0]
                                                              ['acceptedBy'])
                                                          .get(),
                                                      builder:
                                                          (context, staffsnap) {
                                                        try {
                                                          if (staffsnap
                                                              .hasError) {
                                                            print(staffsnap
                                                                .error
                                                                .toString());
                                                          }
                                                          if (staffsnap
                                                              .hasData) {
                                                            return Row(
                                                              children: [
                                                                Text(
                                                                  '${staffsnap.data!['firstname']} ${staffsnap.data!['lastname']}'
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
                                                            );
                                                          }
                                                        } catch (e) {
                                                          log(e.toString());
                                                        }
                                                        return Text('');
                                                      }),
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
                                                    'TOTAL REMAINING BALANCE',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          FontNameDefault,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                    'PHP ${NumberFormat('###,###,###,###.##').format(data[0]['totalPayment'] - data[0]['paidAmount'])}',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          FontNameDefault,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: Colors.red[800],
                                                      letterSpacing: 1.5,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'TOTAL AMOUNT PAID',
                                          style: TextStyle(
                                            fontFamily: FontNameDefault,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          'PHP ${NumberFormat('###,###,###,###.##').format(data[0]['paidAmount'])}',
                                          style: TextStyle(
                                            fontFamily: FontNameDefault,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.teal[800],
                                            letterSpacing: 1.5,
                                          ),
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
                                                                    'PHP ${NumberFormat('###,###,###,###.##').format(data[0]['capitalFee'])}',
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
                                                                    'PHP ${NumberFormat('###,###,###,###.##').format(data[0]['savingsFee'])}',
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
                                                                    'PHP ${NumberFormat('###,###,###,###.##').format(data[0]['netProceed'])}',
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
                                                                    'PHP ${NumberFormat('###,###,###,###.##').format(data[0]['serviceFee'])}',
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
                                                                    'PHP ${NumberFormat('###,###,###,###.##').format(data[0]['insuranceFee'])}',
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
                                                                    'PHP ${NumberFormat('###,###,###,###.##').format(data[0]['totalDeduction'])}',
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
                                            EdgeInsets.symmetric(vertical: 8)),
                                    Builder(
                                      builder: (context) {
                                        if (data[0]['loanStatus'].toString() ==
                                                'active' ||
                                            data[0]['loanStatus'].toString() ==
                                                'unreceived') {
                                          return PDFSave(
                                            coopid: prefs.data!
                                                .getString('coopId')!,
                                            userid: data[0]['userId'],
                                            loanid: data[0]['loanId'],
                                          );
                                        } else {
                                          return ComPDFSave(
                                            coopid: prefs.data!
                                                .getString('coopId')!,
                                            userid: data[0]['userId'],
                                            loanid: data[0]['loanId'],
                                          );
                                        }
                                      },
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
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${data[0]['noMonthsPaid']} / ${data[0]['noMonths']} Months Paid',
                                              style: const TextStyle(
                                                fontFamily: FontNameDefault,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                                letterSpacing: 1.3,
                                              ),
                                            )
                                          ],
                                        ),
                                        ScrollConfiguration(
                                          behavior: MyCustomScrollBehavior(),
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                StreamBuilder(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collectionGroup(
                                                            'tenure')
                                                        .where('loanId',
                                                            isEqualTo:
                                                                widget.loanid)
                                                        .orderBy('dueDate')
                                                        .snapshots(),
                                                    builder:
                                                        (context, loandetsnap) {
                                                      try {
                                                        if (loandetsnap
                                                            .hasError) {
                                                          print(loandetsnap
                                                              .error
                                                              .toString());
                                                        }
                                                        if (loandetsnap
                                                                .hasData &&
                                                            loandetsnap
                                                                .data!
                                                                .docs
                                                                .isNotEmpty) {
                                                          final loandetdata =
                                                              loandetsnap
                                                                  .data!.docs;
                                                          return DataTable(
                                                            headingTextStyle:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  FontNameDefault,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            dataTextStyle:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  FontNameDefault,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.black,
                                                              letterSpacing: 1,
                                                            ),
                                                            columns: const [
                                                              DataColumn(
                                                                label: Expanded(
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                          'Month'),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              DataColumn(
                                                                label: Expanded(
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                          'Due Date'),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              DataColumn(
                                                                label: Expanded(
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                          'Amount Payable'),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              DataColumn(
                                                                label: Expanded(
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                          'Monthly Interest'),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              DataColumn(
                                                                label: Expanded(
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                          'Monthly Payment'),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              DataColumn(
                                                                label: Expanded(
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                          'Penalty'),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              DataColumn(
                                                                label: Expanded(
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                          'Paid Amount'),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              DataColumn(
                                                                label: Expanded(
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                          'Payment Amount'),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              DataColumn(
                                                                  label:
                                                                      Text('')),
                                                            ],
                                                            rows: List.generate(
                                                              loandetsnap.data!
                                                                  .docs.length
                                                                  .toInt(),
                                                              (int loandetIndex) =>
                                                                  DataRow(
                                                                cells: [
                                                                  DataCell(
                                                                    Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Icon(
                                                                          FontAwesome
                                                                              .check_circle,
                                                                          color: loandetdata[loandetIndex]['status'].toString().contains('pending')
                                                                              ? Colors.grey[600]
                                                                              : Colors.teal[800],
                                                                          size:
                                                                              20,
                                                                        ),
                                                                        const Padding(
                                                                            padding:
                                                                                EdgeInsets.symmetric(horizontal: 4)),
                                                                        Text(loandetsnap
                                                                            .data!
                                                                            .docs[loandetIndex]
                                                                            .id
                                                                            .toString())
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  DataCell(
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                          DateFormat('MMM d, yyyy')
                                                                              .format(loandetdata[loandetIndex]['dueDate'].toDate())
                                                                              .toUpperCase(),
                                                                          style:
                                                                              const TextStyle(
                                                                            fontFamily:
                                                                                FontNameDefault,
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w800,
                                                                            color:
                                                                                Colors.black,
                                                                            letterSpacing:
                                                                                1,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  DataCell(
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                            'PHP ${NumberFormat('###,###,###,###.##').format(loandetdata[loandetIndex]['amountPayable'])}'),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  DataCell(Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                          'PHP ${NumberFormat('###,###,###,###.##').format(loandetdata[loandetIndex]['monthInterest'])}'),
                                                                    ],
                                                                  )),
                                                                  DataCell(
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                          'PHP ${NumberFormat('###,###,###,###.##').format(loandetdata[loandetIndex]['monthlyPay'])}',
                                                                          style:
                                                                              const TextStyle(
                                                                            fontFamily:
                                                                                FontNameDefault,
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            color:
                                                                                Colors.black,
                                                                            letterSpacing:
                                                                                1,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  DataCell(
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Builder(builder:
                                                                            (context) {
                                                                          if (double.parse(loandetdata[loandetIndex]['penalty'].toStringAsFixed(2)) >
                                                                              0) {
                                                                            return Text(
                                                                              'PHP ${NumberFormat('###,###,###,###.##').format(loandetdata[loandetIndex]['penalty'])}',
                                                                              style: TextStyle(
                                                                                fontFamily: FontNameDefault,
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.w600,
                                                                                color: Colors.red[800],
                                                                                letterSpacing: 1,
                                                                              ),
                                                                            );
                                                                          } else {
                                                                            return const Text('');
                                                                          }
                                                                        }),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  DataCell(
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                          loandetdata[loandetIndex]['paidAmount'] == 0
                                                                              ? ''
                                                                              : 'PHP ${NumberFormat('###,###,###,###.##').format(loandetdata[loandetIndex]['paidAmount'])}',
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                FontNameDefault,
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w800,
                                                                            color:
                                                                                Colors.orange[800],
                                                                            letterSpacing:
                                                                                1,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  DataCell(
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                          'PHP ${NumberFormat('###,###,###,###.##').format(loandetdata[loandetIndex]['payment'])}',
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                FontNameDefault,
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w800,
                                                                            color:
                                                                                Colors.teal[800],
                                                                            letterSpacing:
                                                                                1,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  prefs.data!
                                                                              .getString(
                                                                                  'myRole')
                                                                              .toString()
                                                                              .toLowerCase() ==
                                                                          'bookkeeper'
                                                                      ? const DataCell(
                                                                          Text(
                                                                              ''))
                                                                      : DataCell(
                                                                          Builder(
                                                                            builder:
                                                                                (context) {
                                                                              var pendingFrst;
                                                                              for (int a = 0; a < loandetdata.length; a++) {
                                                                                if (loandetdata[a]['status'].toString().toLowerCase() == 'pending') {
                                                                                  pendingFrst = a;
                                                                                  break;
                                                                                }
                                                                              }

                                                                              if (loandetIndex == pendingFrst) {
                                                                                return SizedBox(
                                                                                  width: 70,
                                                                                  height: 30,
                                                                                  child: ElevatedButton(
                                                                                    onPressed: () {
                                                                                      showDialog(
                                                                                        context: context,
                                                                                        builder: (context) => PayBtn(
                                                                                          coopId: loandetdata[loandetIndex]['coopId'],
                                                                                          subId: loandetdata[loandetIndex]['userId'],
                                                                                          month: loandetdata[loandetIndex]['month'],
                                                                                          amountPayable: loandetdata[loandetIndex]['amountPayable'],
                                                                                          loanId: loandetdata[loandetIndex]['loanId'],
                                                                                          initial: loandetdata[loandetIndex]['payment'],
                                                                                          docId: loandetdata[loandetIndex].id,
                                                                                        ),
                                                                                      );
                                                                                    },
                                                                                    style: ElevatedButton.styleFrom(
                                                                                      backgroundColor: Colors.teal[800],
                                                                                      shape: RoundedRectangleBorder(
                                                                                        borderRadius: BorderRadius.circular(25.0),
                                                                                      ),
                                                                                    ),
                                                                                    child: const Center(
                                                                                      child: Text(
                                                                                        'PAY',
                                                                                        style: TextStyle(
                                                                                          fontFamily: FontNameDefault,
                                                                                          fontSize: 11,
                                                                                          fontWeight: FontWeight.w800,
                                                                                          color: Colors.white,
                                                                                          letterSpacing: 1,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              } else if (loandetdata[loandetIndex]['status'].toString().toLowerCase() == 'pending' && loandetIndex != pendingFrst) {
                                                                                return SizedBox(
                                                                                  width: 70,
                                                                                  height: 30,
                                                                                  child: Container(
                                                                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), border: Border.all(width: 2, color: orange8)),
                                                                                    child: Center(
                                                                                      child: Text(
                                                                                        'PENDING',
                                                                                        style: TextStyle(
                                                                                          fontFamily: FontNameDefault,
                                                                                          fontSize: 10,
                                                                                          fontWeight: FontWeight.w800,
                                                                                          color: Colors.orange[800],
                                                                                          letterSpacing: 1,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              } else if (loandetdata[loandetIndex]['status'].toString().toLowerCase() == 'paid') {
                                                                                return InkWell(
                                                                                  hoverColor: Colors.transparent,
                                                                                  splashColor: Colors.transparent,
                                                                                  highlightColor: Colors.transparent,
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: [
                                                                                      Container(
                                                                                        width: 70,
                                                                                        height: 30,
                                                                                        decoration: BoxDecoration(
                                                                                            color: Colors.white,
                                                                                            borderRadius: BorderRadius.circular(25),
                                                                                            border: Border.all(
                                                                                              width: 2,
                                                                                              color: red8,
                                                                                            )),
                                                                                        child: Center(
                                                                                          child: Text(
                                                                                            'PAID',
                                                                                            style: TextStyle(
                                                                                              fontFamily: FontNameDefault,
                                                                                              fontSize: 10,
                                                                                              fontWeight: FontWeight.w800,
                                                                                              color: Colors.red[800],
                                                                                              letterSpacing: 1,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      const Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
                                                                                      Icon(
                                                                                        FontAwesomeIcons.circleInfo,
                                                                                        size: 15,
                                                                                        color: Colors.red[800],
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                  onTap: () {
                                                                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                                                                      showDialog(
                                                                                        context: context,
                                                                                        builder: (context) {
                                                                                          return AlertDialog(
                                                                                            title: const Text(
                                                                                              'Payment Details',
                                                                                              style: alertDialogTtl,
                                                                                            ),
                                                                                            content: FutureBuilder(
                                                                                                future: myDb.collection('payment').where('loanId', isEqualTo: widget.loanid).where('coopId', isEqualTo: loandetdata[loandetIndex]['coopId']).where('tenureId', isEqualTo: loandetdata[loandetIndex]['month'].toString()).orderBy('timestamp', descending: true).get(),
                                                                                                builder: (context, snapshot) {
                                                                                                  try {
                                                                                                    final data = snapshot.data!.docs;
                                                                                                    if (snapshot.hasError) {
                                                                                                      log('snapshot.hasError (coopdash): ${snapshot.error}');
                                                                                                      return Container();
                                                                                                    } else if (snapshot.hasData && data.isNotEmpty) {
                                                                                                      switch (snapshot.connectionState) {
                                                                                                        case ConnectionState.waiting:
                                                                                                          return onWait;
                                                                                                        default:
                                                                                                          return SizedBox(
                                                                                                            width: 600,
                                                                                                            height: 800,
                                                                                                            child: ScrollConfiguration(
                                                                                                              behavior: MyCustomScrollBehavior(),
                                                                                                              child: SingleChildScrollView(
                                                                                                                child: ListView.builder(
                                                                                                                  shrinkWrap: true,
                                                                                                                  itemCount: data.length,
                                                                                                                  itemBuilder: (context, index) {
                                                                                                                    return Container(
                                                                                                                      width: MediaQuery.of(context).size.width,
                                                                                                                      margin: const EdgeInsets.all(8),
                                                                                                                      padding: const EdgeInsets.all(10),
                                                                                                                      decoration: BoxDecoration(
                                                                                                                        color: Colors.white,
                                                                                                                        borderRadius: BorderRadius.circular(8),
                                                                                                                        boxShadow: [
                                                                                                                          BoxShadow(color: grey4, spreadRadius: 0.8, blurStyle: BlurStyle.normal, blurRadius: 0.8),
                                                                                                                        ],
                                                                                                                      ),
                                                                                                                      child: Row(
                                                                                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                                                        children: [
                                                                                                                          Column(
                                                                                                                            children: [
                                                                                                                              Column(
                                                                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                                                children: [
                                                                                                                                  Text(
                                                                                                                                    'Date Paid'.toUpperCase(),
                                                                                                                                    style: const TextStyle(fontFamily: FontNameDefault, fontWeight: FontWeight.w400, fontSize: 11, color: Colors.black, letterSpacing: 1),
                                                                                                                                  ),
                                                                                                                                  Text(
                                                                                                                                    DateFormat('MMM d, yyyy').format(data[index]['timestamp'].toDate()).toUpperCase(),
                                                                                                                                    style: const TextStyle(fontFamily: FontNameDefault, fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black, letterSpacing: 1),
                                                                                                                                  ),
                                                                                                                                ],
                                                                                                                              ),
                                                                                                                              const Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                                                                                                                              Column(
                                                                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                                                children: [
                                                                                                                                  Text(
                                                                                                                                    'Amount Paid'.toUpperCase(),
                                                                                                                                    style: const TextStyle(fontFamily: FontNameDefault, fontWeight: FontWeight.w400, fontSize: 11, color: Colors.black, letterSpacing: 1),
                                                                                                                                  ),
                                                                                                                                  Text(
                                                                                                                                    'PHP ${NumberFormat('###,###,###,###,###.##').format(data[index]['amount'])}'.toUpperCase(),
                                                                                                                                    style: const TextStyle(fontFamily: FontNameDefault, fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black, letterSpacing: 1),
                                                                                                                                  ),
                                                                                                                                ],
                                                                                                                              ),
                                                                                                                              const Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                                                                                                                              Column(
                                                                                                                                children: [
                                                                                                                                  Column(
                                                                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                                                    children: [
                                                                                                                                      Text(
                                                                                                                                        'Payment Method'.toUpperCase(),
                                                                                                                                        style: const TextStyle(fontFamily: FontNameDefault, fontWeight: FontWeight.w400, fontSize: 11, color: Colors.black, letterSpacing: 1),
                                                                                                                                      ),
                                                                                                                                      Text(
                                                                                                                                        data[index]['paymentMethod'].toUpperCase(),
                                                                                                                                        style: const TextStyle(fontFamily: FontNameDefault, fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black, letterSpacing: 1),
                                                                                                                                      ),
                                                                                                                                    ],
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
                                                                                                                                  Text(
                                                                                                                                    'Due Date'.toUpperCase(),
                                                                                                                                    style: const TextStyle(fontFamily: FontNameDefault, fontWeight: FontWeight.w400, fontSize: 11, color: Colors.black, letterSpacing: 1),
                                                                                                                                  ),
                                                                                                                                  Text(
                                                                                                                                    DateFormat('MMM d, yyyy').format(data[index]['dueDate'].toDate()).toUpperCase(),
                                                                                                                                    style: const TextStyle(fontFamily: FontNameDefault, fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black, letterSpacing: 1),
                                                                                                                                  ),
                                                                                                                                ],
                                                                                                                              ),
                                                                                                                              const Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                                                                                                                              Column(
                                                                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                                                children: [
                                                                                                                                  Text(
                                                                                                                                    "Received By".toUpperCase(),
                                                                                                                                    style: const TextStyle(
                                                                                                                                      fontFamily: FontNameDefault,
                                                                                                                                      fontWeight: FontWeight.w400,
                                                                                                                                      fontSize: 11,
                                                                                                                                      color: Colors.black,
                                                                                                                                      letterSpacing: 1,
                                                                                                                                    ),
                                                                                                                                  ),
                                                                                                                                  FutureBuilder(
                                                                                                                                      future: myDb.collection('staffs').doc(data[index]['receivedBy']).get(),
                                                                                                                                      builder: (context, usersnap) {
                                                                                                                                        try {
                                                                                                                                          final data = usersnap.data!.data()!;
                                                                                                                                          if (usersnap.hasError) {
                                                                                                                                            log('snapshot.hasError (coopdash): ${usersnap.error}');
                                                                                                                                            return Container();
                                                                                                                                          } else if (snapshot.hasData && data.isNotEmpty) {
                                                                                                                                            switch (snapshot.connectionState) {
                                                                                                                                              case ConnectionState.waiting:
                                                                                                                                                return onWait;
                                                                                                                                              default:
                                                                                                                                                return Text(
                                                                                                                                                  '${data['firstname']} ${data['lastname']}'.toUpperCase(),
                                                                                                                                                  style: const TextStyle(
                                                                                                                                                    fontFamily: FontNameDefault,
                                                                                                                                                    fontWeight: FontWeight.w600,
                                                                                                                                                    fontSize: 14,
                                                                                                                                                    color: Colors.black,
                                                                                                                                                    letterSpacing: 1,
                                                                                                                                                  ),
                                                                                                                                                );
                                                                                                                                            }
                                                                                                                                          } else {
                                                                                                                                            return Container();
                                                                                                                                          }
                                                                                                                                        } catch (e) {
                                                                                                                                          log(e.toString());
                                                                                                                                          return Container();
                                                                                                                                        }
                                                                                                                                      }),
                                                                                                                                ],
                                                                                                                              ),
                                                                                                                              const Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                                                                                                                              Column(
                                                                                                                                children: [
                                                                                                                                  Column(
                                                                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                                                    children: [
                                                                                                                                      Text(
                                                                                                                                        'PAYMENT STATUS'.toUpperCase(),
                                                                                                                                        style: const TextStyle(fontFamily: FontNameDefault, fontWeight: FontWeight.w400, fontSize: 11, color: Colors.black, letterSpacing: 1),
                                                                                                                                      ),
                                                                                                                                      Builder(builder: (context) {
                                                                                                                                        switch (data[index]['payStatus']) {
                                                                                                                                          case 'partial':
                                                                                                                                            return Text(
                                                                                                                                              data[index]['payStatus'].toUpperCase(),
                                                                                                                                              style: TextStyle(fontFamily: FontNameDefault, fontWeight: FontWeight.w600, fontSize: 14, color: Colors.orange[800], letterSpacing: 1),
                                                                                                                                            );

                                                                                                                                          case 'overdue':
                                                                                                                                            return Text(
                                                                                                                                              data[index]['payStatus'].toUpperCase(),
                                                                                                                                              style: TextStyle(fontFamily: FontNameDefault, fontWeight: FontWeight.w600, fontSize: 14, color: Colors.red[800], letterSpacing: 1),
                                                                                                                                            );
                                                                                                                                          default:
                                                                                                                                            return Text(
                                                                                                                                              data[index]['payStatus'].toUpperCase(),
                                                                                                                                              style: TextStyle(fontFamily: FontNameDefault, fontWeight: FontWeight.w600, fontSize: 14, color: Colors.teal[800], letterSpacing: 1),
                                                                                                                                            );
                                                                                                                                        }
                                                                                                                                      }),
                                                                                                                                    ],
                                                                                                                                  ),
                                                                                                                                ],
                                                                                                                              ),
                                                                                                                            ],
                                                                                                                          )
                                                                                                                        ],
                                                                                                                      ),
                                                                                                                    );
                                                                                                                  },
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                          );
                                                                                                      }
                                                                                                    }
                                                                                                  } catch (e) {}
                                                                                                  return Container();
                                                                                                }),
                                                                                            actions: [
                                                                                              ElevatedButton(
                                                                                                onPressed: () {
                                                                                                  Navigator.pop(context);
                                                                                                },
                                                                                                style: ForTealButton,
                                                                                                child: const Padding(
                                                                                                  padding: EdgeInsets.all(8.0),
                                                                                                  child: Text(
                                                                                                    'OK',
                                                                                                    style: alertDialogBtn,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          );
                                                                                        },
                                                                                      );
                                                                                    });
                                                                                  },
                                                                                );
                                                                              } else {
                                                                                return Container();
                                                                              }
                                                                            },
                                                                          ),
                                                                        ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                      } catch (e) {
                                                        print(
                                                            'loandet cnt: ${loandetsnap.data!.docs.length}');
                                                        log(e.toString());
                                                      }
                                                      return Text('');
                                                    }),
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
                'Loan Details',
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
