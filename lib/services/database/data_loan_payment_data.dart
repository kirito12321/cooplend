import 'package:cloud_firestore/cloud_firestore.dart';

class DataLoanPaymentData {
  final double amount;
  final String coopId;
  final DateTime dueDate;
  final String invoiceNo;
  final String loanId;
  final String payStatus;
  final String payerId;
  final String paymentMethod;
  final String receivedBy;
  final String tenureId;
  final double monthlyPay;
  final DateTime timestamp;

  DataLoanPaymentData(
      {required this.amount,
      required this.coopId,
      required this.dueDate,
      required this.invoiceNo,
      required this.loanId,
      required this.payStatus,
      required this.payerId,
      required this.paymentMethod,
      required this.receivedBy,
      required this.tenureId,
      required this.timestamp,
      required this.monthlyPay});

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'coopId': coopId,
        'dueDate': dueDate,
        'invoiceNo': invoiceNo,
        'loanId': loanId,
        'payStatus': payStatus,
        'payerId': payerId,
        'paymentMethod': paymentMethod,
        'receivedBy': receivedBy,
        'tenureId': tenureId,
        'timestamp': timestamp,
        'monthlyPay': monthlyPay
      };

  static DataLoanPaymentData fromJson(Map<String, dynamic> json) =>
      DataLoanPaymentData(
          amount: (json['amount'] as num).toDouble(),
          coopId: json['coopId'],
          dueDate: (json['dueDate'] as Timestamp).toDate(),
          invoiceNo: json['invoiceNo'],
          loanId: json['loanId'],
          payStatus: json['payStatus'],
          payerId: json['payerId'],
          paymentMethod: json['paymentMethod'],
          receivedBy: json['receivedBy'],
          tenureId: json['tenureId'],
          timestamp: (json['timestamp'] as Timestamp).toDate(),
          monthlyPay: (json['monthlyPay'] as num).toDouble());
}
