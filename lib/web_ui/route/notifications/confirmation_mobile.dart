import 'dart:developer';

import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/route/notifications/notif_pc.dart';
import 'package:ascoop/web_ui/route/notifications/profileloan.dart';
import 'package:ascoop/web_ui/route/notifications/profle.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfMgtMobile extends StatefulWidget {
  const ConfMgtMobile({super.key});

  @override
  State<ConfMgtMobile> createState() => _ConfMgtMobileState();
}

class _ConfMgtMobileState extends State<ConfMgtMobile> {
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
            title: 'Confirmation Requests',
            icon: FontAwesomeIcons.squareCheck,
            align: MainAxisAlignment.center,
            widget: const Align(
              alignment: Alignment.center,
              child: NotifHeader(),
            ),
          ),
          const Expanded(
            child: ConfContent(),
          ),
        ],
      ),
    );
  }
}

class ConfContent extends StatefulWidget {
  const ConfContent({super.key});

  @override
  State<ConfContent> createState() => _ConfContentState();
}

class _ConfContentState extends State<ConfContent> {
  String loanid = '';
  late final SharedPreferences prefs;
  late final prefsFuture =
      SharedPreferences.getInstance().then((v) => prefs = v);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: FutureBuilder(
          future: prefsFuture,
          builder: (context, prefs) {
            if (prefs.hasError) {
              return Center(child: onWait);
            } else {
              switch (prefs.connectionState) {
                case ConnectionState.waiting:
                  return onWait;
                default:
                  return StreamBuilder(
                    stream: myDb
                        .collection('notifications')
                        .doc(prefs.data!.getString('coopId'))
                        .collection(FirebaseAuth.instance.currentUser!.uid)
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      try {
                        final data = snapshot.data!.docs;
                        if (snapshot.hasError) {
                          log('snapshot.hasError (listloan): ${snapshot.error}');
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
                                    children: [
                                      ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: data.length,
                                        itemBuilder: (context, index) {
                                          if (data[index]['context']
                                              .toString()
                                              .toLowerCase()
                                              .contains('toadmin')) {
                                            return InkWell(
                                              hoverColor: Colors.transparent,
                                              splashColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () {
                                                int sel = index;
                                                if (data[sel]['status'] ==
                                                    'unread') {
                                                  myDb
                                                      .collection(
                                                          'notifications')
                                                      .doc(prefs.data!
                                                          .getString('coopId'))
                                                      .collection(FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .uid)
                                                      .doc(data[sel].id)
                                                      .update({
                                                    'status': 'read',
                                                  });
                                                }
                                                if (data[sel]['context']
                                                    .toString()
                                                    .contains('loantoadmin')) {
                                                  loanid = data[sel]['loanId'];
                                                }
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ConfProfile(
                                                              docId:
                                                                  data[sel].id,
                                                              coopId: data[sel]
                                                                  ['coopId'],
                                                              staffId: data[sel]
                                                                  ['notifBy'],
                                                              loanId: loanid,
                                                              subId: data[sel]
                                                                  ['userId'],
                                                              contxt: data[sel]
                                                                  ['context'])),
                                                );
                                              },
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 10, 20, 10),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                        color: data[index][
                                                                    'status'] ==
                                                                'unread'
                                                            ? teal8
                                                            : Colors
                                                                .transparent,
                                                        width: 2),
                                                    boxShadow: const [
                                                      BoxShadow(
                                                          color: Color.fromARGB(
                                                              255,
                                                              174,
                                                              171,
                                                              171),
                                                          spreadRadius: 0.8,
                                                          blurStyle:
                                                              BlurStyle.normal,
                                                          blurRadius: 0.9),
                                                    ]),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                        color: data[index][
                                                                    'status'] ==
                                                                'unread'
                                                            ? Colors.white
                                                            : Colors.white,
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Builder(
                                                            builder: (context) {
                                                              if (data[index][
                                                                          'status']
                                                                      .toString()
                                                                      .toLowerCase() ==
                                                                  'unread') {
                                                                return Icon(
                                                                  FontAwesomeIcons
                                                                      .envelope,
                                                                  color: Colors
                                                                          .teal[
                                                                      800],
                                                                );
                                                              } else {
                                                                return Icon(
                                                                  FontAwesomeIcons
                                                                      .envelopeOpen,
                                                                  color: Colors
                                                                          .teal[
                                                                      800],
                                                                );
                                                              }
                                                            },
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              '${data[index]['title']}'
                                                                  .toUpperCase(),
                                                              style:
                                                                  const TextStyle(
                                                                fontFamily:
                                                                    FontNameDefault,
                                                                fontSize: 17,
                                                                letterSpacing:
                                                                    1,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            const Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            2)),
                                                            StreamBuilder(
                                                                stream: myDb
                                                                    .collection(
                                                                        'staffs')
                                                                    .where(
                                                                        'staffID',
                                                                        isEqualTo: data[index]
                                                                            [
                                                                            'notifBy'])
                                                                    .snapshots(),
                                                                builder: (context,
                                                                    snapshot) {
                                                                  try {
                                                                    final staff =
                                                                        snapshot
                                                                            .data!
                                                                            .docs;
                                                                    if (snapshot
                                                                        .hasError) {
                                                                      log('snapshot.hasError (listloan): ${snapshot.error}');
                                                                      return Container();
                                                                    } else if (snapshot
                                                                            .hasData &&
                                                                        staff
                                                                            .isNotEmpty) {
                                                                      switch (snapshot
                                                                          .connectionState) {
                                                                        case ConnectionState
                                                                            .waiting:
                                                                          return onWait;
                                                                        default:
                                                                          return Text(
                                                                            '${staff[0]['firstname']} ${staff[0]['lastname']} ${data[index]['content']}',
                                                                            style: const TextStyle(
                                                                                fontFamily: FontNameDefault,
                                                                                fontWeight: FontWeight.w500,
                                                                                letterSpacing: 1.5,
                                                                                fontSize: 15,
                                                                                color: Colors.black),
                                                                          );
                                                                      }
                                                                    }
                                                                  } catch (e) {}
                                                                  return Container();
                                                                }),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  DateFormat(
                                                                          'MMM d, yyyy hh:mm a')
                                                                      .format(data[index]
                                                                              [
                                                                              'timestamp']
                                                                          .toDate()),
                                                                  style:
                                                                      const TextStyle(
                                                                    fontFamily:
                                                                        FontNameDefault,
                                                                    fontSize:
                                                                        15,
                                                                    letterSpacing:
                                                                        1,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          } else {
                                            return Container();
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              );
                          }
                        }
                      } catch (e) {}
                      return onWait;
                    },
                  );
              }
            }
          }),
    );
  }
}

class ConfProfile extends StatefulWidget {
  String docId;
  String coopId;
  String staffId;
  String subId;
  String contxt;
  String loanId;
  ConfProfile({
    super.key,
    required this.docId,
    required this.coopId,
    required this.staffId,
    required this.subId,
    required this.loanId,
    required this.contxt,
  });

  @override
  State<ConfProfile> createState() => _ConfProfileState();
}

class _ConfProfileState extends State<ConfProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          hoverColor: Colors.white,
          splashColor: Colors.white,
          highlightColor: Colors.white,
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            FontAwesomeIcons.arrowLeft,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: Builder(builder: (context) {
        if (widget.contxt.toString().contains('loantoadmin')) {
          return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ProfileLoanConf(
                docid: widget.docId,
                loanid: widget.loanId,
                subId: widget.subId,
                staffid: widget.staffId,
                context: widget.contxt,
              ));
        } else {
          return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ProfileConf(
                docid: widget.docId,
                subId: widget.subId,
                staffid: widget.staffId,
                context: widget.contxt,
              ));
        }
      }),
    );
  }
}
