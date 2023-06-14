import 'dart:developer';

import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/route/loans/listloan_mob.dart';
import 'package:ascoop/web_ui/route/loans/listloanreq_mob.dart';
import 'package:ascoop/web_ui/route/loans/profile.dart';
import 'package:ascoop/web_ui/route/loans/profilereq.dart';
import 'package:ascoop/web_ui/route/subs/approve.dart';
import 'package:ascoop/web_ui/route/subs/blocksub.dart';
import 'package:ascoop/web_ui/route/subs/unblock.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ascoop/web_ui/global_var.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class SubProfile extends StatefulWidget {
  String subId;
  SubProfile({
    super.key,
    required this.subId,
  });

  @override
  State<SubProfile> createState() => _SubProfileState();
}

class _SubProfileState extends State<SubProfile> {
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
                                              width: 200,
                                              height: 200,
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
                                                        switch (data[index]
                                                                ['status']
                                                            .toString()
                                                            .toLowerCase()) {
                                                          case 'verified':
                                                            return Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Container(
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          10),
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(8),
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                              .teal[
                                                                          800],
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              6)),
                                                                  child: Row(
                                                                    children: const [
                                                                      Text(
                                                                        'Subscribed',
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                FontNameDefault,
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                            color: Colors.white,
                                                                            letterSpacing: 0.5),
                                                                      ),
                                                                      Padding(
                                                                          padding:
                                                                              EdgeInsets.symmetric(horizontal: 5)),
                                                                      Icon(
                                                                        FontAwesomeIcons
                                                                            .circleCheck,
                                                                        color: Colors
                                                                            .white,
                                                                        size:
                                                                            20,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                BlockedSub(
                                                                  coopId: data[
                                                                          index]
                                                                      [
                                                                      'coopId'],
                                                                  firstname: data[
                                                                          index]
                                                                      [
                                                                      'userFirstName'],
                                                                  fullname:
                                                                      "${data[index]['userFirstName']} ${data[index]['userMiddleName']} ${data[index]['userLastName']}",
                                                                  email: data[
                                                                          index]
                                                                      [
                                                                      'userEmail'],
                                                                  index: index,
                                                                  icon:
                                                                      const Icon(
                                                                    Feather
                                                                        .settings,
                                                                    size: 27,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                  subid: data[
                                                                          index]
                                                                      [
                                                                      'userId'],
                                                                ),
                                                              ],
                                                            );
                                                          case 'blocked':
                                                            return Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Container(
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          10),
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(8),
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                              .red[
                                                                          800],
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              6)),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: const [
                                                                      Text(
                                                                        'Blocked',
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                FontNameDefault,
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                            color: Colors.white,
                                                                            letterSpacing: 0.5),
                                                                      ),
                                                                      Padding(
                                                                          padding:
                                                                              EdgeInsets.symmetric(horizontal: 5)),
                                                                      Icon(
                                                                        Feather
                                                                            .slash,
                                                                        color: Colors
                                                                            .white,
                                                                        size:
                                                                            20,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                UnblockSub(
                                                                  coopId: data[
                                                                          index]
                                                                      [
                                                                      'coopId'],
                                                                  firstname: data[
                                                                          index]
                                                                      [
                                                                      'userFirstName'],
                                                                  fullname:
                                                                      "${data[index]['userFirstName']} ${data[index]['userMiddleName']} ${data[index]['userLastName']}",
                                                                  email: data[
                                                                          index]
                                                                      [
                                                                      'userEmail'],
                                                                  index: index,
                                                                  icon:
                                                                      const Icon(
                                                                    Feather
                                                                        .settings,
                                                                    size: 27,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                  subid: data[
                                                                          index]
                                                                      [
                                                                      'userId'],
                                                                ),
                                                              ],
                                                            );
                                                        }
                                                        return ApprodelSub(
                                                          coopId: data[index]
                                                              ['coopId'],
                                                          firstname: data[index]
                                                              ['userFirstName'],
                                                          middlename: data[
                                                                  index][
                                                              'userMiddleName'],
                                                          lastname: data[index]
                                                              ['userLastName'],
                                                          fullname:
                                                              "${data[index]['userFirstName']} ${data[index]['userMiddleName']} ${data[index]['userLastName']}",
                                                          email: data[index]
                                                              ['userEmail'],
                                                          index: index,
                                                          subid: data[index]
                                                              ['userId'],
                                                          status: data[index]
                                                              ['status'],
                                                        );
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
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(15),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  const Icon(
                                                                    Feather
                                                                        .map_pin,
                                                                    size: 30,
                                                                  ),
                                                                  const Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              8)),
                                                                  Expanded(
                                                                    child: Text(
                                                                      "${data[0]['userAddress']}",
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
                                                                  Text(
                                                                    "${data[0]['gender']}",
                                                                    style: GoogleFonts.montserrat(
                                                                        fontSize:
                                                                            17,
                                                                        fontWeight:
                                                                            FontWeight.w800),
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
                                                                        .calendar,
                                                                    size: 30,
                                                                  ),
                                                                  const Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              8)),
                                                                  Expanded(
                                                                    child: Text(
                                                                      '${DateFormat('MMMM d, yyyy').format(data[0]['birthdate'].toDate())}',
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
                                                      data[index]['status'] ==
                                                                  'pending' ||
                                                              data[index][
                                                                      'status'] ==
                                                                  'process'
                                                          ? Container()
                                                          : ScrollConfiguration(
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
                                                                      width:
                                                                          450,
                                                                      height:
                                                                          200,
                                                                      margin: const EdgeInsets
                                                                              .fromLTRB(
                                                                          25,
                                                                          15,
                                                                          15,
                                                                          15),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .white,
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                        boxShadow: const [
                                                                          BoxShadow(
                                                                              color: Color.fromARGB(255, 122, 122, 122),
                                                                              spreadRadius: 0,
                                                                              blurStyle: BlurStyle.normal,
                                                                              blurRadius: 2.6)
                                                                        ],
                                                                      ),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Container(
                                                                            width:
                                                                                MediaQuery.of(context).size.width,
                                                                            height:
                                                                                50,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.teal[800],
                                                                              borderRadius: const BorderRadius.only(
                                                                                topLeft: Radius.circular(10),
                                                                                topRight: Radius.circular(10),
                                                                              ),
                                                                            ),
                                                                            child:
                                                                                Center(
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
                                                                                                    'PHP ${NumberFormat('###,###,###,###,###.##').format(snapshot.data!.data()!['capitalShare'])}',
                                                                                                    style: h1,
                                                                                                  ),
                                                                                                ],
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
                                                                      width:
                                                                          450,
                                                                      height:
                                                                          200,
                                                                      margin:
                                                                          const EdgeInsets.all(
                                                                              15),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .white,
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                        boxShadow: const [
                                                                          BoxShadow(
                                                                              color: Color.fromARGB(255, 122, 122, 122),
                                                                              spreadRadius: 0,
                                                                              blurStyle: BlurStyle.normal,
                                                                              blurRadius: 2.6)
                                                                        ],
                                                                      ),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Container(
                                                                            width:
                                                                                MediaQuery.of(context).size.width,
                                                                            height:
                                                                                50,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.teal[800],
                                                                              borderRadius: const BorderRadius.only(
                                                                                topLeft: Radius.circular(10),
                                                                                topRight: Radius.circular(10),
                                                                              ),
                                                                            ),
                                                                            child:
                                                                                Center(
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
                                                                data
                                                                    .isNotEmpty) {
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
                                                                                if (MediaQuery.of(context).size.width < 1150) {
                                                                                  return InkWell(
                                                                                    onTap: () {
                                                                                      int sel = index;
                                                                                      Navigator.push(
                                                                                        context,
                                                                                        MaterialPageRoute(
                                                                                          builder: (context) => Builder(
                                                                                            builder: (context) {
                                                                                              switch (loans[sel]['loanStatus'].toString().toLowerCase()) {
                                                                                                case 'active':
                                                                                                  return ProfileLoanMob(loanId: loans[sel]['loanId']);
                                                                                                case 'completed':
                                                                                                  return ProfileLoanMob(loanId: loans[sel]['loanId']);
                                                                                                default:
                                                                                                  return ProfileLoanReqMob(loanId: loans[sel]['loanId']);
                                                                                              }
                                                                                            },
                                                                                          ),
                                                                                        ),
                                                                                      );
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
                                                                                      child: Column(
                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                            children: [
                                                                                              Column(
                                                                                                children: [
                                                                                                  Column(
                                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
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
                                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
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
                                                                                                ],
                                                                                              ),
                                                                                              Column(
                                                                                                children: [
                                                                                                  Column(
                                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
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
                                                                                                        crossAxisAlignment: CrossAxisAlignment.center,
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
                                                                                                        crossAxisAlignment: CrossAxisAlignment.center,
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
                                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                                                                                ],
                                                                                              ),
                                                                                              Column(
                                                                                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                } else {
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
                                                                                }
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
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
