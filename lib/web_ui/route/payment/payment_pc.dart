import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/route/payment/overdue.dart';
import 'package:ascoop/web_ui/route/payment/paid.dart';
import 'package:ascoop/web_ui/route/payment/pending.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ascoop/web_ui/global_var.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class PaymentMgtPc extends StatefulWidget {
  const PaymentMgtPc({super.key});

  @override
  State<PaymentMgtPc> createState() => _PaymentMgtPcState();
}

class _PaymentMgtPcState extends State<PaymentMgtPc> {
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
            title: 'Payment Management',
            icon: Feather.credit_card,
            widget: const PaymentMgtHeader(),
          ),
          const Expanded(
            child: PaymentMgtContent(),
          ),
        ],
      ),
    );
  }
}

class PaymentMgtContent extends StatefulWidget {
  const PaymentMgtContent({super.key});

  @override
  State<PaymentMgtContent> createState() => _PaymentMgtContentState();
}

class _PaymentMgtContentState extends State<PaymentMgtContent> {
  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: globals.payIndex,
      children: const [
        PayPending(),
        PayPaid(),
        PayOverdue(),
      ],
    );
  }
}

class PayPending extends StatefulWidget {
  const PayPending({super.key});

  @override
  State<PayPending> createState() => _PayPendingState();
}

class _PayPendingState extends State<PayPending> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: const ListPayPending(),
    );
  }
}

class PayPaid extends StatefulWidget {
  const PayPaid({super.key});

  @override
  State<PayPaid> createState() => _PayPaidState();
}

class _PayPaidState extends State<PayPaid> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: const ListPayPaid(),
    );
  }
}

class PayOverdue extends StatefulWidget {
  const PayOverdue({super.key});

  @override
  State<PayOverdue> createState() => _PayOverdueState();
}

class _PayOverdueState extends State<PayOverdue> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: const ListPayOver(),
    );
  }
}

class PaymentMgtHeader extends StatefulWidget {
  const PaymentMgtHeader({super.key});

  @override
  State<PaymentMgtHeader> createState() => _PaymentMgtHeaderState();
}

class _PaymentMgtHeaderState extends State<PaymentMgtHeader> {
  late final SharedPreferences prefs;
  late final prefsFuture =
      SharedPreferences.getInstance().then((v) => prefs = v);

  void select(int n) {
    for (int i = 0; i < globals.headnavselpay.length; i++) {
      if (i != n) {
        globals.headnavselpay[i] = false;
      } else {
        globals.headnavselpay[i] = true;
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
                          'bookkeeper') {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                                hoverColor: Colors.transparent,
                                onTap: () {
                                  setState(() {
                                    select(1);
                                    globals.payIndex = 1;
                                  });
                                  Navigator.pushReplacementNamed(
                                      context, '/payments/paid');
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 400),
                                  padding: const EdgeInsets.all(8),
                                  margin: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: globals.headnavselpay[1] == true
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
                                    'Paid Payments',
                                    style: GoogleFonts.montserrat(
                                        color: globals.headnavselpay[1] == true
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
                                    globals.payIndex = 0;
                                  });
                                  Navigator.pushReplacementNamed(
                                      context, '/payments/pending');
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 400),
                                  padding: const EdgeInsets.all(8),
                                  margin: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: globals.headnavselpay[0] == true
                                        ? Colors.orange[800]
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
                                    'On-going Payments',
                                    style: GoogleFonts.montserrat(
                                        color: globals.headnavselpay[0] == true
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
                                  globals.payIndex = 1;
                                });
                                Navigator.pushReplacementNamed(
                                    context, '/payments/paid');
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 400),
                                padding: const EdgeInsets.all(8),
                                margin: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: globals.headnavselpay[1] == true
                                      ? Colors.teal[800]
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
                                child: Text(
                                  'Paid Payments',
                                  style: GoogleFonts.montserrat(
                                      color: globals.headnavselpay[1] == true
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 3)),
                            InkWell(
                                hoverColor: Colors.transparent,
                                onTap: () {
                                  setState(() {
                                    select(2);
                                    globals.payIndex = 2;
                                  });
                                  Navigator.pushReplacementNamed(
                                      context, '/payments/overdue');
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 400),
                                  padding: const EdgeInsets.all(8),
                                  margin: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: globals.headnavselpay[2] == true
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
                                    'Overdue Payments',
                                    style: GoogleFonts.montserrat(
                                        color: globals.headnavselpay[2] == true
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
