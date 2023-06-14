import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/styles/buttonstyle.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:ascoop/web_ui/utils/alertdialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';

class UnblockedStaff extends StatefulWidget {
  String coopId, firstname, fullname, email, staffId, role;
  Widget icon;
  int index;
  UnblockedStaff({
    super.key,
    required this.coopId,
    required this.firstname,
    required this.fullname,
    required this.email,
    required this.index,
    required this.icon,
    required this.staffId,
    required this.role,
  });

  @override
  State<UnblockedStaff> createState() => _UnblockedStaffState();
}

class _UnblockedStaffState extends State<UnblockedStaff> {
  @override
  void dispose() {
    widget.coopId;
    widget.firstname;
    widget.fullname;
    widget.email;
    widget.index;
    widget.staffId;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.role.toLowerCase()) {
      case 'cashier':
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
                          "Are you sure you unblock ${widget.firstname}?",
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
                              setState(() {
                                myDb
                                    .collection('staffs')
                                    .doc(widget.staffId)
                                    .update({
                                  'isBlock': false,
                                  'timestamp': DateTime.now(),
                                }).then((value) {
                                  myDb
                                      .collection('staffs')
                                      .where('coopID', isEqualTo: widget.coopId)
                                      .where('staffID',
                                          isNotEqualTo: FirebaseAuth
                                              .instance.currentUser!.uid)
                                      .get()
                                      .then((data) async {
                                    if (data.size > 0) {
                                      for (int a = 0; a < data.size; a++) {
                                        await myDb
                                            .collection('notifications')
                                            .doc(widget.coopId)
                                            .collection(data.docs[a]['staffID'])
                                            .doc(DateFormat('yyyyMMddHHmmss')
                                                .format(DateTime.now()))
                                            .set({
                                          'context': 'staff',
                                          'coopId': widget.coopId,
                                          'title': 'Unblocked Staff',
                                          'content':
                                              "The Administrator has unblocked ${widget.fullname} (${widget.email}).",
                                          'notifBy': FirebaseAuth
                                              .instance.currentUser!.uid,
                                          'notifId': data.docs[a]['staffID'],
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
                                    'context': 'Staff',
                                    'content':
                                        'You unblocked ${widget.fullname} (${widget.email}).',
                                    'title': 'Unblocked Staff',
                                    'staffId':
                                        FirebaseAuth.instance.currentUser!.uid,
                                  });
                                }, onError: (e) {
                                  okDialog(context, 'An error occured',
                                      'Please try again later.');
                                }).whenComplete(() {
                                  Navigator.pop(context);
                                  okDialog(
                                      context,
                                      'Unblocked Staff Successfully',
                                      '${widget.fullname} has added to blacklist.');
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
                    },
                  );
                });
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Feather.slash,
                    color: Colors.teal[900],
                    size: 25,
                  ),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 6)),
                  Text(
                    'Unblock ${widget.firstname}',
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
          ],
          child: widget.icon,
        );

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
                          "Are you sure you unblock ${widget.firstname}?",
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
                              setState(() {
                                myDb
                                    .collection('staffs')
                                    .doc(widget.staffId)
                                    .update({
                                  'isBlock': false,
                                  'timestamp': DateTime.now(),
                                }).then((value) {
                                  myDb
                                      .collection('staffs')
                                      .where('coopID', isEqualTo: widget.coopId)
                                      .where('staffID',
                                          isNotEqualTo: FirebaseAuth
                                              .instance.currentUser!.uid)
                                      .get()
                                      .then((data) async {
                                    if (data.size > 0) {
                                      for (int a = 0; a < data.size; a++) {
                                        await myDb
                                            .collection('notifications')
                                            .doc(widget.coopId)
                                            .collection(data.docs[a]['staffID'])
                                            .doc(DateFormat('yyyyMMddHHmmss')
                                                .format(DateTime.now()))
                                            .set({
                                          'context': 'staff',
                                          'coopId': widget.coopId,
                                          'title': 'Unblocked Staff',
                                          'content':
                                              "The Administrator has unblocked ${widget.fullname} (${widget.email}).",
                                          'notifBy': FirebaseAuth
                                              .instance.currentUser!.uid,
                                          'notifId': data.docs[a]['staffID'],
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
                                    'context': 'Staff',
                                    'content':
                                        'You unblocked ${widget.fullname} (${widget.email}).',
                                    'title': 'Unblocked Staff',
                                    'staffId':
                                        FirebaseAuth.instance.currentUser!.uid,
                                  });
                                }, onError: (e) {
                                  okDialog(context, 'An error occured',
                                      'Please try again later.');
                                }).whenComplete(() {
                                  Navigator.pop(context);
                                  okDialog(
                                      context,
                                      'Unblocked Staff Successfully',
                                      '${widget.fullname} has added to blacklist.');
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
                    },
                  );
                });
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
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 6)),
                  Text(
                    'Unblock ${widget.firstname}',
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.teal[900],
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
}
