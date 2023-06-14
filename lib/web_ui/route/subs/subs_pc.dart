import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/route/subs/listsubblck.dart';
import 'package:ascoop/web_ui/route/subs/listsubreq.dart';
import 'package:ascoop/web_ui/route/subs/listsubs.dart';
import 'package:ascoop/web_ui/route/subs/profile.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:ascoop/web_ui/global_var.dart' as globals;
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubsPc extends StatefulWidget {
  const SubsPc({super.key});

  @override
  State<SubsPc> createState() => _SubsPcState();
}

class _SubsPcState extends State<SubsPc> {
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
            title: 'Subscriber Management',
            icon: Feather.users,
            widget: const SubHeader(),
          ),
          const Expanded(
            child: SubContent(),
          ),
        ],
      ),
    );
  }
}

class SubContent extends StatefulWidget {
  const SubContent({super.key});

  @override
  State<SubContent> createState() => _SubContentState();
}

class _SubContentState extends State<SubContent> {
  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: globals.subIndex,
      children: const [
        SubActive(),
        SubRequest(),
        SubBlck(),
      ],
    );
  }
}

class SubActive extends StatefulWidget {
  const SubActive({super.key});

  @override
  State<SubActive> createState() => _SubActiveState();
}

class _SubActiveState extends State<SubActive> {
  String subId = '';

  callback(String subid) {
    setState(() {
      subId = subid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListSubsAct(
            callback: callback,
          ),
          Expanded(
            child: SubProfile(
              subId: subId,
            ),
          ),
        ],
      ),
    );
  }
}

class SubRequest extends StatefulWidget {
  const SubRequest({super.key});

  @override
  State<SubRequest> createState() => _SubRequestState();
}

class _SubRequestState extends State<SubRequest> {
  String subId = '';

  callback(String subid) {
    setState(() {
      subId = subid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListSubsReq(
            callback: callback,
          ),
          Expanded(
            child: SubProfile(
              subId: subId,
            ),
          ),
        ],
      ),
    );
  }
}

class SubBlck extends StatefulWidget {
  const SubBlck({super.key});

  @override
  State<SubBlck> createState() => _SubBlckState();
}

class _SubBlckState extends State<SubBlck> {
  String subId = '';
  callback(String subid) {
    setState(() {
      subId = subid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListSubBlock(
            callback: callback,
          ),
          Expanded(
            child: SubProfile(
              subId: subId,
            ),
          ),
        ],
      ),
    );
  }
}

class SubHeader extends StatefulWidget {
  const SubHeader({super.key});

  @override
  State<SubHeader> createState() => _SubHeaderState();
}

class _SubHeaderState extends State<SubHeader> {
  late final SharedPreferences prefs;
  late final prefsFuture =
      SharedPreferences.getInstance().then((v) => prefs = v);

