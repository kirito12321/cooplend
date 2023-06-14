import 'package:ascoop/formulas/flatrate_formula.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataLoan {
  final String firstName; //1
  final String? middleName; //2
  final String lastName; //3
  final String loanId; //4
  final double loanAmount; //5
  final double paidAmount; //6
  final double totalPayment; //7
  final String paymentType; //8
  final int noMonths; //9
  final int noMonthsPaid; //10
  final double montlyPayment; //11
  final String userId; //12
  final String coopId; //13
  final String loanStatus; //14
  final DateTime createdAt; //15
  final String coopProfilePic; //16
  final DateTime? activeAt; //17
  final String? acceptedBy; //18
  final String? loanType; //19
  final DateTime? completeAt; //20
  final double interest;
  final double capitalFee;
  final double insuranceFee;
  final double netProceed;
  final double savingsFee;
  final double serviceFee;
  final double totalDeduction;
  final double totalInterest;
  final double totalBalance;

  DataLoan(
      {required this.firstName,
      this.middleName = '',
      required this.lastName,
      required this.loanId,
      required this.loanAmount,
      this.paidAmount = 0,
      this.totalPayment = 0,
      this.paymentType = '',
      required this.noMonths,
      this.noMonthsPaid = 0,
      this.montlyPayment = 0,
      required this.userId,
      required this.coopId,
      this.loanStatus = 'pending',
      required this.createdAt,
      required this.coopProfilePic,
      this.activeAt,
      this.acceptedBy,
      this.loanType,
      this.completeAt,
      required this.interest,
      this.capitalFee = 0,
      this.insuranceFee = 0,
      this.netProceed = 0,
      this.savingsFee = 0,
      this.serviceFee = 0,
      this.totalDeduction = 0,
      this.totalInterest = 0.0,
      this.totalBalance = 0.0});

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'middleName': middleName,
        'lastName': lastName,
        'loanId': loanId,
        'loanAmount': loanAmount,
        'paidAmount': paidAmount,
        'totalPayment': selectFormulaForTotalPayment(),
        'paymentType': paymentType,
        'noMonths': noMonths,
        'noMonthsPaid': noMonthsPaid,
        'montlyPayment': selectFormulaForMonthlyPayment(),
        'userId': userId,
        'coopId': coopId,
        'loanStatus': loanStatus,
        'createdAt': createdAt,
        'coopProfilePic': coopProfilePic,
        'loanType': loanType,
        'totalInterest': totalInterest,
        'totalBalance': totalBalance
      };

  static DataLoan fromJson(Map<String, dynamic> json) => DataLoan(
      firstName: json['firstName'] ?? 'no firstname',
      middleName: json['middleName'] ?? 'no middlename',
      lastName: json['lastName'] ?? 'no lastname',
      loanId: json['loanId'] ?? 'no loan ID',
      loanAmount: (json['loanAmount'] as num).toDouble(),
      paidAmount: (json['paidAmount'] as num).toDouble(),
      totalPayment: (json['totalPayment'] as num).toDouble(),
      paymentType: json['paymentType'] ?? 'no payment type',
      noMonths: json['noMonths'],
      noMonthsPaid: json['noMonthsPaid'],
      montlyPayment: (json['montlyPayment'] as num).toDouble(),
      userId: json['userId'],
      coopId: json['coopId'],
      loanStatus: json['loanStatus'] ?? 'no status',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      coopProfilePic: json['coopProfilePic'] ??
          'https://firebasestorage.googleapis.com/v0/b/my-ascoop-project.appspot.com/o/coops%2Fdefault_nodata.png?alt=media&token=c80aca53-34ae-461e-81b4-a0a2d1cf198f',
      activeAt: json['activeAt'] == null
          ? null
          : (json['activeAt'] as Timestamp).toDate(),
      acceptedBy: json['acceptedBy'] ?? 'no acceptedBy',
      loanType: json['loanType'] ?? 'no loan type',
      completeAt: json['completeAt'] == null
          ? null
          : (json['completeAt'] as Timestamp).toDate(),
      interest: 0.0,
      serviceFee: json['serviceFee'] != null
          ? (json['serviceFee'] as num).toDouble()
          : 0.0,
      savingsFee: json['savingsFee'] != null
          ? (json['savingsFee'] as num).toDouble()
          : 0.0,
      netProceed: json['netProceed'] != null
          ? (json['netProceed'] as num).toDouble()
          : 0.0,
      insuranceFee: json['insuranceFee'] != null
          ? (json['insuranceFee'] as num).toDouble()
          : 0.0,
      capitalFee: json['capitalFee'] != null
          ? (json['capitalFee'] as num).toDouble()
          : 0.0,
      totalDeduction: json['totalDeduction'] != null
          ? (json['totalDeduction'] as num).toDouble()
          : 0.0,
      totalInterest: (json['totalInterest'] as num).toDouble(),
      totalBalance: (json['totalBalance'] as num).toDouble());

  double selectFormulaForMonthlyPayment() {
    switch (paymentType) {
      case 'flatrate':
        return FlatRate(
                loanAmount: loanAmount,
                paidAmount: paidAmount,
                totalPayment: totalPayment,
                interest: interest,
                noMonths: noMonths,
                noMonthsPaid: noMonthsPaid,
                montlyPayment: montlyPayment)
            .computeMonthlyPayment();
      case 'Diminishing Interest Rate':
        return 0;
      default:
        return 0;
    }
  }

  double selectFormulaForTotalPayment() {
    switch (paymentType) {
      case 'Flat Interest Rate':
        return FlatRate(
                loanAmount: loanAmount,
                paidAmount: paidAmount,
                totalPayment: totalPayment,
                interest: interest,
                noMonths: noMonths,
                noMonthsPaid: noMonthsPaid,
                montlyPayment: montlyPayment)
            .computeTotalPayment();
      case 'Diminishing Interest Rate':
        return 0;
      default:
        return 0;
    }
  }
}
