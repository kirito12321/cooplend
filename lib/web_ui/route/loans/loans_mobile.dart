import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/route/loans/listloan_mob.dart';
import 'package:ascoop/web_ui/route/loans/listloancom_mob.dart';
import 'package:ascoop/web_ui/route/loans/listloanreq_mob.dart';
import 'package:ascoop/web_ui/route/loans/loans_pc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:ascoop/web_ui/global_var.dart' as globals;

class LoanMgtMobile extends StatefulWidget {
  const LoanMgtMobile({super.key});

  @override
  State<LoanMgtMobile> createState() => _LoanMgtMobileState();
}

class _LoanMgtMobileState extends State<LoanMgtMobile> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ContextHeader(
            title: 'Loan Management',
            icon: Feather.credit_card,
            align: MainAxisAlignment.center,
            widget: const Align(
              alignment: Alignment.center,
              child: LoanMgtHeader(),
            ),
          ),
          const Expanded(
            child: LoanContent(),
          ),
        ],
      ),
    );
  }
}

class LoanContent extends StatefulWidget {
  const LoanContent({super.key});

  @override
  State<LoanContent> createState() => _LoanContentState();
}

class _LoanContentState extends State<LoanContent> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: IndexedStack(
            index: globals.loanIndex,
            children: [
              ListLoanAct(),
              ListLoanReq(),
              ListLoanCom(),
            ],
          )),
    );
  }
}
