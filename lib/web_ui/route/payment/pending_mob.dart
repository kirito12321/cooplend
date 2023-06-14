import 'dart:developer';

import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/route/loans/pay.dart';
import 'package:ascoop/web_ui/route/subs/header.dart';
import 'package:ascoop/web_ui/styles/inputstyle.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListPayPending extends StatefulWidget {
  const ListPayPending({super.key});

  @override
  State<ListPayPending> createState() => _ListPayPendingState();
}

class _ListPayPendingState extends State<ListPayPending> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderText(
            Ttl: 'All On-going Payments',
            subTtl: 'On-going Payments',
          ),
          const PendingList(),
        ],
      ),
    );
  }
}

class PendingList extends StatefulWidget {
  const PendingList({
    super.key,
  });

  @override
  State<PendingList> createState() => _PendingListState();
}

class _PendingListState extends State<PendingList> {
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
        PayPending(searchStr: searchStr, isSearch: isSearch)
      ],
    );
  }
}

class PayPending extends StatefulWidget {
  String searchStr;
  bool isSearch;
  PayPending({
    super.key,
    required this.searchStr,
    required this.isSearch,
  });

  @override
  State<PayPending> createState() => _PayPendingState();
}

class _PayPendingState extends State<PayPending> {
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

                        //check if has today payment
                        for (int a = 0; a < data.length; a++) {
                          if (DateTime(DateTime.now().year,
                                  DateTime.now().month, DateTime.now().day) ==
                              DateTime(
                                data[a]['dueDate'].toDate().year,
                                data[a]['dueDate'].toDate().month,
                                data[a]['dueDate'].toDate().day,
                              )) {
                            todayPayCnt++;
                          }
                        }
//enhd of check
                        if (snapshot.hasError) {
                          log('snapshot.hasError (pending.dart): ${snapshot.error}');
                          return Container();
                        } else if (snapshot.hasData && data.isNotEmpty) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return onWait;
                            default:
                              return Column(
                                children: [
                                  Visibility(
                                    visible: todayPayCnt > 0 &&
                                            widget.isSearch == true
                                        ? true
                                        : false,
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: 270,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Today's Ongoing Payments",
                                            style: TextStyle(
                                                fontFamily: FontNameDefault,
                                                fontWeight: FontWeight.w800,
                                                fontSize: 18,
                                                color: Colors.orange[800]),
                                          ),
                                          Expanded(
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              padding: const EdgeInsets.all(10),
                                              child: ScrollConfiguration(
                                                behavior:
                                                    MyCustomScrollBehavior(),
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount: data.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      if (DateTime(
                                                              DateTime.now()
                                                                  .year,
                                                              DateTime.now()
                                                                  .month,
                                                              DateTime.now()
                                                                  .day) ==
                                                          DateTime(
                                                            data[index]
                                                                    ['dueDate']
                                                                .toDate()
                                                                .year,
                                                            data[index]
                                                                    ['dueDate']
                                                                .toDate()
                                                                .month,
                                                            data[index]
                                                                    ['dueDate']
                                                                .toDate()
                                                                .day,
                                                          )) {
                                                        return Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          width: 400,
                                                          height: 450,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          7),
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
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  FutureBuilder(
                                                                    future: myDb
                                                                        .collection(
                                                                            'subscribers')
                                                                        .where(
                                                                            'userId',
                                                                            isEqualTo: data[index][
                                                                                'userId'])
                                                                        .where(
                                                                            'coopId',
                                                                            isEqualTo:
                                                                                prefs.data!.getString('coopId'))
                                                                        .get(),
                                                                    builder:
                                                                        (context,
                                                                            usersnap) {
                                                                      try {
                                                                        final userdata = usersnap
                                                                            .data!
                                                                            .docs[0];
                                                                        if (!usersnap
                                                                            .hasData) {
                                                                          return const Center(
                                                                            child:
                                                                                CircularProgressIndicator(),
                                                                          );
                                                                        } else if (usersnap
                                                                            .hasError) {
                                                                          return const Center(
                                                                            child:
                                                                                CircularProgressIndicator(),
                                                                          );
                                                                        } else if (usersnap
                                                                            .hasData) {
                                                                          return CircleAvatar(
                                                                            radius:
                                                                                40.0,
                                                                            backgroundImage:
                                                                                NetworkImage(userdata['profilePicUrl']),
                                                                            backgroundColor:
                                                                                Colors.transparent,
                                                                          );
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
                                                                  const Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              6)),
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            'Payment Amount'.toUpperCase(),
                                                                            style: const TextStyle(
                                                                                fontFamily: FontNameDefault,
                                                                                fontWeight: FontWeight.w400,
                                                                                fontSize: 11,
                                                                                color: Colors.black,
                                                                                letterSpacing: 1),
                                                                          ),
                                                                          Text(
                                                                            'PHP ${NumberFormat.decimalPattern().format(data[index]['payment'])}',
                                                                            style: const TextStyle(
                                                                                fontFamily: FontNameDefault,
                                                                                fontWeight: FontWeight.w700,
                                                                                fontSize: 20,
                                                                                color: Colors.black,
                                                                                letterSpacing: 1),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const Padding(
                                                                          padding:
                                                                              EdgeInsets.symmetric(vertical: 2)),
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          const Text(
                                                                            'Loan Number',
                                                                            style: TextStyle(
                                                                                fontFamily: FontNameDefault,
                                                                                fontWeight: FontWeight.w400,
                                                                                fontSize: 12,
                                                                                color: Colors.black,
                                                                                letterSpacing: 1),
                                                                          ),
                                                                          Text(
                                                                            data[index]['loanId'],
                                                                            style: TextStyle(
                                                                                fontFamily: FontNameDefault,
                                                                                fontWeight: FontWeight.w800,
                                                                                fontSize: 14,
                                                                                color: Colors.black,
                                                                                letterSpacing: 1),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const Padding(
                                                                          padding:
                                                                              EdgeInsets.symmetric(vertical: 2)),
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            'Due Date',
                                                                            style: TextStyle(
                                                                                fontFamily: FontNameDefault,
                                                                                fontWeight: FontWeight.w400,
                                                                                fontSize: 12,
                                                                                color: Colors.black,
                                                                                letterSpacing: 1),
                                                                          ),
                                                                          Text(
                                                                            DateFormat('MMM d, yyyy').format(data[index]['dueDate'].toDate()),
                                                                            style: TextStyle(
                                                                                fontFamily: FontNameDefault,
                                                                                fontWeight: FontWeight.w800,
                                                                                fontSize: 14,
                                                                                color: Colors.black,
                                                                                letterSpacing: 1),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              7)),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            40),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              'Month',
                                                                              style: TextStyle(fontFamily: FontNameDefault, fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black, letterSpacing: 1),
                                                                            ),
                                                                            Text(
                                                                              'Month ${data[index].id}',
                                                                              style: TextStyle(fontFamily: FontNameDefault, fontWeight: FontWeight.w800, fontSize: 14, color: Colors.black, letterSpacing: 1),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        const Padding(
                                                                            padding:
                                                                                EdgeInsets.symmetric(vertical: 2)),
                                                                        Container(
                                                                          width:
                                                                              100,
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              const Text(
                                                                                "Payer's Name",
                                                                                style: TextStyle(
                                                                                  fontFamily: FontNameDefault,
                                                                                  fontWeight: FontWeight.w400,
                                                                                  fontSize: 12,
                                                                                  color: Colors.black,
                                                                                  letterSpacing: 1,
                                                                                ),
                                                                              ),
                                                                              FutureBuilder(
                                                                                  future: myDb.collection('subscribers').doc('${prefs.data!.getString('coopId')}_${data[index]['userId']}').get(),
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
                                                                                              '${data['userFirstName']} ${data['userMiddleName']} ${data['userLastName']}',
                                                                                              style: const TextStyle(
                                                                                                fontFamily: FontNameDefault,
                                                                                                fontWeight: FontWeight.w800,
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
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              const Padding(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              4)),
                                                              SizedBox(
                                                                width: 200,
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
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      } else {}
                                                      return Container();
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: StreamBuilder(
                                      stream: myDb
                                          .collectionGroup('tenure')
                                          .where('status', isEqualTo: 'pending')
                                          .where('coopId',
                                              isEqualTo: prefs.data!
                                                  .getString('coopId'))
                                          .where('dueDate',
                                              isGreaterThan: DateTime.now())
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
                                                final data =
                                                    snapshot.data!.docs;
                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Visibility(
                                                      visible: widget.isSearch,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 15.0,
                                                                top: 8),
                                                        child: Text(
                                                          "${NumberFormat('###,###,###').format(data.length.toInt())} Pending Payments",
                                                          style: GoogleFonts
                                                              .montserrat(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  fontSize: 18,
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                      ),
                                                    ),
                                                    ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount: data.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        var listview =
                                                            Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  15, 8, 15, 8),
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  8, 8, 0, 8),
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color:
                                                                        grey4,
                                                                    spreadRadius:
                                                                        0.2,
                                                                    blurStyle:
                                                                        BlurStyle
                                                                            .normal,
                                                                    blurRadius:
                                                                        1.6),
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
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child:
                                                                        FutureBuilder(
                                                                      future: myDb
                                                                          .collection(
                                                                              'subscribers')
                                                                          .doc(
                                                                              '${prefs.data!.getString('coopId')}_${data[index]['userId']}')
                                                                          .get(),
                                                                      builder:
                                                                          (context,
                                                                              usersnap) {
                                                                        try {
                                                                          final data = usersnap
                                                                              .data!
                                                                              .data()!;
                                                                          if (usersnap
                                                                              .hasError) {
                                                                            log('snapshot.hasError (coopdash): ${usersnap.error}');
                                                                            return Container();
                                                                          } else if (snapshot.hasData &&
                                                                              data.isNotEmpty) {
                                                                            switch (snapshot.connectionState) {
                                                                              case ConnectionState.waiting:
                                                                                return onWait;
                                                                              default:
                                                                                return CircleAvatar(
                                                                                  radius: 55.0,
                                                                                  backgroundImage: NetworkImage(data['profilePicUrl']),
                                                                                  backgroundColor: Colors.transparent,
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
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              4)),
                                                                  SizedBox(
                                                                    width: 140,
                                                                    child:
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
                                                                              'PAYMENT AMOUNT',
                                                                              style: TextStyle(
                                                                                fontFamily: FontNameDefault,
                                                                                fontSize: 12,
                                                                                letterSpacing: 1,
                                                                                fontWeight: FontWeight.w400,
                                                                                color: Colors.black,
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              'PHP ${NumberFormat('###,###,###,###.##').format(data[index]['payment'])}',
                                                                              style: const TextStyle(
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
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            const Text(
                                                                              'DUE DATE',
                                                                              style: TextStyle(
                                                                                fontFamily: FontNameDefault,
                                                                                fontSize: 12,
                                                                                letterSpacing: 1,
                                                                                fontWeight: FontWeight.w400,
                                                                                color: Colors.black,
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              DateFormat('MMM d, yyyy').format(data[index]['dueDate'].toDate()).toUpperCase(),
                                                                              style: const TextStyle(
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
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            const Text(
                                                                              'MONTH',
                                                                              style: TextStyle(
                                                                                fontFamily: FontNameDefault,
                                                                                fontSize: 12,
                                                                                letterSpacing: 1,
                                                                                fontWeight: FontWeight.w400,
                                                                                color: Colors.black,
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              'MONTH ${data[index].id}'.toUpperCase(),
                                                                              style: const TextStyle(
                                                                                fontFamily: FontNameDefault,
                                                                                fontSize: 16,
                                                                                fontWeight: FontWeight.w700,
                                                                                color: Colors.black,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 165,
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                const Text(
                                                                                  'LOAN NUMBER',
                                                                                  style: TextStyle(
                                                                                    fontFamily: FontNameDefault,
                                                                                    fontSize: 12,
                                                                                    letterSpacing: 1,
                                                                                    fontWeight: FontWeight.w400,
                                                                                    color: Colors.black,
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  '${data[index]['loanId']}',
                                                                                  style: const TextStyle(
                                                                                    fontFamily: FontNameDefault,
                                                                                    fontSize: 16,
                                                                                    fontWeight: FontWeight.w700,
                                                                                    color: Colors.black,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            const Padding(padding: EdgeInsets.symmetric(vertical: 3)),
                                                                            const Text(
                                                                              "PAYER'S NAME",
                                                                              style: TextStyle(
                                                                                fontFamily: FontNameDefault,
                                                                                fontSize: 12,
                                                                                letterSpacing: 1,
                                                                                fontWeight: FontWeight.w400,
                                                                                color: Colors.black,
                                                                              ),
                                                                            ),
                                                                            FutureBuilder(
                                                                                future: myDb.collection('subscribers').doc('${prefs.data!.getString('coopId')}_${data[index]['userId']}').get(),
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
                                                                            const Padding(padding: EdgeInsets.symmetric(vertical: 3)),
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
                                                                        left:
                                                                            18.0,
                                                                        bottom:
                                                                            10),
                                                                child: SizedBox(
                                                                  width: 200,
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
                                                                          subId:
                                                                              data[index]['userId'],
                                                                          month:
                                                                              data[index]['month'],
                                                                          amountPayable:
                                                                              data[index]['amountPayable'],
                                                                          loanId:
                                                                              data[index]['loanId'],
                                                                          docId:
                                                                              data[index].id,
                                                                          coopId:
                                                                              data[index]['coopId'],
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
                                                                            BorderRadius.circular(25.0),
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
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        'PAY',
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              FontNameDefault,
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w800,
                                                                          color:
                                                                              Colors.teal[800],
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
                                                                DateTime.now()
                                                                    .year,
                                                                DateTime.now()
                                                                    .month,
                                                                DateTime.now()
                                                                    .day) !=
                                                            DateTime(
                                                              data[index][
                                                                      'dueDate']
                                                                  .toDate()
                                                                  .year,
                                                              data[index][
                                                                      'dueDate']
                                                                  .toDate()
                                                                  .month,
                                                              data[index][
                                                                      'dueDate']
                                                                  .toDate()
                                                                  .day,
                                                            )) {
                                                          if (widget.searchStr
                                                              .trim()
                                                              .isEmpty) {
                                                            return listview;
                                                          }
                                                          if (data[index]
                                                                  ['loanId']
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
                                                          if (data[index]
                                                                  ['loanId']
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
                                            ttl: 'No On-going Payments Yet');
                                      },
                                    ),
                                  ),
                                ],
                              );
                          }
                        } else if (data.isEmpty) {
                          return EmptyData(
                              ttl: 'No On-going  width: 180,ments Yet');
                        }
                      } catch (e) {}
                      return Container();
                    });
            }
          }
        });
  }
}
