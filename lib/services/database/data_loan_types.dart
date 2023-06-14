class DataLoanTypes {
  final String loanName;
  final double interest;
  final int loanMonths;
  final String status;
  final double loanBasedValue;

  DataLoanTypes(
      {required this.loanName,
      required this.interest,
      required this.loanMonths,
      required this.status,
      required this.loanBasedValue});

  static DataLoanTypes fromJson(Map<String, dynamic> json) => DataLoanTypes(
      loanName: json['loanName'],
      interest: (json['interest'] as num).toDouble(),
      loanMonths: json['loanMonths'],
      status: json['status'],
      loanBasedValue: json['loanBasedValue'] == null
          ? 0.0
          : (json['loanBasedValue'] as num).toDouble());
}
