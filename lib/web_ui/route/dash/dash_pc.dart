
import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/route/dash/coop.dart';
import 'package:ascoop/web_ui/route/dash/dashinfo.dart';
import 'package:ascoop/web_ui/route/dash/staff.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashPc extends StatefulWidget {
  const DashPc({super.key});

  @override
  State<DashPc> createState() => _DashPcState();
}

class _DashPcState extends State<DashPc> {
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
            title: 'Dashboard',
            icon: FontAwesomeIcons.gaugeHigh,
          ),
          const Expanded(
            child: DashContent(),
          ),
        ],
      ),
    );
  }
}

class DashContent extends StatefulWidget {
  const DashContent({super.key});

  @override
  State<DashContent> createState() => _DashContentState();
}

class _DashContentState extends State<DashContent> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  CoopDash(),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                  Expanded(
                    child: StaffProfile(),
                  )
                ],
              ),
            ),
            const FeatContxt(),
          ],
        ),
      ),
    );
  }
}

class FeatContxt extends StatefulWidget {
  const FeatContxt({super.key});

  @override
  State<FeatContxt> createState() => _FeatContxtState();
}

class _FeatContxtState extends State<FeatContxt> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 5, top: 20),
            child: Row(
              children: const [
                Icon(
                  Feather.users,
                  size: 30,
                  color: Colors.black,
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                Text(
                  'Subscriber Management',
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          const DashSubs(),
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 5, top: 20),
            child: Row(
              children: const [
                Icon(
                  Feather.credit_card,
                  size: 30,
                  color: Colors.black,
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                Text(
                  'Loan Management',
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          const LoanDash(),
        ],
      ),
    );
  }
}
