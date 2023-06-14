import 'dart:developer';

import 'package:ascoop/web_ui/1.deductionFormula.dart';
import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/route/loans/approve.dart';
import 'package:ascoop/web_ui/route/subs/header.dart';
import 'package:ascoop/web_ui/styles/inputstyle.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListLoanReq extends StatefulWidget {
  Function callback;
  ListLoanReq({super.key, required this.callback});

  @override
  State<ListLoanReq> createState() => _ListLoanReqState();
}

class _ListLoanReqState extends State<ListLoanReq> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 480,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        border: Border(
            right: BorderSide(
                width: 1.0, color: Color.fromARGB(255, 203, 203, 203))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderText(
            Ttl: 'All Loan Requests',
            subTtl: 'Loan Requests',
          ),
          Expanded(
            child: LoanList(
              callback: widget.callback,
            ),
          ),
        ],
      ),
    );
  }
}

class LoanList extends StatefulWidget {
  Function callback;
  LoanList({
    super.key,
    required this.callback,
  });

  @override
  State<LoanList> createState() => _LoanListState();
}

class _LoanListState extends State<LoanList> {
  late final TextEditingController _search;
  bool _obscure = true;
  FocusNode myFocusNode = FocusNode();
  String searchStr = "";
  bool isSearch = true;
  @override
  void initState() {
    _search = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
            child: TextFormField(
              style: inputTextStyle,
              keyboardType: TextInputType.emailAddress,
              controller: _search,
              decoration: InputDecoration(
                hintStyle: inputHintTxtStyle,
                focusedBorder: focusSearchBorder,
                border: SearchBorder,
                hintText: "Search Loan Number or Subscriber's Name",
                prefixIcon: Icon(
                  Feather.search,
                  size: 20,
                  color: Colors.teal[800],
                ),
              ),
              onChanged: (str) {
                setState(() {
                  searchStr = str;
                });
                if (str.isEmpty) {
                  setState(() {
                    isSearch = true;
                  });
                } else {
                  setState(() {
                    isSearch = false;
                  });
                }
              },
            ),
          ),
          Expanded(
            child: LoanReqList(
              searchStr: searchStr,
              callback: widget.callback,
              isSearch: isSearch,
            ),
          ),
        ],
      ),
    );
  }
}

class LoanReqList extends StatefulWidget {
  String searchStr;
  Function callback;
  bool isSearch;
  LoanReqList(
      {this.searchStr = '',
      required this.callback,
      required this.isSearch,
      super.key});

  @override
  State<LoanReqList> createState() => _LoanReqListState();
}

class _LoanReqListState extends State<LoanReqList> {
  late final SharedPreferences prefs;
  late final prefsFuture =
      SharedPreferences.getInstance().then((v) => prefs = v);
  var _controller = ScrollController(keepScrollOffset: true);
  var _loan = <bool>[];
  int cnt = 0;
  list(int count) {
    cnt = count;
    for (int a = 0; a < cnt; a++) {
      _loan.add(false);
    }
  }

  select(int num) {
    for (int i = 0; i < cnt; i++) {
      if (i != num) {
        _loan[i] = false;
      } else {
        _loan[i] = true;
      }
    }
  }

