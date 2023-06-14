import 'package:cloud_firestore/cloud_firestore.dart';

class DataUserNotification {
  final String userId;
  final String notifID;
  final String? notifTitle;
  final String? notifText;
  final String? notifImageUrl;
  final String? iconUrl;
  final DateTime timestamp;
  final String status;

  DataUserNotification(
      {required this.userId,
      required this.notifID,
      this.notifTitle,
      this.notifText,
      this.iconUrl,
      this.notifImageUrl,
      required this.timestamp,
      this.status = 'unread'});

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'notifID': notifID,
        'notifTittle': notifTitle,
        'notifText': notifText,
        'notifImageUrl': notifImageUrl,
        'iconUrl': iconUrl,
        'timestamp': timestamp,
        'status': status
      };

  static DataUserNotification fromJson(Map<String, dynamic> json) =>
      DataUserNotification(
          userId: json['userId'],
          notifID: json['notifID'],
          notifTitle: json['notifTitle'],
          notifText: json['notifText'],
          timestamp: (json['timestamp'] as Timestamp).toDate(),
          notifImageUrl: json['notifImageUrl'],
          iconUrl: json['iconUrl'],
          status: json['status']);
}
