import 'package:cloud_firestore/cloud_firestore.dart';

class StaffData {
  String staffID;
  String coopID;
  String firstname;
  String lastname;
  String email;
  bool isBlock;
  String profiePic;
  String role;
  DateTime timestamp;

  StaffData({
    required this.staffID,
    required this.coopID,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.isBlock,
    required this.profiePic,
    required this.role,
    required this.timestamp,
  });

  StaffData fromJson(Map<String, dynamic> json) => StaffData(
        staffID: json['staffID'],
        coopID: json['coopID'],
        firstname: json['firstname'],
        lastname: json['lastname'],
        email: json['email'],
        isBlock: json['isBlock'],
        profiePic: json['profiePic'],
        role: json['role'],
        timestamp: json['timestamp'].toDate(),
      );
}
