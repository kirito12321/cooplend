import 'dart:developer';
import 'package:ascoop/web_ui/controllers/disposePrefs.dart';
import 'package:ascoop/web_ui/sidenavs/notifbadge.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:ascoop/web_ui/global_var.dart' as globals;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CashierNavs extends StatefulWidget {
  const CashierNavs({super.key});

  @override
  State<CashierNavs> createState() => _CashierNavsState();
}

class _CashierNavsState extends State<CashierNavs> {
  void select(int n) {
    for (int i = 0; i < globals.sidenavsel.length; i++) {
      if (i != n) {
        globals.sidenavsel[i] = false;
      } else {
        globals.sidenavsel[i] = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          NavBarItems(
            tooltip: "Dashboard",
            widget: Container(),
            active: globals.sidenavsel[0],
            icon: FontAwesomeIcons.gaugeHigh,
            touched: () {
              setState(() {
                select(0);

                Navigator.pushNamed(context, '/dashboard');
              });
            },
          ),
          NavBarItems(
            tooltip: "Subscribers",
            widget: Container(),
            active: globals.sidenavsel[1],
            icon: Feather.users,
            touched: () {
              setState(() {
                select(1);
                globals.subIndex = 0;
              });
              Navigator.pushNamed(context, '/subscribers/active');
            },
          ),
          NavBarItems(
            tooltip: "Loans",
            widget: Container(),
            active: globals.sidenavsel[2],
            icon: Feather.credit_card,
            touched: () {
              setState(() {
                select(2);
                globals.loanIndex = 0;
              });
              Navigator.pushNamed(context, '/loans/active');
            },
          ),
          NavBarItems(
            tooltip: "Payment Management",
            widget: Container(),
            active: globals.sidenavsel[3],
            icon: FontAwesomeIcons.wallet,
            touched: () {
              setState(() {
                select(3);
              });
              Navigator.pushNamed(context, '/payments/pending');
            },
          ),
          NavBarItems(
            tooltip: "Notifications",
            widget: notifBadgeStream,
            active: globals.sidenavsel[6],
            icon: Feather.bell,
            touched: () {
              setState(() {
                select(6);
                globals.notifIndex = 0;
              });
              Navigator.pushNamed(context, '/notifications');
            },
          ),
          NavBarItems(
            tooltip: "Deposit Management",
            widget: Container(),
            active: globals.sidenavsel[7],
            icon: FontAwesomeIcons.piggyBank,
            touched: () {
              setState(() {
                select(7);
                globals.depIndex = 0;
              });
              Navigator.pushNamed(context, '/deposit/capitalshare');
            },
          ),
          //logout
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                try {
                  await FirebaseAuth.instance.signOut().whenComplete(() {
                    disposePrefs();

                    Navigator.pushNamedAndRemoveUntil(
                        context, '/coop/login', (route) => false);
                  });
                } catch (e) {
                  log('Signout (admin.dart) error: ${e.toString()}');
                }
              },
              splashColor: Colors.white,
              hoverColor: Colors.white10,
              child: Tooltip(
                message: 'Logout',
                textStyle: NavsToolTipStyle,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 60.0,
                        width: 80.0,
                        child: Row(
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(left: 35.0),
                              child: Icon(
                                Feather.log_out,
                                color: Colors.white54,
                                size: 19.0,
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
          ),
        ],
      ),
    );
  }
}

class NavBarItems extends StatefulWidget {
  final IconData icon;
  final Function touched;
  final bool active;
  final String tooltip;
  final Widget widget;

  const NavBarItems({
    super.key,
    required this.active,
    required this.icon,
    required this.touched,
    required this.tooltip,
    required this.widget,
  });

  @override
  State<NavBarItems> createState() => _NavBarItemsState();
}

class _NavBarItemsState extends State<NavBarItems> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          widget.touched();
        },
        splashColor: Colors.white,
        hoverColor: Colors.white12,
        child: Tooltip(
          message: widget.tooltip,
          textStyle: NavsToolTipStyle,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: Stack(
              children: [
                SizedBox(
                  height: 60.0,
                  width: 80.0,
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 475),
                        height: 35.0,
                        width: 5.0,
                        decoration: BoxDecoration(
                            color: widget.active
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0))),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: Icon(
                          widget.icon,
                          color: widget.active ? Colors.white : Colors.white54,
                          size: 19.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(top: 31, right: 23, child: widget.widget),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
