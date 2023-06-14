// ignore_for_file: non_constant_identifier_names

import 'package:ascoop/web_ui/sidenavs/controller.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';

//sidenav's var holder
// ignore: prefer_typing_uninitialized_variables

//------
var onWait = Center(
    child: CircularProgressIndicator(
  color: teal8,
  strokeWidth: 7,
));
var myAppbar = AppBar(
  backgroundColor: Colors.transparent,
  iconTheme: const IconThemeData(color: Colors.black),
  toolbarHeight: 45,
  elevation: 0,
);
var defaultBackground = Colors.grey[100];

var myDrawer = Drawer(
  elevation: 3,
  width: 80,
  child: Builder(builder: (context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: 80.0,
      decoration: BoxDecoration(color: Colors.teal[800]),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 15.0),
              //logo cooplend
              height: 70.0,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo_only.png',
                      height: 200,
                      scale: 2.5,
                      filterQuality: FilterQuality.high,
                    )
                  ],
                ),
              ),
            ), //end of logo
            const Padding(padding: EdgeInsets.symmetric(vertical: 10)),

            const MainNavs(),
          ],
        ),
      ),
    );
  }),
);

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}

var myDb = FirebaseFirestore.instance;

class ContextHeader extends StatefulWidget {
  String title;
  var icon;
  var align;
  var widget;
  ContextHeader(
      {Key? key,
      required this.title,
      required this.icon,
      this.align = MainAxisAlignment.start,
      this.widget = const SizedBox()})
      : super(key: key);

  @override
  State<ContextHeader> createState() => _ContextHeaderState();
}

class _ContextHeaderState extends State<ContextHeader> {
  @override
  void dispose() {
    super.dispose();
    widget.icon;
    widget.title;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 15, 15, 15),
      decoration: const BoxDecoration(
        border: Border(
            bottom: BorderSide(
                width: 1.0, color: Color.fromARGB(255, 203, 203, 203))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: widget.align,
            children: [
              Icon(
                widget.icon,
                size: 30,
              ),
              const Padding(padding: EdgeInsets.only(top: 18, left: 10)),
              Text(
                widget.title,
                style: headerText,
              ),
            ],
          ),
          widget.widget,
        ],
      ),
    );
  }
}

var vertSpace = const Padding(padding: EdgeInsets.symmetric(vertical: 5));

var teal8 = const Color.fromARGB(255, 0, 105, 92);
var grey4 = const Color.fromARGB(255, 156, 156, 156);
var grey1 = const Color.fromARGB(255, 203, 203, 203);
var orange8 = const Color.fromARGB(255, 239, 108, 0);
var red8 = const Color.fromARGB(255, 198, 40, 40);

class EmptyData extends StatefulWidget {
  String ttl;
  EmptyData({super.key, required this.ttl});

  @override
  State<EmptyData> createState() => _EmptyDataState();
}

class _EmptyDataState extends State<EmptyData> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/images/ghost_noresult.gif',
              scale: 3.5,
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
            Text(
              widget.ttl,
              style: const TextStyle(
                  fontFamily: FontNameDefault,
                  letterSpacing: 0.5,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
