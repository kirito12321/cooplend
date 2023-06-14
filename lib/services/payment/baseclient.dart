import 'dart:convert';

// import 'package:ascoop/services/database/data_loan.dart';
// import 'package:ascoop/services/database/data_payment.dart';
// import 'package:ascoop/services/database/data_service.dart';
// import 'package:ascoop/services/payment/create_soure.dart';
import 'package:ascoop/services/payment/payment_datamodel.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:url_launcher/url_launcher.dart';

const String baseUrl = 'https://api.paymongo.com/v1/sources';
const merchantId = 'sk_test_CQfUK1ShaUzybq99WSeX3hPA';

class BaseClient {
  final ocCy =
      NumberFormat.currency(decimalDigits: 2, customPattern: '#,###,###.00');
  var client = http.Client();
  Future<dynamic> get(String api) async {}
  Future<dynamic> createSource(PaymentDataModel paymentModel) async {
    // const merchantPId = 'pk_test_MwG9kQsEPDxswXxJ1j2XksAW';
    // const String urlCreateSource = 'https://api.paymongo.com/v1/sources';
    // String encoded = base64.encode(utf8.encode(merchantPId));
    // var url = Uri.parse(urlCreateSource);
    // final payload = jsonEncode({
    //   "data": {
    //     "attributes": {
    //       "amount": 10000,
    //       "redirect": {
    //         "success": 'https://www.youtube.com/watch?v=eJO5HU_7_1w',
    //         "failed": 'https://dashboard.paymongo.com/payments'
    //       },
    //       "billing": {
    //         "address": {
    //           "line1": 'Prk.Mabuhay Brgy.Binuangan Maco Davao De Oro',
    //           "line2": 'Prk.Mabuhay Brgy.Binuangan Maco Davao De Oro',
    //           "state": 'Compostela Valley',
    //           "postal_code": '8806',
    //           "city": 'Maco',
    //           "country": 'PH'
    //         },
    //         "name": 'Risley Brian Tarrayo',
    //         "phone": '09655413346',
    //         "email": 'rb.o.tarrayo@gmail.com'
    //       },
    //       "type": 'gcash',
    //       "currency": 'PHP'
    //     }
    //   }
    // });
    // Map<String, String> headers = {
    //   'Accept': 'application/json',
    //   'Content-Type': 'application/json',
    //   'Authorization': 'Basic $encoded'
    // };

    // var response = await client.post(url, body: payload, headers: headers);
    // print('url cord ${response.body.toString()}');
    // if (response.statusCode == 201 || response.statusCode == 200) {
    //   CreateSourceModal srcJson = createSourceModalFromJson(response.body);

    //   return creatPaymentUrl(srcJson.data.id);
    // } else {
    //   return print(response.body.toString());
    // }

    var url = Uri.http('test.dragonpay.ph', '/GenPay.aspx', {
      'merchantid': paymentModel.merchantId,
      'amount': ocCy.format(paymentModel.amount),
      'invoiceno': paymentModel.invoiceNo,
      'name': paymentModel.name,
      'email': paymentModel.email,
      'remarks': paymentModel.remarks
    });
    print(url);
    var response = await client.post(url);
    print('url cord ${response.statusCode.toString()}');
    if (response.statusCode == 301 || response.statusCode == 200) {
      print('url reloading');
      if (await canLaunchUrl(response.request!.url)) {
        if (await launchUrl(response.request!.url,
            mode: LaunchMode.externalApplication)) {
          return true;
        } else {
          return false;
        }
      } else {
        print("failed url");
      }
    } else {
      return false;
    }
  }

  Future<dynamic> webHook(String api) async {
    String encoded = base64.encode(utf8.encode(merchantId));
    var url = Uri.parse(baseUrl);
    final payload = jsonEncode({
      "data": {
        "id": "hook_asgZnJ2LUPUzuuFpT5j66ton",
        "type": "webhook",
        "attributes": {
          "livemode": true,
          "secret_key": "whsk_Cq2e2jxvuen6SoJd9RPu4ccn",
          "status": "enabled",
          "url": "https://mywebsite:3000/webhooks",
          "events": ["source.chargeable", "payment.paid", "payment.failed"],
          "created_at": 1586194939,
          "updated_at": 1586194939
        }
      }
    });
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Basic $encoded'
    };

    var response = await client.post(url, body: payload, headers: headers);
    print('url cord ${response.body.toString()}');
    if (response.statusCode == 201 || response.statusCode == 200) {
      print('url reloading');
      if (await canLaunchUrl(response.request!.url)) {
        await launchUrl(response.request!.url);
      } else {
        print("failed url");
      }
    } else {
      return print(response.body.toString());
    }
  }

  Future<dynamic> creatPaymentUrl(String srcId) async {
    const String urlCreatePayment = 'https://api.paymongo.com/v1/payments';
    String encoded = base64.encode(utf8.encode(merchantId));
    var url = Uri.parse(urlCreatePayment);
    final payload = jsonEncode({
      "data": {
        "attributes": {
          "amount": 10000,
          "source": {"id": srcId, "type": "source"},
          "description": "test coop lend payment #1",
          "currency": "PHP"
        }
      }
    });
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Basic $encoded'
    };

    var response = await client.post(url, body: payload, headers: headers);
    print('url cord ${response.body.toString()}');
    if (response.statusCode == 201 || response.statusCode == 200) {
      print('url reloading');
      if (await canLaunchUrl(response.request!.url)) {
        await launchUrl(response.request!.url);
      } else {
        print("failed url");
      }
    } else {
      return print(response.body.toString());
    }
  }

  // void createPayment(PaymentDataModel paymentModel, DataLoan loan) async {
  //   final payment = DataPayment(
  //       collectionID: ('${loan.coopId}_${loan.userId}_${loan.loanId}'),
  //       loanId: loan.loanId,
  //       invoiceNo: int.parse(paymentModel.invoiceNo) ,
  //       paidAmount: paymentModel.amount,
  //       isConfirmed: false,
  //       createdAt: Timestamp.now().toDate());
  //   await DataService.database().createPayment(payment: payment);
  // }
}
