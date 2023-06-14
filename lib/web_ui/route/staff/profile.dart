import 'dart:developer';

import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/route/staff/blocked.dart';
import 'package:ascoop/web_ui/route/staff/unblock.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

int staffprofIndex = 0;

class StaffProfile extends StatefulWidget {
  String staffId;
  StaffProfile({
    super.key,
    required this.staffId,
  });

  @override
  State<StaffProfile> createState() => _StaffProfileState();
}

class _StaffProfileState extends State<StaffProfile> {
  @override
  void initState() {
    widget.staffId = '';
    super.initState();
  }

  @override
  void dispose() {
    widget.staffId;
    super.dispose();
  }

  callback(int x) {
    setState(() {
      staffprofIndex = x;
    });
  }

  String firstname = '';
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: myDb
          .collection('staffs')
          .where('staffID', isEqualTo: widget.staffId)
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(15),
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        data[index]['profilePic'],
                                      ),
                                      fit: BoxFit.cover,
                                    )),
                              ),
                              Expanded(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${data[index]['firstname']} ${data[index]['lastname']}",
                                        style: h3,
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 1)),
                                      Text(
                                        data[index]['email'],
                                        style: h5,
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 3)),
                                      Text(
                                        '${data[index]['role']} Since ${DateFormat('MMMM d, yyyy').format(data[index]['timestamp'].toDate())}',
                                        style: TextStyle(
                                          color: Colors.grey[800],
                                          fontFamily: FontNameDefault,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10)),
                                      Builder(
                                        builder: (context) {
                                          firstname = data[index]['firstname'];

                                          if (data[index]['isBlock'] == false) {
                                            switch (data[index]['role']
                                                .toString()
                                                .toLowerCase()) {
                                              case 'administrator':
                                                return Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 10),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Colors.teal[800],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6)),
                                                      child: Row(
                                                        children: const [
                                                          Text(
                                                            'Administrator',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    FontNameDefault,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Colors
                                                                    .white,
                                                                letterSpacing:
                                                                    0.5),
                                                          ),
                                                          Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          5)),
                                                          Icon(
                                                            FontAwesomeIcons
                                                                .star,
                                                            color: Colors.white,
                                                            size: 18,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              case 'bookkeeper':
                                                return Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 10),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      decoration: BoxDecoration(
                                                          color: Colors
                                                              .orange[800],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6)),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: const [
                                                          Text(
                                                            'Bookkeeper',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    FontNameDefault,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Colors
                                                                    .white,
                                                                letterSpacing:
                                                                    0.5),
                                                          ),
                                                          Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          5)),
                                                          Icon(
                                                            FontAwesomeIcons
                                                                .calculator,
                                                            color: Colors.white,
                                                            size: 18,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    BlockedStaff(
                                                      coopId: data[index]
                                                          ['coopID'],
                                                      firstname: data[index]
                                                          ['firstname'],
                                                      fullname:
                                                          "${data[index]['firstname']} ${data[index]['lastname']}",
                                                      email: data[index]
                                                          ['email'],
                                                      index: index,
                                                      staffId: data[index]
                                                          ['staffID'],
                                                      role: data[index]['role'],
                                                      icon: Icon(
                                                        Feather.settings,
                                                        size: 20,
                                                        color: Colors.grey[800],
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              default:
                                                return Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 10),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      decoration: BoxDecoration(
                                                          color: Colors.black,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6)),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: const [
                                                          Text(
                                                            'Cashier',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    FontNameDefault,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Colors
                                                                    .white,
                                                                letterSpacing:
                                                                    0.5),
                                                          ),
                                                          Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          5)),
                                                          Icon(
                                                            FontAwesomeIcons
                                                                .cashRegister,
                                                            color: Colors.white,
                                                            size: 18,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    BlockedStaff(
                                                      coopId: data[index]
                                                          ['coopID'],
                                                      firstname: data[index]
                                                          ['firstname'],
                                                      fullname:
                                                          "${data[index]['firstname']} ${data[index]['lastname']}",
                                                      email: data[index]
                                                          ['email'],
                                                      index: index,
                                                      staffId: data[index]
                                                          ['staffID'],
                                                      role: data[index]['role'],
                                                      icon: Icon(
                                                        Feather.settings,
                                                        size: 20,
                                                        color: Colors.grey[800],
                                                      ),
                                                    ),
                                                  ],
                                                );
                                            }
                                          } else {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 10),
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                      color: Colors.red[800],
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
                                                        'Blocked Staff',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                FontNameDefault,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: Colors.white,
                                                            letterSpacing: 0.5),
                                                      ),
                                                      Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      5)),
                                                      Icon(
                                                        Feather.slash,
                                                        color: Colors.white,
                                                        size: 18,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                UnblockedStaff(
                                                  coopId: data[index]['coopID'],
                                                  firstname: data[index]
                                                      ['firstname'],
                                                  fullname:
                                                      "${data[index]['firstname']} ${data[index]['lastname']}",
                                                  email: data[index]['email'],
                                                  index: index,
                                                  staffId: data[index]
                                                      ['staffID'],
                                                  role: data[index]['role'],
                                                  icon: Icon(
                                                    Feather.settings,
                                                    size: 20,
                                                    color: Colors.grey[800],
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
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
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              StaffProfHeader(
                                callback: callback,
                              ),
                              Expanded(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
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
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: IndexedStack(
                                    index: staffprofIndex,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding: const EdgeInsets.only(top: 10),
                                        child: StreamBuilder(
                                          stream: myDb
                                              .collection('staffs')
                                              .doc(widget.staffId)
                                              .collection('transactions')
                                              .orderBy('timestamp',
                                                  descending: true)
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            try {
                                              final data = snapshot.data!.docs;
                                              if (snapshot.hasError) {
                                                log('snapshot.hasError (coopdash): ${snapshot.error}');
                                                return Container();
                                              } else if (snapshot.hasData &&
                                                  data.isNotEmpty) {
                                                switch (
                                                    snapshot.connectionState) {
                                                  case ConnectionState.waiting:
                                                    return onWait;
                                                  default:
                                                    return ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount: snapshot
                                                          .data!.docs.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Container(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                              boxShadow: const [
                                                                BoxShadow(
                                                                    // color: Color.fromARGB(
                                                                    //     255, 156, 156, 156),
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            156,
                                                                            156,
                                                                            156),
                                                                    spreadRadius:
                                                                        0.8,
                                                                    blurStyle:
                                                                        BlurStyle
                                                                            .normal,
                                                                    blurRadius:
                                                                        0.8),
                                                              ]),
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(8),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      '${data[index]['title']}',
                                                                      style:
                                                                          const TextStyle(
                                                                        fontFamily:
                                                                            FontNameDefault,
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w800,
                                                                        letterSpacing:
                                                                            1,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                    const Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(vertical: 2)),
                                                                    Text(
                                                                      '$firstname ${data[index]['content'].toString().substring(4)}',
                                                                      style:
                                                                          const TextStyle(
                                                                        fontFamily:
                                                                            FontNameDefault,
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        letterSpacing:
                                                                            1,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Container(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(4),
                                                                    child: Text(
                                                                      DateFormat(
                                                                              'MMMM d, yyyy  hh:mm a')
                                                                          .format(
                                                                              data[index]['timestamp'].toDate())
                                                                          .toUpperCase(),
                                                                      style:
                                                                          const TextStyle(
                                                                        fontFamily:
                                                                            FontNameDefault,
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        letterSpacing:
                                                                            1,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    );
                                                }
                                              } else if (data.isEmpty) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 50.0),
                                                  child: EmptyData(
                                                      ttl:
                                                          'No Transactions History Yet'),
                                                );
                                              }
                                            } catch (e) {
                                              log(e.toString());
                                            }
                                            return Container();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
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
                const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                const Text(
                  "Select staff's name to view their profile",
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
      },
    );
  }
}

class StaffProfHeader extends StatefulWidget {
  Function callback;
  StaffProfHeader({super.key, required this.callback});

  @override
  State<StaffProfHeader> createState() => _StaffProfHeaderState();
}

class _StaffProfHeaderState extends State<StaffProfHeader> {
  List list = [true, false];
  void select(int n) {
    for (int i = 0; i < list.length; i++) {
      if (i != n) {
        list[i] = false;
      } else {
        list[i] = true;
      }
    }
  }

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
                select(0);
                widget.callback(0);
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
                color: list[0] == true ? Colors.teal[800] : Colors.white,
                boxShadow: const [
                  BoxShadow(
                      color: Color.fromARGB(255, 174, 171, 171),
                      spreadRadius: 0,
                      blurStyle: BlurStyle.normal,
                      blurRadius: 0.9),
                ],
              ),
              child: Text(
                'Transaction History',
                style: TextStyle(
                    fontFamily: FontNameDefault,
                    color: list[0] == true ? Colors.white : Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
