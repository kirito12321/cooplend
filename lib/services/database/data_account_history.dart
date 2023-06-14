import 'package:cloud_firestore/cloud_firestore.dart';

class AccountHistory {
  final String id;
  final String actionTitle;
  final String actionText;
  final DateTime createdAt;

  AccountHistory(
      {required this.id,
      required this.actionTitle,
      required this.actionText,
      required this.createdAt});

  Map<String, dynamic> toJson() => {
        'id': id,
        'actionTitle': actionTitle,
        'actionText': actionText,
        'createdAt': createdAt
      };
  static AccountHistory fromJson(Map<String, dynamic> json) => AccountHistory(
        id: json['id'],
        actionTitle: json['actionTitle'],
        actionText: json['actionText'],
        createdAt: (json['createdAt'] as Timestamp).toDate(),
      );
}
