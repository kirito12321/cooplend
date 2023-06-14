import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

void getStaffCoopInfo() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await FirebaseFirestore.instance
        .collection('staffs')
        .where('staffID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then(
      (staff) {
        //staff's info

        prefs.setString('myRole', staff.docs[0]['role'].toString());
        prefs.setString('coopId', staff.docs[0]['coopID'].toString());
      },
      onError: (e) {
        log('getStaffCoopInfo (getInfo.dart) (calling staffs) Error: ${e.toString()}');
      },
    );
  } catch (e) {
    log('getStaffCoopInfo (getInfo.dart) Error: ${e.toString()}');
  }
}
