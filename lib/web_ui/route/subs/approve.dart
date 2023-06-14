import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/styles/buttonstyle.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:ascoop/web_ui/utils/alertdialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApprodelSub extends StatefulWidget {
  String coopId,
      firstname,
      middlename,
      lastname,
      fullname,
      email,
      subid,
      status;
  int index;
  ApprodelSub({
    super.key,
    required this.coopId,
    required this.status,
    required this.firstname,
    required this.middlename,
    required this.lastname,
    required this.fullname,
    required this.email,
    required this.index,
    required this.subid,
  });

  @override
  State<ApprodelSub> createState() => _ApprodelSubState();
}

class _ApprodelSubState extends State<ApprodelSub> {
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
                if (widget.status.toString().toLowerCase() != 'process' ||
                    prefs.data!.getString('myRole').toString().toLowerCase() ==
                        'administrator') {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          WriteBatch batch = FirebaseFirestore.instance.batch();
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
                                    var savings = TextEditingController(
                                        text: 0.toString());
                                    return AlertDialog(
                                      title: const Text(
                                        'Approve Confirmation',
                                        style: alertDialogTtl,
                                      ),
                                      content: Text(
                                        "Are you sure you want to approve ${widget.firstname}'s request for becoming subscriber?",
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
                                            showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text(
                                                    'Fill Additional Information of ${widget.firstname}',
                                                    style: alertDialogTtl,
                                                  ),
                                                  content: SizedBox(
                                                    width: 200,
                                                    height: 125,
                                                    child: Column(
                                                      children: [
                                                        TextFormField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          controller: capital,
                                                          decoration:
                                                              InputDecoration(
                                                                  prefixIcon:
                                                                      Icon(
                                                                    FontAwesomeIcons
                                                                        .pesoSign,
                                                                    color: Colors
                                                                            .grey[
                                                                        800],
                                                                    size: 16,
                                                                  ),
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            30.0),
                                                                  ),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            30.0),
                                                                    borderSide:
                                                                        const BorderSide(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          0,
                                                                          105,
                                                                          92),
                                                                      width:
                                                                          2.0,
                                                                    ),
                                                                  ),
                                                                  labelText:
                                                                      'Capital Share',
                                                                  labelStyle: TextStyle(
                                                                      fontFamily:
                                                                          FontNameDefault,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                              .grey[
                                                                          700],
                                                                      letterSpacing:
                                                                          1)),
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  FontNameDefault,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.black,
                                                              letterSpacing: 1),
                                                          onTap: () {
                                                            capital.clear();
                                                          },
                                                        ),
                                                        const Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        8)),
                                                        TextFormField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          controller: savings,
                                                          decoration:
                                                              InputDecoration(
                                                                  prefixIcon:
                                                                      Icon(
                                                                    FontAwesomeIcons
                                                                        .pesoSign,
                                                                    color: Colors
                                                                            .grey[
                                                                        800],
                                                                    size: 16,
                                                                  ),
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            30.0),
                                                                  ),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            30.0),
                                                                    borderSide:
                                                                        const BorderSide(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          0,
                                                                          105,
                                                                          92),
                                                                      width:
                                                                          2.0,
                                                                    ),
                                                                  ),
                                                                  labelText:
                                                                      'Savings',
                                                                  labelStyle: TextStyle(
                                                                      fontFamily:
                                                                          FontNameDefault,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                              .grey[
                                                                          700],
                                                                      letterSpacing:
                                                                          1)),
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  FontNameDefault,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.black,
                                                              letterSpacing: 1),
                                                          onTap: () {
                                                            capital.clear();
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        //batch write
                                                        batch.update(
                                                            myDb
                                                                .collection(
                                                                    'subscribers')
                                                                .doc(
                                                                    '${widget.coopId}_${widget.subid}'),
                                                            {
                                                              'status':
                                                                  'verified',
                                                              'timestamp':
                                                                  DateTime
                                                                      .now(),
                                                            });
                                                        batch.set(
                                                            myDb
                                                                .collection(
                                                                    'subscribers')
                                                                .doc(
                                                                    '${widget.coopId}_${widget.subid}')
                                                                .collection(
                                                                    'coopAccDetails')
                                                                .doc('Data'),
                                                            {
                                                              'capitalShare':
                                                                  double.parse(
                                                                      capital
                                                                          .text
                                                                          .toString()),
                                                              'savings': double
                                                                  .parse(savings
                                                                      .text
                                                                      .toString()),
                                                              'firstName': widget
                                                                  .firstname,
                                                              'middleName': widget
                                                                  .middlename,
                                                              'lastName': widget
                                                                  .lastname,
                                                              'status':
                                                                  'active',
                                                            });
                                                        //commit
                                                        batch.commit().then(
                                                            (value) {
                                                          //apply notifications to all staff
                                                          myDb
                                                              .collection(
                                                                  'staffs')
                                                              .where('coopID',
                                                                  isEqualTo:
                                                                      widget
                                                                          .coopId)
                                                              .where('staffID',
                                                                  isNotEqualTo:
                                                                      FirebaseAuth
                                                                          .instance
                                                                          .currentUser!
                                                                          .uid)
                                                              .get()
                                                              .then(
                                                                  (data) async {
                                                            if (data.size > 0) {
                                                              for (int a = 0;
                                                                  a < data.size;
                                                                  a++) {
                                                                await myDb
                                                                    .collection(
                                                                        'notifications')
                                                                    .doc(widget
                                                                        .coopId)
                                                                    .collection(
                                                                        data.docs[a]
                                                                            [
                                                                            'staffID'])
                                                                    .doc(DateFormat(
                                                                            'yyyyMMddHHmmss')
                                                                        .format(
                                                                            DateTime.now()))
                                                                    .set({
                                                                  'context':
                                                                      'subscriber',
                                                                  'coopId': widget
                                                                      .coopId,
                                                                  'title':
                                                                      'Approved Subscriber Request',
                                                                  'content':
                                                                      "The Administrator has approved ${widget.firstname}'s subscriber request.",
                                                                  'notifBy': FirebaseAuth
                                                                      .instance
                                                                      .currentUser!
                                                                      .uid,
                                                                  'notifId': data
                                                                          .docs[a]
                                                                      [
                                                                      'staffID'],
                                                                  'timestamp':
                                                                      DateTime
                                                                          .now(),
                                                                  'status':
                                                                      'unread',
                                                                });
                                                              }
                                                            }
                                                          });

                                                          myDb
                                                              .collection(
                                                                  'staffs')
                                                              .where('coopID',
                                                                  isEqualTo: prefs
                                                                      .data!
                                                                      .getString(
                                                                          'coopId'))
                                                              .where('role',
                                                                  isEqualTo:
                                                                      'Administrator')
                                                              .get()
                                                              .then(
                                                                  (data) async {
                                                            if (data.size > 0) {
                                                              for (int a = 0;
                                                                  a < data.size;
                                                                  a++) {
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
                                                                    .where(
                                                                        'context',
                                                                        isEqualTo:
                                                                            'approvesubtoadmin')
                                                                    .where(
                                                                        'userId',
                                                                        isEqualTo:
                                                                            widget
                                                                                .subid)
                                                                    .get()
                                                                    .then(
                                                                        (value) async {
                                                                  if (value
                                                                          .size >
                                                                      0) {
                                                                    for (int b =
                                                                            0;
                                                                        b < value.size;
                                                                        b++) {
                                                                      await myDb
                                                                          .collection(
                                                                              'notifications')
                                                                          .doc(prefs.data!.getString(
                                                                              'coopId'))
                                                                          .collection(data.docs[a]
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

                                                          myDb
                                                              .collection(
                                                                  'staffs')
                                                              .doc(FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid)
                                                              .collection(
                                                                  'transactions')
                                                              .doc(DateFormat(
                                                                      'yyyyMMddHHmmss')
                                                                  .format(DateTime
                                                                      .now()))
                                                              .set({
                                                            'timestamp':
                                                                DateTime.now(),
                                                            'context':
                                                                'Subscriber',
                                                            'content':
                                                                'You approved the request of ${widget.fullname} (${widget.email}).',
                                                            'title':
                                                                'Approved Subscriber Request',
                                                            'staffId':
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid,
                                                          });

                                                          okDialog(
                                                                  context,
                                                                  'Approve Successfully',
                                                                  "You approved ${widget.firstname}'s request successfully")
                                                              .whenComplete(() {
                                                            Navigator.pop(
                                                                context);
                                                            Navigator
                                                                .pushReplacementNamed(
                                                                    context,
                                                                    '/subscribers/request');
                                                          });
                                                        }, onError: (e) {
                                                          okDialog(
                                                              context,
                                                              'An Error Occured',
                                                              'Please try again. Later!');
                                                        });
                                                      },
                                                      style: ForTealButton,
                                                      child: const Padding(
                                                        padding:
                                                            EdgeInsets.all(8),
                                                        child: Text(
                                                          'Submit',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  FontNameDefault,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              letterSpacing: 1,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
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
                            //if approve by not admin
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    var capital = TextEditingController(
                                        text: 0.toString());
                                    var savings = TextEditingController(
                                        text: 0.toString());
                                    return AlertDialog(
                                      title: const Text(
                                        'Approve Confirmation',
                                        style: alertDialogTtl,
                                      ),
                                      content: Text(
                                        "Are you sure you want to approve ${widget.firstname}'s request for becoming subscriber?",
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
                                            showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text(
                                                    'Fill Additional Information of ${widget.firstname}',
                                                    style: alertDialogTtl,
                                                  ),
                                                  content: Container(
                                                    width: 200,
                                                    height: 125,
                                                    child: Column(
                                                      children: [
                                                        TextFormField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          controller: capital,
                                                          decoration:
                                                              InputDecoration(
                                                                  prefixIcon:
                                                                      Icon(
                                                                    FontAwesomeIcons
                                                                        .pesoSign,
                                                                    color: Colors
                                                                            .grey[
                                                                        800],
                                                                    size: 16,
                                                                  ),
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            30.0),
                                                                  ),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            30.0),
                                                                    borderSide:
                                                                        const BorderSide(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          0,
                                                                          105,
                                                                          92),
                                                                      width:
                                                                          2.0,
                                                                    ),
                                                                  ),
                                                                  labelText:
                                                                      'Capital Share',
                                                                  labelStyle: TextStyle(
                                                                      fontFamily:
                                                                          FontNameDefault,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                              .grey[
                                                                          700],
                                                                      letterSpacing:
                                                                          1)),
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  FontNameDefault,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.black,
                                                              letterSpacing: 1),
                                                          onTap: () {
                                                            capital.clear();
                                                          },
                                                        ),
                                                        const Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        8)),
                                                        TextFormField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          controller: savings,
                                                          decoration:
                                                              InputDecoration(
                                                                  prefixIcon:
                                                                      Icon(
                                                                    FontAwesomeIcons
                                                                        .pesoSign,
                                                                    color: Colors
                                                                            .grey[
                                                                        800],
                                                                    size: 16,
                                                                  ),
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            30.0),
                                                                  ),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            30.0),
                                                                    borderSide:
                                                                        const BorderSide(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          0,
                                                                          105,
                                                                          92),
                                                                      width:
                                                                          2.0,
                                                                    ),
                                                                  ),
                                                                  labelText:
                                                                      'Savings',
                                                                  labelStyle: TextStyle(
                                                                      fontFamily:
                                                                          FontNameDefault,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                              .grey[
                                                                          700],
                                                                      letterSpacing:
                                                                          1)),
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  FontNameDefault,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.black,
                                                              letterSpacing: 1),
                                                          onTap: () {
                                                            capital.clear();
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        //batch write
                                                        batch.update(
                                                            myDb
                                                                .collection(
                                                                    'subscribers')
                                                                .doc(
                                                                    '${widget.coopId}_${widget.subid}'),
                                                            {
                                                              'status':
                                                                  'process',
                                                              'timestamp':
                                                                  DateTime
                                                                      .now(),
                                                            });
                                                        batch.set(
                                                            myDb
                                                                .collection(
                                                                    'subscribers')
                                                                .doc(
                                                                    '${widget.coopId}_${widget.subid}')
                                                                .collection(
                                                                    'coopAccDetails')
                                                                .doc('Data'),
                                                            {
                                                              'capitalShare':
                                                                  double.parse(
                                                                      capital
                                                                          .text
                                                                          .toString()),
                                                              'savings': double
                                                                  .parse(savings
                                                                      .text
                                                                      .toString()),
                                                              'firstName': widget
                                                                  .firstname,
                                                              'middleName': widget
                                                                  .middlename,
                                                              'lastName': widget
                                                                  .lastname,
                                                              'status':
                                                                  'pending',
                                                            });

                                                        //commit
                                                        batch.commit().then(
                                                            (value) {
                                                          //apply notifications to all staff
                                                          myDb
                                                              .collection(
                                                                  'staffs')
                                                              .where('coopID',
                                                                  isEqualTo:
                                                                      widget
                                                                          .coopId)
                                                              .where('role',
                                                                  isEqualTo:
                                                                      'Administrator')
                                                              .get()
                                                              .then(
                                                                  (data) async {
                                                            if (data.size > 0) {
                                                              for (int a = 0;
                                                                  a < data.size;
                                                                  a++) {
                                                                await myDb
                                                                    .collection(
                                                                        'notifications')
                                                                    .doc(widget
                                                                        .coopId)
                                                                    .collection(
                                                                        data.docs[a]
                                                                            [
                                                                            'staffID'])
                                                                    .doc(DateFormat(
                                                                            'yyyyMMddHHmmss')
                                                                        .format(
                                                                            DateTime.now()))
                                                                    .set({
                                                                  'context':
                                                                      'approvesubtoadmin',
                                                                  'coopId': widget
                                                                      .coopId,
                                                                  'title':
                                                                      'Confirmation for Subscriber Request Approbation',
                                                                  'content':
                                                                      "has submitted approbation confirmation of ${widget.firstname}'s subscriber request.",
                                                                  'notifBy': FirebaseAuth
                                                                      .instance
                                                                      .currentUser!
                                                                      .uid,
                                                                  'userId':
                                                                      widget
                                                                          .subid,
                                                                  'notifId': data
                                                                          .docs[a]
                                                                      [
                                                                      'staffID'],
                                                                  'timestamp':
                                                                      DateTime
                                                                          .now(),
                                                                  'status':
                                                                      'unread',
                                                                });
                                                              }
                                                            }
                                                          });
                                                          myDb
                                                              .collection(
                                                                  'staffs')
                                                              .doc(FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid)
                                                              .collection(
                                                                  'transactions')
                                                              .doc(DateFormat(
                                                                      'yyyyMMddHHmmss')
                                                                  .format(DateTime
                                                                      .now()))
                                                              .set({
                                                            'timestamp':
                                                                DateTime.now(),
                                                            'context':
                                                                'Subscriber',
                                                            'content':
                                                                'You submit confirmation of approbation of subscriber request of ${widget.fullname} (${widget.email}).',
                                                            'title':
                                                                'Submit Confirmation for Approvation of Subscriber Request',
                                                            'staffId':
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid,
                                                          });

                                                          okDialog(
                                                                  context,
                                                                  'Submitted Confirmation',
                                                                  "Please wait for the response of administrator.")
                                                              .whenComplete(() {
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.pop(
                                                                context);
                                                          });
                                                        }, onError: (e) {
                                                          okDialog(
                                                              context,
                                                              'An Error Occured',
                                                              'Please try again. Later!');
                                                        });
                                                      },
                                                      style: ForTealButton,
                                                      child: const Padding(
                                                        padding:
                                                            EdgeInsets.all(8),
                                                        child: Text(
                                                          'Submit',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  FontNameDefault,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              letterSpacing: 1,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
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
                          }
                        },
                        style: ForTealButton,
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(4, 8, 4, 8),
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
                          padding: EdgeInsets.symmetric(horizontal: 5)),
                      ElevatedButton(
                        onPressed: () {
                          if (prefs.data!
                                  .getString('myRole')
                                  .toString()
                                  .toLowerCase() ==
                              'administrator') {
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
                                        "Are you sure you want to decline ${widget.firstname}'s request for becoming subscriber?",
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
                                            //batch write

                                            myDb
                                                .collection('subscribers')
                                                .doc(
                                                    '${widget.coopId}_${widget.subid}')
                                                .delete()
                                                .then((value) {
                                              //apply notifications to all staff
                                              myDb
                                                  .collection('staffs')
                                                  .where('coopID',
                                                      isEqualTo: widget.coopId)
                                                  .where('staffID',
                                                      isNotEqualTo: FirebaseAuth
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
                                                        .doc(widget.coopId)
                                                        .collection(data.docs[a]
                                                            ['staffID'])
                                                        .doc(DateFormat(
                                                                'yyyyMMddHHmmss')
                                                            .format(
                                                                DateTime.now()))
                                                        .set({
                                                      'context': 'subscriber',
                                                      'coopId': widget.coopId,
                                                      'title':
                                                          'Decline Subscriber Request',
                                                      'content':
                                                          "The Administrator has decline ${widget.firstname}'s subscriber request.",
                                                      'notifBy': FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .uid,
                                                      'notifId': data.docs[a]
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
                                                      isEqualTo: prefs.data!
                                                          .getString('coopId'))
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
                                                        .collection(data.docs[a]
                                                            ['staffID'])
                                                        .where('context',
                                                            isEqualTo:
                                                                'declinesubtoadmin')
                                                        .where('userId',
                                                            isEqualTo:
                                                                widget.subid)
                                                        .get()
                                                        .then((value) async {
                                                      if (value.size > 0) {
                                                        for (int b = 0;
                                                            b < value.size;
                                                            b++) {
                                                          await myDb
                                                              .collection(
                                                                  'notifications')
                                                              .doc(prefs.data!
                                                                  .getString(
                                                                      'coopId'))
                                                              .collection(data
                                                                      .docs[a]
                                                                  ['staffID'])
                                                              .doc(value
                                                                  .docs[b].id)
                                                              .delete();
                                                        }
                                                      }
                                                    });
                                                  }
                                                }
                                              });
                                              myDb
                                                  .collection('staffs')
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser!.uid)
                                                  .collection('transactions')
                                                  .doc(DateFormat(
                                                          'yyyyMMddHHmmss')
                                                      .format(DateTime.now()))
                                                  .set({
                                                'timestamp': DateTime.now(),
                                                'context': 'Subscriber',
                                                'content':
                                                    'You decline the request of ${widget.fullname} (${widget.email}).',
                                                'title':
                                                    'Decline Subscriber Request',
                                                'staffId': FirebaseAuth
                                                    .instance.currentUser!.uid,
                                              });

                                              okDialog(
                                                      context,
                                                      'Decline Successfully',
                                                      "You decline ${widget.firstname}'s request successfully")
                                                  .whenComplete(() {
                                                Navigator.pushReplacementNamed(
                                                    context,
                                                    '/subscribers/request');
                                              });
                                            }, onError: (e) {
                                              okDialog(
                                                  context,
                                                  'An Error Occured',
                                                  'Please try again. Later!');
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
                                  return AlertDialog(
                                    title: const Text(
                                      'Decline Confirmation',
                                      style: alertDialogTtl,
                                    ),
                                    content: Text(
                                      "Are you sure you want to decline ${widget.firstname}'s request for becoming subscriber?",
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
                                          WriteBatch batch = FirebaseFirestore
                                              .instance
                                              .batch();
                                          //batch write
                                          batch.update(
                                              myDb.collection('subscribers').doc(
                                                  '${widget.coopId}_${widget.subid}'),
                                              {
                                                'status': 'process',
                                                'timestamp': DateTime.now(),
                                              });

                                          batch.commit().then((value) {
                                            //apply notifications to all staff
                                            myDb
                                                .collection('staffs')
                                                .where('coopID',
                                                    isEqualTo: widget.coopId)
                                                .where('role',
                                                    isEqualTo: 'Adminstrator')
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
                                                      .collection(data.docs[a]
                                                          ['staffID'])
                                                      .doc(DateFormat(
                                                              'yyyyMMddHHmmss')
                                                          .format(
                                                              DateTime.now()))
                                                      .set({
                                                    'context':
                                                        'declinesubtoadmin',
                                                    'coopId': widget.coopId,
                                                    'title':
                                                        'Confirmation for Declining Subscriber Request',
                                                    'content':
                                                        "has submitted decline confirmation of ${widget.firstname}'s subscriber request.",
                                                    'notifBy': FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid,
                                                    'userId': widget.subid,
                                                    'notifId': data.docs[a]
                                                        ['staffID'],
                                                    'timestamp': DateTime.now(),
                                                    'status': 'unread',
                                                  });
                                                }
                                              }
                                            });
                                            myDb
                                                .collection('staffs')
                                                .doc(FirebaseAuth
                                                    .instance.currentUser!.uid)
                                                .collection('transactions')
                                                .doc(
                                                    DateFormat('yyyyMMddHHmmss')
                                                        .format(DateTime.now()))
                                                .set({
                                              'timestamp': DateTime.now(),
                                              'context': 'Subscriber',
                                              'content':
                                                  'You submit confirmation for decline of subscriber request of ${widget.fullname} (${widget.email}).',
                                              'title':
                                                  'Submit Confirmation for Declining Subscriber Request',
                                              'staffId': FirebaseAuth
                                                  .instance.currentUser!.uid,
                                            });

                                            okDialog(
                                                    context,
                                                    'Submitted Confirmation',
                                                    "Please wait for the response of administrator.")
                                                .whenComplete(() {
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
                          }
                        },
                        style: ForRedButton,
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(4, 8, 4, 8),
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
            }
          }
        });
  }
}
