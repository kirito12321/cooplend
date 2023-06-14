import 'package:cloud_firestore/cloud_firestore.dart';

class DataSubscription {
  final String userId;
  final String userFirstName;
  final String userMiddleName;
  final String userLastName;
  final String gender;
  final String? addedBy;
  final DateTime? blockedAt;
  final DateTime birthdate;
  final String userEmail;
  final String userAddress;
  final String userMobileNo;
  final String coopId;
  final String profilePicUrl;
  final String? validIdUrl;
  final String selfiewithIdUrl;
  final DateTime timestamp;
  final String status;
  final String? isConfirm;
  DataSubscription(
      {required this.userId,
      required this.userFirstName,
      required this.userMiddleName,
      required this.userLastName,
      required this.gender,
      this.addedBy,
      this.blockedAt,
      this.isConfirm,
      required this.birthdate,
      required this.userEmail,
      required this.userAddress,
      required this.userMobileNo,
      required this.coopId,
      required this.profilePicUrl,
      required this.validIdUrl,
      required this.timestamp,
      required this.status,
      required this.selfiewithIdUrl});

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'userFirstName': userFirstName,
        'userMiddleName': userMiddleName,
        'userLastName': userLastName,
        'gender': gender,
        'birthdate': birthdate,
        'userEmail': userEmail,
        'userAddress': userAddress,
        'userMobileNo': userMobileNo,
        'coopId': coopId,
        'profilePicUrl': profilePicUrl,
        'validIdUrl': validIdUrl,
        'timestamp': timestamp,
        'status': status,
        'selfiewithIdUrl': selfiewithIdUrl
      };

  static DataSubscription fromJson(Map<String, dynamic> json) =>
      DataSubscription(
          userId: json['userId'],
          userFirstName: json['userFirstName'],
          userMiddleName: json['userMiddleName'],
          userLastName: json['userLastName'],
          gender: json['gender'],
          addedBy: json['addedBy'] ?? '',
          blockedAt: json['blockedAt'] == null
              ? null
              : (json['blockedAt'] as Timestamp).toDate(),
          birthdate: (json['birthdate'] as Timestamp).toDate(),
          userEmail: json['userEmail'],
          userAddress: json['userAddress'],
          userMobileNo: json['userMobileNo'],
          coopId: json['coopId'],
          profilePicUrl: json['profilePicUrl'],
          validIdUrl: json['validIdUrl'],
          timestamp: (json['timestamp'] as Timestamp).toDate(),
          isConfirm: json['isConfirm'] != null ? '' : json['isConfirm'],
          selfiewithIdUrl: json['selfiewithIdUrl'],
          status: json['status']);
}
