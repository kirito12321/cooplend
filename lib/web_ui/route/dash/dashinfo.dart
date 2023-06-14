
import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashSubs extends StatefulWidget {
  const DashSubs({super.key});

  @override
  State<DashSubs> createState() => _DashSubsState();
}

class _DashSubsState extends State<DashSubs> {
  late final SharedPreferences prefs;
  late final prefsFuture =
      SharedPreferences.getInstance().then((v) => prefs = v);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: prefsFuture,
        builder: (context, AsyncSnapshot<SharedPreferences> snapshot) {
          if (snapshot.hasError) {
          } else if (snapshot.hasData) {
            return ScrollConfiguration(
              behavior: MyCustomScrollBehavior(),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder(
                      stream: myDb
                          .collection('subscribers')
                          .where('coopId',
                              isEqualTo: snapshot.data!.getString('coopId'))
                          .where('status', isEqualTo: 'verified')
                          .snapshots(),
                      builder: (context, snapshot) {
                        final data = snapshot.data?.docs;
                        return SubActiveDash(
                          count: data?.length ?? 0,
                        );
                      },
                    ),
                    StreamBuilder(
                      stream: myDb
                          .collection('subscribers')
                          .where('coopId',
                              isEqualTo: snapshot.data!.getString('coopId'))
                          .where('status', isEqualTo: 'pending')
                          .snapshots(),
                      builder: (context, snapshot) {
                        final data = snapshot.data?.docs;
                        return DashSubReq(
                          count: data?.length ?? 0,
                        );
                      },
                    ),
                    StreamBuilder(
                      stream: myDb
                          .collection('subscribers')
                          .where('coopId',
                              isEqualTo: snapshot.data!.getString('coopId'))
                          .where('status', isEqualTo: 'blocked')
                          .snapshots(),
                      builder: (context, snapshot) {
                        final data = snapshot.data?.docs;
                        return SubBlockDash(
                          count: data?.length ?? 0,
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }
          return Container();
        });
  }
}

class DashSubReq extends StatefulWidget {
  int count;
  DashSubReq({required this.count, super.key});

  @override
  State<DashSubReq> createState() => _DashSubReqState();
}

class _DashSubReqState extends State<DashSubReq> {
  @override
  void dispose() {
    widget.count;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 480,
      height: 200,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                color: Color.fromARGB(255, 174, 171, 171),
                spreadRadius: 1.0,
                blurStyle: BlurStyle.normal,
                blurRadius: 5.0)
          ]),
      child: Row(
        children: [
          Container(
            width: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15),
                topLeft: Radius.circular(15),
              ),
              color: Colors.orange[800],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Icon(
                  Feather.user_plus,
                  size: 80,
                  color: Colors.white,
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                Text(
                  'Subscriber Requests',
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    NumberFormat("###,###,###,###").format(widget.count),
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange[800],
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Total Subscriber Requests',
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: 15,
                      fontWeight: FontWeight.w100,
                      color: Colors.grey[800],
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                  SizedBox(
                    width: 150,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/subscribers/request');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'View More',
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: 13,
                                fontWeight: FontWeight.w100,
                                color: Colors.blue[500],
                                letterSpacing: 2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Icon(
                              Icons.chevron_right_outlined,
                              color: Colors.blue[500],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SubActiveDash extends StatefulWidget {
  int count;
  SubActiveDash({required this.count, super.key});

  @override
  State<SubActiveDash> createState() => _SubActiveDashState();
}

class _SubActiveDashState extends State<SubActiveDash> {
  @override
  void dispose() {
    widget.count;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 480,
      height: 200,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                color: Color.fromARGB(255, 174, 171, 171),
                spreadRadius: 1.0,
                blurStyle: BlurStyle.normal,
                blurRadius: 5.0)
          ]),
      child: Row(
        children: [
          Container(
            width: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15),
                topLeft: Radius.circular(15),
              ),
              color: Colors.teal[800],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Icon(
                  FontAwesomeIcons.users,
                  size: 80,
                  color: Colors.white,
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                Text(
                  'Active Subscribers',
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            // child: StreamBuilder(
            //   stream: myDb.collection('subscribers').where('coopId', isEqualTo: globals.coopId),
            //   builder: (context, snapshot) {
            //     try {
            //       final data = snapshot.data!.docs[0];
            //     } catch (e) {}
            //   },
            // ),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    NumberFormat("###,###,###,###").format(widget.count),
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                      color: Colors.teal[800],
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Total Active Subscribers',
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: 15,
                      fontWeight: FontWeight.w100,
                      color: Colors.grey[800],
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                  SizedBox(
                    width: 150,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/subscribers/active');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'View More',
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: 13,
                                fontWeight: FontWeight.w100,
                                color: Colors.blue[500],
                                letterSpacing: 2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Icon(
                              Icons.chevron_right_outlined,
                              color: Colors.blue[500],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SubBlockDash extends StatefulWidget {
  int count;
  SubBlockDash({required this.count, super.key});

  @override
  State<SubBlockDash> createState() => _SubBlockDashState();
}

class _SubBlockDashState extends State<SubBlockDash> {
  @override
  void dispose() {
    widget.count;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 480,
      height: 200,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                color: Color.fromARGB(255, 174, 171, 171),
                spreadRadius: 1.0,
                blurStyle: BlurStyle.normal,
                blurRadius: 5.0)
          ]),
      child: Row(
        children: [
          Container(
            width: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15),
                topLeft: Radius.circular(15),
              ),
              color: Colors.red[800],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Icon(
                  FontAwesomeIcons.users,
                  size: 80,
                  color: Colors.white,
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                Text(
                  'Blocked Subscribers',
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            // child: StreamBuilder(
            //   stream: myDb.collection('subscribers').where('coopId', isEqualTo: globals.coopId),
            //   builder: (context, snapshot) {
            //     try {
            //       final data = snapshot.data!.docs[0];
            //     } catch (e) {}
            //   },
            // ),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    NumberFormat("###,###,###,###").format(widget.count),
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                      color: Colors.red[800],
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Total Blocked Subscribers',
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: 15,
                      fontWeight: FontWeight.w100,
                      color: Colors.grey[800],
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                  SizedBox(
                    width: 150,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/subscribers/blocked');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'View More',
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: 13,
                                fontWeight: FontWeight.w100,
                                color: Colors.blue[500],
                                letterSpacing: 2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Icon(
                              Icons.chevron_right_outlined,
                              color: Colors.blue[500],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class LoanDash extends StatefulWidget {
  const LoanDash({super.key});

  @override
  State<LoanDash> createState() => _LoanDashState();
}

class _LoanDashState extends State<LoanDash> {
  late final SharedPreferences prefs;
  late final prefsFuture =
      SharedPreferences.getInstance().then((v) => prefs = v);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: prefsFuture,
        builder: (context, AsyncSnapshot<SharedPreferences> snapshot) {
          if (snapshot.hasError) {
          } else if (snapshot.hasData) {
            return ScrollConfiguration(
              behavior: MyCustomScrollBehavior(),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder(
                      stream: myDb
                          .collection('loans')
                          .where('coopId',
                              isEqualTo: snapshot.data!.getString('coopId'))
                          .where('loanStatus', isEqualTo: 'active')
                          .snapshots(),
                      builder: (context, snapshot) {
                        final data = snapshot.data?.docs;
                        return LoanActDash(
                          count: data?.length ?? 0,
                        );
                      },
                    ),
                    StreamBuilder(
                      stream: myDb
                          .collection('loans')
                          .where('coopId',
                              isEqualTo: snapshot.data!.getString('coopId'))
                          .where('loanStatus', isEqualTo: 'pending')
                          .snapshots(),
                      builder: (context, snapshot) {
                        final data = snapshot.data?.docs;
                        return LoanReqDash(
                          count: data?.length ?? 0,
                        );
                      },
                    ),
                    StreamBuilder(
                      stream: myDb
                          .collection('loans')
                          .where('coopId',
                              isEqualTo: snapshot.data!.getString('coopId'))
                          .where('loanStatus', isEqualTo: 'completed')
                          .snapshots(),
                      builder: (context, snapshot) {
                        final data = snapshot.data?.docs;
                        return LoanComDash(
                          count: data?.length ?? 0,
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }
          return Container();
        });
  }
}

class LoanReqDash extends StatefulWidget {
  int count;
  LoanReqDash({super.key, required this.count});

  @override
  State<LoanReqDash> createState() => _LoanReqDashState();
}

class _LoanReqDashState extends State<LoanReqDash> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 480,
      height: 200,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                color: Color.fromARGB(255, 174, 171, 171),
                spreadRadius: 1.0,
                blurStyle: BlurStyle.normal,
                blurRadius: 5.0)
          ]),
      child: Row(
        children: [
          Container(
            width: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15),
                topLeft: Radius.circular(15),
              ),
              color: Colors.orange[800],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Icon(
                  FontAwesomeIcons.fileCirclePlus,
                  size: 80,
                  color: Colors.white,
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                Text(
                  'Loan Requests',
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            // child: StreamBuilder(
            //   stream: myDb.collection('subscribers').where('coopId', isEqualTo: globals.coopId),
            //   builder: (context, snapshot) {
            //     try {
            //       final data = snapshot.data!.docs[0];
            //     } catch (e) {}
            //   },
            // ),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    NumberFormat('###,###,###,###').format(widget.count),
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange[800],
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Total Loan Requests',
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: 15,
                      fontWeight: FontWeight.w100,
                      color: Colors.grey[800],
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                  SizedBox(
                    width: 150,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/loans/request');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'View More',
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: 13,
                                fontWeight: FontWeight.w100,
                                color: Colors.blue[500],
                                letterSpacing: 2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Icon(
                              Icons.chevron_right_outlined,
                              color: Colors.blue[500],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class LoanActDash extends StatefulWidget {
  int count;
  LoanActDash({super.key, required this.count});

  @override
  State<LoanActDash> createState() => _LoanActDashState();
}

class _LoanActDashState extends State<LoanActDash> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 480,
      height: 200,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                color: Color.fromARGB(255, 174, 171, 171),
                spreadRadius: 1.0,
                blurStyle: BlurStyle.normal,
                blurRadius: 5.0)
          ]),
      child: Row(
        children: [
          Container(
            width: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15),
                topLeft: Radius.circular(15),
              ),
              color: Colors.teal[800],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Icon(
                  FontAwesomeIcons.file,
                  size: 80,
                  color: Colors.white,
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                Text(
                  'Active Loans',
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            // child: StreamBuilder(
            //   stream: myDb.collection('subscribers').where('coopId', isEqualTo: globals.coopId),
            //   builder: (context, snapshot) {
            //     try {
            //       final data = snapshot.data!.docs[0];
            //     } catch (e) {}
            //   },
            // ),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    NumberFormat('###,###,###,###').format(widget.count),
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                      color: Colors.teal[800],
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Total Active Loans',
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: 15,
                      fontWeight: FontWeight.w100,
                      color: Colors.grey[800],
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                  SizedBox(
                    width: 150,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/loans/active');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'View More',
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: 13,
                                fontWeight: FontWeight.w100,
                                color: Colors.blue[500],
                                letterSpacing: 2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Icon(
                              Icons.chevron_right_outlined,
                              color: Colors.blue[500],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class LoanComDash extends StatefulWidget {
  int count;
  LoanComDash({super.key, required this.count});

  @override
  State<LoanComDash> createState() => _LoanComDashState();
}

class _LoanComDashState extends State<LoanComDash> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 480,
      height: 200,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                color: Color.fromARGB(255, 174, 171, 171),
                spreadRadius: 1.0,
                blurStyle: BlurStyle.normal,
                blurRadius: 5.0)
          ]),
      child: Row(
        children: [
          Container(
            width: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15),
                topLeft: Radius.circular(15),
              ),
              color: Colors.red[800],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Icon(
                  FontAwesomeIcons.fileCircleCheck,
                  size: 80,
                  color: Colors.white,
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                Text(
                  'Completed Loans',
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            // child: StreamBuilder(
            //   stream: myDb.collection('subscribers').where('coopId', isEqualTo: globals.coopId),
            //   builder: (context, snapshot) {
            //     try {
            //       final data = snapshot.data!.docs[0];
            //     } catch (e) {}
            //   },
            // ),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    NumberFormat('###,###,###,###').format(widget.count),
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                      color: Colors.red[800],
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Total Completed Loans',
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: 15,
                      fontWeight: FontWeight.w100,
                      color: Colors.grey[800],
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                  SizedBox(
                    width: 150,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/loans/complete');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'View More',
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: 13,
                                fontWeight: FontWeight.w100,
                                color: Colors.blue[500],
                                letterSpacing: 2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Icon(
                              Icons.chevron_right_outlined,
                              color: Colors.blue[500],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
