import 'package:ascoop/services/database/data_loan_tenure.dart';
import 'package:ascoop/style.dart';
import 'package:ascoop/widgets/calendar_widget.dart';
import 'package:flutter/material.dart';

class LoanView extends StatefulWidget {
  const LoanView({super.key});

  @override
  State<LoanView> createState() => _LoanViewState();
}

class _LoanViewState extends State<LoanView> {
  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    Size size = MediaQuery.of(context).size;
    double screenWidth = size.width;

    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.black,
          ),
          title: const Text(
            'Loan',
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
        body: buildLoan(size, arguments));
  }

  Widget buildLoan(Size size, Map<dynamic, dynamic> arguments) {
    double screenHeight = size.height;
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                      image: AssetImage('assets/images/darker_wallpaper.jpg'),
                      fit: BoxFit.fill)),
              child: Container(
                padding: EdgeInsets.all(screenHeight * 0.02),
                margin: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                    color: Color.fromARGB(153, 237, 241, 242),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text('Your loan ID:'),
                    ),
                    Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 32, 207, 208),
                            border: Border.all(color: Colors.black26)),
                        child: Text(
                          (arguments['tenureData'] as DataLoanTenure).loanId,
                          style: const TextStyle(color: Colors.white),
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white54,
                          border: Border.all(color: Colors.black26)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Payment Method:'),
                              Text('Amount Due:'),
                              Text('Month Interest:')
                            ],
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text((arguments['tenureData'] as DataLoanTenure)
                                    .payMethod!),
                                Text(
                                  (arguments['tenureData'] as DataLoanTenure)
                                      .amountPayable
                                      .toString(),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text((arguments['tenureData'] as DataLoanTenure)
                                    .monthInterest
                                    .toString())
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 32, 207, 208),
                          border: Border.all(color: Colors.black26)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Paid:',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                'Total Running Balance:',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                  (arguments['tenureData'] as DataLoanTenure)
                                      .payment
                                      .toString(),
                                  style: const TextStyle(color: Colors.green)),
                              Text(
                                (((arguments['tenureData'] as DataLoanTenure)
                                                .amountPayable +
                                            (arguments['tenureData']
                                                    as DataLoanTenure)
                                                .monthInterest) -
                                        (arguments['tenureData']
                                                as DataLoanTenure)
                                            .payment)
                                    .toString(),
                                style: const TextStyle(color: Colors.red),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white54,
                          border: Border.all(color: Colors.black26)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: Text('Status:'),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: Text('Month #:'),
                              ),
                            ],
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                (arguments['tenureData'] as DataLoanTenure)
                                            .status ==
                                        'paid'
                                    ? Container(
                                        padding: const EdgeInsets.all(5),
                                        color: Colors.green,
                                        child: Text(
                                          (arguments['tenureData']
                                                  as DataLoanTenure)
                                              .status,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ))
                                    : Container(
                                        padding: const EdgeInsets.all(5),
                                        color: Colors.red,
                                        child: Text(
                                          (arguments['tenureData']
                                                  as DataLoanTenure)
                                              .status,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        )),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                    padding: const EdgeInsets.all(5),
                                    color:
                                        const Color.fromARGB(255, 32, 207, 208),
                                    child: Text(
                                      'Month ${(arguments['tenureData'] as DataLoanTenure).month}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 32, 207, 208),
                            border: Border.all(color: Colors.transparent)),
                        child: (arguments['tenureData'] as DataLoanTenure)
                                    .payDate !=
                                null
                            ? const Center(
                                child: Text(
                                  'Paid Date',
                                  style: LoanDateText,
                                ),
                              )
                            : const Center(
                                child: Text('Due Date', style: LoanDateText),
                              )),
                    Flexible(
                      fit: FlexFit.tight,
                      child: SizedBox(
                          height: screenHeight * 0.4,
                          child: CalendarWidget(
                            initialDate: (arguments['tenureData']
                                            as DataLoanTenure)
                                        .payDate !=
                                    null
                                ? (arguments['tenureData'] as DataLoanTenure)
                                    .payDate!
                                : (arguments['tenureData'] as DataLoanTenure)
                                    .dueDate,
                          )),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
