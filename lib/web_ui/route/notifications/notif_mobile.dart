import 'dart:developer';

import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/route/notifications/notif_pc.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:ascoop/web_ui/utils/alertdialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:ascoop/web_ui/global_var.dart' as globals;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotifMgtMobile extends StatefulWidget {
  const NotifMgtMobile({super.key});

  @override
  State<NotifMgtMobile> createState() => _NotifMgtMobileState();
}

class _NotifMgtMobileState extends State<NotifMgtMobile> {
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
            title: 'Notifications',
            icon: Feather.bell,
            align: MainAxisAlignment.center,
            widget: const Align(
              alignment: Alignment.center,
              child: NotifHeader(),
            ),
          ),
          const Expanded(
            child: NotifContent(),
          ),
        ],
      ),
    );
  }
}

class NotifContent extends StatefulWidget {
  const NotifContent({super.key});

  @override
  State<NotifContent> createState() => _NotifContentState();
}

class _NotifContentState extends State<NotifContent> {
  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: globals.notifIndex,
      children: const [
        Notifs(),
      ],
    );
  }
}

class Notifs extends StatefulWidget {
  const Notifs({super.key});

  @override
  State<Notifs> createState() => _NotifsState();
}

class _NotifsState extends State<Notifs> {
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
              return const Center(child: CircularProgressIndicator());
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
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                              onPressed: () async {
                                                showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    elevation: 0,
                                                    content: onWait,
                                                  ),
                                                );
                                                await myDb
                                                    .collection('notifications')
                                                    .doc(prefs.data!
                                                        .getString('coopId'))
                                                    .collection(FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid)
                                                    .where('notifId',
                                                        isEqualTo: FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid)
                                                    .get()
                                                    .then((value) async {
                                                  for (int a = 0;
                                                      a < value.docs.length;
                                                      a++) {
                                                    await myDb
                                                        .collection(
                                                            'notifications')
                                                        .doc(prefs.data!
                                                            .getString(
                                                                'coopId'))
                                                        .collection(FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid)
                                                        .doc(value.docs[a].id)
                                                        .update({
                                                      'status': 'read',
                                                    });
                                                  }
                                                }).whenComplete(() =>
                                                        Navigator.pop(context));
                                              },
                                              child: Text(
                                                'Mark all as read',
                                                style: TextStyle(
                                                    fontFamily: FontNameDefault,
                                                    color: Colors.teal[800],
                                                    fontSize: 15,
                                                    letterSpacing: 1.5,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: data.length,
                                        itemBuilder: (context, index) {
                                          if (!data[index]['context']
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
                                                if (data[index]['status'] ==
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
                                                      .doc(data[index].id)
                                                      .update({
                                                    'status': 'read',
                                                  });
                                                }
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            NotifProfile(
                                                              coopid: data[sel]
                                                                  ['coopId'],
                                                              staffid: data[sel]
                                                                  ['notifId'],
                                                              docid:
                                                                  data[sel].id,
                                                            )));
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
                                                            Text(
                                                              '${data[index]['content']}',
                                                              style:
                                                                  const TextStyle(
                                                                fontFamily:
                                                                    FontNameDefault,
                                                                fontSize: 15,
                                                                letterSpacing:
                                                                    1,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
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
                                                    Container(
                                                      width: 40,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          PopupMenuButton(
                                                              tooltip: '',
                                                              icon: Icon(
                                                                  FontAwesomeIcons
                                                                      .ellipsisVertical),
                                                              iconSize: 15,
                                                              itemBuilder:
                                                                  (context) => [
                                                                        PopupMenuItem(
                                                                          onTap:
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
                                                                            await myDb.collection('notifications').doc(prefs.data!.getString('coopId')).collection(FirebaseAuth.instance.currentUser!.uid).doc(data[index].id).delete().whenComplete(() {
                                                                              Navigator.pop(context);
                                                                              okDialog(context, 'Delete Successfully', 'Remove Notification Successfully.');
                                                                            });
                                                                          },
                                                                          child:
                                                                              Row(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: [
                                                                              Icon(
                                                                                Feather.trash_2,
                                                                                color: Colors.red[900],
                                                                                size: 25,
                                                                              ),
                                                                              const Padding(padding: EdgeInsets.symmetric(horizontal: 6)),
                                                                              Text(
                                                                                'Delete Notification',
                                                                                style: TextStyle(
                                                                                  fontFamily: FontNameDefault,
                                                                                  fontSize: 13,
                                                                                  fontWeight: FontWeight.w600,
                                                                                  color: Colors.red[900],
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ])
                                                        ],
                                                      ),
                                                    )
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

class NotifProfile extends StatefulWidget {
  String docid;
  String coopid;
  String staffid;

  NotifProfile({
    super.key,
    required this.docid,
    required this.coopid,
    required this.staffid,
  });

  @override
  State<NotifProfile> createState() => _NotifProfileState();
}

class _NotifProfileState extends State<NotifProfile> {
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
      body: StreamBuilder(
        stream: myDb
            .collection('notifications')
            .doc(widget.coopid)
            .collection(widget.staffid)
            .doc(widget.docid)
            .snapshots(),
        builder: (context, snapshot) {
          try {
            final data = snapshot.data!.data()!;
            if (snapshot.hasError) {
              log('snapshot.hasError (listloan): ${snapshot.error}');
            } else if (snapshot.hasData) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return onWait;
                default:
                  return Container(
                    padding: const EdgeInsets.all(15),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.teal[800]),
                                child: const Icon(
                                  Feather.mail,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5)),
                              const Text(
                                'Notification Details',
                                style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.5,
                                    fontSize: 20,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20)),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['title'],
                                style: const TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.5,
                                    fontSize: 18,
                                    color: Colors.black),
                              ),
                              Text(
                                DateFormat('MMM d, yyyy hh:mm a')
                                    .format(data['timestamp'].toDate()),
                                style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 1.5,
                                    fontSize: 13,
                                    color: Colors.grey[800]),
                              ),
                            ],
                          ),
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10)),
                          Text(
                            data['content'],
                            style: const TextStyle(
                                fontFamily: FontNameDefault,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.5,
                                fontSize: 16,
                                color: Colors.black),
                          ),
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 15)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Action Took',
                                style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 1.5,
                                    fontSize: 13,
                                    color: Colors.grey[800]),
                              ),
                              FutureBuilder(
                                  future: myDb
                                      .collection('staffs')
                                      .where('staffID',
                                          isEqualTo: data['notifBy'])
                                      .where('coopID', isEqualTo: widget.coopid)
                                      .get(),
                                  builder: (context, snapshot) {
                                    try {
                                      final staff = snapshot.data!.docs;
                                      if (snapshot.hasError) {
                                        log('snapshot.hasError (listloan): ${snapshot.error}');
                                        return Container();
                                      } else if (snapshot.hasData &&
                                          staff.isNotEmpty) {
                                        switch (snapshot.connectionState) {
                                          case ConnectionState.waiting:
                                            return onWait;
                                          default:
                                            return Text(
                                              '${staff[0]['firstname']} ${staff[0]['lastname']}',
                                              style: const TextStyle(
                                                  fontFamily: FontNameDefault,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 1.5,
                                                  fontSize: 15,
                                                  color: Colors.black),
                                            );
                                        }
                                      }
                                    } catch (e) {}
                                    return Container();
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
              }
            }
          } catch (e) {}
          return Container();
        },
      ),
    );
  }
}
