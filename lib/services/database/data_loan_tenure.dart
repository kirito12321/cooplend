import 'package:cloud_firestore/cloud_firestore.dart';

class DataLoanTenure {
  final String loanId;
  final String coopId;
  final String userId;
  final String status;
  final double amountPayable;
  final double monthInterest;
  final double payment;
  final DateTime? payDate;
  final String? payMethod;
  final DateTime dueDate;
  final int month;
  final double? penalty;

  DataLoanTenure(
      {required this.loanId,
      required this.coopId,
      required this.userId,
      required this.status,
      required this.amountPayable,
      required this.monthInterest,
      this.payDate,
      required this.payment,
      this.payMethod,
      required this.dueDate,
      required this.month,
      this.penalty});

  static DataLoanTenure fromJson(Map<String, dynamic> json) => DataLoanTenure(
      loanId: json['loanId'],
      coopId: json['coopId'],
      userId: json['userId'],
      status: json['status'],
      amountPayable: (json['amountPayable'] as num).toDouble(),
      monthInterest: (json['monthInterest'] as num).toDouble(),
      payDate: json['payDate'] != null
          ? (json['payDate'] as Timestamp).toDate()
          : null,
      payment:
          json['payment'] != null ? (json['payment'] as num).toDouble() : 0,
      payMethod: json['payMethod'] ?? ' ',
      dueDate: (json['dueDate'] as Timestamp).toDate(),
      month: json['month'] ?? 0,
      penalty:
          json['penalty'] != null ? (json['penalty'] as num).toDouble() : 0.0);
}
