import 'dart:developer';

import 'package:ascoop/web_ui/route/deposit/capital.dart';
import 'package:ascoop/web_ui/route/deposit/savings.dart';
import 'package:ascoop/web_ui/styles/buttonstyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:ascoop/web_ui/global_var.dart' as globals;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:ascoop/web_ui/utils/alertdialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ascoop/web_ui/constants.dart';

class DepositMgtPc extends StatefulWidget {
  const DepositMgtPc({super.key});

  @override
  State<DepositMgtPc> createState() => _DepositMgtPcState();
}

class _DepositMgtPcState extends State<DepositMgtPc> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ContextHeader(
            title: 'Deposit Management',
            icon: FontAwesomeIcons.piggyBank,
            widget: const DepositMgtHeader(),
          ),
          const Expanded(
            child: DepositContent(),
          ),
        ],
      ),
    );
  }
}

class DepositContent extends StatefulWidget {
  const DepositContent({super.key});

  @override
  State<DepositContent> createState() => _DepositContentState();
}

class _DepositContentState extends State<DepositContent> {
  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: globals.depIndex,
      children: const [
        Capital(),
        Savings(),
      ],
    );
  }
}

class Capital extends StatefulWidget {
  const Capital({super.key});

  @override
  State<Capital> createState() => _CapitalState();
}

class _CapitalState extends State<Capital> {
  String id = '';

  callback(String getid) {
    setState(() {
      id = getid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListCapital(
            callback: callback,
          ),
          Expanded(
            child: CapitalView(
              subId: id,
            ),
          ),
        ],
      ),
    );
  }
}

class Savings extends StatefulWidget {
  const Savings({super.key});

  @override
  State<Savings> createState() => _SavingsState();
}

class _SavingsState extends State<Savings> {
  String id = '';

  callback(String getid) {
    setState(() {
      id = getid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListSavings(
            callback: callback,
          ),
          Expanded(
            child: SavingsView(
              subId: id,
            ),
          ),
        ],
      ),
    );
  }
}

class DepositMgtHeader extends StatefulWidget {
  const DepositMgtHeader({super.key});

  @override
  State<DepositMgtHeader> createState() => _DepositMgtHeaderState();
}

class _DepositMgtHeaderState extends State<DepositMgtHeader> {
  late final SharedPreferences prefs;
  late final prefsFuture =
      SharedPreferences.getInstance().then((v) => prefs = v);

  void select(int n) {
    for (int i = 0; i < globals.headnavseldeposit.length; i++) {
      if (i != n) {
        globals.headnavseldeposit[i] = false;
      } else {
        globals.headnavseldeposit[i] = true;
      }
    }
  }

  int notifReq = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: ScrollConfiguration(
        behavior: MyCustomScrollBehavior(),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: FutureBuilder(
              future: prefsFuture,
              builder: (context, pref) {
                if (pref.hasError) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  switch (pref.connectionState) {
                    case ConnectionState.waiting:
                      return onWait;
                    default:
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                              hoverColor: Colors.transparent,
                              onTap: () {
                                setState(() {
                                  select(0);
                                  globals.depIndex = 0;
                                });
                                Navigator.pushReplacementNamed(
                                    context, '/deposit/capitalshare');
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 400),
                                padding: const EdgeInsets.all(8),
                                margin: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: globals.headnavseldeposit[0] == true
                                      ? Colors.teal[800]
                                      : Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                        color:
                                            Color.fromARGB(255, 174, 171, 171),
                                        spreadRadius: 0,
                                        blurStyle: BlurStyle.normal,
                                        blurRadius: 0.9),
                                  ],
                                ),
                                child: Text(
                                  'Capital Share',
                                  style: GoogleFonts.montserrat(
                                      color:
                                          globals.headnavseldeposit[0] == true
                                              ? Colors.white
                                              : Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              )),
                          const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 3)),
                          InkWell(
                              hoverColor: Colors.transparent,
                              onTap: () {
                                setState(() {
                                  select(1);
                                  globals.depIndex = 1;
                                });
                                Navigator.pushReplacementNamed(
                                    context, '/deposit/savings');
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 400),
                                padding: const EdgeInsets.all(8),
                                margin: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: globals.headnavseldeposit[1] == true
                                      ? Colors.teal[800]
                                      : Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                        color:
                                            Color.fromARGB(255, 174, 171, 171),
                                        spreadRadius: 0,
                                        blurStyle: BlurStyle.normal,
                                        blurRadius: 0.9),
                                  ],
                                ),
                                child: Text(
                                  'Savings',
                                  style: GoogleFonts.montserrat(
                                      color:
                                          globals.headnavseldeposit[1] == true
                                              ? Colors.white
                                              : Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              )),
                        ],
                      );
                  }
                }
              }),
        ),
      ),
    );
  }
}

class CapitalView extends StatefulWidget {
  String subId;
  CapitalView({super.key, required this.subId});

  @override
  State<CapitalView> createState() => _CapitalViewState();
}

