import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/styles/buttonstyle.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:ascoop/web_ui/utils/alertdialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlockedSub extends StatefulWidget {
  String coopId, firstname, fullname, email, subid;
  Widget icon;
  int index;
  BlockedSub({
    super.key,
    required this.coopId,
    required this.firstname,
    required this.fullname,
    required this.email,
    required this.index,
    required this.icon,
    required this.subid,
  });

  @override
  State<BlockedSub> createState() => _BlockedSubState();
}

class _BlockedSubState extends State<BlockedSub> {
  @override
  void dispose() {
    widget.coopId;
    widget.firstname;
    widget.fullname;
    widget.email;
    widget.index;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late final SharedPreferences prefs;
    late final prefsFuture =
        SharedPreferences.getInstance().then((v) => prefs = v);
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
                return PopupMenuButton(
                  padding: const EdgeInsets.all(8),
                  tooltip: '',
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: () {
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
                                  return AlertDialog(
                                    title: const Text(
                                      'Block Confirmation',
                                      style: alertDialogTtl,
                                    ),
                                    content: Text(
                                      "Are you sure you want to block ${widget.firstname}?",
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
                                          batch.update(
                                              myDb.collection('subscribers').doc(
                                                  '${widget.coopId}_${widget.subid}'),
                                              {
                                                'status': 'blocked',
                                                'timestamp': DateTime.now(),
                                              });

                                          //commit
                                          batch.commit().then((value) {
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
                                                        'Blocked Subscriber',
                                                    'content':
                                                        "The Administrator has blocked ${widget.fullname} (${widget.email}) as subscriber.",
                                                    'notifBy': FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid,
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
                                                  'You blocked ${widget.fullname} (${widget.email}) as subscriber.',
                                              'title': 'Blocked Subscriber',
                                              'staffId': FirebaseAuth
                                                  .instance.currentUser!.uid,
                                            });

                                            okDialog(
                                                    context,
                                                    'Blocked Successfully',
                                                    "You blocked ${widget.firstname} successfully")
                                                .whenComplete(() {
                                              Navigator.pop(context);
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
                                      "Are you sure you want to block ${widget.firstname}?",
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

                                          //apply notifications to all staff
                                          myDb
                                              .collection('staffs')
                                              .where('coopID',
                                                  isEqualTo: widget.coopId)
                                              .where('role',
                                                  isEqualTo: 'Administrator')
                                              .get()
                                              .then((data) async {
                                            if (data.size > 0) {
                                              for (int a = 0;
                                                  a < data.size;
                                                  a++) {
                                                await myDb
                                                    .collection('notifications')
                                                    .doc(widget.coopId)
                                                    .collection(
                                                        data.docs[a]['staffID'])
                                                    .doc(DateFormat(
                                                            'yyyyMMddHHmmss')
                                                        .format(DateTime.now()))
                                                    .set({
                                                  'context': 'blocksubtoadmin',
                                                  'coopId': widget.coopId,
                                                  'title':
                                                      'Confirmation for Blocking a Subscriber',
                                                  'content':
                                                      "has submitted confirmation for blocking ${widget.fullname} (${widget.email}) in subscriber list.",
                                                  'notifBy': FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid,
                                                  'notifId': data.docs[a]
                                                      ['staffID'],
                                                  'userId': widget.subid,
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
                                              .doc(DateFormat('yyyyMMddHHmmss')
                                                  .format(DateTime.now()))
                                              .set({
                                            'timestamp': DateTime.now(),
                                            'context': 'Subscriber',
                                            'content':
                                                'You submit confirmation for blocking ${widget.fullname} (${widget.email}) in subscriber list.',
                                            'title':
                                                'Submit Confirmation for Blocking Subscriber',
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
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Feather.slash,
                            color: Colors.orange[900],
                            size: 25,
                          ),
                          const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6)),
                          Text(
                            'Block ${widget.firstname}',
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange[900],
                            ),
                          )
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () {
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
                                      'Remove Confirmation',
                                      style: alertDialogTtl,
                                    ),
                                    content: Text(
                                      "Are you sure you want to remove ${widget.firstname} from active subscribers?",
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
                                                        'Remove Subscriber',
                                                    'content':
                                                        "The Administrator has remove ${widget.firstname} from active subscriber.",
                                                    'notifBy': FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid,
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
                                                  'You remove ${widget.fullname} (${widget.email}) from active subscribers.',
                                              'title': 'Remove Subscriber',
                                              'staffId': FirebaseAuth
                                                  .instance.currentUser!.uid,
                                            });

                                            okDialog(
                                                    context,
                                                    'Remove Successfully',
                                                    "You remove ${widget.firstname} successfully")
                                                .whenComplete(() {
                                              Navigator.pop(context);
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
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(
                                      'Remove Confirmation',
                                      style: alertDialogTtl,
                                    ),
                                    content: Text(
                                      "Are you sure you want to remove ${widget.firstname}?",
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

                                          //apply notifications to all staff
                                          myDb
                                              .collection('staffs')
                                              .where('coopID',
                                                  isEqualTo: widget.coopId)
                                              .where('role',
                                                  isEqualTo: 'Administrator')
                                              .get()
                                              .then((data) async {
                                            if (data.size > 0) {
                                              for (int a = 0;
                                                  a < data.size;
                                                  a++) {
                                                await myDb
                                                    .collection('notifications')
                                                    .doc(widget.coopId)
                                                    .collection(
                                                        data.docs[a]['staffID'])
                                                    .doc(DateFormat(
                                                            'yyyyMMddHHmmss')
                                                        .format(DateTime.now()))
                                                    .set({
                                                  'context': 'removesubtoadmin',
                                                  'coopId': widget.coopId,
                                                  'title':
                                                      'Confirmation for Removing a Subscriber',
                                                  'content':
                                                      "has submitted confirmation for removing ${widget.fullname} (${widget.email}) in subscriber list.",
                                                  'notifBy': FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid,
                                                  'notifId': data.docs[a]
                                                      ['staffID'],
                                                  'userId': widget.subid,
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
                                              .doc(DateFormat('yyyyMMddHHmmss')
                                                  .format(DateTime.now()))
                                              .set({
                                            'timestamp': DateTime.now(),
                                            'context': 'Subscriber',
                                            'content':
                                                'You submit confirmation for removing ${widget.fullname} (${widget.email}) in subscriber list.',
                                            'title':
                                                'Submit Confirmation for Removing Subscriber',
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
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Feather.user_x,
                            color: Colors.red[900],
                            size: 25,
                          ),
                          const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6)),
                          Text(
                            'Remove ${widget.firstname}',
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.red[900],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                  child: widget.icon,
                );
            }
          }
        });
  }
}
