import 'package:cloud_firestore/cloud_firestore.dart';

class DataPayment {
  final String collectionID;
  final String loanId;
  final int invoiceNo;
  final double paidAmount;
  final bool isConfirmed;
  final DateTime createdAt;

  DataPayment(
      {required this.collectionID,
      required this.loanId,
      required this.invoiceNo,
      required this.paidAmount,
      required this.isConfirmed,
      required this.createdAt});

  Map<String, dynamic> toJson() => {
        'collectionID': collectionID,
        'loanId': loanId,
        'invoiceNo': invoiceNo,
        'paidAmount': paidAmount,
        'isConfirmed': isConfirmed,
        'createdAt': createdAt,
      };

  static DataPayment fromJson(Map<String, dynamic> json) => DataPayment(
        collectionID: json['collectionID'],
        loanId: json['loanId'],
        invoiceNo: json['invoiceNo'],
        paidAmount: json['paidAmount'],
        isConfirmed: json['isConfirmed'],
        createdAt: (json['createdAt'] as Timestamp).toDate(),
      );
}