  void select(int n) {
    for (int i = 0; i < globals.headnavselsub.length; i++) {
      if (i != n) {
        globals.headnavselsub[i] = false;
      } else {
        globals.headnavselsub[i] = true;
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
                      if (pref.data!
                              .getString('myRole')
                              .toString()
                              .toLowerCase() ==
                          'cashier') {
                        return Row(
                          children: [
                            InkWell(
                                hoverColor: Colors.transparent,
                                onTap: () {
                                  setState(() {
                                    select(0);
                                    globals.subIndex = 0;
                                  });
                                  Navigator.pushReplacementNamed(
                                      context, '/subscribers/active');
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 400),
                                  padding: const EdgeInsets.all(8),
                                  margin: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.teal[800],
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Color.fromARGB(
                                              255, 174, 171, 171),
                                          spreadRadius: 0,
                                          blurStyle: BlurStyle.normal,
                                          blurRadius: 0.9),
                                    ],
                                  ),
                                  child: Text(
                                    'Active Subscribers',
                                    style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )),
                          ],
                        );
                      } else {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                                hoverColor: Colors.transparent,
                                onTap: () {
                                  setState(() {
                                    select(0);
                                    globals.subIndex = 0;
                                  });
                                  Navigator.pushReplacementNamed(
                                      context, '/subscribers/active');
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 400),
                                  padding: const EdgeInsets.all(8),
                                  margin: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: globals.headnavselsub[0] == true
                                        ? Colors.teal[800]
                                        : Colors.white,
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Color.fromARGB(
                                              255, 174, 171, 171),
                                          spreadRadius: 0,
                                          blurStyle: BlurStyle.normal,
                                          blurRadius: 0.9),
                                    ],
                                  ),
                                  child: Text(
                                    'Active Subscribers',
                                    style: GoogleFonts.montserrat(
                                        color: globals.headnavselsub[0] == true
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
                                  globals.subIndex = 1;
                                });
                                Navigator.pushReplacementNamed(
                                    context, '/subscribers/request');
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 400),
                                padding: const EdgeInsets.all(8),
                                margin: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: globals.headnavselsub[1] == true
                                      ? Colors.orange[800]
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
                                child: Row(
                                  children: [
                                    StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection('subscribers')
                                            .where('status',
                                                whereIn: ['pending', 'process'])
                                            .where('coopId',
                                                isEqualTo: pref.data!
                                                    .getString('coopId'))
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          try {
                                            notifReq =
                                                snapshot.data!.docs.length;
                                            if (snapshot.hasError) {
                                              print(snapshot.error.toString());
                                            }
                                            if (!snapshot.hasData) {
                                              print('waiting');
                                            }
                                            if (snapshot.hasData &&
                                                notifReq != 0) {
                                              return Container(
                                                margin: const EdgeInsets.only(
                                                    right: 5),
                                                width: 20,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: Colors.white,
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    notifReq.toString(),
                                                    softWrap: false,
                                                    style: const TextStyle(
                                                      fontFamily: FontNameMed,
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      letterSpacing: 0.5,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                            if (snapshot.hasData &&
                                                notifReq > 99) {
                                              return Container(
                                                margin: const EdgeInsets.only(
                                                    right: 5),
                                                width: 20,
                                                height: 20,
                                                decoration: const BoxDecoration(
                                                    color: Colors.red,
                                                    shape: BoxShape.circle),
                                                child: const Center(
                                                  child: Text(
                                                    '99+',
                                                    softWrap: false,
                                                    style: TextStyle(
                                                        fontFamily: FontNameMed,
                                                        color: Colors.white,
                                                        fontSize: 8,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        letterSpacing: 0.5),
                                                  ),
                                                ),
                                              );
                                            }
                                            if (notifReq == 0 ||
                                                !snapshot.hasData) {
                                              return Container();
                                            }
                                          } catch (e) {
                                            print(e.toString());
                                          }
                                          return Container();
                                        }),
                                    Text(
                                      'Subscriber Requests',
                                      style: GoogleFonts.montserrat(
                                          color:
                                              globals.headnavselsub[1] == true
                                                  ? Colors.white
                                                  : Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                //  Text(
                                //   'Subscriber Requests',
                                //   style: GoogleFonts.montserrat(
                                //       color: globals.headnavselsub[1] == true
                                //           ? Colors.white
                                //           : Colors.black,
                                //       fontSize: 14,
                                //       fontWeight: FontWeight.w600),
                                // ),
                              ),
                            ),
                            const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 3)),
                            InkWell(
                                hoverColor: Colors.transparent,
                                onTap: () {
                                  setState(() {
                                    select(2);
                                    globals.subIndex = 2;
                                  });
                                  Navigator.pushReplacementNamed(
                                      context, '/subscribers/blocked');
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 400),
                                  padding: const EdgeInsets.all(8),
                                  margin: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: globals.headnavselsub[2] == true
                                        ? Colors.red[800]
                                        : Colors.white,
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Color.fromARGB(
                                              255, 174, 171, 171),
                                          spreadRadius: 0,
                                          blurStyle: BlurStyle.normal,
                                          blurRadius: 0.9),
                                    ],
                                  ),
                                  child: Text(
                                    'Blocked Subscribers',
                                    style: GoogleFonts.montserrat(
                                        color: globals.headnavselsub[2] == true
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )),
                          ],
                        );
                      }
                      return Container();
                  }
                }
              }),
        ),
      ),
    );
  }
}
