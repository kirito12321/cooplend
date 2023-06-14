import 'dart:developer';

import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ClickProfile extends StatefulWidget {
  String payerid;
  ClickProfile({super.key, required this.payerid});

  @override
  State<ClickProfile> createState() => _ClickProfileState();
}

class _ClickProfileState extends State<ClickProfile> {
  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width < 1150) {
      return FutureBuilder(
        future: myDb
            .collection('subscribers')
            .where('userId', isEqualTo: widget.payerid)
            .orderBy('timestamp', descending: true)
            .get(),
        builder: (context, snapshot) {
          try {
            final length = snapshot.data!.docs;
            if (snapshot.hasError) {
              log('snapshot.hasError (listloan): ${snapshot.error}');
              return Container();
            } else if (snapshot.hasData && length.isNotEmpty) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return onWait;
                default:
                  return InkWell(
                    onTap: () {
                      final data = snapshot.data!.docs;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Scaffold(
                                    appBar: AppBar(
                                      backgroundColor: Colors.white,
                                      elevation: 0.7,
                                      title: Text(
                                        data[0]['userFirstName'],
                                        style: const TextStyle(
                                          fontFamily: FontNameDefault,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
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
                                    body: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(15),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
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
                                                            data[0][
                                                                'profilePicUrl'],
                                                          ),
                                                          fit: BoxFit.cover,
                                                        )),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 10),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "${data[0]['userFirstName']} ${data[0]['userMiddleName']} ${data[0]['userLastName']}",
                                                            style: h3,
                                                          ),
                                                          const Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          2)),
                                                          Text(
                                                            data[0]
                                                                ['userEmail'],
                                                            style: h5,
                                                          ),
                                                          const Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          10)),
                                                          Builder(
                                                            builder: (context) {
                                                              switch (data[0]
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
                                                                        padding:
                                                                            const EdgeInsets.all(8),
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.teal[800],
                                                                            borderRadius: BorderRadius.circular(6)),
                                                                        child:
                                                                            const Row(
                                                                          children: [
                                                                            Text(
                                                                              'Subscribed',
                                                                              style: TextStyle(fontFamily: FontNameDefault, fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 0.5),
                                                                            ),
                                                                            Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                                                                            Icon(
                                                                              FontAwesomeIcons.circleCheck,
                                                                              color: Colors.white,
                                                                              size: 20,
                                                                            ),
                                                                          ],
                                                                        ),
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
                                                                        padding:
                                                                            const EdgeInsets.all(8),
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.red[800],
                                                                            borderRadius: BorderRadius.circular(6)),
                                                                        child:
                                                                            const Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            Text(
                                                                              'Blocked',
                                                                              style: TextStyle(fontFamily: FontNameDefault, fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 0.5),
                                                                            ),
                                                                            Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                                                                            Icon(
                                                                              Feather.slash,
                                                                              color: Colors.white,
                                                                              size: 20,
                                                                            ),
                                                                          ],
                                                                        ),
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
                                            AnimatedContainer(
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              margin: const EdgeInsets.all(20),
                                              padding: const EdgeInsets.all(15),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.white,
                                                boxShadow: const [
                                                  BoxShadow(
                                                      color: Color.fromARGB(
                                                          255, 174, 171, 171),
                                                      spreadRadius: 0,
                                                      blurStyle:
                                                          BlurStyle.normal,
                                                      blurRadius: 1.6)
                                                ],
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'About ${data[0]['userFirstName']}',
                                                    style: h3,
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        const Icon(
                                                          Feather.map_pin,
                                                          size: 30,
                                                        ),
                                                        const Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        8)),
                                                        Expanded(
                                                          child: Text(
                                                            "${data[0]['userAddress']}",
                                                            style: GoogleFonts
                                                                .montserrat(
                                                                    fontSize:
                                                                        17,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15),
                                                    child: Row(
                                                      children: [
                                                        const Icon(
                                                          Feather.phone_call,
                                                          size: 25,
                                                        ),
                                                        const Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        8)),
                                                        Expanded(
                                                          child: Text(
                                                            data[0][
                                                                'userMobileNo'],
                                                            style: GoogleFonts
                                                                .montserrat(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15),
                                                    child: Row(
                                                      children: [
                                                        const Icon(
                                                          Feather.mail,
                                                          size: 30,
                                                        ),
                                                        const Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        8)),
                                                        Expanded(
                                                          child: Text(
                                                            data[0]
                                                                ['userEmail'],
                                                            style: GoogleFonts
                                                                .montserrat(
                                                                    fontSize:
                                                                        17,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15),
                                                    child: Row(
                                                      children: [
                                                        const Icon(
                                                          Feather.user,
                                                          size: 30,
                                                        ),
                                                        const Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        8)),
                                                        Text(
                                                          "${data[0]['gender']}",
                                                          style: GoogleFonts
                                                              .montserrat(
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15),
                                                    child: Row(
                                                      children: [
                                                        const Icon(
                                                          Feather.calendar,
                                                          size: 30,
                                                        ),
                                                        const Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        8)),
                                                        Expanded(
                                                          child: Text(
                                                            '${DateFormat('MMMM d, yyyy').format(data[0]['birthdate'].toDate())}',
                                                            style: GoogleFonts
                                                                .montserrat(
                                                                    fontSize:
                                                                        17,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800),
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
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: 450,
                                                      height: 200,
                                                      margin: const EdgeInsets
                                                              .fromLTRB(
                                                          25, 15, 15, 15),
                                                      decoration: BoxDecoration(
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
                                                                'Capital Share'
                                                                    .toUpperCase(),
                                                                style:
                                                                    const TextStyle(
                                                                  fontFamily:
                                                                      FontNameDefault,
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 16,
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
                                                            child:
                                                                StreamBuilder(
                                                                    stream: myDb
                                                                        .collection(
                                                                            'subscribers')
                                                                        .doc(data[0]
                                                                            .id)
                                                                        .collection(
                                                                            'coopAccDetails')
                                                                        .doc(
                                                                            'Data')
                                                                        .snapshots(),
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      try {
                                                                        if (snapshot
                                                                            .hasError) {
                                                                          log('snapshot.hasError (coopdash): ${snapshot.error}');
                                                                          return Container();
                                                                        } else if (snapshot
                                                                            .hasData) {
                                                                          switch (
                                                                              snapshot.connectionState) {
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
                                                                                  const Text(
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
                                                          const EdgeInsets.all(
                                                              15),
                                                      decoration: BoxDecoration(
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
                                                                'Savings'
                                                                    .toUpperCase(),
                                                                style:
                                                                    const TextStyle(
                                                                  fontFamily:
                                                                      FontNameDefault,
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 16,
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
                                                            child:
                                                                StreamBuilder(
                                                                    stream: myDb
                                                                        .collection(
                                                                            'subscribers')
                                                                        .doc(data[0]
                                                                            .id)
                                                                        .collection(
                                                                            'coopAccDetails')
                                                                        .doc(
                                                                            'Data')
                                                                        .snapshots(),
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      try {
                                                                        if (snapshot
                                                                            .hasError) {
                                                                          log('snapshot.hasError (coopdash): ${snapshot.error}');
                                                                          return Container();
                                                                        } else if (snapshot
                                                                            .hasData) {
                                                                          switch (
                                                                              snapshot.connectionState) {
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
                                            const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 6)),
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 800,
                                              margin: const EdgeInsets.all(15),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: const [
                                                  BoxShadow(
                                                      color: Color.fromARGB(
                                                          255, 122, 122, 122),
                                                      spreadRadius: 0,
                                                      blurStyle:
                                                          BlurStyle.normal,
                                                      blurRadius: 2.6)
                                                ],
                                              ),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      color: Colors.teal[800],
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topLeft:
                                                            Radius.circular(10),
                                                        topRight:
                                                            Radius.circular(10),
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        'Valid ID'
                                                            .toUpperCase(),
                                                        style: const TextStyle(
                                                          fontFamily:
                                                              FontNameDefault,
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          letterSpacing: 1,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.black,
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                                data[0][
                                                                    'validIdUrl']),
                                                            fit: BoxFit.contain,
                                                          )),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 800,
                                              margin: const EdgeInsets.all(15),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: const [
                                                  BoxShadow(
                                                      color: Color.fromARGB(
                                                          255, 122, 122, 122),
                                                      spreadRadius: 0,
                                                      blurStyle:
                                                          BlurStyle.normal,
                                                      blurRadius: 2.6)
                                                ],
                                              ),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      color: Colors.teal[800],
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topLeft:
                                                            Radius.circular(10),
                                                        topRight:
                                                            Radius.circular(10),
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        'Selfie With ID'
                                                            .toUpperCase(),
                                                        style: const TextStyle(
                                                          fontFamily:
                                                              FontNameDefault,
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          letterSpacing: 1,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.black,
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                                data[0][
                                                                    'selfiewithIdUrl']),
                                                            fit: BoxFit.contain,
                                                          )),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )));
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 15.0,
                          backgroundImage: NetworkImage(
                              snapshot.data!.docs[0]['profilePicUrl']),
                          backgroundColor: Colors.transparent,
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6)),
                        Text(
                          '${snapshot.data!.docs[0]['userFirstName']} ${snapshot.data!.docs[0]['userMiddleName']} ${snapshot.data!.docs[0]['userLastName']}',
                          style: GoogleFonts.montserrat(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  );
              }
            }
          } catch (e) {
            log(e.toString());
          }
          return Container();
        },
      );
    } else {
      return FutureBuilder(
        future: myDb
            .collection('subscribers')
            .where('userId', isEqualTo: widget.payerid)
            .orderBy('timestamp', descending: true)
            .get(),
        builder: (context, snapshot) {
          try {
            final length = snapshot.data!.docs;
            if (snapshot.hasError) {
              log('snapshot.hasError (listloan): ${snapshot.error}');
              return Container();
            } else if (snapshot.hasData && length.isNotEmpty) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return onWait;
                default:
                  return InkWell(
                    onTap: () {
                      final data = snapshot.data!.docs;
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Container(
                            width: MediaQuery.of(context).size.width * .98,
                            height: MediaQuery.of(context).size.height * .8,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(15),
                                    width: MediaQuery.of(context).size.width,
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
                                                  data[0]['profilePicUrl'],
                                                ),
                                                fit: BoxFit.cover,
                                              )),
                                        ),
                                        Expanded(
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            padding: const EdgeInsets.all(10),
                                            margin:
                                                const EdgeInsets.only(left: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${data[0]['userFirstName']} ${data[0]['userMiddleName']} ${data[0]['userLastName']}",
                                                  style: h3,
                                                ),
                                                const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 2)),
                                                Text(
                                                  data[0]['userEmail'],
                                                  style: h5,
                                                ),
                                                const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10)),
                                                Builder(
                                                  builder: (context) {
                                                    switch (data[0]['status']
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
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                          .teal[
                                                                      800],
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6)),
                                                              child: const Row(
                                                                children: [
                                                                  Text(
                                                                    'Subscribed',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            FontNameDefault,
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        color: Colors
                                                                            .white,
                                                                        letterSpacing:
                                                                            0.5),
                                                                  ),
                                                                  Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              5)),
                                                                  Icon(
                                                                    FontAwesomeIcons
                                                                        .circleCheck,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 17,
                                                                  ),
                                                                ],
                                                              ),
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
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8),
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .red[800],
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6)),
                                                              child: const Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    'Blocked',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            FontNameDefault,
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        color: Colors
                                                                            .white,
                                                                        letterSpacing:
                                                                            0.5),
                                                                  ),
                                                                  Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              5)),
                                                                  Icon(
                                                                    Feather
                                                                        .slash,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 17,
                                                                  ),
                                                                ],
                                                              ),
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
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 500),
                                    margin: const EdgeInsets.all(20),
                                    padding: const EdgeInsets.all(15),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Color.fromARGB(
                                                255, 174, 171, 171),
                                            spreadRadius: 0,
                                            blurStyle: BlurStyle.normal,
                                            blurRadius: 1.6)
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'About ${data[0]['userFirstName']}',
                                          style: h3,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(15),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Feather.map_pin,
                                                size: 30,
                                              ),
                                              const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8)),
                                              Expanded(
                                                child: Text(
                                                  "${data[0]['userAddress']}",
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w800),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Feather.phone_call,
                                                size: 25,
                                              ),
                                              const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8)),
                                              Expanded(
                                                child: Text(
                                                  data[0]['userMobileNo'],
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w800),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Feather.mail,
                                                size: 30,
                                              ),
                                              const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8)),
                                              Expanded(
                                                child: Text(
                                                  data[0]['userEmail'],
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w800),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Feather.user,
                                                size: 30,
                                              ),
                                              const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8)),
                                              Text(
                                                "${data[0]['gender']}",
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w800),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Feather.calendar,
                                                size: 30,
                                              ),
                                              const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8)),
                                              Expanded(
                                                child: Text(
                                                  '${DateFormat('MMMM d, yyyy').format(data[0]['birthdate'].toDate())}',
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: 17,
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
                                    behavior: MyCustomScrollBehavior(),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 450,
                                            height: 200,
                                            margin: const EdgeInsets.fromLTRB(
                                                25, 15, 15, 15),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                                      topLeft:
                                                          Radius.circular(10),
                                                      topRight:
                                                          Radius.circular(10),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'Capital Share'
                                                          .toUpperCase(),
                                                      style: const TextStyle(
                                                        fontFamily:
                                                            FontNameDefault,
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        letterSpacing: 1,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: StreamBuilder(
                                                      stream: myDb
                                                          .collection(
                                                              'subscribers')
                                                          .doc(data[0].id)
                                                          .collection(
                                                              'coopAccDetails')
                                                          .doc('Data')
                                                          .snapshots(),
                                                      builder:
                                                          (context, snapshot) {
                                                        try {
                                                          if (snapshot
                                                              .hasError) {
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
                                                                          style:
                                                                              h1,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    const Text(
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
                                            margin: const EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                                      topLeft:
                                                          Radius.circular(10),
                                                      topRight:
                                                          Radius.circular(10),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'Savings'.toUpperCase(),
                                                      style: const TextStyle(
                                                        fontFamily:
                                                            FontNameDefault,
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        letterSpacing: 1,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: StreamBuilder(
                                                      stream: myDb
                                                          .collection(
                                                              'subscribers')
                                                          .doc(data[0].id)
                                                          .collection(
                                                              'coopAccDetails')
                                                          .doc('Data')
                                                          .snapshots(),
                                                      builder:
                                                          (context, snapshot) {
                                                        try {
                                                          if (snapshot
                                                              .hasError) {
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
                                                                          'PHP ${NumberFormat('###,###,###,###,###.##').format(snapshot.data!.data()!['savings'])}',
                                                                          style:
                                                                              h1,
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
                                  const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 6)),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 800,
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
                                              'Valid ID'.toUpperCase(),
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
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      data[0]['validIdUrl']),
                                                  fit: BoxFit.contain,
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 800,
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
                                              'Selfie With ID'.toUpperCase(),
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
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                image: DecorationImage(
                                                  image: NetworkImage(data[0]
                                                      ['selfiewithIdUrl']),
                                                  fit: BoxFit.contain,
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 15.0,
                          backgroundImage: NetworkImage(
                              snapshot.data!.docs[0]['profilePicUrl']),
                          backgroundColor: Colors.transparent,
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6)),
                        Text(
                          '${snapshot.data!.docs[0]['userFirstName']} ${snapshot.data!.docs[0]['userMiddleName']} ${snapshot.data!.docs[0]['userLastName']}',
                          style: GoogleFonts.montserrat(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  );
              }
            }
          } catch (e) {
            log(e.toString());
          }
          return Container();
        },
      );
    }
  }
}
