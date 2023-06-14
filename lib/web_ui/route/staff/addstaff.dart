import 'dart:developer';

import 'package:ascoop/web_ui/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ascoop/web_ui/global_var.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class AddStaff extends StatefulWidget {
  const AddStaff({
    super.key,
  });

  @override
  State<AddStaff> createState() => _AddStaffState();
}

class _AddStaffState extends State<AddStaff> {
  late final SharedPreferences prefs;
  late final prefsFuture =
      SharedPreferences.getInstance().then((v) => prefs = v);
  List<String> roles = <String>['Bookkeeper', 'Cashier'];
  late String fname, lname, email, pass;
  TextEditingController _fname = TextEditingController(),
      _lname = TextEditingController(),
      _email = TextEditingController(),
      _pass = TextEditingController();
  late String dropdownValue = roles.first;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: prefsFuture,
        builder: (context, prefs) {
          if (prefs.hasError) {
            return const Center(child: CircularProgressIndicator());
          } else {
            switch (prefs.connectionState) {
              case ConnectionState.waiting:
                return onWait;
              default:
                return AlertDialog(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Feather.plus_circle,
                            size: 30,
                          ),
                          const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5)),
                          Text(
                            'Add Staff',
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.5,
                                fontSize: 20,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      InkWell(
                        hoverColor: Colors.white,
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Feather.x,
                          size: 25,
                        ),
                      )
                    ],
                  ),
                  content: Form(
                    child: ScrollConfiguration(
                      behavior: MyCustomScrollBehavior(),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: TextFormField(
                                      controller: _fname,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                          labelText: 'Firstname',
                                          labelStyle: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color: Colors.grey[700],
                                              letterSpacing: 1)),
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          color: Colors.black,
                                          letterSpacing: 1),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 150,
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: TextFormField(
                                      controller: _lname,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                          labelText: 'Lastname',
                                          labelStyle: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color: Colors.grey[700],
                                              letterSpacing: 1)),
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          color: Colors.black,
                                          letterSpacing: 1),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 300,
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: TextFormField(
                                  controller: _email,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    labelText: 'Email',
                                    labelStyle: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                        letterSpacing: 1),
                                  ),
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: Colors.black,
                                      letterSpacing: 1),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 300,
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: TextFormField(
                                  controller: _pass,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color:
                                              Color.fromARGB(255, 1, 104, 92),
                                          width: 1),
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    labelText: 'Password',
                                    labelStyle: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                        letterSpacing: 1),
                                  ),
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: Colors.black,
                                      letterSpacing: 1),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 300,
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    // <- Here
                                    splashColor: Colors.white, // <- Here
                                    highlightColor: Colors.white, // <- Here
                                    hoverColor: Colors.white, // <- Here
                                    focusColor: Colors.white,
                                  ),
                                  child: DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      labelText: 'Account Role',
                                      labelStyle: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                          letterSpacing: 1),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                    ),
                                    isExpanded: true,
                                    value: dropdownValue,
                                    items: roles.map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value,
                                            style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14,
                                                color: Colors.black,
                                                letterSpacing: 1)),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        dropdownValue = value!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const Padding(
                                padding: EdgeInsets.symmetric(vertical: 6)),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal[800],
                              ),
                              child: Container(
                                width: 100,
                                padding: const EdgeInsets.all(12.0),
                                child: Center(
                                  child: Text(
                                    "Submit",
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: Colors.white,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                final bool emailValid = RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(_email.text);
                                if (_fname.text.trim().isEmpty ||
                                    _lname.text.trim().isEmpty ||
                                    _email.text.trim().isEmpty ||
                                    _pass.text.trim().isEmpty) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: AlertDialog(
                                        title: Text(
                                          'An error occured',
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w700),
                                        ),
                                        content: Text(
                                          "Please fill all inputs required",
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[800]),
                                        ),
                                        actions: [
                                          ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.teal[800]),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  'OK',
                                                  style: GoogleFonts.montserrat(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 15,
                                                      color: Colors.white),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  );
                                } else if (emailValid != true) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: AlertDialog(
                                        title: Text(
                                          'An error occured',
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w700),
                                        ),
                                        content: Text(
                                          "Email Address is not valid",
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[800]),
                                        ),
                                        actions: [
                                          ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.teal[800]),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  'OK',
                                                  style: GoogleFonts.montserrat(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 15,
                                                      color: Colors.white),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  FirebaseApp apptemp =
                                      await Firebase.initializeApp(
                                          name: 'tempRegister',
                                          options: Firebase.app().options);
                                  await FirebaseAuth.instanceFor(app: apptemp)
                                      .createUserWithEmailAndPassword(
                                          email: _email.text,
                                          password: _pass.text)
                                      .then((value) async {
                                    await apptemp.delete();
                                    //staffs col
                                    await FirebaseFirestore.instance
                                        .collection('staffs')
                                        .doc(value.user!.uid)
                                        .set({
                                      'coopID': prefs.data!.getString('coopId'),
                                      'email': _email.text,
                                      'firstname': _fname.text.trim(),
                                      'lastname': _lname.text.trim(),
                                      'profilePic':
                                          'https://firebasestorage.googleapis.com/v0/b/my-ascoop-project.appspot.com/o/staffs%2Fdefault.png?alt=media&token=a78f8305-d8b7-45c3-b731-39ab044e2d24',
                                      'role': dropdownValue,
                                      'staffID': value.user!.uid,
                                      'timestamp': DateTime.now(),
                                      'isBlock': false,
                                      'addedBy': globals.logId
                                    });

                                    WriteBatch batch =
                                        FirebaseFirestore.instance.batch();
                                    //notif col
                                    myDb
                                        .collection('staffs')
                                        .where('staffID',
                                            isEqualTo: value.user!.uid)
                                        .get()
                                        .then((data) async {
                                      if (data.size > 0) {
                                        for (int a = 0; a < data.size; a++) {
                                          await myDb
                                              .collection('notifications')
                                              .doc(prefs.data!
                                                  .getString('coopId'))
                                              .collection(
                                                  data.docs[a]['staffID'])
                                              .doc(DateFormat('yyyyMMddHHmmss')
                                                  .format(DateTime.now()))
                                              .set({
                                            'context': 'subscriber',
                                            'coopId':
                                                prefs.data!.getString('coopId'),
                                            'title': 'Approved Loan Request',
                                            'content':
                                                "Welcome! You can now login in the Cooperative as $dropdownValue.",
                                            'notifBy': FirebaseAuth
                                                .instance.currentUser!.uid,
                                            'notifId': data.docs[a]['staffID'],
                                            'timestamp': DateTime.now(),
                                            'status': 'unread',
                                          });
                                        }
                                      }
                                    });

                                    //transaction

                                    batch.set(
                                        FirebaseFirestore.instance
                                            .collection('staffs')
                                            .doc(globals.logId)
                                            .collection('transactions')
                                            .doc(),
                                        {
                                          'timestamp': DateTime.now(),
                                          'context': 'Staff',
                                          'content':
                                              'You added a new $dropdownValue to the staff list.',
                                          'title': 'Added Staff',
                                          'staffId': FirebaseAuth
                                              .instance.currentUser!.uid,
                                        });

                                    batch.commit().then(
                                      (value) {
                                        showDialog(
                                          context: context,
                                          builder: (context) => Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: AlertDialog(
                                              title: Text(
                                                'Added Successfully',
                                                style: GoogleFonts.montserrat(
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              content: Text(
                                                "${_fname.text} ${_lname.text} added as a $dropdownValue",
                                                style: GoogleFonts.montserrat(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.grey[800]),
                                              ),
                                              actions: [
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                Colors
                                                                    .teal[800]),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        'OK',
                                                        style: GoogleFonts
                                                            .montserrat(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .white),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      onError: (e) {
                                        log('batch error: ' + e.toString());
                                      },
                                    );
                                  }, onError: (e) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                            'An error occured',
                                            style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.w700),
                                          ),
                                          content: Text(
                                            'You have entered used email address.',
                                            style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey[800]),
                                          ),
                                        );
                                      },
                                    );
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
            }
          }
        });
  }
}
