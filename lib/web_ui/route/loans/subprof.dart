import 'dart:developer';

import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/route/subs/profile.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class SubProf extends StatefulWidget {
  String loanId;
  SubProf({
    super.key,
    required this.loanId,
  });

  @override
  State<SubProf> createState() => _SubProfState();
}

class _SubProfState extends State<SubProf> {
  @override
  void initState() {
    widget.loanId = '';
    super.initState();
  }

  @override
  void dispose() {
    widget.loanId;
    super.dispose();
  }

  int index = 0;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: myDb
            .collection('loans')
            .where('loanId', isEqualTo: widget.loanId)
            .snapshots(),
        builder: (context, snapshot) {
          try {
            if (snapshot.hasError) {
              log('snapshot.hasError (coopdash): ${snapshot.error}');
              return Container();
            } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return onWait;
                default:
                  return StreamBuilder(
                      stream: myDb
                          .collection('subscribers')
                          .where('userId',
                              isEqualTo: snapshot.data!.docs[0]['userId'])
                          .where('coopId',
                              isEqualTo: snapshot.data!.docs[0]['coopId'])
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
                                return SubProfile(subId: data[index]['userId']);
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
          } catch (e) {}
          return Container();
        });
  }
}
