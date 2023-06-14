class DataFCM {
  final String userId;
  final String fcmToken;

  DataFCM({required this.userId, required this.fcmToken});

  Map<String, dynamic> toJson() => {'userId': userId, 'fcmToken': fcmToken};

  static DataFCM fromJson(Map<String, dynamic> json) =>
      DataFCM(userId: json['userId'], fcmToken: json['fcmToken']);
}
