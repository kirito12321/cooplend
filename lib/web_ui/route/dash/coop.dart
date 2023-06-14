import 'dart:developer';

import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/route/dash/access.dart';
import 'package:ascoop/web_ui/route/dash/editprofile.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoopDash extends StatefulWidget {
  const CoopDash({super.key});
  @override
  State<CoopDash> createState() => _CoopDashState();
}

class _CoopDashState extends State<CoopDash> {
  late final SharedPreferences prefs;
  late final prefsFuture =
      SharedPreferences.getInstance().then((v) => prefs = v);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: prefsFuture,
        builder: (context, AsyncSnapshot<SharedPreferences> pref) {
          if (pref.hasError) {
            return const Center(child: CircularProgressIndicator());
          } else if (pref.hasData) {
            return StreamBuilder(
              stream: myDb
                  .collection('coops')
                  .doc(pref.data?.getString('coopId'))
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                try {
                  final data = snapshot.data?.data();
                  if (snapshot.hasError) {
                    log('snapshot.hasError (coopdash): ${snapshot.error}');
                    return Container();
                  } else if (snapshot.hasData) {
                    switch (snapshot.connectionState) {
                      // case ConnectionState.none:
                      //   log('connectionState.none (coopDash)');
                      //   return const Center(child: CircularProgressIndicator());
                      case ConnectionState.waiting:
                        return const Center(child: CircularProgressIndicator());
                      default:
                        return Container(
                          width: MediaQuery.of(context).size.width * .65,
                          height: 460,
                          padding: const EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                    color: Color.fromARGB(255, 174, 171, 171),
                                    spreadRadius: 1.0,
                                    blurStyle: BlurStyle.normal,
                                    blurRadius: 5.0)
                              ]),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 300,
                                    width: 300,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(data[
                                                  'profilePic'] ??
                                              'https://firebasestorage.googleapis.com/v0/b/my-ascoop-project.appspot.com/o/coops%2Fdefault_nodata.png?alt=media&token=c80aca53-34ae-461e-81b4-a0a2d1cf198f'),
                                          fit: BoxFit.contain),
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10)),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data['coopName'] ?? '',
                                          style: h1,
                                          textAlign: TextAlign.center,
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5)),
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          alignment: Alignment.centerLeft,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Coop Email Address: ',
                                                style: h5,
                                              ),
                                              Text(
                                                data['email'] ?? '',
                                                style: h3,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          alignment: Alignment.centerLeft,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Coop Local Address: ',
                                                style: h5,
                                              ),
                                              Text(
                                                data['coopAddress'] ?? '',
                                                style: h3,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10)),
                                        pref.data!
                                                    .getString('myRole')
                                                    .toString()
                                                    .toLowerCase() !=
                                                "administrator"
                                            ? Container()
                                            : Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 350,
                                                        child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            elevation: 3,
                                                            backgroundColor:
                                                                Colors.white,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50.0),
                                                              side:
                                                                  const BorderSide(
                                                                width: 2,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        1,
                                                                        95,
                                                                        84),
                                                              ),
                                                            ),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                  Feather.edit,
                                                                  size: 25,
                                                                  color: Colors
                                                                          .teal[
                                                                      900],
                                                                ),
                                                                const Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            4)),
                                                                Text(
                                                                  'Edit Cooperative Profile',
                                                                  style:
                                                                      editButtonTxt,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            setState(() {
                                                              showDialog(
                                                                barrierDismissible:
                                                                    false,
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return EditCoopBtn(
                                                                      name: data[
                                                                          'coopName'],
                                                                      add: data[
                                                                          'coopAddress'],
                                                                      email: data[
                                                                          'email'],
                                                                      profile: data[
                                                                          'profilePic'],
                                                                      isOnline:
                                                                          data[
                                                                              'isOnlinePay'],
                                                                      coopId: data[
                                                                          'coopId']);
                                                                },
                                                              );
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10)),
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 350,
                                                        child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            elevation: 3,
                                                            backgroundColor:
                                                                Colors.white,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50.0),
                                                              side:
                                                                  const BorderSide(
                                                                width: 2,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        1,
                                                                        95,
                                                                        84),
                                                              ),
                                                            ),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                  Feather
                                                                      .settings,
                                                                  size: 25,
                                                                  color: Colors
                                                                          .teal[
                                                                      900],
                                                                ),
                                                                const Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            4)),
                                                                Text(
                                                                  'Accessibility',
                                                                  style:
                                                                      editButtonTxt,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            setState(() {
                                                              showDialog(
                                                                barrierDismissible:
                                                                    false,
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return AccessibilityBtn(
                                                                      coopId: data[
                                                                          'coopId']);
                                                                },
                                                              );
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                    }
                  }
                } catch (e) {
                  log('coop.dart error (stream): ${e.toString()}');
                }
                return Container(/** if null */);
              },
            );
          }
          return Container();
        });
  }
}
