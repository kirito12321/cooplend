import 'package:ascoop/services/database/data_loan.dart';
import 'package:ascoop/services/database/data_loan_tenure.dart';
import 'package:ascoop/services/database/data_loan_types.dart';
import 'package:ascoop/services/database/data_service.dart';
// import 'package:ascoop/services/payment/baseclient.dart';
// import 'package:ascoop/services/payment/payment_datamodel.dart';
import 'package:ascoop/style.dart';
import 'package:ascoop/utilities/show_alert_dialog.dart';
import 'package:ascoop/utilities/show_pay_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../services/database/data_loan_payment_data.dart';

class LoanTenureView extends StatefulWidget {
  const LoanTenureView({super.key});

  @override
  State<LoanTenureView> createState() => _LoanTenureViewState();
}

class _LoanTenureViewState extends State<LoanTenureView> {
  int activeIndex = 0;
  // bool isOnlinePay = false;
  final ocCy =
      NumberFormat.currency(decimalDigits: 2, customPattern: '#,###,###.00');

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    Size size = MediaQuery.of(context).size;
    // checkCoopPayService(arguments['coopId']);
    double screenWidth = size.width;

    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.black,
          ),
          title: const Text(
            'Loan Tenure',
            style: dashboardMemberTextStyle,
          ),
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Image(
                  image: AssetImage('assets/images/cooplendlogo.png')),
              padding: const EdgeInsets.all(2.0),
              iconSize: screenWidth * 0.4,
              onPressed: () {},
            )
          ],
        ),
        body: StreamBuilder<DataLoanTenure?>(
          stream: DataService.database().readLoanTenure(
              loanId: (arguments['loanInfo'] as DataLoan).loanId,
              coopId: (arguments['loanInfo'] as DataLoan).coopId,
              userId: (arguments['loanInfo'] as DataLoan).userId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final loanTenure = snapshot.data!;

              return buildLoan(loanTenure, size, arguments);

              // return loanTenure == null
              //     ? const Text('No Data')
              //     : buildLoan(loanTenure, size, arguments);
            } else if (snapshot.hasError) {
              // return Center(
              //     child: Text('error reading loan details${snapshot.error}'));
              final loanTenure = DataLoanTenure(
                  loanId: (arguments['loanInfo'] as DataLoan).loanId,
                  coopId: (arguments['loanInfo'] as DataLoan).coopId,
                  userId: (arguments['loanInfo'] as DataLoan).userId,
                  status: 'completed',
                  amountPayable: 0,
                  monthInterest: 0,
                  payment: 0,
                  dueDate: DateTime.now(),
                  month: 0);
              return buildLoan(loanTenure, size, arguments);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }

  Widget buildLoan(
      DataLoanTenure loanTenure, Size size, Map<dynamic, dynamic> arguments) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: size.height * 0.1,
            width: size.width,
            decoration: BoxDecoration(
              color: Colors.teal[600],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  'LOAN ID: ${loanTenure.loanId}',
                  style: TenureLoanIDTextStyle,
                ),
              ),
            ),
          ),
          Container(
            height: size.height * 0.2,
            width: size.width,
            decoration: const BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Colors.grey, blurRadius: 25.0, offset: Offset(0, -10))
            ]),
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                      child: Column(
                        children: [
                          const Text(
                            'NEXT PAYMENT DUE',
                            style: DashboardNormalTextStyle,
                          ),
                          loanTenure.status == 'pending'
                              ? Text('PHP ${ocCy.format(loanTenure.payment)}')
                              : Text(loanTenure.status),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                      child: Column(
                        children: [
                          const Text(
                            'DUE DATE',
                            style: DashboardNormalTextStyle,
                          ),
                          loanTenure.status == 'pending'
                              ? Text(
                                  '${loanTenure.dueDate.month} / ${loanTenure.dueDate.day} / ${loanTenure.dueDate.year}')
                              : Text(loanTenure.status),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                    height: 50,
                    width: 160,
                    child: loanTenure.status == 'pending'
                        ? FutureBuilder<DataLoanPaymentData>(
                            future: DataService.database()
                                .checkLoanPayment(tenure: loanTenure)
                                .first,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final paymentData = snapshot.data!;

                                return ElevatedButton(
                                    onPressed: () {
                                      if (arguments['isOnlinePay'] &&
                                          paymentData.payStatus !=
                                              'processing') {
                                        ShowPayDialog(
                                                context: context,
                                                loanData: arguments['loanInfo']
                                                    as DataLoan,
                                                tenure: loanTenure)
                                            .showPaymentDialog()
                                            .then((value) {
                                          if (value == true) {
                                            ShowAlertDialog(
                                                    context: context,
                                                    title: 'Payment Successful',
                                                    body:
                                                        'Your payment is now processing',
                                                    btnName: 'Close')
                                                .showAlertDialog();
                                          }
                                        });
                                      } else if (paymentData.payStatus ==
                                          'processing') {
                                        ShowAlertDialog(
                                                context: context,
                                                title: 'STATUS',
                                                body:
                                                    'Your payment is currently on process.',
                                                btnName: 'Close')
                                            .showAlertDialog();
                                      } else {
                                        ShowAlertDialog(
                                                context: context,
                                                title: 'Ops, Sorry',
                                                body:
                                                    'Your coop currently not accepting online payment.',
                                                btnName: 'Close')
                                            .showAlertDialog();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            arguments['isOnlinePay']
                                                ? Colors.teal[600]
                                                : Colors.grey,
                                        shape: const StadiumBorder()),
                                    child: Text(paymentData.payStatus));
                              } else if (snapshot.hasError) {
                                return ElevatedButton(
                                    onPressed: () {
                                      print(arguments['isOnlinePay']);
                                      if (arguments['isOnlinePay']) {
                                        ShowPayDialog(
                                                context: context,
                                                loanData: arguments['loanInfo']
                                                    as DataLoan,
                                                tenure: loanTenure)
                                            .showPaymentDialog()
                                            .then((value) {
                                          if (value == true) {
                                            ShowAlertDialog(
                                                    context: context,
                                                    title: 'Payment Successful',
                                                    body:
                                                        'Your payment is now processing',
                                                    btnName: 'Close')
                                                .showAlertDialog();
                                          }
                                        });
                                      } else {
                                        ShowAlertDialog(
                                                context: context,
                                                title: 'Ops, Sorry',
                                                body:
                                                    'Your coop currently not accepting online payment.',
                                                btnName: 'Close')
                                            .showAlertDialog();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            arguments['isOnlinePay']
                                                ? Colors.teal[600]
                                                : Colors.grey,
                                        shape: const StadiumBorder()),
                                    child: const Text('Pay'));
                              } else {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                            })
                        : null),
              ),
              StreamBuilder<List<DataLoanTypes>>(
                stream: DataService.database().readLoanTypeAvailable(
                    coopId: (arguments['loanInfo'] as DataLoan).coopId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final loanTypes = snapshot.data!;

                    // return SizedBox(
                    //     height: size.height * 0.5,
                    //     width: size.width,
                    //     child: ListView.builder(
                    //       scrollDirection: Axis.vertical,
                    //       itemCount: notif.length,
                    //       itemBuilder: (context, index) =>
                    //           paymentSchedule(notif[index]),
                    //     ));

                    return SizedBox(
                      height: size.height * 0.3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CarouselSlider.builder(
                            options: CarouselOptions(
                              height: size.height * 0.2,
                              enableInfiniteScroll: false,
                              reverse: false,
                              onPageChanged: (index, reason) =>
                                  setState(() => activeIndex = index),
                            ),
                            itemCount: loanTypes.length,
                            itemBuilder: (context, index, realIndex) {
                              final loan = loanTypes[index];

                              return buildCard(
                                  loan,
                                  index,
                                  (arguments['loanInfo'] as DataLoan).coopId,
                                  (arguments['loanInfo'] as DataLoan).userId);
                            },
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          buildIndicator(loanTypes.length)
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text(
                        'there is something error!carousel ${snapshot.error.toString()}');
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ],
          ),
          Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_month),
                  Text('Payment Schedule')
                ],
              ),
              StreamBuilder<List<DataLoanTenure>>(
                stream: DataService.database().readAllLoanTenure(
                    loanId: (arguments['loanInfo'] as DataLoan).loanId,
                    coopId: (arguments['loanInfo'] as DataLoan).coopId,
                    userId: (arguments['loanInfo'] as DataLoan).userId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final tenure = snapshot.data!;

                    // return SizedBox(
                    //     height: size.height * 0.5,
                    //     width: size.width,
                    //     child: ListView.builder(
                    //       scrollDirection: Axis.vertical,
                    //       itemCount: notif.length,
                    //       itemBuilder: (context, index) =>
                    //           paymentSchedule(notif[index]),
                    //     ));

                    return SizedBox(
                      child: SingleChildScrollView(
                        child: FittedBox(
                          child: DataTable(columns: const [
                            DataColumn(label: Text('Month')),
                            DataColumn(label: Text('Recommended Pay Data')),
                            DataColumn(label: Text('Amount Due')),
                          ], rows: paymentRow(tenure)),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text(
                        'there is something error! ${snapshot.error.toString()}');
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget paymentSchedule(DataLoanTenure loanTenure) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/coop/loanview/',
          arguments: {
            'loanId': loanTenure.loanId,
            'coopId': loanTenure.coopId,
            'userId': loanTenure.userId
          },
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(loanTenure.month.toString()),
              Text(
                  '${loanTenure.dueDate.month}/${loanTenure.dueDate.day}/${loanTenure.dueDate.year}'),
              Text('PHP ${ocCy.format(loanTenure.amountPayable.toDouble())}')
            ],
          ),
          const Divider(
            thickness: 1,
            color: Color.fromRGBO(0, 0, 0, 0.8),
          ),
        ],
      ),
    );
  }

  List<DataRow> paymentRow(List<DataLoanTenure> tenure) {
    final ocCy =
        NumberFormat.currency(decimalDigits: 2, customPattern: '#,###,###.00');
    List<DataRow> newList = tenure
        .map((e) => DataRow(cells: [
              DataCell(Center(
                  child: Row(
                children: [
                  e.status == 'paid'
                      ? const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        )
                      : const Icon(
                          Icons.check_circle,
                          color: Colors.grey,
                        ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(e.month.toString()),
                  ),
                ],
              ))),
              DataCell(Center(
                child: Text(
                    '${e.dueDate.month} / ${e.dueDate.day} / ${e.dueDate.year}'),
              )),
              DataCell(Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text('PHP ${ocCy.format(e.payment.toDouble())}'),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            '/coop/loanview/',
                            arguments: {'tenureData': e},
                          );
                        },
                        icon: const Icon(Icons.info_outline))
                  ],
                ),
              ))
            ]))
        .toList();

    return newList;
  }

  Widget buildCard(
      DataLoanTypes? loanTypes, int index, String coopId, String userId) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      color: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(child: Text(loanTypes!.loanName)),
            Center(
                child: Text(
                    'Interest Rate:  ${((loanTypes.interest * 100) * loanTypes.loanMonths).round()}%')),
            Center(
                child: loanTypes.loanMonths % 12 == 0
                    ? const Text('Per Anom')
                    : Text('Per ${loanTypes.loanMonths}')),
            FutureBuilder<double>(
              future: DataService.database()
                  .getCapitalShare(coopId: coopId, userId: userId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final accData = snapshot.data!;

                  // return SizedBox(
                  //     height: size.height * 0.5,
                  //     width: size.width,
                  //     child: ListView.builder(
                  //       scrollDirection: Axis.vertical,
                  //       itemCount: notif.length,
                  //       itemBuilder: (context, index) =>
                  //           paymentSchedule(notif[index]),
                  //     ));

                  return Center(
                    child: Text(
                        'Loan Up to: Php${ocCy.format(accData.toDouble() * loanTypes.loanBasedValue)}'),
                  );
                } else if (snapshot.hasError) {
                  return Text(
                      'there is something error! buildcar ${snapshot.error.toString()}');
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height: 20,
                      width: 80,
                      child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal[600],
                              shape: const StadiumBorder()),
                          child: const Text('Apply'))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildIndicator(int count) => AnimatedSmoothIndicator(
      effect: const WormEffect(activeDotColor: Color.fromRGBO(0, 137, 123, 1)),
      activeIndex: activeIndex,
      count: count);
}
