import 'dart:developer';

import 'package:ascoop/web_ui/constants.dart';
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
    return SizedBox(
      width: MediaQuery.of(context).size.width,
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
                              return StreamBuilder(
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
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15.0, top: 8),
                                                  child: Text(
                                                    "${NumberFormat('###,###,###').format(data.length.toInt())} Overdue Payments",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            fontSize: 18,
                                                            color:
                                                                Colors.black),
                                                  ),
                                                ),
                                              ),
                                              ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: data.length,
                                                itemBuilder: (context, index) {
                                                  var listview = Container(
                                                    margin: const EdgeInsets
                                                        .fromLTRB(15, 8, 15, 8),
                                                    padding: const EdgeInsets
                                                        .fromLTRB(8, 8, 0, 8),
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: grey4,
                                                              spreadRadius: 0.2,
                                                              blurStyle:
                                                                  BlurStyle
                                                                      .normal,
                                                              blurRadius: 1.6),
                                                        ]),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child:
                                                                  FutureBuilder(
                                                                future: myDb
                                                                    .collection(
                                                                        'subscribers')
                                                                    .doc(
                                                                        '${prefs.data!.getString('coopId')}_${data[index]['userId']}')
                                                                    .get(),
                                                                builder: (context,
                                                                    usersnap) {
                                                                  try {
                                                                    final data =
                                                                        usersnap
                                                                            .data!
                                                                            .data()!;
                                                                    if (usersnap
                                                                        .hasError) {
                                                                      log('snapshot.hasError (coopdash): ${usersnap.error}');
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
                                                                          return CircleAvatar(
                                                                            radius:
                                                                                55.0,
                                                                            backgroundImage:
                                                                                NetworkImage(data['profilePicUrl']),
                                                                            backgroundColor:
                                                                                Colors.transparent,
                                                                          );
                                                                      }
                                                                    } else {
                                                                      return Container();
                                                                    }
                                                                  } catch (e) {
                                                                    log(e
                                                                        .toString());
                                                                    return Container();
                                                                  }
                                                                },
                                                              ),
                                                            ),
                                                            const Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            4)),
                                                            SizedBox(
                                                              width: 140,
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
                                                                        'PAYMENT AMOUNT',
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              FontNameDefault,
                                                                          fontSize:
                                                                              12,
                                                                          letterSpacing:
                                                                              1,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        'PHP ${NumberFormat('###,###,###,###.##').format(data[index]['payment'])}',
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
                                                                        'DUE DATE',
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              FontNameDefault,
                                                                          fontSize:
                                                                              12,
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
                                                                            .format(data[index]['dueDate'].toDate())
                                                                            .toUpperCase(),
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
                                                                        'MONTH',
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              FontNameDefault,
                                                                          fontSize:
                                                                              12,
                                                                          letterSpacing:
                                                                              1,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        'MONTH ${data[index].id}'
                                                                            .toUpperCase(),
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
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 165,
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
                                                                              fontSize: 12,
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
                                                                              fontSize: 16,
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
                                                                        "PAYER'S NAME",
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              FontNameDefault,
                                                                          fontSize:
                                                                              12,
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
                                                                              .collection('subscribers')
                                                                              .doc('${prefs.data!.getString('coopId')}_${data[index]['userId']}')
                                                                              .get(),
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
                                                                                      '${data['userFirstName']} ${data['userMiddleName']} ${data['userLastName']}'.toUpperCase(),
                                                                                      style: const TextStyle(
                                                                                        fontFamily: FontNameDefault,
                                                                                        fontWeight: FontWeight.w800,
                                                                                        fontSize: 16,
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
                                                                      const Padding(
                                                                          padding:
                                                                              EdgeInsets.symmetric(vertical: 3)),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 18.0,
                                                                  bottom: 10),
                                                          child: SizedBox(
                                                            width: 200,
                                                            height: 35,
                                                            child:
                                                                ElevatedButton(
                                                              onPressed: () {},
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              25.0),
                                                                  side:
                                                                      const BorderSide(
                                                                    width: 2,
                                                                    color: Color
                                                                        .fromARGB(
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
                                                                        FontWeight
                                                                            .w800,
                                                                    color: Colors
                                                                            .teal[
                                                                        800],
                                                                    letterSpacing:
                                                                        1,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                  //to display
                                                  if (DateTime(
                                                          DateTime.now().year,
                                                          DateTime.now().month,
                                                          DateTime.now().day) !=
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
                                                    return Container();
                                                  } else {
                                                    return Container();
                                                  }
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
