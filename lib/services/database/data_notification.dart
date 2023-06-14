import 'package:cloud_firestore/cloud_firestore.dart';

class DataNotification {
  final String id;
  final String authUID;
  final String notifTitle;
  final String notifText;
  final DateTime timestamp;
  final String? notifImageUrl;
  final String status;

  DataNotification(
      {required this.id,
      required this.authUID,
      required this.notifTitle,
      required this.notifText,
      required this.timestamp,
      this.notifImageUrl,
      this.status = 'unread'});

  Map<String, dynamic> toJson() => {
        'id': id,
        'authUID': authUID,
        'notifTittle': notifTitle,
        'notifText': notifText,
        'notifImageUrl': notifImageUrl,
        'status': status
      };

  static DataNotification fromJson(Map<String, dynamic> json) =>
      DataNotification(
          id: json['id'],
          authUID: json['authUID'],
          notifTitle: json['notifTitle'],
          notifText: json['notifText'],
          timestamp: (json['createdAt'] as Timestamp).toDate(),
          notifImageUrl: json['notifImageUrl'],
          status: json['status']);
}
