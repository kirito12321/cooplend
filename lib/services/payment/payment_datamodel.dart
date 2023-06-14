import 'dart:convert';

PaymentDataModel paymentDataModelFromJson(String str) =>
    PaymentDataModel.fromJson(json.decode(str));

String paymentDataModelToJson(PaymentDataModel data) =>
    json.encode(data.toJson());

class PaymentDataModel {
  PaymentDataModel({
    required this.merchantId,
    required this.invoiceNo,
    required this.name,
    required this.email,
    required this.amount,
    required this.remarks,
  });

  String merchantId;
  String invoiceNo;
  String name;
  String email;
  double amount;
  String remarks;

  factory PaymentDataModel.fromJson(Map<String, dynamic> json) =>
      PaymentDataModel(
        merchantId: json["merchantId"],
        invoiceNo: json["invoiceNo"],
        name: json["name"],
        email: json["email"],
        amount: json["amount"],
        remarks: json["remarks"],
      );

  Map<String, dynamic> toJson() => {
        "merchantId": merchantId,
        "invoiceNo": invoiceNo,
        "name": name,
        "email": email,
        "amount": amount,
        "remarks": remarks,
      };
}
