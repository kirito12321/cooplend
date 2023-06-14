import 'dart:convert';

CreateSourceModal createSourceModalFromJson(String str) =>
    CreateSourceModal.fromJson(json.decode(str));

String createSourceModalToJson(CreateSourceModal data) =>
    json.encode(data.toJson());

class CreateSourceModal {
  CreateSourceModal({
    required this.data,
  });

  Data data;

  factory CreateSourceModal.fromJson(Map<String, dynamic> json) =>
      CreateSourceModal(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.id,
    required this.type,
    required this.attributes,
  });

  String id;
  String type;
  Attributes attributes;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        type: json["type"],
        attributes: Attributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "attributes": attributes.toJson(),
      };
}

class Attributes {
  Attributes({
    required this.amount,
    required this.billing,
    required this.currency,
    required this.livemode,
    required this.redirect,
    required this.status,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  int amount;
  Billing billing;
  String currency;
  bool livemode;
  Redirect redirect;
  String status;
  String type;
  int createdAt;
  int updatedAt;

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
        amount: json["amount"],
        billing: Billing.fromJson(json["billing"]),
        currency: json["currency"],
        livemode: json["livemode"],
        redirect: Redirect.fromJson(json["redirect"]),
        status: json["status"],
        type: json["type"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "billing": billing.toJson(),
        "currency": currency,
        "livemode": livemode,
        "redirect": redirect.toJson(),
        "status": status,
        "type": type,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class Billing {
  Billing({
    required this.address,
    required this.email,
    required this.name,
    required this.phone,
  });

  Address address;
  String email;
  String name;
  String phone;

  factory Billing.fromJson(Map<String, dynamic> json) => Billing(
        address: Address.fromJson(json["address"]),
        email: json["email"],
        name: json["name"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "address": address.toJson(),
        "email": email,
        "name": name,
        "phone": phone,
      };
}

class Address {
  Address({
    required this.city,
    required this.country,
    required this.line1,
    required this.line2,
    required this.postalCode,
    required this.state,
  });

  String city;
  String country;
  String line1;
  String line2;
  String postalCode;
  String state;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        city: json["city"],
        country: json["country"],
        line1: json["line1"],
        line2: json["line2"],
        postalCode: json["postal_code"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "city": city,
        "country": country,
        "line1": line1,
        "line2": line2,
        "postal_code": postalCode,
        "state": state,
      };
}

class Redirect {
  Redirect({
    required this.checkoutUrl,
    required this.failed,
    required this.success,
  });

  String checkoutUrl;
  String failed;
  String success;

  factory Redirect.fromJson(Map<String, dynamic> json) => Redirect(
        checkoutUrl: json["checkout_url"],
        failed: json["failed"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "checkout_url": checkoutUrl,
        "failed": failed,
        "success": success,
      };
}
