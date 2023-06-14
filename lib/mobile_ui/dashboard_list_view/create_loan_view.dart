import 'package:ascoop/services/database/data_coop.dart';
import 'package:ascoop/services/database/data_loan.dart';
import 'package:ascoop/services/database/data_loan_types.dart';
import 'package:ascoop/services/database/data_service.dart';
import 'package:ascoop/services/database/data_user.dart';
import 'package:ascoop/style.dart';
import 'package:ascoop/utilities/show_alert_dialog.dart';
import 'package:ascoop/utilities/show_error_dialog.dart';
import 'package:ascoop/mobile_ui/dashboard_list_view/dashboard_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateLoan extends StatefulWidget {
  final CoopInfo coop;
  final UserInfo user;
  final String loanCode;
  const CreateLoan(
      {required this.coop,
      required this.user,
      required this.loanCode,
      super.key});

  @override
  State<CreateLoan> createState() => _CreateLoanState();
}

class _CreateLoanState extends State<CreateLoan> {
  double noLoanMonthCounted = 0;
  late final String setLoanId;
  late final TextEditingController _loanAmount;
  late final TextEditingController _noMonths;
  String _sampleLoanTypes = '';
  String? _dropDownValue;
  double loanBasedValue = 0.0;
  double capitalShare = 0.0;
  int minMonths = 0;
  bool amountChecker = false;
  bool monthChecker = false;
  final ocCy =
      NumberFormat.currency(decimalDigits: 2, customPattern: '#,###,###.00');

  @override
  void initState() {
    _loanAmount = TextEditingController();
    _noMonths = TextEditingController();
    setLoanId = widget.loanCode;
    super.initState();
  }

