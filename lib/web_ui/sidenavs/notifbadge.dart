import 'dart:developer';

import 'package:ascoop/web_ui/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

late final SharedPreferences prefs;
late final prefsFuture = SharedPreferences.getInstance().then((v) => prefs = v);

var notifBadgeStream = FutureBuilder(
    future: prefsFuture,
    builder: (context, prefs) {
      if (prefs.hasError) {
        return const Center(child: CircularProgressIndicator());
      } else {
        switch (prefs.connectionState) {
          case ConnectionState.waiting:
            return onWait;
          default:
            return StreamBuilder(
                stream: myDb
                    .collection('notifications')
                    .doc(prefs.data!.getString('coopId'))
                    .collection(FirebaseAuth.instance.currentUser!.uid)
                    .where('status', isEqualTo: 'unread')
                    .snapshots(),
                builder: (context, snapshot) {
                  try {
                    if (snapshot.hasError) {
                      log('notifBadge.dart (notifBadgeStream) (snapshot) error: ${snapshot.error.toString()}');
                    } else if (snapshot.hasData &&
                        snapshot.data!.docs.isNotEmpty) {
                      return Container(
                        width: 8.5,
                        height: 8.5,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red[800],
                        ),
                      );
                    }
                  } catch (e) {
                    log(e.toString());
                  }

                  return Container();
                });
        }
      }
    });
