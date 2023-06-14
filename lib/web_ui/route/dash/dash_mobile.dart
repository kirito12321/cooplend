import 'dart:developer';

import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/route/dash/access.dart';
import 'package:ascoop/web_ui/route/dash/dash_pc.dart';
import 'package:ascoop/web_ui/route/dash/editprofile.dart';
import 'package:ascoop/web_ui/route/dash/editstaff.dart';
import 'package:ascoop/web_ui/route/dash/transactions.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashMobile extends StatefulWidget {
  const DashMobile({super.key});

  @override
  State<DashMobile> createState() => _DashMobileState();
}

class _DashMobileState extends State<DashMobile> {
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
            align: MainAxisAlignment.center,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  CoopDashProfile(),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                  StaffContent()
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

class StaffContent extends StatefulWidget {
  const StaffContent({super.key});

  @override
  State<StaffContent> createState() => _StaffContentState();
}

class _StaffContentState extends State<StaffContent> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('staffs')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('Something error...');
        }
        final data = snapshot.data!.data()!;
        return Container(
          padding: const EdgeInsets.all(15),
          width: MediaQuery.of(context).size.width * .6,
          //coop
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                  color: Color.fromARGB(255, 174, 171, 171),
                  spreadRadius: 0.5,
                  blurStyle: BlurStyle.normal,
                  blurRadius: 3.0)
            ],
          ),
          child: Column(
            children: [
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(data['profilePic']),
                    fit: BoxFit.cover,
                  ),
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              const Padding(
                  padding: EdgeInsets.symmetric(
                vertical: 4,
              )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '${data['firstname'].toString().toUpperCase()}  ${data['lastname'].toString().toUpperCase()}',
                    style: h3,
                    textAlign: TextAlign.center,
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                  const Text(
                    'My Email:',
                    style: h5,
                  ),
                  Text(
                    data['email'],
                    style: h4,
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                  const Text(
                    'Account Role:',
                    style: h5,
                  ),
                  Text(
                    data['role'].toString().toUpperCase(),
                    style: h4,
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                ],
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 6)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 210,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 3,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          side: const BorderSide(
                            width: 2,
                            color: Color.fromARGB(255, 1, 95, 84),
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Feather.clock,
                              size: 20,
                              color: Colors.teal[900],
                            ),
                            const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4)),
                            Text(
                              'My Transactions',
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.teal[900],
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const TransactBtn();
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 210,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 3,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          side: const BorderSide(
                            width: 2,
                            color: Color.fromARGB(255, 1, 95, 84),
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Feather.edit_3,
                              size: 20,
                              color: Colors.teal[900],
                            ),
                            const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4)),
                            Text(
                              'Update Account',
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.teal[900],
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onPressed: () {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return EditStaffBtn(
                                fname: data['firstname'],
                                lname: data['lastname'],
                                email: data['email'],
                                profile: data['profilePic'],
                                staffId: data['staffID'],
                                coopId: data['coopID'],
                              );
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
        );
      },
    );
  }
}

class CoopDashProfile extends StatefulWidget {
  const CoopDashProfile({super.key});
  @override
  State<CoopDashProfile> createState() => _CoopDashProfileState();
}

class _CoopDashProfileState extends State<CoopDashProfile> {
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
                          margin: const EdgeInsets.only(bottom: 20),
                          width: MediaQuery.of(context).size.width * .94,
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
                              Container(
                                height: 300,
                                width: 300,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(data['profilePic'] ??
                                          'https://firebasestorage.googleapis.com/v0/b/my-ascoop-project.appspot.com/o/coops%2Fdefault_nodata.png?alt=media&token=c80aca53-34ae-461e-81b4-a0a2d1cf198f'),
                                      fit: BoxFit.contain),
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['coopName'] ?? '',
                                    style: h1,
                                    textAlign: TextAlign.center,
                                  ),
                                  const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5)),
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
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10)),
                                  pref.data!
                                              .getString('myRole')
                                              .toString()
                                              .toLowerCase() !=
                                          "administrator"
                                      ? Container()
                                      : Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
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
                                                                .circular(50.0),
                                                        side: const BorderSide(
                                                          width: 2,
                                                          color: Color.fromARGB(
                                                              255, 1, 95, 84),
                                                        ),
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
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
                                                                .teal[900],
                                                          ),
                                                          const Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
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
                                                          context: context,
                                                          builder: (context) {
                                                            return EditCoopBtn(
                                                                name: data[
                                                                    'coopName'],
                                                                isOnline: data[
                                                                    'isOnlinePay'],
                                                                add: data[
                                                                    'coopAddress'],
                                                                email: data[
                                                                    'email'],
                                                                profile: data[
                                                                    'profilePic'],
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
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10)),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
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
                                                                .circular(50.0),
                                                        side: const BorderSide(
                                                          width: 2,
                                                          color: Color.fromARGB(
                                                              255, 1, 95, 84),
                                                        ),
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Feather.settings,
                                                            size: 25,
                                                            color: Colors
                                                                .teal[900],
                                                          ),
                                                          const Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
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
                                                          context: context,
                                                          builder: (context) {
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
                            ],
                          ),
                        );
                    }
                  }
                } catch (e) {
                  print('coop.dart error (stream): ${e.toString()}');
                }
                return Container(/** if null */);
              },
            );
          }
          return Container();
        });
  }
}
