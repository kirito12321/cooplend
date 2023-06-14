import 'package:ascoop/services/database/data_loan.dart';
import 'package:ascoop/services/database/data_loan_tenure.dart';
import 'package:ascoop/services/database/data_service.dart';
import 'package:ascoop/services/payment/baseclient.dart';
import 'package:ascoop/services/payment/payment_datamodel.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShowPayDialog {
  final BuildContext context;
  final DataLoan loanData;
  final DataLoanTenure tenure;
  final ocCy =
      NumberFormat.currency(decimalDigits: 2, customPattern: '#,###,###.00');
  // final TextEditingController _payment = TextEditingController();
  ShowPayDialog(
      {required this.context, required this.loanData, required this.tenure});

  Future<bool?> showPaymentDialog() async {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: ocCy.format(tenure.payment),
              readOnly: true,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.right,
              decoration: const InputDecoration(
                  hintText: '0.00',
                  label: Text('Amount'),
                  border: OutlineInputBorder(),
                  prefixIcon: Align(
                    widthFactor: 1.0,
                    heightFactor: 1.0,
                    child: Icon(Icons.add_outlined),
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.all(8)),
            ),
            const SizedBox(
              width: 12,
            ),
            ElevatedButton(
                onPressed: () async {
                  var payment = PaymentDataModel(
                      merchantId: 'SAMPLEGEN',
                      invoiceNo: DateFormat('yyyyMMdd')
                          .format(DateTime.now())
                          .toString(),
                      name: 'Ban',
                      email: 'midfox30@gmail.com',
                      amount: tenure.payment,
                      remarks: 'test testing test');
                  try {
                    await BaseClient()
                        .createSource(payment)
                        .catchError((error) {
                      print(error);
                    }).then((value) async {
                      if (value) {
                        print('showPaymentDialog: $value');
                        await DataService.database()
                            .payLoan(tenure: tenure, amount: tenure.payment)
                            .then((value) => Navigator.of(context).pop(true));
                      } else {
                        Navigator.of(context).pop(false);
                      }
                    });
                    // DataService.database()
                    //     .payLoan(tenure: tenure, amount: amount)
                    //     .then((value) => Navigator.of(context).pop(true));
                  } catch (e) {
                    Navigator.of(context).pop(false);
                  }
                },
                child: const Text('Pay')),
          ],
        ),
      ),
    );
  }

  // void _payAction() async {
  // DataLoan loanInfo
  // var payment = PaymentDataModel(
  //     merchantId: 'SAMPLEGEN',
  //     invoiceNo: 12343,
  //     name: 'Ban',
  //     email: 'midfox30@gmail.com',
  //     amount: 1000,
  //     remarks: 'test testing test');
  // var response =
  //     await BaseClient().createSource(payment).catchError((error) {});
  // if (response == null) return;

  // var mechantId = 'test12301203912';
  // var password = '12345';
  // var client = http.Client();
  // var url = Uri.parse('http//test.dragonpay.ph/api/collect/v2/test20200118002/post');

  // var response = await client.get(url);
  // if(response.statusCode == 200){
  //   var json = response.body;

  // }
  // var credintials = SystemEncoding().encode("$mechantId:$password");
  // String token = convert.base64UrlEncode(credintials);

  // var urlHeader = await http.head(url, headers: {
  //   'Content-Type': 'application/json',
  //   'Authorization': 'Basic$token'
  // });

  // print("url header response: ${urlHeader.statusCode}");

  // var response = await http.post(url, body: {
  //   // 'merchantid': 'SAMPLEGEN',
  //   // 'txnid': '24835',
  //   "amount": '100',
  //   "currency": 'PHP',
  //   "invoiceNo": '3322444',
  //   "name": 'Ban',
  //   "description": 'Sample Description',
  //   "email": 'midfox30@gmail.com',
  //   "mobileNo": '09655413346',
  //   "procId": 'GCSH'
  // });
  // print('Response status: ${response.statusCode}');
  // print('Response body: ${response.body}');

  // if (await canLaunchUrl(response.request!.url)) {
  //   await launchUrl(response.request!.url);
  // } else {
  //   print("failed url");
  // }
  // }
}
// class PayDialog extends StatefulWidget {
//   const PayDialog({super.key});

//   @override
//   State<PayDialog> createState() => _PayDialogState();
// }

// class _PayDialogState extends State<PayDialog> {
//   late final TextEditingController _payment;

//   @override
//   void initState() {
//     _payment = TextEditingController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _payment.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final arguments = (ModalRoute.of(context)?.settings.arguments ??
//         <String, dynamic>{}) as Map;

//     DataLoanTenure tenure = arguments['tenure'] as DataLoanTenure;
//     return Dialog(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Center(
//             child: Wrap(
//               alignment: WrapAlignment.center,
//               spacing: 32,
//               children: [
//                 TextFormField(
//                   controller: _payment,
//                   keyboardType: TextInputType.number,
//                   textAlign: TextAlign.right,
//                   decoration: const InputDecoration(
//                       hintText: '0.00',
//                       label: Text('Amount'),
//                       border: OutlineInputBorder(),
//                       prefixIcon: Align(
//                         widthFactor: 1.0,
//                         heightFactor: 1.0,
//                         child: Icon(Icons.add_outlined),
//                       ),
//                       isDense: true,
//                       contentPadding: EdgeInsets.all(8)),
//                 ),
//                 const SizedBox(
//                   width: 12,
//                 ),
//                 ElevatedButton(
//                     onPressed: () {
//                       double amount = double.parse(_payment.text);
//                       try {
//                         DataService.database()
//                             .payLoan(tenure: tenure, amount: amount)
//                             .then((value) => Navigator.of(context).pop(true));
//                       } catch (e) {
//                         Navigator.of(context).pop(false);
//                       }
//                     },
//                     child: const Text('Pay')),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
