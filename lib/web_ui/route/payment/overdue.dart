import 'dart:developer';

import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/route/loans/pay.dart';
import 'package:ascoop/web_ui/route/payment/profileclck.dart';
import 'package:ascoop/web_ui/route/subs/header.dart';
import 'package:ascoop/web_ui/styles/inputstyle.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListPayOver extends StatefulWidget {
  const ListPayOver({super.key});

  @override
  State<ListPayOver> createState() => _ListPayOverState();
}

class _ListPayOverState extends State<ListPayOver> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderText(
            Ttl: 'All Overdue Payments',
            subTtl: 'Overdue Payments',
          ),
          const OverdueList(),
        ],
      ),
    );
  }
}

class OverdueList extends StatefulWidget {
  const OverdueList({
    super.key,
  });

  @override
  State<OverdueList> createState() => _OverdueListState();
}

class _OverdueListState extends State<OverdueList> {
  late final TextEditingController _search;
  bool _obscure = true;
  FocusNode myFocusNode = FocusNode();
  String searchStr = "";
  bool isSearch = true;
  bool isVis = true;

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 500,
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
          child: TextFormField(
            style: inputTextStyle,
            keyboardType: TextInputType.emailAddress,
            controller: _search,
            decoration: InputDecoration(
              hintStyle: inputHintTxtStyle,
              focusedBorder: focusSearchBorder,
              border: SearchBorder,
              hintText: "Search Loan Number",
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
        PayOverdue(searchStr: searchStr, isSearch: isSearch)
      ],
    );
  }
}

class PayOverdue extends StatefulWidget {
  String searchStr;
  bool isSearch;
  PayOverdue({
    super.key,
    required this.searchStr,
    required this.isSearch,
  });

  @override
  State<PayOverdue> createState() => _PayOverdueState();
}

