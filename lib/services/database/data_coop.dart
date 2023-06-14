class CoopInfo {
  final String coopID;
  final String email;
  final String coopName;
  final String coopAddress;
  final double interest;
  final String profilePic;
  final bool isOnlinePay;
  final double? penalty;
  // final String formula;
  // final double paidUpCS;
  // final double savingDeposit;
  // final double serviceFee;

  CoopInfo(
      {required this.coopID,
      required this.email,
      required this.coopAddress,
      required this.coopName,
      required this.interest,
      this.profilePic = '',
      required this.isOnlinePay,
      this.penalty
      // required this.formula,
      // required this.paidUpCS,
      // required this.savingDeposit,
      // required this.serviceFee
      });

  Map<String, dynamic> toJson() => {
        'coopID': coopID,
        'email': email,
        'coopAddress': coopAddress,
        'coopName': coopName,
        'interest': interest,
        'profilePic': profilePic
      };

  static CoopInfo fromJson(Map<String, dynamic> json) => CoopInfo(
      coopID: json['id'],
      email: json['email'],
      coopName: json['coopName'],
      coopAddress: json['coopAddress'],
      interest: json['interest'],
      profilePic: json['profilePic'],
      isOnlinePay: json['isOnlinePay'],
      penalty:
          json['penalty'] != null ? (json['penalty'] as num).toDouble() : 0.0
      // formula: json['formula'],
      // paidUpCS: (json['paidUpCS'] as num).toDouble(),
      // savingDeposit: (json['savingDeposit'] as num).toDouble(),
      // serviceFee: (json['serviceFee'] as num).toDouble()
      );
}