  @override
  void dispose() {
    _loan;
    widget.searchStr;
    cnt;
    _controller;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: FutureBuilder(
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
                      .where('coopId',
                          isEqualTo: prefs.data!.getString('coopId'))
                      .where('loanStatus', whereIn: ['pending', 'process'])
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    try {
                      final data = snapshot.data!.docs;

                      if (snapshot.hasError) {
                        log('snapshot.hasError (listloan): ${snapshot.error}');
                        return Container();
                      } else if (snapshot.hasData && data.isNotEmpty) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return onWait;
                          default:
                            list(data.length); //get all subs to array of bool
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Visibility(
                                  visible: widget.isSearch,
                                  child: Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(15, 5, 10, 0),
                                    child: Text(
                                      '${NumberFormat('###,###,###').format(data.length.toInt())} Loan Requests',
                                      style: TextStyle(
                                        fontFamily: FontNameDefault,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.orange[900],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      controller: _controller,
                                      itemCount: data.length,
                                      itemBuilder: (context, index) {
                                        var listOf = InkWell(
                                          hoverColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          onTap: () {
                                            setState(() {
                                              int sel = index;
                                              setState(() {
                                                select(sel);
                                                widget.callback(
                                                    data[sel]['loanId']);
                                              });
                                            });
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.fromLTRB(
                                                15, 8, 15, 8),
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 8, 0, 8),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(
                                                    color: _loan[index] == true
                                                        ? orange8
                                                        : Colors.transparent,
                                                    width: 2),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color:
                                                          _loan[index] == true
                                                              ? orange8
                                                              : grey4,
                                                      spreadRadius: 0.2,
                                                      blurStyle:
                                                          BlurStyle.normal,
                                                      blurRadius: 1.6),
                                                ]),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 90,
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      CircularPercentIndicator(
                                                        radius: 40,
                                                        lineWidth: 4.0,
                                                        center: const Center(
                                                          child: Text(
                                                            '-',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    FontNameDefault,
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800),
                                                          ),
                                                        ),
                                                        progressColor:
                                                            Colors.orange[800],
                                                      ),
                                                      const Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 2)),
                                                      Text(
                                                        '${data[index]['loanType']} loan'
                                                            .toUpperCase(),
                                                        style: const TextStyle(
                                                          fontFamily:
                                                              FontNameDefault,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 4)),
                                                Expanded(
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 135,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      const Text(
                                                                        'LOAN AMOUNT',
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              FontNameDefault,
                                                                          fontSize:
                                                                              11,
                                                                          letterSpacing:
                                                                              1,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        'PHP ${NumberFormat('###,###,###,###.##').format(data[index]['loanAmount'])}',
                                                                        style:
                                                                            const TextStyle(
                                                                          fontFamily:
                                                                              FontNameDefault,
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.w700,
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          vertical:
                                                                              3)),
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      const Text(
                                                                        'DATE REQUESTED',
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              FontNameDefault,
                                                                          fontSize:
                                                                              11,
                                                                          letterSpacing:
                                                                              1,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        DateFormat('MMM d, yyyy')
                                                                            .format(data[index]['createdAt'].toDate())
                                                                            .toUpperCase(),
                                                                        style:
                                                                            const TextStyle(
                                                                          fontFamily:
                                                                              FontNameDefault,
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.w700,
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          vertical:
                                                                              3)),
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      const Text(
                                                                        "INTEREST RATE",
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              FontNameDefault,
                                                                          fontSize:
                                                                              11,
                                                                          letterSpacing:
                                                                              1,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                      ),
                                                                      FutureBuilder(
                                                                        future: myDb
                                                                            .collection('coops')
                                                                            .doc(data[index]['coopId'])
                                                                            .collection('loanTypes')
                                                                            .doc(data[index]['loanType'])
                                                                            .get(),
                                                                        builder:
                                                                            (context,
                                                                                snapshot) {
                                                                          try {
                                                                            if (snapshot.hasError) {
                                                                              log('snapshot.hasError (coopdash): ${snapshot.error}');
                                                                              return Container();
                                                                            } else if (snapshot.hasData) {
                                                                              switch (snapshot.connectionState) {
                                                                                case ConnectionState.waiting:
                                                                                  return onWait;
                                                                                default:
                                                                                  return Text(
                                                                                    '${NumberFormat('###.##').format(snapshot.data!.data()!['interest'] * 100)} %',
                                                                                    style: const TextStyle(
                                                                                      fontFamily: FontNameDefault,
                                                                                      fontSize: 15,
                                                                                      fontWeight: FontWeight.w700,
                                                                                      color: Colors.black,
                                                                                    ),
                                                                                    overflow: TextOverflow.ellipsis,
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
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 195,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          const Text(
                                                                            'LOAN NUMBER',
                                                                            style:
                                                                                TextStyle(
                                                                              fontFamily: FontNameDefault,
                                                                              fontSize: 11,
                                                                              letterSpacing: 1,
                                                                              fontWeight: FontWeight.w400,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            '${data[index]['loanId']}',
                                                                            style:
                                                                                const TextStyle(
                                                                              fontFamily: FontNameDefault,
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.w700,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const Padding(
                                                                          padding:
                                                                              EdgeInsets.symmetric(vertical: 3)),
                                                                      const Text(
                                                                        "SUBSCRIBER'S NAME",
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              FontNameDefault,
                                                                          fontSize:
                                                                              11,
                                                                          letterSpacing:
                                                                              1,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                      ),
                                                                      StreamBuilder(
                                                                        stream: FirebaseFirestore
                                                                            .instance
                                                                            .collection(
                                                                                'subscribers')
                                                                            .where('userId',
                                                                                isEqualTo: data[index]['userId'])
                                                                            .snapshots(),
                                                                        builder:
                                                                            (context,
                                                                                snapshot) {
                                                                          try {
                                                                            if (snapshot.hasError) {
                                                                              log('snapshot.hasError (coopdash): ${snapshot.error}');
                                                                              return Container();
                                                                            } else if (snapshot.hasData) {
                                                                              switch (snapshot.connectionState) {
                                                                                case ConnectionState.waiting:
                                                                                  return onWait;
                                                                                default:
                                                                                  return Text(
                                                                                    '${snapshot.data!.docs[0]['userFirstName']} ${snapshot.data!.docs[0]['userMiddleName'].toString()[0]}. ${snapshot.data!.docs[0]['userLastName']}'.toUpperCase(),
                                                                                    style: const TextStyle(
                                                                                      fontFamily: FontNameDefault,
                                                                                      fontSize: 15,
                                                                                      fontWeight: FontWeight.w700,
                                                                                      color: Colors.black,
                                                                                    ),
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                  );
                                                                              }
                                                                            }
                                                                          } catch (e) {
                                                                            log(e.toString());
                                                                          }
                                                                          return Container();
                                                                        },
                                                                      ),
                                                                      const Padding(
                                                                          padding:
                                                                              EdgeInsets.symmetric(vertical: 3)),
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          const Text(
                                                                            'LOAN TENURE',
                                                                            style:
                                                                                TextStyle(
                                                                              fontFamily: FontNameDefault,
                                                                              fontSize: 11,
                                                                              letterSpacing: 1,
                                                                              fontWeight: FontWeight.w400,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            '${NumberFormat("###,##0", "en_US").format(data[index]['noMonths'])} MONTHS',
                                                                            style:
                                                                                const TextStyle(
                                                                              fontFamily: FontNameDefault,
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.w700,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Visibility(
                                                          visible:
                                                              _loan[index] ==
                                                                      false
                                                                  ? false
                                                                  : true,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 10,
                                                                    top: 10),
                                                            child:
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
                                                                        .doc(data[index]
                                                                            [
                                                                            'loanType'])
                                                                        .get(),
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      try {
                                                                        final snap = snapshot
                                                                            .data!
                                                                            .data()!;

                                                                        if (snapshot
                                                                            .hasError) {
                                                                          log('snapshot.hasError (listloan): ${snapshot.error}');
                                                                          return Container();
                                                                        } else if (snapshot.hasData &&
                                                                            data.isNotEmpty) {
                                                                          switch (
                                                                              snapshot.connectionState) {
                                                                            case ConnectionState.waiting:
                                                                              return onWait;
                                                                            default:
                                                                              return ApproveLoan(
                                                                                status: data[index]['loanStatus'],
                                                                                coopId: data[index]['coopId'],
                                                                                loanId: data[index]['loanId'],
                                                                                userId: data[index]['userId'],
                                                                                docId: data[index].id,
                                                                                index: index,
                                                                                capital: DeductionFormula().forDedCapital(data[index]['loanAmount'], snap['capitalFee'])!,
                                                                                service: DeductionFormula().forDedService(data[index]['loanAmount'], snap['serviceFee'])!,
                                                                                savings: DeductionFormula().forDedSavings(data[index]['loanAmount'], snap['savingsFee'])!,
                                                                                insurance: DeductionFormula().forDedInsurance(data[index]['loanAmount'], snap['insuranceFee'], snap['insuranceRate'], data[index]['noMonths'])!,
                                                                                totDed: DeductionFormula().forTotDed((data[index]['loanAmount'] * snap['savingsFee']), (data[index]['loanAmount'] * snap['capitalFee']), (data[index]['loanAmount'] * snap['serviceFee']), ((data[index]['loanAmount'] / snap['insuranceFee']) * snap['insuranceRate'] * data[index]['noMonths']))!,
                                                                                netproceed: DeductionFormula().forNetProceed(data[index]['loanAmount'], ((data[index]['loanAmount'] * snap['capitalFee']) + (data[index]['loanAmount'] * snap['savingsFee']) + (data[index]['loanAmount'] * snap['serviceFee']) + ((data[index]['loanAmount'] / snap['insuranceFee']) * snap['insuranceRate'] * data[index]['noMonths'])))!,
                                                                              );
                                                                          }
                                                                        }
                                                                      } catch (e) {}
                                                                      return onWait;
                                                                    }),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );

                                        if (widget.searchStr.trim().isEmpty) {
                                          return listOf;
                                        }
                                        // if ('${data[index]['userFirstName']} ${data[index]['userMiddleName']} ${data[index]['userLastName']}'
                                        //     .trim()
                                        //     .toLowerCase()
                                        //     .startsWith(widget.searchStr
                                        //         .trim()
                                        //         .toString()
                                        //         .toLowerCase())) {
                                        //   return listOf;
                                        // }
                                        // if ('${data[index]['userFirstName']} ${data[index]['userLastName']} ${data[index]['userMiddleName']}'
                                        //     .trim()
                                        //     .toLowerCase()
                                        //     .startsWith(widget.searchStr
                                        //         .trim()
                                        //         .toString()
                                        //         .toLowerCase())) {
                                        //   return listOf;
                                        // }
                                        // if ('${data[index]['userMiddleName']} ${data[index]['userFirstName']} ${data[index]['userLastName']}'
                                        //     .trim()
                                        //     .toLowerCase()
                                        //     .startsWith(widget.searchStr
                                        //         .trim()
                                        //         .toString()
                                        //         .toLowerCase())) {
                                        //   return listOf;
                                        // }
                                        // if ('${data[index]['userMiddleName']} ${data[index]['userLastName']} ${data[index]['userFirstName']}'
                                        //     .trim()
                                        //     .toLowerCase()
                                        //     .startsWith(widget.searchStr
                                        //         .trim()
                                        //         .toString()
                                        //         .toLowerCase())) {
                                        //   return listOf;
                                        // }
                                        // if ('${data[index]['userLastName']} ${data[index]['userMiddleName']} ${data[index]['userFirstName']}'
                                        //     .trim()
                                        //     .toLowerCase()
                                        //     .startsWith(widget.searchStr
                                        //         .trim()
                                        //         .toString()
                                        //         .toLowerCase())) {
                                        //   return listOf;
                                        // }
                                        // if ('${data[index]['userLastName']} ${data[index]['userFirstName']} ${data[index]['userMiddleName']}'
                                        //     .trim()
                                        //     .toLowerCase()
                                        //     .startsWith(widget.searchStr
                                        //         .trim()
                                        //         .toString()
                                        //         .toLowerCase())) {
                                        //   return listOf;
                                        // }

                                        // //reciprocal
                                        // if ('${data[index]['userFirstName']} ${data[index]['userMiddleName']} ${data[index]['userLastName']}'
                                        //     .trim()
                                        //     .toUpperCase()
                                        //     .startsWith(widget.searchStr
                                        //         .trim()
                                        //         .toString()
                                        //         .toUpperCase())) {
                                        //   return listOf;
                                        // }
                                        // if ('${data[index]['userFirstName']} ${data[index]['userLastName']} ${data[index]['userMiddleName']}'
                                        //     .trim()
                                        //     .toUpperCase()
                                        //     .startsWith(widget.searchStr
                                        //         .trim()
                                        //         .toString()
                                        //         .toUpperCase())) {
                                        //   return listOf;
                                        // }
                                        // if ('${data[index]['userMiddleName']} ${data[index]['userFirstName']} ${data[index]['userLastName']}'
                                        //     .trim()
                                        //     .toUpperCase()
                                        //     .startsWith(widget.searchStr
                                        //         .trim()
                                        //         .toString()
                                        //         .toUpperCase())) {
                                        //   return listOf;
                                        // }
                                        // if ('${data[index]['userMiddleName']} ${data[index]['userLastName']} ${data[index]['userFirstName']}'
                                        //     .trim()
                                        //     .toUpperCase()
                                        //     .startsWith(widget.searchStr
                                        //         .trim()
                                        //         .toString()
                                        //         .toUpperCase())) {
                                        //   return listOf;
                                        // }
                                        // if ('${data[index]['userLastName']} ${data[index]['userMiddleName']} ${data[index]['userFirstName']}'
                                        //     .trim()
                                        //     .toUpperCase()
                                        //     .startsWith(widget.searchStr
                                        //         .trim()
                                        //         .toString()
                                        //         .toUpperCase())) {
                                        //   return listOf;
                                        // }
                                        // if ('${data[index]['userLastName']} ${data[index]['userFirstName']} ${data[index]['userMiddleName']}'
                                        //     .trim()
                                        //     .toUpperCase()
                                        //     .startsWith(widget.searchStr
                                        //         .trim()
                                        //         .toString()
                                        //         .toUpperCase())) {
                                        //   return listOf;
                                        // }

                                        if (data[index]['loanId']
                                            .toString()
                                            .trim()
                                            .toLowerCase()
                                            .startsWith(widget.searchStr
                                                .trim()
                                                .toString()
                                                .toLowerCase())) {
                                          return listOf;
                                        }
                                        if (data[index]['loanId']
                                            .toString()
                                            .trim()
                                            .toUpperCase()
                                            .startsWith(widget.searchStr
                                                .trim()
                                                .toString()
                                                .toUpperCase())) {
                                          return listOf;
                                        }

                                        return Container();
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            );
                        }
                      } else if (data.isEmpty) {
                        return EmptyData(ttl: 'No Loan Request Yet');
                      }
                    } catch (e) {
                      log('listloan.dart error (stream): ${e.toString()}');
                    }
                    return Container(/** if null */);
                  },
                );
            }
          }
        },
      ),
    );
  }
}