class _PayOverdueState extends State<PayOverdue> {
  late final SharedPreferences prefs;
  late final prefsFuture =
      SharedPreferences.getInstance().then((v) => prefs = v);
  int todayPayCnt = 0;

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
                        .collectionGroup('tenure')
                        .where('status', isEqualTo: 'pending')
                        .where('coopId',
                            isEqualTo: prefs.data!.getString('coopId'))
                        .orderBy('dueDate', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      try {
                        final data = snapshot.data!.docs;

                        if (snapshot.hasError) {
                          log('snapshot.hasError (pending.dart): ${snapshot.error}');
                          return Container();
                        } else if (snapshot.hasData && data.isNotEmpty) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return onWait;
                            default:
                              return Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, left: 15),
                                child: StreamBuilder(
                                  stream: myDb
                                      .collectionGroup('tenure')
                                      .where('status', isEqualTo: 'pending')
                                      .where('coopId',
                                          isEqualTo:
                                              prefs.data!.getString('coopId'))
                                      .where('dueDate',
                                          isLessThan: DateTime.now())
                                      .orderBy('dueDate', descending: false)
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
                                            final data = snapshot.data!.docs;
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Visibility(
                                                  visible: widget.isSearch,
                                                  child: Text(
                                                    "${NumberFormat('###,###,###').format(data.length.toInt())} Pending Payments",
                                                    style: const TextStyle(
                                                        fontFamily:
                                                            FontNameDefault,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontSize: 18,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: data.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    var listview = Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      margin: const EdgeInsets
                                                              .fromLTRB(
                                                          5, 10, 20, 5),
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(7),
                                                          boxShadow: const [
                                                            BoxShadow(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        174,
                                                                        171,
                                                                        171),
                                                                spreadRadius:
                                                                    0.8,
                                                                blurStyle:
                                                                    BlurStyle
                                                                        .normal,
                                                                blurRadius:
                                                                    0.9),
                                                          ]),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'Payment Date'
                                                                    .toUpperCase(),
                                                                style: const TextStyle(
                                                                    fontFamily:
                                                                        FontNameDefault,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontSize:
                                                                        13,
                                                                    color: Colors
                                                                        .black,
                                                                    letterSpacing:
                                                                        1),
                                                              ),
                                                              Text(
                                                                DateFormat(
                                                                        'MMM d, yyyy')
                                                                    .format(data[index]
                                                                            [
                                                                            'dueDate']
                                                                        .toDate())
                                                                    .toUpperCase(),
                                                                style: const TextStyle(
                                                                    fontFamily:
                                                                        FontNameDefault,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .black,
                                                                    letterSpacing:
                                                                        1),
                                                              ),
                                                            ],
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'Loan Number'
                                                                    .toUpperCase(),
                                                                style: const TextStyle(
                                                                    fontFamily:
                                                                        FontNameDefault,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontSize:
                                                                        13,
                                                                    color: Colors
                                                                        .black,
                                                                    letterSpacing:
                                                                        1),
                                                              ),
                                                              Text(
                                                                data[index]
                                                                    ['loanId'],
                                                                style: const TextStyle(
                                                                    fontFamily:
                                                                        FontNameDefault,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .black,
                                                                    letterSpacing:
                                                                        1),
                                                              ),
                                                            ],
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'Month'
                                                                    .toUpperCase(),
                                                                style: const TextStyle(
                                                                    fontFamily:
                                                                        FontNameDefault,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontSize:
                                                                        13,
                                                                    color: Colors
                                                                        .black,
                                                                    letterSpacing:
                                                                        1),
                                                              ),
                                                              Text(
                                                                'Month ${data[index].id}'
                                                                    .toUpperCase(),
                                                                style: const TextStyle(
                                                                    fontFamily:
                                                                        FontNameDefault,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .black,
                                                                    letterSpacing:
                                                                        1),
                                                              ),
                                                            ],
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'Payment Amount'
                                                                    .toUpperCase(),
                                                                style: const TextStyle(
                                                                    fontFamily:
                                                                        FontNameDefault,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontSize:
                                                                        13,
                                                                    color: Colors
                                                                        .black,
                                                                    letterSpacing:
                                                                        1),
                                                              ),
                                                              Text(
                                                                'PHP ${NumberFormat.decimalPattern().format(data[index]['payment'])}',
                                                                style: const TextStyle(
                                                                    fontFamily:
                                                                        FontNameDefault,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .black,
                                                                    letterSpacing:
                                                                        1),
                                                              ),
                                                            ],
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "Payer's Name"
                                                                    .toUpperCase(),
                                                                style: const TextStyle(
                                                                    fontFamily:
                                                                        FontNameDefault,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontSize:
                                                                        13,
                                                                    color: Colors
                                                                        .black,
                                                                    letterSpacing:
                                                                        1),
                                                              ),
                                                              const Padding(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              2)),
                                                              ClickProfile(
                                                                  payerid: data[
                                                                          index]
                                                                      [
                                                                      'userId']),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              SizedBox(
                                                                width: 100,
                                                                height: 35,
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) =>
                                                                              PayBtn(
                                                                        subId: data[index]
                                                                            [
                                                                            'userId'],
                                                                        month: data[index]
                                                                            [
                                                                            'month'],
                                                                        amountPayable:
                                                                            data[index]['amountPayable'],
                                                                        loanId: data[index]
                                                                            [
                                                                            'loanId'],
                                                                        docId: data[index]
                                                                            .id,
                                                                        coopId: data[index]
                                                                            [
                                                                            'coopId'],
                                                                        initial:
                                                                            data[index]['payment'],
                                                                      ),
                                                                    );
                                                                  },
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              25.0),
                                                                      side:
                                                                          const BorderSide(
                                                                        width:
                                                                            2,
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            1,
                                                                            95,
                                                                            84),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      'PAY',
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            FontNameDefault,
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.w800,
                                                                        color: Colors
                                                                            .teal[800],
                                                                        letterSpacing:
                                                                            1,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                    //to display
                                                    if (DateTime(
                                                            DateTime.now().year,
                                                            DateTime.now()
                                                                .month,
                                                            DateTime.now()
                                                                .day) !=
                                                        DateTime(
                                                          data[index]['dueDate']
                                                              .toDate()
                                                              .year,
                                                          data[index]['dueDate']
                                                              .toDate()
                                                              .month,
                                                          data[index]['dueDate']
                                                              .toDate()
                                                              .day,
                                                        )) {
                                                      if (widget.searchStr
                                                          .trim()
                                                          .isEmpty) {
                                                        return listview;
                                                      }
                                                      if (data[index]['loanId']
                                                          .toString()
                                                          .trim()
                                                          .toLowerCase()
                                                          .startsWith(widget
                                                              .searchStr
                                                              .trim()
                                                              .toString()
                                                              .toLowerCase())) {
                                                        return listview;
                                                      }
                                                      if (data[index]['loanId']
                                                          .toString()
                                                          .trim()
                                                          .toUpperCase()
                                                          .startsWith(widget
                                                              .searchStr
                                                              .trim()
                                                              .toString()
                                                              .toUpperCase())) {
                                                        return listview;
                                                      }
                                                    }
                                                    return Container();
                                                  },
                                                ),
                                              ],
                                            );
                                        }
                                      }
                                    } catch (e) {
                                      log(e.toString());
                                    }
                                    return EmptyData(
                                        ttl: 'No Overdue Payments Yet');
                                  },
                                ),
                              );
                          }
                        } else if (data.isEmpty) {
                          return EmptyData(ttl: 'No Overdue Payments Yet');
                        }
                      } catch (e) {}
                      return Container();
                    });
            }
          }
        });
  }
}
