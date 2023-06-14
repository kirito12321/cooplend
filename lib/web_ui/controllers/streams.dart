
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ascoop/web_ui/global_var.dart' as globals;
import 'package:firebase_auth/firebase_auth.dart';

//stream for sidenavs
var getNotifBadge = FirebaseFirestore.instance
    .collection('notifications')
    .where('notifFor', isEqualTo: globals.logId)
    .where('status', isEqualTo: 'unread')
    .snapshots();
