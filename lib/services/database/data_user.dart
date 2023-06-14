import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfo {
  final String userUID;
  final String firstName;
  final String middleName;
  final String lastName;
  final String gender;
  final String email;
  final String mobileNo;
  final DateTime birthDate;
  final String currentAddress;
  final String? profilePicUrl;
  UserInfo(
      {required this.userUID,
      required this.firstName,
      required this.middleName,
      required this.lastName,
      required this.gender,
      required this.email,
      required this.mobileNo,
      required this.birthDate,
      required this.currentAddress,
      this.profilePicUrl});

  Map<String, dynamic> toJson() => {
        'userUID': userUID,
        'firstName': firstName,
        'middleName': middleName,
        'lastName': lastName,
        'gender': gender,
        'email': email,
        'mobileNo': mobileNo,
        'birthDate': birthDate,
        'currentAddress': currentAddress,
      };

  static UserInfo fromJson(Map<String, dynamic> json) => UserInfo(
      userUID: json['userUID'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      gender: json['gender'],
      email: json['email'],
      mobileNo: json['mobileNo'],
      birthDate: (json['birthDate'] as Timestamp).toDate(),
      currentAddress: json['currentAddress'],
      profilePicUrl: json['profilePicUrl'] ??
          'https://firebasestorage.googleapis.com/v0/b/my-ascoop-project.appspot.com/o/coops%2Fdefault_nodata.png?alt=media&token=c80aca53-34ae-461e-81b4-a0a2d1cf198f');
}