class _CapitalViewState extends State<CapitalView> {
  late final SharedPreferences prefs;
  late final prefsFuture =
      SharedPreferences.getInstance().then((v) => prefs = v);
  int index = 0;

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
                      .collection('subscribers')
                      .where('userId', isEqualTo: widget.subId)
                      .where('coopId',
                          isEqualTo: prefs.data!.getString('coopId'))
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
                            return ScrollConfiguration(
                              behavior: MyCustomScrollBehavior(),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 500,
                                      height: 200,
                                      margin: const EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: const [
                                          BoxShadow(
                                              color: Color.fromARGB(
                                                  255, 122, 122, 122),
                                              spreadRadius: 0,
                                              blurStyle: BlurStyle.normal,
                                              blurRadius: 2.6)
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.teal[800],
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Capital Share'.toUpperCase(),
                                                style: const TextStyle(
                                                  fontFamily: FontNameDefault,
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w800,
                                                  letterSpacing: 1,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: StreamBuilder(
                                                stream: myDb
                                                    .collection('subscribers')
                                                    .doc(data[index].id)
                                                    .collection(
                                                        'coopAccDetails')
                                                    .doc('Data')
                                                    .snapshots(),
                                                builder: (context, snapshot) {
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
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
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
                                                                  Text(
                                                                    'PHP ${NumberFormat('###,###,###,###,###.##').format(snapshot.data!.data()!['capitalShare'])}',
                                                                    style: h1,
                                                                  ),
                                                                  IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        var amount;
                                                                        showDialog(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (context) {
                                                                              return AlertDialog(
                                                                                content: Container(
                                                                                  clipBehavior: Clip.hardEdge,
                                                                                  width: 250,
                                                                                  height: 120,
                                                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                                                                                  child: Column(
                                                                                    children: [
                                                                                      Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          Row(
                                                                                            children: const [
                                                                                              Icon(
                                                                                                Feather.plus_circle,
                                                                                                size: 20,
                                                                                              ),
                                                                                              Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
                                                                                              Text(
                                                                                                'Deposit',
                                                                                                style: TextStyle(fontFamily: FontNameDefault, fontWeight: FontWeight.w800, letterSpacing: 1.5, fontSize: 16, color: Colors.black),
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
                                                                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                                                                        child: Divider(
                                                                                          thickness: 0.3,
                                                                                          color: grey4,
                                                                                        ),
                                                                                      ),
                                                                                      const Padding(padding: EdgeInsets.symmetric(vertical: 7)),
                                                                                      Expanded(
                                                                                        child: TextFormField(
                                                                                          keyboardType: TextInputType.number,
                                                                                          inputFormatters: [
                                                                                            FilteringTextInputFormatter.allow(RegExp('[0-9.]+')),
                                                                                          ],
                                                                                          controller: amount = TextEditingController(),
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
                                                                                              labelText: 'Deposit Amount',
                                                                                              labelStyle: TextStyle(fontFamily: FontNameDefault, fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey[700], letterSpacing: 1)),
                                                                                          style: const TextStyle(fontFamily: FontNameDefault, fontWeight: FontWeight.w700, fontSize: 14, color: Colors.black, letterSpacing: 1),
                                                                                          onTap: () {
                                                                                            amount.clear();
                                                                                          },
                                                                                        ),
                                                                                      )
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
                                                                                          content: Container(
                                                                                            child: Center(
                                                                                              child: CircularProgressIndicator(
                                                                                                color: Colors.teal[800],
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      );
                                                                                      myDb.collection('subscribers').doc('${prefs.data!.getString('coopId')}_${widget.subId}').collection('coopAccDetails').doc('Data').get().then((value) async {
                                                                                        await myDb.collection('subscribers').doc('${prefs.data!.getString('coopId')}_${widget.subId}').collection('coopAccDetails').doc('Data').update({
                                                                                          'capitalShare': value.data()!['capitalShare'] + double.parse(amount.text)
                                                                                        });
                                                                                        await myDb.collection('subscribers').doc('${prefs.data!.getString('coopId')}_${widget.subId}').collection('coopAccDetails').doc('Data').collection('shareLedger').doc(DateFormat('yyyyMMddHHmmsss').format(DateTime.now())).set({
                                                                                          'timestamp': DateTime.now(),
                                                                                          'deposits': double.parse(amount.text),
                                                                                          'withdrawals': 0,
                                                                                          'balance': value.data()!['capitalShare'] + double.parse(amount.text),
                                                                                        });
                                                                                      });

                                                                                      myDb.collection('staffs').where('coopID', isEqualTo: prefs.data!.getString('coopId')).get().then((notf) async {
                                                                                        if (notf.size > 0) {
                                                                                          for (int a = 0; a < notf.size; a++) {
                                                                                            await myDb.collection('notifications').doc(prefs.data!.getString('coopId')).collection(notf.docs[a]['staffID']).doc(DateFormat('yyyyMMddHHmmss').format(DateTime.now())).set({
                                                                                              'context': 'deposit',
                                                                                              'coopId': prefs.data!.getString('coopId'),
                                                                                              'title': 'Deposits to Capital Share',
                                                                                              'content': "${data[index]['userFirstName']} ${data[index]['userMiddleName']} ${data[index]['userLastName']} (${data[index]['userEmail']}) deposits PHP ${NumberFormat('###,###,###,###.##').format(double.parse(amount.text))} under Capital Share.",
                                                                                              'notifBy': FirebaseAuth.instance.currentUser!.uid,
                                                                                              'notifId': notf.docs[a]['staffID'],
                                                                                              'timestamp': DateTime.now(),
                                                                                              'userId': widget.subId,
                                                                                              'status': 'unread',
                                                                                            });
                                                                                          }
                                                                                        }
                                                                                      });

                                                                                      await myDb.collection('staffs').doc(FirebaseAuth.instance.currentUser!.uid).collection('transactions').doc(DateFormat('yyyyMMddHHmmss').format(DateTime.now())).set({
                                                                                        'timestamp': DateTime.now(),
                                                                                        'context': 'Deposit',
                                                                                        'content': '${data[index]['userFirstName']} ${data[index]['userMiddleName']} ${data[index]['userLastName']} (${data[index]['userEmail']}) deposits PHP ${NumberFormat('###,###,###,###.##').format(double.parse(amount.text))} under Capital Share.',
                                                                                        'title': 'Assess Deposit from Capital Share',
                                                                                        'staffId': FirebaseAuth.instance.currentUser!.uid,
                                                                                      }).whenComplete(() {
                                                                                        Navigator.pop(context);
                                                                                        okDialog(context, 'Deposit Successfully', 'PHP ${NumberFormat('###,###,###,###.##').format(double.parse(amount.text))} deposits to Capital Share.').whenComplete(() => Navigator.pop(context));
                                                                                      });
                                                                                    },
                                                                                    style: ForTealButton,
                                                                                    child: const Padding(
                                                                                      padding: EdgeInsets.all(8),
                                                                                      child: Text(
                                                                                        'Deposit',
                                                                                        style: TextStyle(fontFamily: FontNameDefault, fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 1, color: Colors.white),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              );
                                                                            });
                                                                      },
                                                                      icon:
                                                                          Icon(
                                                                        Feather
                                                                            .plus_circle,
                                                                        color: Colors
                                                                            .grey[800],
                                                                        size:
                                                                            20,
                                                                      ))
                                                                ],
                                                              ),
                                                              const Text(
                                                                'Total Shares',
                                                                style: h5,
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  var amount;
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return AlertDialog(
                                                                        content:
                                                                            Container(
                                                                          clipBehavior:
                                                                              Clip.hardEdge,
                                                                          width:
                                                                              250,
                                                                          height:
                                                                              120,
                                                                          decoration:
                                                                              BoxDecoration(borderRadius: BorderRadius.circular(15)),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Row(
                                                                                    children: const [
                                                                                      Icon(
                                                                                        FontAwesomeIcons.handHoldingDollar,
                                                                                        size: 20,
                                                                                      ),
                                                                                      Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
                                                                                      Text(
                                                                                        'Withdrawal',
                                                                                        style: TextStyle(fontFamily: FontNameDefault, fontWeight: FontWeight.w800, letterSpacing: 1.5, fontSize: 16, color: Colors.black),
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
                                                                                padding: const EdgeInsets.symmetric(vertical: 8),
                                                                                child: Divider(
                                                                                  thickness: 0.3,
                                                                                  color: grey4,
                                                                                ),
                                                                              ),
                                                                              const Padding(padding: EdgeInsets.symmetric(vertical: 7)),
                                                                              Expanded(
                                                                                child: TextFormField(
                                                                                  keyboardType: TextInputType.number,
                                                                                  inputFormatters: [
                                                                                    FilteringTextInputFormatter.allow(RegExp('[0-9.]+')),
                                                                                  ],
                                                                                  controller: amount = TextEditingController(),
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
                                                                                      labelText: 'Withdrawal Amount',
                                                                                      labelStyle: TextStyle(fontFamily: FontNameDefault, fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey[700], letterSpacing: 1)),
                                                                                  style: const TextStyle(fontFamily: FontNameDefault, fontWeight: FontWeight.w700, fontSize: 14, color: Colors.black, letterSpacing: 1),
                                                                                  onTap: () {
                                                                                    amount.clear();
                                                                                  },
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        actions: [
                                                                          ElevatedButton(
                                                                            onPressed:
                                                                                () async {
                                                                              showDialog(
                                                                                barrierDismissible: false,
                                                                                context: context,
                                                                                builder: (context) => AlertDialog(
                                                                                  backgroundColor: Colors.transparent,
                                                                                  elevation: 0,
                                                                                  content: Container(
                                                                                    child: Center(
                                                                                      child: CircularProgressIndicator(
                                                                                        color: Colors.teal[800],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              );
                                                                              myDb.collection('subscribers').doc('${prefs.data!.getString('coopId')}_${widget.subId}').collection('coopAccDetails').doc('Data').get().then((value) async {
                                                                                await myDb.collection('subscribers').doc('${prefs.data!.getString('coopId')}_${widget.subId}').collection('coopAccDetails').doc('Data').update({
                                                                                  'capitalShare': value.data()!['capitalShare'] - double.parse(amount.text)
                                                                                });
                                                                                await myDb.collection('subscribers').doc('${prefs.data!.getString('coopId')}_${widget.subId}').collection('coopAccDetails').doc('Data').collection('shareLedger').doc(DateFormat('yyyyMMddHHmmsss').format(DateTime.now())).set({
                                                                                  'timestamp': DateTime.now(),
                                                                                  'deposits': 0,
                                                                                  'withdrawals': double.parse(amount.text),
                                                                                  'balance': value.data()!['capitalShare'] - double.parse(amount.text),
                                                                                });
                                                                              });

                                                                              myDb.collection('staffs').where('coopID', isEqualTo: prefs.data!.getString('coopId')).get().then((notf) async {
                                                                                if (notf.size > 0) {
                                                                                  for (int a = 0; a < notf.size; a++) {
                                                                                    await myDb.collection('notifications').doc(prefs.data!.getString('coopId')).collection(notf.docs[a]['staffID']).doc(DateFormat('yyyyMMddHHmmss').format(DateTime.now())).set({
                                                                                      'context': 'withdrawal',
                                                                                      'coopId': prefs.data!.getString('coopId'),
                                                                                      'title': 'Withdrawal from Capital Share',
                                                                                      'content': "${data[index]['userFirstName']} ${data[index]['userMiddleName']} ${data[index]['userLastName']} (${data[index]['userEmail']}) withdraws PHP ${NumberFormat('###,###,###,###.##').format(double.parse(amount.text))} under Capital Share.",
                                                                                      'notifBy': FirebaseAuth.instance.currentUser!.uid,
                                                                                      'notifId': notf.docs[a]['staffID'],
                                                                                      'timestamp': DateTime.now(),
                                                                                      'userId': widget.subId,
                                                                                      'status': 'unread',
                                                                                    });
                                                                                  }
                                                                                }
                                                                              });

                                                                              await myDb.collection('staffs').doc(FirebaseAuth.instance.currentUser!.uid).collection('transactions').doc(DateFormat('yyyyMMddHHmmss').format(DateTime.now())).set({
                                                                                'timestamp': DateTime.now(),
                                                                                'context': 'Withdrawal',
                                                                                'content': '${data[index]['userFirstName']} ${data[index]['userMiddleName']} ${data[index]['userLastName']} (${data[index]['userEmail']}) withdraws PHP ${NumberFormat('###,###,###,###.##').format(double.parse(amount.text))} under Capital Share.',
                                                                                'title': 'Assess Withdraw from Capital Share',
                                                                                'staffId': FirebaseAuth.instance.currentUser!.uid,
                                                                              }).whenComplete(() {
                                                                                Navigator.pop(context);
                                                                                okDialog(context, 'Withdraw Successfully', 'PHP ${NumberFormat('###,###,###,###.##').format(double.parse(amount.text))} withdrawn from Capital Share.').whenComplete(() => Navigator.pop(context));
                                                                              });
                                                                            },
                                                                            style:
                                                                                ForTealButton,
                                                                            child:
                                                                                const Padding(
                                                                              padding: EdgeInsets.all(8),
                                                                              child: Text(
                                                                                'Withdraw',
                                                                                style: TextStyle(fontFamily: FontNameDefault, fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 1, color: Colors.white),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                style: TextButton
                                                                    .styleFrom(
                                                                  foregroundColor:
                                                                      Colors
                                                                          .white,
                                                                ),
                                                                child: SizedBox(
                                                                  width: 100,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Icon(
                                                                        FontAwesomeIcons
                                                                            .handHoldingDollar,
                                                                        color: Colors
                                                                            .grey[800],
                                                                        size:
                                                                            12,
                                                                      ),
                                                                      const Padding(
                                                                          padding:
                                                                              EdgeInsets.symmetric(horizontal: 2)),
                                                                      Text(
                                                                        'Withdraw',
                                                                        style:
                                                                            btnForgotTxtStyle,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                      }
                                                    }
                                                  } catch (e) {}
                                                  return Container();
                                                }),
                                          )
                                        ],
                                      ),
                                    ),
                                    const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10)),
                                    StreamBuilder(
                                      stream: myDb
                                          .collection('subscribers')
                                          .doc(
                                              '${prefs.data!.getString('coopId')}_${widget.subId}')
                                          .collection('coopAccDetails')
                                          .doc('Data')
                                          .collection('shareLedger')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        try {
                                          final share = snapshot.data!.docs;
                                          if (snapshot.hasError) {
                                            log('snapshot.hasError (coopdash): ${snapshot.error}');
                                            return Container();
                                          } else if (snapshot.hasData &&
                                              share.isNotEmpty) {
                                            switch (snapshot.connectionState) {
                                              case ConnectionState.waiting:
                                                return onWait;
                                              default:
                                                return ScrollConfiguration(
                                                  behavior:
                                                      MyCustomScrollBehavior(),
                                                  child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: DataTable(
                                                      headingTextStyle:
                                                          const TextStyle(
                                                        fontFamily:
                                                            FontNameDefault,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.black,
                                                      ),
                                                      dataTextStyle:
                                                          const TextStyle(
                                                        fontFamily:
                                                            FontNameDefault,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black,
                                                        letterSpacing: 1,
                                                      ),
                                                      columns: [
                                                        DataColumn(
                                                          label: Expanded(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: const [
                                                                Text('Date'),
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
                                                              children: const [
                                                                Text(
                                                                    'Withdrawals'),
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
                                                              children: const [
                                                                Text(
                                                                    'Deposits'),
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
                                                              children: const [
                                                                Text('Balance'),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                      rows: List.generate(
                                                        share.length,
                                                        (index) => DataRow(
                                                          cells: [
                                                            DataCell(
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    DateFormat(
                                                                            'MMM d, yyyy hh:mm a')
                                                                        .format(
                                                                            share[index]['timestamp'].toDate())
                                                                        .toUpperCase(),
                                                                    style:
                                                                        const TextStyle(
                                                                      fontFamily:
                                                                          FontNameDefault,
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w800,
                                                                      color: Colors
                                                                          .black,
                                                                      letterSpacing:
                                                                          1,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            DataCell(
                                                              Builder(builder:
                                                                  (context) {
                                                                if (share[index]
                                                                        [
                                                                        'withdrawals'] !=
                                                                    0) {
                                                                  return Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        'PHP ${NumberFormat('###,###,###,###,###.00').format(share[index]['withdrawals'])}'
                                                                            .toUpperCase(),
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              FontNameDefault,
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.w800,
                                                                          color:
                                                                              Colors.red[800],
                                                                          letterSpacing:
                                                                              1,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                                } else {
                                                                  return const Text(
                                                                      '');
                                                                }
                                                              }),
                                                            ),
                                                            DataCell(
                                                              Builder(builder:
                                                                  (context) {
                                                                if (share[index]
                                                                        [
                                                                        'deposits'] !=
                                                                    0) {
                                                                  return Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        'PHP ${NumberFormat('###,###,###,###,###.##').format(share[index]['deposits'])}'
                                                                            .toUpperCase(),
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
                                                                  );
                                                                } else {
                                                                  return const Text(
                                                                      '');
                                                                }
                                                              }),
                                                            ),
                                                            DataCell(
                                                              Builder(builder:
                                                                  (context) {
                                                                return Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      'PHP ${NumberFormat('###,###,###,###,###.##').format(share[index]['balance'])}'
                                                                          .toUpperCase(),
                                                                      style:
                                                                          const TextStyle(
                                                                        fontFamily:
                                                                            FontNameDefault,
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.w800,
                                                                        color: Colors
                                                                            .black,
                                                                        letterSpacing:
                                                                            1,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                );
                                                              }),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                            }
                                          }
                                        } catch (e) {}
                                        return Container();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                        }
                      } else if (data.isEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/click_showprof.gif',
                              color: Colors.black,
                              scale: 3,
                            ),
                            const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5)),
                            const Text(
                              "Select subscriber's name to view their deposit information",
                              style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        );
                      }
                    } catch (e) {}
                    return Container();
                  });
          }
        }
      },
    );
  }
}

class SavingsView extends StatefulWidget {
  String subId;
  SavingsView({super.key, required this.subId});

  @override
  State<SavingsView> createState() => _SavingsViewState();
}

class _SavingsViewState extends State<SavingsView> {
  late final SharedPreferences prefs;
  late final prefsFuture =
      SharedPreferences.getInstance().then((v) => prefs = v);
  int index = 0;
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
                      .collection('subscribers')
                      .where('userId', isEqualTo: widget.subId)
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
                                  Container(
                                    width: 500,
                                    height: 200,
                                    margin: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Color.fromARGB(
                                                255, 122, 122, 122),
                                            spreadRadius: 0,
                                            blurStyle: BlurStyle.normal,
                                            blurRadius: 2.6)
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.teal[800],
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Savings'.toUpperCase(),
                                              style: const TextStyle(
                                                fontFamily: FontNameDefault,
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w800,
                                                letterSpacing: 1,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: StreamBuilder(
                                              stream: myDb
                                                  .collection('subscribers')
                                                  .doc(data[index].id)
                                                  .collection('coopAccDetails')
                                                  .doc('Data')
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                try {
                                                  if (snapshot.hasError) {
                                                    log('snapshot.hasError (coopdash): ${snapshot.error}');
                                                    return Container();
                                                  } else if (snapshot.hasData) {
                                                    switch (snapshot
                                                        .connectionState) {
                                                      case ConnectionState
                                                            .waiting:
                                                        return onWait;
                                                      default:
                                                        return Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
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
                                                                Text(
                                                                  'PHP ${NumberFormat('###,###,###,###,###.##').format(snapshot.data!.data()!['savings'])}',
                                                                  style: h1,
                                                                ),
                                                                IconButton(
                                                                    onPressed:
                                                                        () {
                                                                      var amount;
                                                                      showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (context) {
                                                                            return AlertDialog(
                                                                              content: Container(
                                                                                clipBehavior: Clip.hardEdge,
                                                                                width: 250,
                                                                                height: 120,
                                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                                                                                child: Column(
                                                                                  children: [
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Row(
                                                                                          children: const [
                                                                                            Icon(
                                                                                              Feather.plus_circle,
                                                                                              size: 20,
                                                                                            ),
                                                                                            Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
                                                                                            Text(
                                                                                              'Deposit',
                                                                                              style: TextStyle(fontFamily: FontNameDefault, fontWeight: FontWeight.w800, letterSpacing: 1.5, fontSize: 16, color: Colors.black),
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
                                                                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                                                                      child: Divider(
                                                                                        thickness: 0.3,
                                                                                        color: grey4,
                                                                                      ),
                                                                                    ),
                                                                                    const Padding(padding: EdgeInsets.symmetric(vertical: 7)),
                                                                                    Expanded(
                                                                                      child: TextFormField(
                                                                                        keyboardType: TextInputType.number,
                                                                                        inputFormatters: [
                                                                                          FilteringTextInputFormatter.allow(RegExp('[0-9.]+')),
                                                                                        ],
                                                                                        controller: amount = TextEditingController(),
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
                                                                                            labelText: 'Deposit Amount',
                                                                                            labelStyle: TextStyle(fontFamily: FontNameDefault, fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey[700], letterSpacing: 1)),
                                                                                        style: const TextStyle(fontFamily: FontNameDefault, fontWeight: FontWeight.w700, fontSize: 14, color: Colors.black, letterSpacing: 1),
                                                                                        onTap: () {
                                                                                          amount.clear();
                                                                                        },
                                                                                      ),
                                                                                    )
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
                                                                                        content: Container(
                                                                                          child: Center(
                                                                                            child: CircularProgressIndicator(
                                                                                              color: Colors.teal[800],
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    );
                                                                                    myDb.collection('subscribers').doc('${prefs.data!.getString('coopId')}_${widget.subId}').collection('coopAccDetails').doc('Data').get().then((value) async {
                                                                                      await myDb.collection('subscribers').doc('${prefs.data!.getString('coopId')}_${widget.subId}').collection('coopAccDetails').doc('Data').update({
                                                                                        'capitalShare': value.data()!['savings'] + double.parse(amount.text)
                                                                                      });
                                                                                      await myDb.collection('subscribers').doc('${prefs.data!.getString('coopId')}_${widget.subId}').collection('coopAccDetails').doc('Data').collection('savingsLedger').doc(DateFormat('yyyyMMddHHmmsss').format(DateTime.now())).set({
                                                                                        'timestamp': DateTime.now(),
                                                                                        'deposits': double.parse(amount.text),
                                                                                        'withdrawals': 0,
                                                                                        'balance': value.data()!['savings'] + double.parse(amount.text),
                                                                                      });
                                                                                    });

                                                                                    myDb.collection('staffs').where('coopID', isEqualTo: prefs.data!.getString('coopId')).get().then((notf) async {
                                                                                      if (notf.size > 0) {
                                                                                        for (int a = 0; a < notf.size; a++) {
                                                                                          await myDb.collection('notifications').doc(prefs.data!.getString('coopId')).collection(notf.docs[a]['staffID']).doc(DateFormat('yyyyMMddHHmmss').format(DateTime.now())).set({
                                                                                            'context': 'deposit',
                                                                                            'coopId': prefs.data!.getString('coopId'),
                                                                                            'title': 'Deposits to Savings',
                                                                                            'content': "${data[index]['userFirstName']} ${data[index]['userMiddleName']} ${data[index]['userLastName']} (${data[index]['userEmail']}) deposits PHP ${NumberFormat('###,###,###,###.##').format(double.parse(amount.text))} to Savings.",
                                                                                            'notifBy': FirebaseAuth.instance.currentUser!.uid,
                                                                                            'notifId': notf.docs[a]['staffID'],
                                                                                            'timestamp': DateTime.now(),
                                                                                            'userId': widget.subId,
                                                                                            'status': 'unread',
                                                                                          });
                                                                                        }
                                                                                      }
                                                                                    });

                                                                                    await myDb.collection('staffs').doc(FirebaseAuth.instance.currentUser!.uid).collection('transactions').doc(DateFormat('yyyyMMddHHmmss').format(DateTime.now())).set({
                                                                                      'timestamp': DateTime.now(),
                                                                                      'context': 'Deposit',
                                                                                      'content': '${data[index]['userFirstName']} ${data[index]['userMiddleName']} ${data[index]['userLastName']} (${data[index]['userEmail']}) deposits PHP ${NumberFormat('###,###,###,###.##').format(double.parse(amount.text))} to Savings.',
                                                                                      'title': 'Assess Deposit to Savings',
                                                                                      'staffId': FirebaseAuth.instance.currentUser!.uid,
                                                                                    }).whenComplete(() {
                                                                                      Navigator.pop(context);
                                                                                      okDialog(context, 'Deposit Successfully', 'PHP ${NumberFormat('###,###,###,###.##').format(double.parse(amount.text))} deposits to Savings.').whenComplete(() => Navigator.pop(context));
                                                                                    });
                                                                                  },
                                                                                  style: ForTealButton,
                                                                                  child: const Padding(
                                                                                    padding: EdgeInsets.all(8),
                                                                                    child: Text(
                                                                                      'Deposit',
                                                                                      style: TextStyle(fontFamily: FontNameDefault, fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 1, color: Colors.white),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            );
                                                                          });
                                                                    },
                                                                    icon: Icon(
                                                                      Feather
                                                                          .plus_circle,
                                                                      color: Colors
                                                                              .grey[
                                                                          800],
                                                                      size: 20,
                                                                    ))
                                                              ],
                                                            ),
                                                            const Text(
                                                              'Total Savings',
                                                              style: h5,
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                var amount;
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return AlertDialog(
                                                                      content:
                                                                          Container(
                                                                        clipBehavior:
                                                                            Clip.hardEdge,
                                                                        width:
                                                                            250,
                                                                        height:
                                                                            120,
                                                                        decoration:
                                                                            BoxDecoration(borderRadius: BorderRadius.circular(15)),
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Row(
                                                                                  children: const [
                                                                                    Icon(
                                                                                      FontAwesomeIcons.handHoldingDollar,
                                                                                      size: 20,
                                                                                    ),
                                                                                    Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
                                                                                    Text(
                                                                                      'Withdrawal',
                                                                                      style: TextStyle(fontFamily: FontNameDefault, fontWeight: FontWeight.w800, letterSpacing: 1.5, fontSize: 16, color: Colors.black),
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
                                                                              padding: const EdgeInsets.symmetric(vertical: 8),
                                                                              child: Divider(
                                                                                thickness: 0.3,
                                                                                color: grey4,
                                                                              ),
                                                                            ),
                                                                            const Padding(padding: EdgeInsets.symmetric(vertical: 7)),
                                                                            Expanded(
                                                                              child: TextFormField(
                                                                                keyboardType: TextInputType.number,
                                                                                inputFormatters: [
                                                                                  FilteringTextInputFormatter.allow(RegExp('[0-9.]+')),
                                                                                ],
                                                                                controller: amount = TextEditingController(),
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
                                                                                    labelText: 'Withdrawal Amount',
                                                                                    labelStyle: TextStyle(fontFamily: FontNameDefault, fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey[700], letterSpacing: 1)),
                                                                                style: const TextStyle(fontFamily: FontNameDefault, fontWeight: FontWeight.w700, fontSize: 14, color: Colors.black, letterSpacing: 1),
                                                                                onTap: () {
                                                                                  amount.clear();
                                                                                },
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      actions: [
                                                                        ElevatedButton(
                                                                          onPressed:
                                                                              () async {
                                                                            showDialog(
                                                                              barrierDismissible: false,
                                                                              context: context,
                                                                              builder: (context) => AlertDialog(
                                                                                backgroundColor: Colors.transparent,
                                                                                elevation: 0,
                                                                                content: Container(
                                                                                  child: Center(
                                                                                    child: CircularProgressIndicator(
                                                                                      color: Colors.teal[800],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );
                                                                            myDb.collection('subscribers').doc('${prefs.data!.getString('coopId')}_${widget.subId}').collection('coopAccDetails').doc('Data').get().then((value) async {
                                                                              await myDb.collection('subscribers').doc('${prefs.data!.getString('coopId')}_${widget.subId}').collection('coopAccDetails').doc('Data').update({
                                                                                'savings': value.data()!['savings'] - double.parse(amount.text)
                                                                              });
                                                                              await myDb.collection('subscribers').doc('${prefs.data!.getString('coopId')}_${widget.subId}').collection('coopAccDetails').doc('Data').collection('savingsLedger').doc(DateFormat('yyyyMMddHHmmsss').format(DateTime.now())).set({
                                                                                'timestamp': DateTime.now(),
                                                                                'deposits': 0,
                                                                                'withdrawals': double.parse(amount.text),
                                                                                'balance': value.data()!['savings'] - double.parse(amount.text),
                                                                              });
                                                                            });

                                                                            myDb.collection('staffs').where('coopID', isEqualTo: prefs.data!.getString('coopId')).get().then((notf) async {
                                                                              if (notf.size > 0) {
                                                                                for (int a = 0; a < notf.size; a++) {
                                                                                  await myDb.collection('notifications').doc(prefs.data!.getString('coopId')).collection(notf.docs[a]['staffID']).doc(DateFormat('yyyyMMddHHmmss').format(DateTime.now())).set({
                                                                                    'context': 'withdrawal',
                                                                                    'coopId': prefs.data!.getString('coopId'),
                                                                                    'title': 'Withdrawal from Savings',
                                                                                    'content': "${data[index]['userFirstName']} ${data[index]['userMiddleName']} ${data[index]['userLastName']} (${data[index]['userEmail']}) withdraws PHP ${NumberFormat('###,###,###,###.##').format(double.parse(amount.text))} under Savings.",
                                                                                    'notifBy': FirebaseAuth.instance.currentUser!.uid,
                                                                                    'notifId': notf.docs[a]['staffID'],
                                                                                    'userId': widget.subId,
                                                                                    'timestamp': DateTime.now(),
                                                                                    'status': 'unread',
                                                                                  });
                                                                                }
                                                                              }
                                                                            });

                                                                            await myDb.collection('staffs').doc(FirebaseAuth.instance.currentUser!.uid).collection('transactions').doc(DateFormat('yyyyMMddHHmmss').format(DateTime.now())).set({
                                                                              'timestamp': DateTime.now(),
                                                                              'context': 'Withdrawal',
                                                                              'content': '${data[index]['userFirstName']} ${data[index]['userMiddleName']} ${data[index]['userLastName']} (${data[index]['userEmail']}) withdraws PHP ${NumberFormat('###,###,###,###.##').format(double.parse(amount.text))} under Savings.',
                                                                              'title': 'Assess Withdraw from Savings',
                                                                              'staffId': FirebaseAuth.instance.currentUser!.uid,
                                                                            }).whenComplete(() {
                                                                              Navigator.pop(context);
                                                                              okDialog(context, 'Withdraw Successfully', 'PHP ${NumberFormat('###,###,###,###.##').format(double.parse(amount.text))} withdrawn from Savings.').whenComplete(() => Navigator.pop(context));
                                                                            });
                                                                          },
                                                                          style:
                                                                              ForTealButton,
                                                                          child:
                                                                              const Padding(
                                                                            padding:
                                                                                EdgeInsets.all(8),
                                                                            child:
                                                                                Text(
                                                                              'Withdraw',
                                                                              style: TextStyle(fontFamily: FontNameDefault, fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 1, color: Colors.white),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              style: TextButton
                                                                  .styleFrom(
                                                                foregroundColor:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                              child: SizedBox(
                                                                width: 100,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Icon(
                                                                      FontAwesomeIcons
                                                                          .handHoldingDollar,
                                                                      color: Colors
                                                                              .grey[
                                                                          800],
                                                                      size: 12,
                                                                    ),
                                                                    const Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: 2)),
                                                                    Text(
                                                                      'Withdraw',
                                                                      style:
                                                                          btnForgotTxtStyle,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                    }
                                                  }
                                                } catch (e) {}
                                                return Container();
                                              }),
                                        )
                                      ],
                                    ),
                                  ),
                                  const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10)),
                                  StreamBuilder(
                                    stream: myDb
                                        .collection('subscribers')
                                        .doc(
                                            '${prefs.data!.getString('coopId')}_${widget.subId}')
                                        .collection('coopAccDetails')
                                        .doc('Data')
                                        .collection('savingsLedger')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      try {
                                        final share = snapshot.data!.docs;
                                        if (snapshot.hasError) {
                                          log('snapshot.hasError (coopdash): ${snapshot.error}');
                                          return Container();
                                        } else if (snapshot.hasData &&
                                            share.isNotEmpty) {
                                          switch (snapshot.connectionState) {
                                            case ConnectionState.waiting:
                                              return onWait;
                                            default:
                                              return ScrollConfiguration(
                                                behavior:
                                                    MyCustomScrollBehavior(),
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: DataTable(
                                                    headingTextStyle:
                                                        const TextStyle(
                                                      fontFamily:
                                                          FontNameDefault,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.black,
                                                    ),
                                                    dataTextStyle:
                                                        const TextStyle(
                                                      fontFamily:
                                                          FontNameDefault,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black,
                                                      letterSpacing: 1,
                                                    ),
                                                    columns: [
                                                      DataColumn(
                                                        label: Expanded(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: const [
                                                              Text('Date'),
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
                                                            children: const [
                                                              Text(
                                                                  'Withdrawals'),
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
                                                            children: const [
                                                              Text('Deposits'),
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
                                                            children: const [
                                                              Text('Balance'),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                    rows: List.generate(
                                                      share.length,
                                                      (index) => DataRow(
                                                        cells: [
                                                          DataCell(
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  DateFormat(
                                                                          'MMM d, yyyy hh:mm a')
                                                                      .format(share[index]
                                                                              [
                                                                              'timestamp']
                                                                          .toDate())
                                                                      .toUpperCase(),
                                                                  style:
                                                                      const TextStyle(
                                                                    fontFamily:
                                                                        FontNameDefault,
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                    color: Colors
                                                                        .black,
                                                                    letterSpacing:
                                                                        1,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          DataCell(
                                                            Builder(builder:
                                                                (context) {
                                                              if (share[index][
                                                                      'withdrawals'] !=
                                                                  0) {
                                                                return Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      'PHP ${NumberFormat('###,###,###,###,###.00').format(share[index]['withdrawals'])}'
                                                                          .toUpperCase(),
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            FontNameDefault,
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.w800,
                                                                        color: Colors
                                                                            .red[800],
                                                                        letterSpacing:
                                                                            1,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                );
                                                              } else {
                                                                return const Text(
                                                                    '');
                                                              }
                                                            }),
                                                          ),
                                                          DataCell(
                                                            Builder(builder:
                                                                (context) {
                                                              if (share[index][
                                                                      'deposits'] !=
                                                                  0) {
                                                                return Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      'PHP ${NumberFormat('###,###,###,###,###.##').format(share[index]['deposits'])}'
                                                                          .toUpperCase(),
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            FontNameDefault,
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.w800,
                                                                        color: Colors
                                                                            .teal[800],
                                                                        letterSpacing:
                                                                            1,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                );
                                                              } else {
                                                                return const Text(
                                                                    '');
                                                              }
                                                            }),
                                                          ),
                                                          DataCell(
                                                            Builder(builder:
                                                                (context) {
                                                              return Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    'PHP ${NumberFormat('###,###,###,###,###.##').format(share[index]['balance'])}'
                                                                        .toUpperCase(),
                                                                    style:
                                                                        const TextStyle(
                                                                      fontFamily:
                                                                          FontNameDefault,
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w800,
                                                                      color: Colors
                                                                          .black,
                                                                      letterSpacing:
                                                                          1,
                                                                    ),
                                                                  ),
                                                                ],
                                                              );
                                                            }),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                          }
                                        }
                                      } catch (e) {}
                                      return Container();
                                    },
                                  ),
                                ],
                              ),
                            );
                        }
                      } else if (data.isEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/click_showprof.gif',
                              color: Colors.black,
                              scale: 3,
                            ),
                            const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5)),
                            const Text(
                              "Select subscriber's name to view their deposit information",
                              style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        );
                      }
                    } catch (e) {}
                    return Container();
                  });
          }
        }
      },
    );
  }
}
