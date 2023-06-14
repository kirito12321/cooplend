import 'dart:developer';

import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/route/payment/profileclck.dart';
import 'package:ascoop/web_ui/route/subs/header.dart';
import 'package:ascoop/web_ui/styles/buttonstyle.dart';
import 'package:ascoop/web_ui/styles/inputstyle.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:ascoop/web_ui/utils/alertdialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListPayPaid extends StatefulWidget {
  const ListPayPaid({super.key});

  @override
  State<ListPayPaid> createState() => _ListPayPaidState();
}

class _ListPayPaidState extends State<ListPayPaid> {
  late final SharedPreferences prefs;
  late final prefsFuture =
      SharedPreferences.getInstance().then((v) => prefs = v);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              HeaderText(
                Ttl: 'All Paid Payments',
                subTtl: 'Paid Payments',
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Container(
                              clipBehavior: Clip.hardEdge,
                              width: 500,
                              height: MediaQuery.of(context).size.height,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Row(
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 4)),
                                          Text(
                                            'Online Payment Confirmation',
                                            style: TextStyle(
                                                fontFamily: FontNameDefault,
                                                fontWeight: FontWeight.w800,
                                                letterSpacing: 1.5,
                                                fontSize: 18,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      InkWell(
                                        hoverColor: Colors.white,
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Icon(
                                          Feather.x,
                                          size: 25,
                                          color: Colors.grey[800],
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Divider(
                                      thickness: 0.3,
                                      color: grey4,
                                    ),
                                  ),
                                  Expanded(
                                    child: ScrollConfiguration(
                                      behavior: MyCustomScrollBehavior(),
                                      child: SingleChildScrollView(
                                          child: FutureBuilder(
                                              future: prefsFuture,
                                              builder: (context, prefs) {
                                                if (prefs.hasError) {
                                                  return const Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                } else {
                                                  switch (
                                                      prefs.connectionState) {
                                                    case ConnectionState
                                                          .waiting:
                                                      return onWait;
                                                    default:
                                                      return StreamBuilder(
                                                        stream: myDb
                                                            .collection(
                                                                'payment')
                                                            .where('payStatus',
                                                                isEqualTo:
                                                                    'processing')
                                                            .where('coopId',
                                                                isEqualTo: prefs
                                                                    .data!
                                                                    .getString(
                                                                        'coopId'))
                                                            .snapshots(),
                                                        builder: (context,
                                                            snapshot) {
                                                          try {
                                                            final data =
                                                                snapshot
                                                                    .data!.docs;
                                                            if (snapshot
                                                                .hasError) {
                                                              return Container();
                                                            } else if (snapshot
                                                                    .hasData &&
                                                                data
                                                                    .isNotEmpty) {
                                                              switch (snapshot
                                                                  .connectionState) {
                                                                case ConnectionState
                                                                      .waiting:
                                                                  return onWait;
                                                                default:
                                                                  return ListView
                                                                      .builder(
                                                                    shrinkWrap:
                                                                        true,
                                                                    itemCount: data
                                                                        .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      return Container(
                                                                        width: MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                        margin:
                                                                            const EdgeInsets.all(8),
                                                                        padding:
                                                                            const EdgeInsets.all(10),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Colors.white,
                                                                          borderRadius:
                                                                              BorderRadius.circular(8),
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                                color: grey4,
                                                                                spreadRadius: 0.8,
                                                                                blurStyle: BlurStyle.normal,
                                                                                blurRadius: 0.8),
                                                                          ],
                                                                        ),
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                              children: [
                                                                                Column(
                                                                                  children: [
                                                                                    Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                      children: [
                                                                                        Text(
                                                                                          'LOAN ID'.toUpperCase(),
                                                                                          style: const TextStyle(fontFamily: FontNameDefault, fontSize: 11, fontWeight: FontWeight.w400, color: Colors.black),
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                        ),
                                                                                        const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                                                                                        Text(
                                                                                          data[index]['loanId'],
                                                                                          style: const TextStyle(
                                                                                            fontFamily: FontNameDefault,
                                                                                            color: Colors.black,
                                                                                            fontSize: 14,
                                                                                            fontWeight: FontWeight.w600,
                                                                                          ),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                    const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                                                                                    Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                      children: [
                                                                                        Text(
                                                                                          'date paid'.toUpperCase(),
                                                                                          style: const TextStyle(fontFamily: FontNameDefault, fontSize: 11, fontWeight: FontWeight.w400, color: Colors.black),
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                        ),
                                                                                        const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                                                                                        Text(
                                                                                          DateFormat('MMM d, yyyy').format(data[index]['timestamp'].toDate()),
                                                                                          style: const TextStyle(
                                                                                            fontFamily: FontNameDefault,
                                                                                            color: Colors.black,
                                                                                            fontSize: 14,
                                                                                            fontWeight: FontWeight.w600,
                                                                                          ),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                    const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                                                                                    Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                      children: [
                                                                                        Text(
                                                                                          'amount paid'.toUpperCase(),
                                                                                          style: const TextStyle(fontFamily: FontNameDefault, fontSize: 11, fontWeight: FontWeight.w400, color: Colors.black),
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                        ),
                                                                                        const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                                                                                        Text(
                                                                                          NumberFormat('###,###,###,###,###.##').format(data[index]['amount']),
                                                                                          style: TextStyle(
                                                                                            fontFamily: FontNameDefault,
                                                                                            color: orange8,
                                                                                            fontSize: 14,
                                                                                            fontWeight: FontWeight.w600,
                                                                                          ),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                Column(
                                                                                  children: [
                                                                                    Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                      children: [
                                                                                        Text(
                                                                                          'INVOICE NO.'.toUpperCase(),
                                                                                          style: const TextStyle(fontFamily: FontNameDefault, fontSize: 11, fontWeight: FontWeight.w400, color: Colors.black),
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                        ),
                                                                                        const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                                                                                        Text(
                                                                                          data[index]['invoiceNo'],
                                                                                          style: const TextStyle(
                                                                                            fontFamily: FontNameDefault,
                                                                                            color: Colors.black,
                                                                                            fontSize: 14,
                                                                                            fontWeight: FontWeight.w600,
                                                                                          ),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                    const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                                                                                    Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                      children: [
                                                                                        Text(
                                                                                          'due date'.toUpperCase(),
                                                                                          style: const TextStyle(fontFamily: FontNameDefault, fontSize: 11, fontWeight: FontWeight.w400, color: Colors.black),
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                        ),
                                                                                        const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                                                                                        Text(
                                                                                          DateFormat('MMM d, yyyy').format(data[index]['dueDate'].toDate()),
                                                                                          style: TextStyle(
                                                                                            fontFamily: FontNameDefault,
                                                                                            color: Colors.red[800],
                                                                                            fontSize: 14,
                                                                                            fontWeight: FontWeight.w600,
                                                                                          ),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                    const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                                                                                    Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                      children: [
                                                                                        Text(
                                                                                          'payment amount'.toUpperCase(),
                                                                                          style: const TextStyle(fontFamily: FontNameDefault, fontSize: 11, fontWeight: FontWeight.w400, color: Colors.black),
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                        ),
                                                                                        const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                                                                                        Text(
                                                                                          NumberFormat('###,###,###,###,###.##').format(data[index]['monthlyPay']),
                                                                                          style: TextStyle(
                                                                                            fontFamily: FontNameDefault,
                                                                                            color: orange8,
                                                                                            fontSize: 14,
                                                                                            fontWeight: FontWeight.w600,
                                                                                          ),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            const Padding(padding: EdgeInsets.symmetric(vertical: 6)),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                ClickProfile(payerid: data[index]['payerId']),
                                                                              ],
                                                                            ),
                                                                            const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                ElevatedButton(
                                                                                  onPressed: () async {
                                                                                    await myDb.collection('loans').doc('${prefs.data!.getString('coopId')}_${data[index]['payerId']}_${data[index]['loanId']}').get().then((value) async {
                                                                                      if (double.parse(data[index]['amount'].toStringAsFixed(2)) >= double.parse(data[index]['monthlyPay'].toStringAsFixed(2))) {
                                                                                        await myDb.collection('loans').doc('${prefs.data!.getString('coopId')}_${data[index]['payerId']}_${data[index]['loanId']}').update({
                                                                                          'totalBalance': value.data()!['totalBalance'] - (value.data()!['paidAmount'] + data[index]['amount']),
                                                                                          'paidAmount': value.data()!['paidAmount'] + data[index]['amount'],
                                                                                        });
                                                                                        await myDb.collection('loans').doc('${prefs.data!.getString('coopId')}_${data[index]['payerId']}_${data[index]['loanId']}').collection('tenure').doc(data[index]['tenureId']).get().then((tenures) async {
                                                                                          await myDb.collection('loans').doc(value.id).collection('tenure').doc(data[index]['tenureId']).update({
                                                                                            'status': 'paid',
                                                                                            'paidAmount': tenures.data()!['paidAmount'] + data[index]['amount'],
                                                                                            'paymentMethod': 'Online Payment',
                                                                                            'receivedBy': FirebaseAuth.instance.currentUser!.uid,
                                                                                            'timestamp': DateTime.now(),
                                                                                          });
                                                                                        });

                                                                                        await myDb.collection('payment').doc(data[index].id).update({
                                                                                          'payStatus': DateTime.now().difference(data[index]['dueDate'].toDate()).inHours < 0 ? 'paid' : 'overdue',
                                                                                        });
                                                                                      } else {
                                                                                        await myDb.collection('loans').doc('${prefs.data!.getString('coopId')}_${data[index]['payerId']}_${data[index]['loanId']}').update({
                                                                                          'totalBalance': value.data()!['totalBalance'] - (value.data()!['paidAmount'] + data[index]['amount']),
                                                                                          'paidAmount': value.data()!['paidAmount'] + data[index]['amount'],
                                                                                        });
                                                                                        await myDb.collection('loans').doc('${prefs.data!.getString('coopId')}_${data[index]['payerId']}_${data[index]['loanId']}').collection('tenure').doc(data[index]['tenureId']).get().then((tenures) async {
                                                                                          await myDb.collection('loans').doc(value.id).collection('tenure').doc(data[index]['tenureId']).update({
                                                                                            'paidAmount': tenures.data()!['paidAmount'] + data[index]['amount'],
                                                                                            'receivedBy': FirebaseAuth.instance.currentUser!.uid,
                                                                                          });
                                                                                        });

                                                                                        await myDb.collection('payment').doc(data[index].id).update({
                                                                                          'payStatus': 'partial',
                                                                                        });
                                                                                      }
                                                                                    }, onError: (e) {
                                                                                      okDialog(context, 'An error occured', 'Something went wrong. Please try again later.');
                                                                                    });
                                                                                  },
                                                                                  style: ForTealButton,
                                                                                  child: const Padding(
                                                                                    padding: EdgeInsets.all(8.0),
                                                                                    child: Text(
                                                                                      'Received',
                                                                                      style: alertDialogBtn,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            )
                                                                          ],
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                              }
                                                            } else if (data
                                                                .isEmpty) {
                                                              return EmptyData(
                                                                  ttl:
                                                                      'No Transactions Yet');
                                                            }
                                                          } catch (e) {}
                                                          return EmptyData(
                                                              ttl:
                                                                  'No Transactions Yet');
                                                        },
                                                      );
                                                  }
                                                }
                                              })),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Text(
                      'Payment Confirmations',
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: 14,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w800,
                        color: Colors.teal[800],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
          const PaidList(),
        ],
      ),
    );
  }
}

class PaidList extends StatefulWidget {
  const PaidList({
    super.key,
  });

  @override
  State<PaidList> createState() => _PaidListState();
}

class _PaidListState extends State<PaidList> {
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
        PayPaid(searchStr: searchStr, isSearch: isSearch)
      ],
    );
  }
}

class PayPaid extends StatefulWidget {
  String searchStr;
  bool isSearch;
  PayPaid({
    super.key,
    required this.searchStr,
    required this.isSearch,
  });

  @override
  State<PayPaid> createState() => _PayPaidState();
}

class _PayPaidState extends State<PayPaid> {
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
                      .collection('payment')
                      .where('coopId',
                          isEqualTo: prefs.data!.getString('coopId'))
                      .where('payStatus',
                          whereIn: ['partial', 'overdue', 'paid'])
                      .orderBy('timestamp', descending: true)
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
                            return ScrollConfiguration(
                              behavior: MyCustomScrollBehavior(),
                              child: SingleChildScrollView(
                                child: PaginatedDataTable(
                                  columns: [
                                    DataColumn(
                                      label: Text(
                                        'Invoice No.',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Date Paid',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Due Date',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Loan No.',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Month',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Payment Amount',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Amount Paid',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Payer',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Payment Method',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Status',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                  source: PaymentDataSrc(
                                      data, widget.isSearch, widget.searchStr),
                                ),
                              ),
                            );
                        }
                      } else if (data.isEmpty) {
                        return EmptyData(ttl: 'No Paid Payments Yet');
                      }
                    } catch (e) {
                      log(e.toString());
                    }
                    return Container();
                  },
                );
            }
          }
        });
  }
}

class PaymentDataSrc extends DataTableSource {
  String searchStr;
  bool isSearch;
  PaymentDataSrc(this._data, this.isSearch, this.searchStr);

  final List<dynamic> _data;

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => _data.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    var list = DataRow(
      cells: [
        DataCell(
          Text(
            _data[index]['invoiceNo'],
            style: GoogleFonts.montserrat(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              letterSpacing: 1.5,
            ),
          ),
        ),
        DataCell(
          Text(
            DateFormat('MMM d, yyyy hh:mm a')
                .format(_data[index]["timestamp"].toDate())
                .toUpperCase(),
            style: GoogleFonts.montserrat(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Colors.black,
              letterSpacing: 1,
            ),
          ),
        ),
        DataCell(
          Text(
            DateFormat('MMM d, yyyy')
                .format(_data[index]["dueDate"].toDate())
                .toUpperCase(),
            style: GoogleFonts.montserrat(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Colors.black,
              letterSpacing: 1,
            ),
          ),
        ),
        DataCell(
          Text(
            '${_data[index]["loanId"]}',
            style: GoogleFonts.montserrat(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              letterSpacing: 1,
            ),
          ),
        ),
        DataCell(
          Text(
            'Month ${_data[index]["tenureId"]}',
            style: GoogleFonts.montserrat(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              letterSpacing: 1,
            ),
          ),
        ),
        DataCell(
          Text(
            'PHP ${NumberFormat('###,###,###,###,###.##').format(_data[index]["monthlyPay"].toDouble())}',
            style: GoogleFonts.montserrat(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Colors.teal[800],
              letterSpacing: 1,
            ),
          ),
        ),
        DataCell(
          Text(
            'PHP ${NumberFormat('###,###,###,###,###.##').format(_data[index]["amount"].toDouble())}',
            style: GoogleFonts.montserrat(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Colors.orange[800],
              letterSpacing: 1,
            ),
          ),
        ),
        DataCell(
          ClickProfile(
            payerid: _data[index]['payerId'],
          ),
        ),
        DataCell(
          Text(
            '${_data[index]["paymentMethod"]}',
            style: GoogleFonts.montserrat(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              letterSpacing: 1,
            ),
          ),
        ),
        DataCell(Builder(
          builder: (context) {
            switch (_data[index]['payStatus'].toString().toLowerCase()) {
              case 'paid':
                return Container(
                  padding: const EdgeInsets.all(4),
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: teal8,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'PAID',
                      style: GoogleFonts.montserrat(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.teal[800],
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                );

              case 'overdue':
                return Container(
                  padding: const EdgeInsets.all(4),
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: red8,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'OVERDUE',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.red[800],
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                );
              case 'processing':
                return Container(
                  padding: const EdgeInsets.all(4),
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: red8,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'CONFIRM',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.red[800],
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                );
              default:
                return Container(
                  padding: const EdgeInsets.all(4),
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: orange8,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'PARTIAL',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.orange[800],
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                );
            }
          },
        )),
      ],
    );

    if (_data[index]['loanId'].toString().toLowerCase().contains(searchStr)) {
      return list;
    }
    if (_data[index]['loanId'].toString().toUpperCase().contains(searchStr)) {
      return list;
    }
    if (_data[index]['invoiceNo']
        .toString()
        .toLowerCase()
        .contains(searchStr)) {
      return list;
    }
    if (_data[index]['invoiceNo']
        .toString()
        .toUpperCase()
        .contains(searchStr)) {
      return list;
    }
    if (_data[index]['paymentMethod']
        .toString()
        .toLowerCase()
        .contains(searchStr)) {
      return list;
    }
    if (_data[index]['paymentMethod']
        .toString()
        .toUpperCase()
        .contains(searchStr)) {
      return list;
    }
    if (searchStr.isEmpty) {
      return list;
    }
    return DataRow(cells: [
      DataCell(Container()),
      DataCell(Container()),
      DataCell(Container()),
      DataCell(Container()),
      DataCell(Container()),
      DataCell(Container()),
      DataCell(Container()),
      DataCell(Container()),
      DataCell(Container()),
    ]);
  }
}