  @override
  void dispose() {
    _loanAmount.dispose();
    _noMonths.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double screenWidth = size.width;

    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.black,
          ),
          title: Text(
            widget.coop.coopName,
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
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text('Loan Code:'),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                initialValue:
                                    setLoanId != '' ? setLoanId : '??',
                                textAlign: TextAlign.right,
                                readOnly: true,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    prefixIcon: Align(
                                      widthFactor: 1.0,
                                      heightFactor: 1.0,
                                      child: Icon(Icons.password_sharp),
                                    ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(8)),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              StreamBuilder<List<DataLoanTypes>>(
                                stream: DataService.database()
                                    .readLoanTypeAvailable(
                                        coopId: widget.coop.coopID),
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

                                    return Column(
                                      children: [
                                        DropdownButtonFormField(
                                          items: ddMenuItem(loanTypes),
                                          value: _sampleLoanTypes,
                                          hint: const Text(
                                              'Please Select Loan Types'),
                                          isExpanded: true,
                                          focusColor: Colors.black,
                                          onChanged: (value) {
                                            setState(() {
                                              _dropDownValue = value;
                                            });
                                          },
                                        ),
                                      ],
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text(
                                        'there is something error! ${snapshot.error.toString()}');
                                  } else {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              const Text('Enter Loan Amount:'),
                              const SizedBox(
                                height: 10,
                              ),
                              TextField(
                                controller: _loanAmount,
                                keyboardType: TextInputType.number,
                                enabled: _dropDownValue != null ? true : false,
                                onChanged: (value) {
                                  if (value.length == 0) {
                                    setState(() {
                                      amountChecker = true;
                                    });
                                  } else {
                                    return;
                                  }
                                },
                                decoration: InputDecoration(
                                    hintText:
                                        'PHP ${ocCy.format(capitalShare * loanBasedValue)}',
                                    border: const OutlineInputBorder(),
                                    prefixIcon: const Align(
                                      widthFactor: 1.0,
                                      heightFactor: 1.0,
                                      child: Icon(Icons.money_outlined),
                                    ),
                                    isDense: true,
                                    contentPadding: const EdgeInsets.all(8)),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              const Text('Enter Max No. of months to pay:'),
                              const SizedBox(
                                height: 10,
                              ),
                              TextField(
                                controller: _noMonths,
                                keyboardType: TextInputType.number,
                                enabled: _dropDownValue != null &&
                                        amountChecker != false
                                    ? true
                                    : false,
                                decoration: InputDecoration(
                                    hintText: 'min No. of Months $minMonths',
                                    border: const OutlineInputBorder(),
                                    prefixIcon: const Align(
                                      widthFactor: 1.0,
                                      heightFactor: 1.0,
                                      child:
                                          Icon(Icons.calendar_month_outlined),
                                    ),
                                    isDense: true,
                                    contentPadding: const EdgeInsets.all(8)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 40,
                                      width: 100,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 32, 207, 208),
                                          shape: const StadiumBorder(),
                                        ),
                                        onPressed: () async {
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const Dashboard()),
                                            (route) => false,
                                          );
                                        },
                                        child: const Text('Back'),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    SizedBox(
                                      height: 40,
                                      width: 100,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 32, 207, 208),
                                          shape: const StadiumBorder(),
                                        ),
                                        onPressed: () async {
                                          if ((capitalShare * loanBasedValue) <
                                              double.parse(_loanAmount.text)) {
                                            ShowAlertDialog(
                                                    context: context,
                                                    title: 'Amount Error',
                                                    body:
                                                        'You reached limit amount.',
                                                    btnName: 'Okay')
                                                .showAlertDialog();
                                            return;
                                          }
                                          if (int.parse(_noMonths.text) <
                                              minMonths) {
                                            ShowAlertDialog(
                                                context: context,
                                                title: 'No Months',
                                                body:
                                                    'No should not be less than to the required No. months',
                                                btnName: 'Okay');
                                            return;
                                          }

                                          if (_dropDownValue == '' ||
                                              _dropDownValue == null) {
                                            ShowAlertDialog(
                                                context: context,
                                                title: 'Loan Type',
                                                body: 'Please Select Loan Type',
                                                btnName: 'Okay');
                                            return;
                                          }
                                          try {
                                            final createdAt =
                                                Timestamp.now().toDate();
                                            final loanAmount =
                                                double.parse(_loanAmount.text);
                                            final interest =
                                                widget.coop.interest;
                                            final noMonths =
                                                int.parse(_noMonths.text);

                                            final loanReq = DataLoan(
                                                firstName:
                                                    widget.user.firstName,
                                                middleName:
                                                    widget.user.middleName,
                                                lastName: widget.user.lastName,
                                                loanId: setLoanId,
                                                loanAmount: loanAmount,
                                                interest: interest,
                                                noMonths: noMonths,
                                                userId: widget.user.userUID,
                                                coopId: widget.coop.coopID,
                                                createdAt: createdAt,
                                                loanType: _dropDownValue!
                                                    .toLowerCase(),
                                                coopProfilePic:
                                                    widget.coop.profilePic);
                                            await DataService.database()
                                                .createLoan(loan: loanReq)
                                                .then((value) => ShowAlertDialog(
                                                        context: context,
                                                        title: 'Loan Request',
                                                        body:
                                                            'Your Loan request has been submitted',
                                                        btnName: 'Close')
                                                    .showAlertDialog()
                                                    .then((value) =>
                                                        Navigator.of(context)
                                                            .pop()));

                                            // await DataService.database()
                                            //     .createLoan(loan: loanReq)
                                            //     .then((value) =>
                                            //         ShowLoanInfoDialog(
                                            //                 context: context,
                                            //                 coop: widget.coop,
                                            //                 amount: loanAmount,
                                            //                 months: noMonths)
                                            //             .showLoanDataDialog());
                                          } catch (e) {
                                            showErrorDialog(
                                                context, e.toString());
                                          }
                                        },
                                        child: const Text('Loan'),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  List<DropdownMenuItem> ddMenuItem(List<DataLoanTypes> loanTypes) {
    _sampleLoanTypes = loanTypes[0].loanName;
    List<DropdownMenuItem> newList = loanTypes
        .map((e) => DropdownMenuItem(
              value: e.loanName,
              onTap: () {
                getCS();
                setState(() {
                  minMonths = e.loanMonths;
                  loanBasedValue = e.loanBasedValue;
                });
              },
              child: Text(e.loanName),
            ))
        .toList();

    return newList;
  }

  void getCS() async {
    double amount = await DataService.database().getCapitalShare(
        coopId: widget.coop.coopID, userId: widget.user.userUID);

    setState(() {
      capitalShare = amount;
    });
  }
}
