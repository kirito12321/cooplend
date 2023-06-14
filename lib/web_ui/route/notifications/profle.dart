import 'dart:developer';

import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/route/loans/profile.dart';
import 'package:ascoop/web_ui/route/loans/profilereq.dart';
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

class ProfileConf extends StatefulWidget {
  String subId, staffid, context, docid;
  ProfileConf({
    super.key,
    required this.docid,
    required this.subId,
    required this.staffid,
    required this.context,
  });

  @override
  State<ProfileConf> createState() => _ProfileConfState();
}

class _ProfileConfState extends State<ProfileConf> {
  late int subprofIndex;
  @override
  void initState() {
    subprofIndex = 0;
    globals.listSubProfHead = [true, false];
    super.initState();
  }

  @override
  void dispose() {
    widget.subId;
    super.dispose();
  }

  callback(int x, int n) {
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
                              return SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(15),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 180,
                                              height: 180,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                      data[index]
                                                          ['profilePicUrl'],
                                                    ),
                                                    fit: BoxFit.cover,
                                                  )),
                                            ),
                                            Expanded(
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                padding:
                                                    const EdgeInsets.all(10),
                                                margin: const EdgeInsets.only(
                                                    left: 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${data[index]['userFirstName']} ${data[index]['userMiddleName']} ${data[index]['userLastName']}",
                                                      style: h3,
                                                    ),
                                                    const Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 2)),
                                                    Text(
                                                      data[index]['userEmail'],
                                                      style: h5,
                                                    ),
                                                    const Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 10)),
                                                    Builder(
                                                      builder: (context) {
                                                        switch (widget.context
                                                            .toLowerCase()) {
                                                          case 'blocksubtoadmin':
                                                            return Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
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
                                                                              isEqualTo: widget.staffid)
                                                                          .get(),
                                                                      builder:
                                                                          (context,
                                                                              snapshot) {
                                                                        try {
                                                                          final staff = snapshot
                                                                              .data!
                                                                              .docs;

                                                                          if (snapshot
                                                                              .hasError) {
                                                                            log('snapshot.hasError (pending.dart): ${snapshot.error}');
                                                                            return Container();
                                                                          } else if (snapshot.hasData &&
                                                                              data.isNotEmpty) {
                                                                            switch (snapshot.connectionState) {
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
                                                                                                  text: 'request to block this subscriber',
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
                                                                                                        'Block Confirmation',
                                                                                                        style: alertDialogTtl,
                                                                                                      ),
                                                                                                      content: Text(
                                                                                                        "Are you sure you want to block ${data[index]['userFirstName']}?",
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
                                                                                                            batch.update(myDb.collection('subscribers').doc('${prefs.data!.getString('coopId')}_${widget.subId}'), {
                                                                                                              'status': 'blocked',
                                                                                                              'blockedAt': DateTime.now(),
                                                                                                            });

                                                                                                            //commit
                                                                                                            batch.commit().then((value) async {
                                                                                                              //apply notifications to all staff
                                                                                                              myDb.collection('staffs').where('coopID', isEqualTo: prefs.data!.getString('coopId')).where('staffID', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid).get().then((value) async {
                                                                                                                if (value.size > 0) {
                                                                                                                  for (int a = 0; a < value.size; a++) {
                                                                                                                    await myDb.collection('notifications').doc(prefs.data!.getString('coopId')).collection(value.docs[a]['staffID']).doc(DateFormat('yyyyMMddHHmmss').format(DateTime.now())).set({
                                                                                                                      'context': 'subscriber',
                                                                                                                      'coopId': prefs.data!.getString('coopId'),
                                                                                                                      'title': 'Blocked Subscriber',
                                                                                                                      'content': "The Administrator has confirmed the blocked request for ${data[index]['userFirstName']} ${data[index]['userMiddleName']} ${data[index]['userLastName']} (${data[index]['userEmail']}) as subscriber.",
                                                                                                                      'notifBy': widget.staffid,
                                                                                                                      'notifId': value.docs[a]['staffID'],
                                                                                                                      'timestamp': DateTime.now(),
                                                                                                                      'status': 'unread',
                                                                                                                    });
                                                                                                                  }
                                                                                                                }
                                                                                                              });
                                                                                                              myDb.collection('notifications').doc(prefs.data!.getString('coopId')).collection(widget.staffid).doc(DateFormat('yyyyMMddHHmmss').format(DateTime.now())).set({
                                                                                                                'context': 'subscriber',
                                                                                                                'coopId': prefs.data!.getString('coopId'),
                                                                                                                'title': 'Blocked Subscriber',
                                                                                                                'content': "The Administrator has confirmed your block request for ${data[index]['userFirstName']} ${data[index]['userMiddleName']} ${data[index]['userLastName']} (${data[index]['userEmail']}) as subscriber.",
                                                                                                                'notifBy': widget.staffid,
                                                                                                                'notifId': widget.staffid,
                                                                                                                'timestamp': DateTime.now(),
                                                                                                                'status': 'unread',
                                                                                                              });
                                                                                                              myDb.collection('staffs').doc(FirebaseAuth.instance.currentUser!.uid).collection('transactions').doc(DateFormat('yyyyMMddHHmmss').format(DateTime.now())).set({
                                                                                                                'timestamp': DateTime.now(),
                                                                                                                'context': 'Subscriber',
                                                                                                                'content': 'You confirmed blocked request for ${data[index]['userFirstName']} ${data[index]['userMiddleName']} ${data[index]['userLastName']} (${data[index]['userEmail']}) as subscriber.',
                                                                                                                'title': 'Blocked Subscriber',
                                                                                                                'staffId': FirebaseAuth.instance.currentUser!.uid,
                                                                                                              });
                                                                                                              await myDb.collection('notifications').doc(prefs.data!.getString('coopId')).collection(FirebaseAuth.instance.currentUser!.uid).where('context', isEqualTo: 'blocksubtoadmin').where('userId', isEqualTo: widget.subId).get().then((value) {
                                                                                                                if (value.size != 0) {
                                                                                                                  for (int a = 0; a < value.size; a++) {
                                                                                                                    myDb.collection('notifications').doc(prefs.data!.getString('coopId')).collection(FirebaseAuth.instance.currentUser!.uid).doc(value.docs[a].id).delete();
                                                                                                                  }
                                                                                                                }
                                                                                                              });
                                                                                                            }, onError: (e) {
                                                                                                              okDialog(context, 'An Error Occured', 'Please try again. Later!');
                                                                                                            }).whenComplete(
                                                                                                              () => okDialog(context, 'Blocked Successfully', "You blocked ${data[index]['userFirstName']} successfully").whenComplete(() {
                                                                                                                Navigator.pop(context);
                                                                                                                Navigator.pop(context);
                                                                                                              }),
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
                                                                                                            await myDb.collection('notifications').doc(prefs.data!.getString('coopId')).collection(FirebaseAuth.instance.currentUser!.uid).where('context', isEqualTo: 'blocksubtoadmin').where('userId', isEqualTo: widget.subId).get().then((value) {
                                                                                                              if (value.size != 0) {
                                                                                                                for (int a = 0; a < value.size; a++) {
                                                                                                                  myDb.collection('notifications').doc(prefs.data!.getString('coopId')).collection(FirebaseAuth.instance.currentUser!.uid).doc(value.docs[a].id).delete();
                                                                                                                }
                                                                                                              }
                                                                                                            }).then((val) {
                                                                                                              myDb.collection('notifications').doc(prefs.data!.getString('coopId')).collection(widget.staffid).doc(DateFormat('yyyyMMddHHmmss').format(DateTime.now())).set({
                                                                                                                'context': 'subscriber',
                                                                                                                'coopId': prefs.data!.getString('coopId'),
                                                                                                                'title': 'Decline Confirmation Request',
                                                                                                                'content': "The Administrator has decline your block request for ${data[index]['userFirstName']} ${data[index]['userMiddleName']} ${data[index]['userLastName']} (${data[index]['userEmail']}) as subscriber.",
                                                                                                                'notifBy': widget.staffid,
                                                                                                                'notifId': widget.staffid,
                                                                                                                'timestamp': DateTime.now(),
                                                                                                                'status': 'unread',
                                                                                                              });
                                                                                                              myDb.collection('staffs').doc(FirebaseAuth.instance.currentUser!.uid).collection('transactions').doc(DateFormat('yyyyMMddHHmmss').format(DateTime.now())).set({
                                                                                                                'timestamp': DateTime.now(),
                                                                                                                'context': 'Subscriber',
                                                                                                                'content': 'You declined blocked request of ${staff[0]['firstname']} ${staff[0]['lastname']}.',
                                                                                                                'title': 'Decline Confirmation Request',
                                                                                                                'staffId': FirebaseAuth.instance.currentUser!.uid,
                                                                                                              });
                                                                                                            }, onError: (e) {
                                                                                                              okDialog(context, 'An Error Occured', 'Please try again. Later!');
                                                                                                            }).whenComplete(() {
                                                                                                              okDialog(context, 'Decline Successfully', "Block Request has been decline").whenComplete(() {
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
                                                            );
                                                          case 'approvesubtoadmin':
                                                            return Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
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
                                                                              isEqualTo: widget.staffid)
                                                                          .get(),
                                                                      builder:
                                                                          (context,
                                                                              snapshot) {
                                                                        try {
                                                                          final staff = snapshot
                                                                              .data!
                                                                              .docs;

                                                                          if (snapshot
                                                                              .hasError) {
                                                                            log('snapshot.hasError (pending.dart): ${snapshot.error}');
                                                                            return Container();
                                                                          } else if (snapshot.hasData &&
                                                                              data.isNotEmpty) {
                                                                            switch (snapshot.connectionState) {
                                                                              case ConnectionState.waiting:
                                                                                return onWait;
                                                                              default:
                                                                                return Column(
                                                                                  children: [
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        CircleAvatar(
                                                                                          backgroundImage: NetworkImage(staff[0]['profilePic']),
                                                                                          radius: 15,
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
                                                                                              children: [
                                                                                                TextSpan(
                                                                                                  text: "request to approve ${staff[0]['firstname']}'s subscriber request",
                                                                                                  style: const TextStyle(
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
                                                                                        const Padding(padding: EdgeInsets.only(left: 10)),
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
                                                                                                        "Are you sure you want to add ${data[index]['userFirstName']} to subscriber?",
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
                                                                                                            batch.update(myDb.collection('subscribers').doc('${prefs.data!.getString('coopId')}_${widget.subId}'), {
                                                                                                              'status': 'verified',
                                                                                                              'timestamp': DateTime.now(),
                                                                                                            });

                                                                                                            //commit
                                                                                                            batch.commit().then((value) async {
                                                                                                              //apply notifications to all staff
                                                                                                              myDb.collection('staffs').where('coopID', isEqualTo: prefs.data!.getString('coopId')).where('staffID', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid).get().then((value) async {
                                                                                                                if (value.size > 0) {
                                                                                                                  for (int a = 0; a < value.size; a++) {
                                                                                                                    await myDb.collection('notifications').doc(prefs.data!.getString('coopId')).collection(value.docs[a]['staffID']).doc(DateFormat('yyyyMMddHHmmss').format(DateTime.now())).set({
                                                                                                                      'context': 'subscriber',
                                                                                                                      'coopId': prefs.data!.getString('coopId'),
                                                                                                                      'title': 'Approved Subscriber',
                                                                                                                      'content': "The Administrator has confirmed the subscriber approbation request for ${data[index]['userFirstName']} ${data[index]['userMiddleName']} ${data[index]['userLastName']} (${data[index]['userEmail']}).",
                                                                                                                      'notifBy': widget.staffid,
                                                                                                                      'notifId': value.docs[a]['staffID'],
                                                                                                                      'timestamp': DateTime.now(),
                                                                                                                      'status': 'unread',
                                                                                                                    });
                                                                                                                  }
                                                                                                                }
                                                                                                              });
                                                                                                              myDb.collection('notifications').doc(prefs.data!.getString('coopId')).collection(widget.staffid).doc(DateFormat('yyyyMMddHHmmss').format(DateTime.now())).set({
                                                                                                                'context': 'subscriber',
                                                                                                                'coopId': prefs.data!.getString('coopId'),
                                                                                                                'title': 'Approved Subscriber',
                                                                                                                'content': "The Administrator has confirmed your subscriber approbation request for ${data[index]['userFirstName']} ${data[index]['userMiddleName']} ${data[index]['userLastName']} (${data[index]['userEmail']}).",
                                                                                                                'notifBy': widget.staffid,
                                                                                                                'notifId': widget.staffid,
                                                                                                                'timestamp': DateTime.now(),
                                                                                                                'status': 'unread',
                                                                                                              });
                                                                                                              myDb.collection('staffs').doc(FirebaseAuth.instance.currentUser!.uid).collection('transactions').doc(DateFormat('yyyyMMddHHmmss').format(DateTime.now())).set({
                                                                                                                'timestamp': DateTime.now(),
                                                                                                                'context': 'Subscriber',
                                                                                                                'content': 'You confirmed subscriber approbation request for ${data[index]['userFirstName']} ${data[index]['userMiddleName']} ${data[index]['userLastName']} (${data[index]['userEmail']}).',
                                                                                                                'title': 'Approved Subscriber',
                                                                                                                'staffId': FirebaseAuth.instance.currentUser!.uid,
                                                                                                              });
                                                                                                              await myDb.collection('notifications').doc(prefs.data!.getString('coopId')).collection(FirebaseAuth.instance.currentUser!.uid).where('context', isEqualTo: 'approvesubtoadmin').where('userId', isEqualTo: widget.subId).get().then((value) {
                                                                                                                if (value.size != 0) {
                                                                                                                  for (int a = 0; a < value.size; a++) {
                                                                                                                    myDb.collection('notifications').doc(prefs.data!.getString('coopId')).collection(FirebaseAuth.instance.currentUser!.uid).doc(value.docs[a].id).delete();
                                                                                                                  }
                                                                                                                }
                                                                                                              });
                                                                                                            }, onError: (e) {
                                                                                                              okDialog(context, 'An Error Occured', 'Please try again. Later!');
                                                                                                            }).whenComplete(() {
                                                                                                              okDialog(context, 'Approve Successfully', "You added ${data[index]['userFirstName']} to subscriber list").whenComplete(() {
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
                                                                                                            await myDb.collection('notifications').doc(prefs.data!.getString('coopId')).collection(FirebaseAuth.instance.currentUser!.uid).where('context', isEqualTo: 'approvesubtoadmin').where('userId', isEqualTo: widget.subId).get().then((value) {
                                                                                                              if (value.size != 0) {
                                                                                                                for (int a = 0; a < value.size; a++) {
                                                                                                                  myDb.collection('notifications').doc(prefs.data!.getString('coopId')).collection(FirebaseAuth.instance.currentUser!.uid).doc(value.docs[a].id).delete();
                                                                                                                }
                                                                                                              }
                                                                                                            }).then((val) async {
                                                                                                              batch.update(myDb.collection('subscribers').doc('${prefs.data!.getString('coopId')}_${widget.subId}'), {
                                                                                                                'status': 'pending',
                                                                                                              });
                                                                                                              batch.commit().then((value) async {
                                                                                                                myDb.collection('notifications').doc(prefs.data!.getString('coopId')).collection(widget.staffid).doc(DateFormat('yyyyMMddHHmmss').format(DateTime.now())).set({
                                                                                                                  'context': 'subscriber',
                                                                                                                  'coopId': prefs.data!.getString('coopId'),
                                                                                                                  'title': 'Decline Confirmation Request',
                                                                                                                  'content': "The Administrator has decline your subscriber approbation request for ${data[index]['userFirstName']} ${data[index]['userMiddleName']} ${data[index]['userLastName']} (${data[index]['userEmail']}).",
                                                                                                                  'notifBy': widget.staffid,
                                                                                                                  'notifId': widget.staffid,
                                                                                                                  'timestamp': DateTime.now(),
                                                                                                                  'status': 'unread',
                                                                                                                });
                                                                                                                myDb.collection('staffs').doc(FirebaseAuth.instance.currentUser!.uid).collection('transactions').doc(DateFormat('yyyyMMddHHmmss').format(DateTime.now())).set({
                                                                                                                  'timestamp': DateTime.now(),
                                                                                                                  'context': 'Subscriber',
                                                                                                                  'content': 'You declined subscrber approbation request of ${staff[0]['firstname']} ${staff[0]['lastname']}.',
                                                                                                                  'title': 'Decline Confirmation Request',
                                                                                                                  'staffId': FirebaseAuth.instance.currentUser!.uid,
                                                                                                                });
                                                                                                              });
                                                                                                            }, onError: (e) {
                                                                                                              okDialog(context, 'An Error Occured', 'Please try again. Later!');
                                                                                                            }).whenComplete(() {
                                                                                                              okDialog(context, 'Decline Successfully', "Subscriber Approbation Request has been decline").whenComplete(() {
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
                                                            );

                                                          case 'declinesubtoadmin':
                                                            return Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
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
                                                                              isEqualTo: widget.staffid)
                                                                          .get(),
                                                                      builder:
                                                                          (context,
                                                                              snapshot) {
                                                                        try {
                                                                          final staff = snapshot
                                                                              .data!
                                                                              .docs;

                                                                          if (snapshot
                                                                              .hasError) {
                                                                            log('snapshot.hasError (pending.dart): ${snapshot.error}');
                                                                            return Container();
                                                                          } else if (snapshot.hasData &&
                                                                              data.isNotEmpty) {
                                                                            switch (snapshot.connectionState) {
                                                                              case ConnectionState.waiting:
                                                                                return onWait;
                                                                              default:
                                                                                return Column(
                                                                                  children: [
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        CircleAvatar(
                                                                                          backgroundImage: NetworkImage(staff[0]['profilePic']),
                                                                                          radius: 15,
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
                                                                                              children: [
                                                                                                TextSpan(
                                                                                                  text: "request to decline ${staff[0]['firstname']}'s subscriber request",
                                                                                                  style: const TextStyle(
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
                                                                                        const Padding(padding: EdgeInsets.only(left: 10)),
                                                                                        ElevatedButton(
                                                                                          onPressed: () {
                                                                                            WriteBatch batch = FirebaseFirestore.instance.batch();
                                                                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                                                                              showDialog(
                                                                                                  context: context,
                                                                                                  builder: (context) {
                                                                                                    return AlertDialog(
                                                                                                      title: const Text(
                                                                                                        'Decline Subscriber Confirmation',
                                                                                                        style: alertDialogTtl,
                                                                                                      ),
                                                                                                      content: Text(
                                                                                                        "Are you sure you want to decline ${data[index]['userFirstName']}'s subscriber request?",
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
                                                                                                            batch.delete(myDb.collection('subscribers').doc('${prefs.data!.getString('coopId')}_${widget.subId}'));

                                                                                                            //commit
                                                                                                            batch.commit().then((value) async {
                                                                                                              //apply notifications to all staff
                                                                                                              myDb.collection('staffs').where('coopID', isEqualTo: prefs.data!.getString('coopId')).where('staffID', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid).get().then((value) async {
                                                                                                                if (value.size > 0) {
                                                                                                                  for (int a = 0; a < value.size; a++) {
                                                                                                                    await myDb.collection('notifications').doc(prefs.data!.getString('coopId')).collection(value.docs[a]['staffID']).doc(DateFormat('yyyyMMddHHmmss').format(DateTime.now())).set({
                                                                                                                      'context': 'subscriber',
                                                                                                                      'coopId': prefs.data!.getString('coopId'),
                                                                                                                      'title': 'Unblocked Subscriber',
                                                                                                                      'content': "The Administrator has confirmed the subscriber decline request for ${data[index]['userFirstName']} ${data[index]['userMiddleName']} ${data[index]['userLastName']} (${data[index]['userEmail']}).",
                                                                                                                      'notifBy': widget.staffid,
                                                                                                                      'notifId': value.docs[a]['staffID'],
                                                                                                                      'timestamp': DateTime.now(),
                                                                                                                      'status': 'unread',
                                                                                                                    });
                                                                                                                  }
                                                                                                                }
                                                                                                              });
                                                                                                              myDb.collection('notifications').doc(prefs.data!.getString('coopId')).collection(widget.staffid).doc(DateFormat('yyyyMMddHHmmss').format(DateTime.now())).set({
                                                                                                                'context': 'subscriber',
                                                                                                                'coopId': prefs.data!.getString('coopId'),
                                                                                                                'title': 'Unblocked Subscriber',
                                                                                                                'content': "The Administrator has confirmed your subscriber decline request for ${data[index]['userFirstName']} ${data[index]['userMiddleName']} ${data[index]['userLastName']} (${data[index]['userEmail']}) as subscriber.",
                                                                                                                'notifBy': widget.staffid,
                                                                                                                'notifId': widget.staffid,
                                                                                                                'timestamp': DateTime.now(),
                                                                                                                'status': 'unread',
                                                                                                              });
                                                                                                              myDb.collection('staffs').doc(FirebaseAuth.instance.currentUser!.uid).collection('transactions').doc(DateFormat('yyyyMMddHHmmss').format(DateTime.now())).set({
                                                                                                                'timestamp': DateTime.now(),
                                                                                                                'context': 'Subscriber',
                                                                                                                'content': 'You confirmed subscriber decline request for ${data[index]['userFirstName']} ${data[index]['userMiddleName']} ${data[index]['userLastName']} (${data[index]['userEmail']}) as subscriber.',
                                                                                                                'title': 'Unblocked Subscriber',
                                                                                                                'staffId': FirebaseAuth.instance.currentUser!.uid,
                                                                                                              });
                                                                                                              await myDb.collection('notifications').doc(prefs.data!.getString('coopId')).collection(FirebaseAuth.instance.currentUser!.uid).where('context', isEqualTo: 'blocksubtoadmin').where('userId', isEqualTo: widget.subId).get().then((value) {
                                                                                                                if (value.size != 0) {
                                                                                                                  for (int a = 0; a < value.size; a++) {
                                                                                                                    myDb.collection('notifications').doc(prefs.data!.getString('coopId')).collection(FirebaseAuth.instance.currentUser!.uid).doc(value.docs[a].id).delete();
                                                                                                                  }
                                                                                                                }
                                                                                                              });
                                                                                                            }, onError: (e) {
                                                                                                              okDialog(context, 'An Error Occured', 'Please try again. Later!');
                                                                                                            }).whenComplete(() {
                                                                                                              okDialog(context, 'Subscriber Decline Successfully', "You decline ${data[index]['userFirstName']}'s subscriber request successfully").whenComplete(() {
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
                                                                                                            await myDb.collection('notifications').doc(prefs.data!.getString('coopId')).collection(FirebaseAuth.instance.currentUser!.uid).where('context', isEqualTo: 'declinesubtoadmin').where('userId', isEqualTo: widget.subId).get().then((value) {
                                                                                                              if (value.size != 0) {
                                                                                                                for (int a = 0; a < value.size; a++) {
                                                                                                                  myDb.collection('notifications').doc(prefs.data!.getString('coopId')).collection(FirebaseAuth.instance.currentUser!.uid).doc(value.docs[a].id).delete();
                                                                                                                }
                                                                                                              }
                                                                                                            }).then((val) {
                                                                                                              myDb.collection('notifications').doc(prefs.data!.getString('coopId')).collection(widget.staffid).doc(DateFormat('yyyyMMddHHmmss').format(DateTime.now())).set({
                                                                                                                'context': 'subscriber',
                                                                                                                'coopId': prefs.data!.getString('coopId'),
                                                                                                                'title': 'Decline Confirmation Request',
                                                                                                                'content': "The Administrator has decline your decline a subscriber request for ${data[index]['userFirstName']} ${data[index]['userMiddleName']} ${data[index]['userLastName']} (${data[index]['userEmail']}) as subscriber.",
                                                                                                                'notifBy': widget.staffid,
                                                                                                                'notifId': widget.staffid,
                                                                                                                'timestamp': DateTime.now(),
                                                                                                                'status': 'unread',
                                                                                                              });
                                                                                                              myDb.collection('staffs').doc(FirebaseAuth.instance.currentUser!.uid).collection('transactions').doc(DateFormat('yyyyMMddHHmmss').format(DateTime.now())).set({
                                                                                                                'timestamp': DateTime.now(),
                                                                                                                'context': 'Subscriber',
                                                                                                                'content': 'You declined a decline subscriber request of ${staff[0]['firstname']} ${staff[0]['lastname']}.',
                                                                                                                'title': 'Decline Confirmation Request',
                                                                                                                'staffId': FirebaseAuth.instance.currentUser!.uid,
                                                                                                              });
                                                                                                            }, onError: (e) {
                                                                                                              okDialog(context, 'An Error Occured', 'Please try again. Later!');
                                                                                                            }).whenComplete(() {
                                                                                                              okDialog(context, 'Decline Successfully', "Decline Request has been decline").whenComplete(() {
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
                                                            );
                                                          case 'unblocksubtoadmin':
                                                            return Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
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
                                                                              isEqualTo: widget.staffid)
                                                                          .get(),
                                                                      builder:
                                                                          (context,
                                                                              snapshot) {
                                                                        try {
                                                                          final staff = snapshot
                                                                              .data!
                                                                              .docs;

                                                                          if (snapshot
                                                                              .hasError) {
                                                                            log('snapshot.hasError (pending.dart): ${snapshot.error}');
                                                                            return Container();
                                                                          } else if (snapshot.hasData &&
                                                                              data.isNotEmpty) {
                                                                            switch (snapshot.connectionState) {
                                                                              case ConnectionState.waiting:
                                                                                return onWait;
                                                                              default:
                                                                                return Column(
                                                                                  children: [
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        CircleAvatar(
                                                                                          backgroundImage: NetworkImage(staff[0]['profilePic']),
                                                                                          radius: 15,
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
                                                                                                  text: 'request to unblock this subscriber',
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
                                                                                        const Padding(padding: EdgeInsets.only(left: 10)),
                                                                                        ElevatedButton(
                                                                                          onPressed: () {
                                                                                            WriteBatch batch = FirebaseFirestore.instance.batch();
                                                                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                                                                              showDialog(
                                                                                                  context: context,
                                                                                                  builder: (context) {
                                                                                                    return AlertDialog(
                                                                                                      title: const Text(
                                                                                                        'Unblock Confirmation',
                                                                                                        style: alertDialogTtl,
                                                                                                      ),
                                                                                                      content: Text(
                                                                                                        "Are you sure you want to unblock ${data[index]['userFirstName']}?",
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
                                                                                                            batch.update(myDb.collection('subscribers').doc('${prefs.data!.getString('coopId')}_${widget.subId}'), {
                                                                                                              'status': 'verified',
                                                                                                              'timestamp': DateTime.now(),
                                                                                                            });

                                                                                                            //commit
                                                                                                            batch.commit().then((value) async {
                                                                                                              //apply notifications to all staff
                                                                                                              myDb.collection('staffs').where('coopID', isEqualTo: prefs.data!.getString('coopId')).where('staffID', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid).get().then((value) async {
                                                                                                                if (value.size > 0) {
                                                                                                                  for (int a = 0; a < value.size; a++) {
                                                                                                                    await myDb.collection('notifications').doc(prefs.data!.getString('coopId')).collection(value.docs[a]['staffID']).doc(DateFormat('yyyyMMddHHmmss').format(DateTime.now())).set({
                                                                                                                      'context': 'subscriber',
                                                                                                                      'coopId': prefs.data!.getString('coopId'),
                                                                                                                      'title': 'Unblocked Subscriber',
                                                                                                                      'content': "The Administrator has confirmed the unblocked request for ${data[index]['userFirstName']} ${data[index]['userMiddleName']} ${data[index]['userLastName']} (${data[index]['userEmail']}) as subscriber.",
                                                                                                                      'notifBy': widget.staffid,
                                                                                                                      'notifId': value.docs[a]['staffID'],
                                                                                                                      'timestamp': DateTime.now(),
                                                                                                                      'status': 'unread',
                                                                                                                    });
                                                                                                                  }
                                                                                                                }
                                                                                                              });
                                                                                                              myDb.collection('notifications').doc(prefs.data!.getString('coopId')).collection(widget.staffid).doc(DateFormat('yyyyMMddHHmmss').format(DateTime.now())).set({
                                                                                                                'context': 'subscriber',
                                                                                                                'coopId': prefs.data!.getString('coopId'),
                                                                                                                'title': 'Unblocked Subscriber',
                                                                                                                'content': "The Administrator has confirmed your unblock request for ${data[index]['userFirstName']} ${data[index]['userMiddleName']} ${data[index]['userLastName']} (${data[index]['userEmail']}) as subscriber.",
                                                                                                                'notifBy': widget.staffid,
                                                                                                                'notifId': widget.staffid,
                                                                                                                'timestamp': DateTime.now(),
                                                                                                                'status': 'unread',
                                                                                                              });
                                                                                                              myDb.collection('staffs').doc(FirebaseAuth.instance.currentUser!.uid).collection('transactions').doc(DateFormat('yyyyMMddHHmmss').format(DateTime.now())).set({
                                                                                                                'timestamp': DateTime.now(),
                                                                                                                'context': 'Subscriber',
                                                                                                                'content': 'You confirmed unblocked request for ${data[index]['userFirstName']} ${data[index]['userMiddleName']} ${data[index]['userLastName']} (${data[index]['userEmail']}) as subscriber.',
                                                                                                                'title': 'Unblocked Subscriber',
                                                                                                                'staffId': FirebaseAuth.instance.currentUser!.uid,
                                                                                                              });
                                                                                                              await myDb.collection('notifications').doc(prefs.data!.getString('coopId')).collection(FirebaseAuth.instance.currentUser!.uid).where('context', isEqualTo: 'blocksubtoadmin').where('userId', isEqualTo: widget.subId).get().then((value) {
                                                                                                                if (value.size != 0) {
                                                                                                                  for (int a = 0; a < value.size; a++) {
                                                                                                                    myDb.collection('notifications').doc(prefs.data!.getString('coopId')).collection(FirebaseAuth.instance.currentUser!.uid).doc(value.docs[a].id).delete();
                                                                                                                  }
                                                                                                                }
                                                                                                              });
                                                                                                            }, onError: (e) {
                                                                                                              okDialog(context, 'An Error Occured', 'Please try again. Later!');
                                                                                                            }).whenComplete(() {
                                                                                                              okDialog(context, 'Unblocked Successfully', "You unblocked ${data[index]['userFirstName']} successfully").whenComplete(() {
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
                                                                                                            await myDb.collection('notifications').doc(prefs.data!.getString('coopId')).collection(FirebaseAuth.instance.currentUser!.uid).where('context', isEqualTo: 'blocksubtoadmin').where('userId', isEqualTo: widget.subId).get().then((value) {
                                                                                                              if (value.size != 0) {
                                                                                                                for (int a = 0; a < value.size; a++) {
                                                                                                                  myDb.collection('notifications').doc(prefs.data!.getString('coopId')).collection(FirebaseAuth.instance.currentUser!.uid).doc(value.docs[a].id).delete();
                                                                                                                }
                                                                                                              }
                                                                                                            }).then((val) {
                                                                                                              myDb.collection('notifications').doc(prefs.data!.getString('coopId')).collection(widget.staffid).doc(DateFormat('yyyyMMddHHmmss').format(DateTime.now())).set({
                                                                                                                'context': 'subscriber',
                                                                                                                'coopId': prefs.data!.getString('coopId'),
                                                                                                                'title': 'Decline Confirmation Request',
                                                                                                                'content': "The Administrator has decline your unblock request for ${data[index]['userFirstName']} ${data[index]['userMiddleName']} ${data[index]['userLastName']} (${data[index]['userEmail']}) as subscriber.",
                                                                                                                'notifBy': widget.staffid,
                                                                                                                'notifId': widget.staffid,
                                                                                                                'timestamp': DateTime.now(),
                                                                                                                'status': 'unread',
                                                                                                              });
                                                                                                              myDb.collection('staffs').doc(FirebaseAuth.instance.currentUser!.uid).collection('transactions').doc(DateFormat('yyyyMMddHHmmss').format(DateTime.now())).set({
                                                                                                                'timestamp': DateTime.now(),
                                                                                                                'context': 'Subscriber',
                                                                                                                'content': 'You declined unblocked request of ${staff[0]['firstname']} ${staff[0]['lastname']}.',
                                                                                                                'title': 'Decline Confirmation Request',
                                                                                                                'staffId': FirebaseAuth.instance.currentUser!.uid,
                                                                                                              });
                                                                                                            }, onError: (e) {
                                                                                                              okDialog(context, 'An Error Occured', 'Please try again. Later!');
                                                                                                            }).whenComplete(() {
                                                                                                              okDialog(context, 'Decline Successfully', "Unblock Request has been decline").whenComplete(() {
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
                                                            );
                                                        }
                                                        return Container();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Column(
                                          children: [
                                            SubProfHeader(
                                              callback: callback,
                                              status: data[index]['status'],
                                              fname: data[index]
                                                  ['userFirstName'],
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
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
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  topRight: Radius.circular(20),
                                                ),
                                              ),
                                              child: IndexedStack(
                                                index: subprofIndex,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .all(15),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          color: Colors.white,
                                                          boxShadow: const [
                                                            BoxShadow(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        122,
                                                                        122,
                                                                        122),
                                                                spreadRadius: 0,
                                                                blurStyle:
                                                                    BlurStyle
                                                                        .normal,
                                                                blurRadius: 1.6)
                                                          ],
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'About ${data[index]['userFirstName']}',
                                                              style: h3,
                                                            ),
                                                            Column(
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(15),
                                                                  child: Row(
                                                                    children: [
                                                                      const Icon(
                                                                        Feather
                                                                            .map_pin,
                                                                        size:
                                                                            30,
                                                                      ),
                                                                      const Padding(
                                                                          padding:
                                                                              EdgeInsets.symmetric(horizontal: 7)),
                                                                      Expanded(
                                                                        child:
                                                                            RichText(
                                                                          text:
                                                                              TextSpan(
                                                                            text:
                                                                                'Lives In ',
                                                                            style:
                                                                                const TextStyle(
                                                                              fontFamily: FontNameDefault,
                                                                              color: Colors.black,
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.w500,
                                                                              letterSpacing: 0.5,
                                                                            ),
                                                                            children: [
                                                                              TextSpan(
                                                                                text: "${data[0]['userAddress']}",
                                                                                style: const TextStyle(
                                                                                  fontFamily: FontNameDefault,
                                                                                  color: Colors.black,
                                                                                  fontSize: 16,
                                                                                  fontWeight: FontWeight.w800,
                                                                                  letterSpacing: 0.5,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(15),
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                    Feather
                                                                        .phone_call,
                                                                    size: 25,
                                                                  ),
                                                                  const Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              8)),
                                                                  Expanded(
                                                                    child: Text(
                                                                      data[0][
                                                                          'userMobileNo'],
                                                                      style: GoogleFonts.montserrat(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w800),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(15),
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                    Feather
                                                                        .mail,
                                                                    size: 30,
                                                                  ),
                                                                  const Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              8)),
                                                                  Expanded(
                                                                    child: Text(
                                                                      data[0][
                                                                          'userEmail'],
                                                                      style: GoogleFonts.montserrat(
                                                                          fontSize:
                                                                              17,
                                                                          fontWeight:
                                                                              FontWeight.w800),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(15),
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                    Feather
                                                                        .user,
                                                                    size: 30,
                                                                  ),
                                                                  const Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              8)),
                                                                  Expanded(
                                                                    child: Text(
                                                                      "${data[0]['gender']}",
                                                                      style: GoogleFonts.montserrat(
                                                                          fontSize:
                                                                              17,
                                                                          fontWeight:
                                                                              FontWeight.w800),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(15),
                                                              child: Row(
                                                                children: [
                                                                  const Icon(
                                                                    Feather
                                                                        .calendar,
                                                                    size: 30,
                                                                  ),
                                                                  const Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              8)),
                                                                  Expanded(
                                                                    child: Text(
                                                                      DateFormat(
                                                                              'MMMM d, yyyy')
                                                                          .format(
                                                                              data[0]['birthdate'].toDate()),
                                                                      style: GoogleFonts.montserrat(
                                                                          fontSize:
                                                                              17,
                                                                          fontWeight:
                                                                              FontWeight.w800),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
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
                                                              Container(
                                                                width: 450,
                                                                height: 200,
                                                                margin:
                                                                    const EdgeInsets
                                                                        .all(15),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  boxShadow: const [
                                                                    BoxShadow(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            122,
                                                                            122,
                                                                            122),
                                                                        spreadRadius:
                                                                            0,
                                                                        blurStyle:
                                                                            BlurStyle
                                                                                .normal,
                                                                        blurRadius:
                                                                            2.6)
                                                                  ],
                                                                ),
                                                                child: Column(
                                                                  children: [
                                                                    Container(
                                                                      width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                      height:
                                                                          50,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .teal[800],
                                                                        borderRadius:
                                                                            const BorderRadius.only(
                                                                          topLeft:
                                                                              Radius.circular(10),
                                                                          topRight:
                                                                              Radius.circular(10),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          'Capital Share'
                                                                              .toUpperCase(),
                                                                          style:
                                                                              const TextStyle(
                                                                            fontFamily:
                                                                                FontNameDefault,
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.w800,
                                                                            letterSpacing:
                                                                                1,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child: StreamBuilder(
                                                                          stream: myDb.collection('subscribers').doc(data[index].id).collection('coopAccDetails').doc('Data').snapshots(),
                                                                          builder: (context, snapshot) {
                                                                            try {
                                                                              if (snapshot.hasError) {
                                                                                log('snapshot.hasError (coopdash): ${snapshot.error}');
                                                                                return Container();
                                                                              } else if (snapshot.hasData) {
                                                                                switch (snapshot.connectionState) {
                                                                                  case ConnectionState.waiting:
                                                                                    return onWait;
                                                                                  default:
                                                                                    return Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                      children: [
                                                                                        Text(
                                                                                          'PHP ${NumberFormat('###,###,###,###,###.##').format(snapshot.data!.data()!['capitalShare'])}',
                                                                                          style: h1,
                                                                                        ),
                                                                                        Text(
                                                                                          'Total Shares',
                                                                                          style: h5,
                                                                                        )
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
                                                              Container(
                                                                width: 450,
                                                                height: 200,
                                                                margin:
                                                                    const EdgeInsets
                                                                        .all(15),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  boxShadow: const [
                                                                    BoxShadow(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            122,
                                                                            122,
                                                                            122),
                                                                        spreadRadius:
                                                                            0,
                                                                        blurStyle:
                                                                            BlurStyle
                                                                                .normal,
                                                                        blurRadius:
                                                                            2.6)
                                                                  ],
                                                                ),
                                                                child: Column(
                                                                  children: [
                                                                    Container(
                                                                      width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                      height:
                                                                          50,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .teal[800],
                                                                        borderRadius:
                                                                            const BorderRadius.only(
                                                                          topLeft:
                                                                              Radius.circular(10),
                                                                          topRight:
                                                                              Radius.circular(10),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          'Savings'
                                                                              .toUpperCase(),
                                                                          style:
                                                                              const TextStyle(
                                                                            fontFamily:
                                                                                FontNameDefault,
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.w800,
                                                                            letterSpacing:
                                                                                1,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child: StreamBuilder(
                                                                          stream: myDb.collection('subscribers').doc(data[index].id).collection('coopAccDetails').doc('Data').snapshots(),
                                                                          builder: (context, snapshot) {
                                                                            try {
                                                                              if (snapshot.hasError) {
                                                                                log('snapshot.hasError (coopdash): ${snapshot.error}');
                                                                                return Container();
                                                                              } else if (snapshot.hasData) {
                                                                                switch (snapshot.connectionState) {
                                                                                  case ConnectionState.waiting:
                                                                                    return onWait;
                                                                                  default:
                                                                                    return Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                      children: [
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                                          children: [
                                                                                            Text(
                                                                                              'PHP ${NumberFormat('###,###,###,###,###.##').format(snapshot.data!.data()!['savings'])}',
                                                                                              style: h1,
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        const Text(
                                                                                          'Total Savings',
                                                                                          style: h5,
                                                                                        )
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
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        height: 800,
                                                        margin: const EdgeInsets
                                                            .all(15),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          boxShadow: const [
                                                            BoxShadow(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        122,
                                                                        122,
                                                                        122),
                                                                spreadRadius: 0,
                                                                blurStyle:
                                                                    BlurStyle
                                                                        .normal,
                                                                blurRadius: 2.6)
                                                          ],
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              height: 50,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .teal[800],
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          10),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          10),
                                                                ),
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  'Valid ID'
                                                                      .toUpperCase(),
                                                                  style:
                                                                      const TextStyle(
                                                                    fontFamily:
                                                                        FontNameDefault,
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                    letterSpacing:
                                                                        1,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                        color: Colors
                                                                            .black,
                                                                        image:
                                                                            DecorationImage(
                                                                          image:
                                                                              NetworkImage(data[index]['validIdUrl']),
                                                                          fit: BoxFit
                                                                              .contain,
                                                                        )),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        height: 800,
                                                        margin: const EdgeInsets
                                                            .all(15),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          boxShadow: const [
                                                            BoxShadow(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        122,
                                                                        122,
                                                                        122),
                                                                spreadRadius: 0,
                                                                blurStyle:
                                                                    BlurStyle
                                                                        .normal,
                                                                blurRadius: 2.6)
                                                          ],
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              height: 50,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .teal[800],
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          10),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          10),
                                                                ),
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  'Selfie With ID'
                                                                      .toUpperCase(),
                                                                  style:
                                                                      const TextStyle(
                                                                    fontFamily:
                                                                        FontNameDefault,
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                    letterSpacing:
                                                                        1,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                        color: Colors
                                                                            .black,
                                                                        image:
                                                                            DecorationImage(
                                                                          image:
                                                                              NetworkImage(data[index]['selfiewithIdUrl']),
                                                                          fit: BoxFit
                                                                              .contain,
                                                                        )),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  //loan details
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: StreamBuilder(
                                                        stream: myDb
                                                            .collection('loans')
                                                            .where('userId',
                                                                isEqualTo: data[
                                                                        index]
                                                                    ['userId'])
                                                            .where('coopId',
                                                                isEqualTo: data[
                                                                        index]
                                                                    ['coopId'])
                                                            .orderBy(
                                                                'loanStatus')
                                                            .snapshots(),
                                                        builder: (context,
                                                            snapshot) {
                                                          try {
                                                            final loans =
                                                                snapshot
                                                                    .data!.docs;
                                                            if (snapshot
                                                                .hasError) {
                                                              log('snapshot.hasError (pending.dart): ${snapshot.error}');
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
                                                                  list(loans
                                                                      .length);
                                                                  return Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Container(
                                                                        width: MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                        padding:
                                                                            const EdgeInsets.all(10),
                                                                        child:
                                                                            ScrollConfiguration(
                                                                          behavior:
                                                                              MyCustomScrollBehavior(),
                                                                          child:
                                                                              SingleChildScrollView(
                                                                            child:
                                                                                ListView.builder(
                                                                              shrinkWrap: true,
                                                                              itemCount: loans.length,
                                                                              itemBuilder: (context, index) {
                                                                                return InkWell(
                                                                                  onTap: () {
                                                                                    setState(() {
                                                                                      int sel = index;
                                                                                      select(sel);

                                                                                      showDialog(
                                                                                        context: context,
                                                                                        builder: (context) {
                                                                                          return AlertDialog(
                                                                                            content: Container(
                                                                                              width: 900,
                                                                                              height: MediaQuery.of(context).size.height,
                                                                                              child: Builder(
                                                                                                builder: (context) {
                                                                                                  switch (loans[sel]['loanStatus'].toString().toLowerCase()) {
                                                                                                    case 'active':
                                                                                                      return LoanProfile(loanId: loans[sel]['loanId']);
                                                                                                    case 'completed':
                                                                                                      return LoanProfile(loanId: loans[sel]['loanId']);
                                                                                                    default:
                                                                                                      return LoanProfileReq(loanId: loans[sel]['loanId']);
                                                                                                  }
                                                                                                },
                                                                                              ),
                                                                                            ),
                                                                                          );
                                                                                        },
                                                                                      );
                                                                                    });
                                                                                  },
                                                                                  child: Container(
                                                                                    padding: const EdgeInsets.all(10),
                                                                                    margin: const EdgeInsets.only(bottom: 10),
                                                                                    width: MediaQuery.of(context).size.width,
                                                                                    decoration: BoxDecoration(
                                                                                      color: Colors.white,
                                                                                      borderRadius: BorderRadius.circular(10),
                                                                                      border: Border.all(color: _loan[index] == true ? teal8 : Colors.transparent, width: 2),
                                                                                      boxShadow: [
                                                                                        BoxShadow(color: _loan[index] == true ? teal8 : grey4, spreadRadius: 0.2, blurStyle: BlurStyle.normal, blurRadius: 1.6),
                                                                                      ],
                                                                                    ),
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                      children: [
                                                                                        Column(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            const Text(
                                                                                              'LOAN NO.',
                                                                                              style: TextStyle(
                                                                                                fontFamily: FontNameDefault,
                                                                                                fontSize: 10,
                                                                                                letterSpacing: 1,
                                                                                                fontWeight: FontWeight.w400,
                                                                                                color: Colors.black,
                                                                                              ),
                                                                                            ),
                                                                                            Text(
                                                                                              loans[index]['loanId'],
                                                                                              style: const TextStyle(
                                                                                                fontFamily: FontNameDefault,
                                                                                                fontSize: 14,
                                                                                                fontWeight: FontWeight.w700,
                                                                                                color: Colors.black,
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        Column(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            const Text(
                                                                                              'LOAN AMOUNT',
                                                                                              style: TextStyle(
                                                                                                fontFamily: FontNameDefault,
                                                                                                fontSize: 10,
                                                                                                letterSpacing: 1,
                                                                                                fontWeight: FontWeight.w400,
                                                                                                color: Colors.black,
                                                                                              ),
                                                                                            ),
                                                                                            Text(
                                                                                              'PHP ${NumberFormat('###,###,###,###.##').format(loans[index]['loanAmount'])}',
                                                                                              style: const TextStyle(
                                                                                                fontFamily: FontNameDefault,
                                                                                                fontSize: 14,
                                                                                                fontWeight: FontWeight.w700,
                                                                                                color: Colors.black,
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        Column(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            const Text(
                                                                                              'LOAN TYPE',
                                                                                              style: TextStyle(
                                                                                                fontFamily: FontNameDefault,
                                                                                                fontSize: 10,
                                                                                                letterSpacing: 1,
                                                                                                fontWeight: FontWeight.w400,
                                                                                                color: Colors.black,
                                                                                              ),
                                                                                            ),
                                                                                            Text(
                                                                                              '${loans[index]['loanType']} Loan'.toUpperCase(),
                                                                                              style: const TextStyle(
                                                                                                fontFamily: FontNameDefault,
                                                                                                fontSize: 14,
                                                                                                fontWeight: FontWeight.w700,
                                                                                                color: Colors.black,
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        Builder(builder: (context) {
                                                                                          if (loans[index]['loanStatus'].toString().toLowerCase() == 'pending' || loans[index]['loanStatus'].toString().toLowerCase() == 'process') {
                                                                                            return Column(
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                const Text(
                                                                                                  'DATE REQUESTED',
                                                                                                  style: TextStyle(
                                                                                                    fontFamily: FontNameDefault,
                                                                                                    fontSize: 10,
                                                                                                    letterSpacing: 1,
                                                                                                    fontWeight: FontWeight.w400,
                                                                                                    color: Colors.black,
                                                                                                  ),
                                                                                                ),
                                                                                                Text(
                                                                                                  DateFormat('MMM d, yyyy').format(loans[index]['createdAt'].toDate()).toUpperCase(),
                                                                                                  style: const TextStyle(
                                                                                                    fontFamily: FontNameDefault,
                                                                                                    fontSize: 14,
                                                                                                    fontWeight: FontWeight.w700,
                                                                                                    color: Colors.black,
                                                                                                  ),
                                                                                                )
                                                                                              ],
                                                                                            );
                                                                                          } else if (loans[index]['loanStatus'].toString().toLowerCase() == 'completed') {
                                                                                            Column(
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                const Text(
                                                                                                  'DATE COMPLETED',
                                                                                                  style: TextStyle(
                                                                                                    fontFamily: FontNameDefault,
                                                                                                    fontSize: 10,
                                                                                                    letterSpacing: 1,
                                                                                                    fontWeight: FontWeight.w400,
                                                                                                    color: Colors.black,
                                                                                                  ),
                                                                                                ),
                                                                                                Text(
                                                                                                  DateFormat('MMM d, yyyy').format(loans[index]['completeAt'].toDate()).toUpperCase(),
                                                                                                  style: const TextStyle(
                                                                                                    fontFamily: FontNameDefault,
                                                                                                    fontSize: 14,
                                                                                                    fontWeight: FontWeight.w700,
                                                                                                    color: Colors.black,
                                                                                                  ),
                                                                                                )
                                                                                              ],
                                                                                            );
                                                                                          }
                                                                                          return Column(
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: [
                                                                                              const Text(
                                                                                                'DATE ACTIVE',
                                                                                                style: TextStyle(
                                                                                                  fontFamily: FontNameDefault,
                                                                                                  fontSize: 10,
                                                                                                  letterSpacing: 1,
                                                                                                  fontWeight: FontWeight.w400,
                                                                                                  color: Colors.black,
                                                                                                ),
                                                                                              ),
                                                                                              Text(
                                                                                                DateFormat('MMM d, yyyy').format(loans[index]['activeAt'].toDate()).toUpperCase(),
                                                                                                style: const TextStyle(
                                                                                                  fontFamily: FontNameDefault,
                                                                                                  fontSize: 14,
                                                                                                  fontWeight: FontWeight.w700,
                                                                                                  color: Colors.black,
                                                                                                ),
                                                                                              )
                                                                                            ],
                                                                                          );
                                                                                        }),
                                                                                        Column(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            const Text(
                                                                                              'STATUS',
                                                                                              style: TextStyle(
                                                                                                fontFamily: FontNameDefault,
                                                                                                fontSize: 10,
                                                                                                letterSpacing: 1,
                                                                                                fontWeight: FontWeight.w400,
                                                                                                color: Colors.black,
                                                                                              ),
                                                                                            ),
                                                                                            Text(
                                                                                              loans[index]['loanStatus'].toString().toUpperCase(),
                                                                                              style: const TextStyle(
                                                                                                fontFamily: FontNameDefault,
                                                                                                fontSize: 14,
                                                                                                fontWeight: FontWeight.w700,
                                                                                                color: Colors.black,
                                                                                              ),
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        width: MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                        height:
                                                                            500,
                                                                      )
                                                                    ],
                                                                  );
                                                              }
                                                            } else if (data
                                                                .isEmpty) {
                                                              return EmptyData(
                                                                  ttl:
                                                                      'No Loans Yet');
                                                            }
                                                          } catch (e) {}
                                                          return onWait;
                                                        }),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      )
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
                                "Select subscriber's name to view their profile",
                                style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          );
                        }
                      } catch (e) {
                        log('profile.dart error (stream): ${e}');
                      }
                      return Container();
                    });
            }
          }
        });
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
