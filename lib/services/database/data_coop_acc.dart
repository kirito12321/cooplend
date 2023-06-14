class DataCoopAcc {
  final String firstName;
  final String middleName;
  final String lastName;
  final double capitalShare;
  final String status;
  final double savings;

  DataCoopAcc(
      {required this.firstName,
      required this.middleName,
      required this.lastName,
      required this.capitalShare,
      required this.status,
      required this.savings});

  static DataCoopAcc fromJson(Map<String, dynamic> json) => DataCoopAcc(
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      capitalShare: (json['capitalShare'] as num).toDouble(),
      status: json['status'],
      savings: (json['savings'] as num).toDouble());
}
