// ignore_for_file: prefer_const_constructors

import 'package:ascoop/services/database/data_loan.dart';
import 'package:ascoop/services/database/data_service.dart';
// import 'package:ascoop/services/payment/baseclient.dart';
// import 'package:ascoop/services/payment/payment_datamodel.dart';
import 'package:ascoop/utilities/show_alert_dialog.dart';
import 'package:ascoop/utilities/show_loan_details.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

enum Actions { view, details }

class LoanPage extends StatefulWidget {
  const LoanPage({Key? key}) : super(key: key);

  @override
  State<LoanPage> createState() => _LoanPageState();
}

class _LoanPageState extends State<LoanPage> {
  bool isOnlinePay = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final double screenHeight = size.height;
    final double screenWidth = size.width;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Padding(
                padding: EdgeInsets.only(
                    top: screenHeight * 0.04,
                    bottom: screenHeight * 0.04,
                    left: screenWidth * 0.06,
                    right: screenWidth * 0.06),
                child: PhysicalModel(
                  color: Colors.white,
                  elevation: 8,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                        // color: Color.fromARGB(153, 237, 241, 242),
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      children: [
                        Row(
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            Container(
                              height: 11,
                              width: 11,
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Text(
                              "Pending Loans",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),

                        Divider(
                          thickness: 1,
                          color: Color.fromRGBO(0, 0, 0, 0.8),
                        ),

                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            child: StreamBuilder<List<DataLoan>>(
                              stream: DataService.database()
                                  .readAllLoans(status: ['pending', 'process']),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.active &&
                                    snapshot.hasData) {
                                  final loan = snapshot.data!;
                                  return ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: loan.length,
                                      itemBuilder: (context, index) =>
                                          buildLoan(loan[index]));
                                } else if (snapshot.hasError &&
                                    snapshot.connectionState ==
                                        ConnectionState.active) {
                                  return Text(
                                      'No data to display ${snapshot.error.toString()}');
                                } else {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                              },
                            ),
                          ),
                        ),
                        Row(
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            Container(
                              height: 11,
                              width: 11,
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                color: Colors.yellow,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Text(
                              "Active Loans",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),

                        Divider(
                          thickness: 1,
                          color: Color.fromRGBO(0, 0, 0, 0.8),
                        ),

                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            child: StreamBuilder<List<DataLoan>>(
                              stream: DataService.database().readAllLoans(
                                  status: ['active', 'unreceived']),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.active &&
                                    snapshot.hasData) {
                                  final loan = snapshot.data!;
                                  return SlidableAutoCloseBehavior(
                                    closeWhenOpened: true,
                                    child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: loan.length,
                                        itemBuilder: (context, index) =>
                                            Slidable(
                                                endActionPane: ActionPane(
                                                    motion:
                                                        const BehindMotion(),
                                                    children: [
                                                      SlidableAction(
                                                        backgroundColor: Colors
                                                            .yellow.shade300,
                                                        icon: Icons
                                                            .list_alt_outlined,
                                                        label: 'Details',
                                                        onPressed: (context) =>
                                                            _onSelectedAction(
                                                                loan[index],
                                                                Actions
                                                                    .details),
                                                      ),
                                                      SlidableAction(
                                                        backgroundColor: Colors
                                                            .green.shade300,
                                                        icon: Icons
                                                            .money_outlined,
                                                        label: 'View',
                                                        onPressed: (context) =>
                                                            _onSelectedAction(
                                                                loan[index],
                                                                Actions.view),
                                                      ),
                                                    ]),
                                                child: buildLoan(loan[index]))),
                                  );
                                } else if (snapshot.hasError &&
                                    snapshot.connectionState ==
                                        ConnectionState.active) {
                                  return Text(
                                      'No data to display ${snapshot.error.toString()}');
                                } else {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                              },
                            ),
                          ),
                        ),
                        //Only a Space
                        Row(
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            Container(
                              height: 11,
                              width: 11,
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Text(
                              "Completed Loans",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),

                        Divider(
                          thickness: 1,
                          color: Color.fromRGBO(0, 0, 0, 0.8),
                        ),

                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            child: StreamBuilder<List<DataLoan>>(
                              stream: DataService.database()
                                  .readAllLoans(status: ['completed']),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.active &&
                                    snapshot.hasData) {
                                  final loan = snapshot.data!;
                                  return SlidableAutoCloseBehavior(
                                    closeWhenOpened: true,
                                    child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: loan.length,
                                        itemBuilder: (context, index) =>
                                            Slidable(
                                                endActionPane: ActionPane(
                                                    motion:
                                                        const BehindMotion(),
                                                    children: [
                                                      SlidableAction(
                                                        backgroundColor: Colors
                                                            .yellow.shade300,
                                                        icon: Icons
                                                            .list_alt_outlined,
                                                        label: 'Details',
                                                        onPressed: (context) =>
                                                            _onSelectedAction(
                                                                loan[index],
                                                                Actions
                                                                    .details),
                                                      ),
                                                      SlidableAction(
                                                        backgroundColor: Colors
                                                            .green.shade300,
                                                        icon: Icons
                                                            .money_outlined,
                                                        label: 'View',
                                                        onPressed: (context) =>
                                                            _onSelectedAction(
                                                                loan[index],
                                                                Actions.view),
                                                      ),
                                                    ]),
                                                child: buildLoan(loan[index]))),
                                  );
                                } else if (snapshot.hasError &&
                                    snapshot.connectionState ==
                                        ConnectionState.active) {
                                  return Text(
                                      'No data to display on completed loan and the error is ${snapshot.error.toString()}');
                                } else {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                              },
                            ),
                          ),
                        ),
                      ], // Colomn Child End here :)
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onSelectedAction(DataLoan loan, Actions action) {
    switch (action) {
      case Actions.details:
        ShowLoanInfoDialog(context: context, loan: loan).showLoanDataDialog();
        break;
      case Actions.view:
        // _payAction(loan);
        Navigator.of(context).pushNamed(
          // '/coop/loanview/',
          '/coop/loantenureview',
          arguments: {
            'loanId': loan.loanId,
            'coopId': loan.coopId,
            'userId': loan.userId
          },
        );
        break;
    }
  }

  Widget buildLoan(DataLoan loanInfo) => Builder(
        builder: (context) => ListTile(
          leading: ClipOval(
            child: CachedNetworkImage(
              imageUrl: loanInfo.coopProfilePic,
              width: 60.0,
              height: 60.0,
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          title: Text(
            loanInfo.loanId,
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          subtitle: Text('Php ${loanInfo.loanAmount.toString()}'),
          trailing: Icon(Icons.arrow_left_outlined),
          onTap: () {
            checkCoopPayService(loanInfo.coopId);
            // final slidable = Slidable.of(context)!;

            // final isClosed =
            //     slidable.actionPaneType.value == ActionPaneType.none;

            // if (isClosed) {
            //   slidable.openEndActionPane();
            // } else {
            //   slidable.close();
            // }
            if (loanInfo.loanStatus == 'pending') {
              ShowAlertDialog(
                      context: context,
                      title: 'Show this to the coop counter',
                      body: 'Loan code: ${loanInfo.loanId}',
                      btnName: 'Done')
                  .showAlertDialog();
            } else {
              print('this is in loan page: $isOnlinePay');
              Navigator.of(context).pushNamed(
                // '/coop/loanview/',
                '/coop/loantenureview',
                arguments: {'loanInfo': loanInfo, 'isOnlinePay': isOnlinePay},
              );
            }
          },
        ),
      );
  void checkCoopPayService(String coopId) async {
    try {
      await DataService.database()
          .checkCoopOnlinePay(coopId: coopId)
          .then((value) {
        print('this is in checkCoopService function: ${value!.isOnlinePay}');
        setState(() {
          isOnlinePay = value.isOnlinePay;
        });
      });
    } catch (e) {
      print('error in check pay service ${e.toString()}');
    }
  }
}
