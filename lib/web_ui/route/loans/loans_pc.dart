import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/route/loans/listloan.dart';
import 'package:ascoop/web_ui/route/loans/listloancom.dart';
import 'package:ascoop/web_ui/route/loans/listloanreq.dart';
import 'package:ascoop/web_ui/route/loans/profile.dart';
import 'package:ascoop/web_ui/route/loans/profilereq.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ascoop/web_ui/global_var.dart' as globals;

class LoanMgtPc extends StatefulWidget {
  const LoanMgtPc({super.key});

  @override
  State<LoanMgtPc> createState() => _LoanMgtPcState();
}

class _LoanMgtPcState extends State<LoanMgtPc> {
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
            title: 'Loan Management',
            icon: FontAwesomeIcons.wallet,
            widget: const LoanMgtHeader(),
          ),
          const Expanded(
            child: LoanContent(),
          ),
        ],
      ),
    );
  }
}

class LoanContent extends StatefulWidget {
  const LoanContent({super.key});

  @override
  State<LoanContent> createState() => _LoanContentState();
}

class _LoanContentState extends State<LoanContent> {
  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: globals.loanIndex,
      children: const [
        LoanAct(),
        LoanReq(),
        LoanCom(),
      ],
    );
  }
}

class LoanAct extends StatefulWidget {
  const LoanAct({super.key});

  @override
  State<LoanAct> createState() => _LoanActState();
}

class _LoanActState extends State<LoanAct> {
  String loanId = '';

  callback(String loanid) {
    setState(() {
      loanId = loanid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListLoanAct(
            callback: callback,
          ),
          Expanded(
            child: LoanProfile(
              loanId: loanId,
            ),
          ),
        ],
      ),
    );
  }
}

class LoanReq extends StatefulWidget {
  const LoanReq({super.key});

  @override
  State<LoanReq> createState() => _LoanReqState();
}

class _LoanReqState extends State<LoanReq> {
  String loanId = '';

  callback(String loanid) {
    setState(() {
      loanId = loanid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListLoanReq(
            callback: callback,
          ),
          Expanded(
            child: LoanProfileReq(
              loanId: loanId,
            ),
          ),
        ],
      ),
    );
  }
}

class LoanCom extends StatefulWidget {
  const LoanCom({super.key});

  @override
  State<LoanCom> createState() => _LoanComState();
}

class _LoanComState extends State<LoanCom> {
  String loanId = '';

  callback(String loanid) {
    setState(() {
      loanId = loanid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListLoanCom(
            callback: callback,
          ),
          Expanded(
            child: LoanProfile(
              loanId: loanId,
            ),
          ),
        ],
      ),
    );
  }
}

class LoanMgtHeader extends StatefulWidget {
  const LoanMgtHeader({super.key});

  @override
  State<LoanMgtHeader> createState() => _LoanMgtHeaderState();
}

class _LoanMgtHeaderState extends State<LoanMgtHeader> {
  late final SharedPreferences prefs;
  late final prefsFuture =
      SharedPreferences.getInstance().then((v) => prefs = v);

  void select(int n) {
    for (int i = 0; i < globals.headnavselloan.length; i++) {
      if (i != n) {
        globals.headnavselloan[i] = false;
      } else {
        globals.headnavselloan[i] = true;
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                                hoverColor: Colors.transparent,
                                onTap: () {
                                  setState(() {
                                    select(0);
                                    globals.loanIndex = 0;
                                  });
                                  Navigator.pushReplacementNamed(
                                      context, '/loans/active');
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 400),
                                  padding: const EdgeInsets.all(8),
                                  margin: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: globals.headnavselloan[0] == true
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
                                    'Active Loans',
                                    style: GoogleFonts.montserrat(
                                        color: globals.headnavselloan[0] == true
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
                                    select(2);
                                    globals.loanIndex = 2;
                                  });
                                  Navigator.pushReplacementNamed(
                                      context, '/loans/complete');
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 400),
                                  padding: const EdgeInsets.all(8),
                                  margin: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: globals.headnavselloan[2] == true
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
                                    'Completed Loans',
                                    style: GoogleFonts.montserrat(
                                        color: globals.headnavselloan[2] == true
                                            ? Colors.white
                                            : Colors.black,
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
                                    globals.loanIndex = 0;
                                  });
                                  Navigator.pushReplacementNamed(
                                      context, '/loans/active');
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 400),
                                  padding: const EdgeInsets.all(8),
                                  margin: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: globals.headnavselloan[0] == true
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
                                    'Active Loans',
                                    style: GoogleFonts.montserrat(
                                        color: globals.headnavselloan[0] == true
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
                                  globals.loanIndex = 1;
                                });
                                Navigator.pushReplacementNamed(
                                    context, '/loans/request');
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 400),
                                padding: const EdgeInsets.all(8),
                                margin: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: globals.headnavselloan[1] == true
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
                                            .collection('loans')
                                            .where('loanStatus',
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
                                      'Loan Requests',
                                      style: GoogleFonts.montserrat(
                                          color:
                                              globals.headnavselloan[1] == true
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
                                //       color: globals.headnavselloan[1] == true
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
                                    globals.loanIndex = 2;
                                  });
                                  Navigator.pushReplacementNamed(
                                      context, '/loans/complete');
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 400),
                                  padding: const EdgeInsets.all(8),
                                  margin: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: globals.headnavselloan[2] == true
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
                                    'Completed Loans',
                                    style: GoogleFonts.montserrat(
                                        color: globals.headnavselloan[2] == true
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )),
                          ],
                        );
                      }
                  }
                }
              }),
        ),
      ),
    );
  }
}
