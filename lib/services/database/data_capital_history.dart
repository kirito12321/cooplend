import 'package:cloud_firestore/cloud_firestore.dart';

class DataCapitalShareHistory {
  final double balance;
  final double deposits;
  final DateTime timestamp;
  final double withdrawals;

  DataCapitalShareHistory(
      {required this.balance,
      required this.deposits,
      required this.timestamp,
      required this.withdrawals});

  static DataCapitalShareHistory fromJson(Map<String, dynamic> json) =>
      DataCapitalShareHistory(
          balance: (json['balance'] as num).toDouble(),
          deposits: (json['deposits'] as num).toDouble(),
          timestamp: (json['timestamp'] as Timestamp).toDate(),
          withdrawals: (json['withdrawals'] as num).toDouble());
}
