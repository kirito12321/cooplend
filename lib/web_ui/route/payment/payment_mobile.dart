import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/route/payment/overdue_mob.dart';
import 'package:ascoop/web_ui/route/payment/paid_mob.dart';
import 'package:ascoop/web_ui/route/payment/payment_pc.dart';
import 'package:ascoop/web_ui/route/payment/pending_mob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ascoop/web_ui/global_var.dart' as globals;

class PaymentMgtMobile extends StatefulWidget {
  const PaymentMgtMobile({super.key});

  @override
  State<PaymentMgtMobile> createState() => _PaymentMgtMobileState();
}

class _PaymentMgtMobileState extends State<PaymentMgtMobile> {
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
            title: 'Payment Management',
            icon: FontAwesomeIcons.wallet,
            align: MainAxisAlignment.center,
            widget: const Align(
              alignment: Alignment.center,
              child: PaymentMgtHeader(),
            ),
          ),
          const Expanded(
            child: PayContent(),
          ),
        ],
      ),
    );
  }
}

class PayContent extends StatefulWidget {
  const PayContent({super.key});

  @override
  State<PayContent> createState() => _PayContentState();
}

class _PayContentState extends State<PayContent> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: IndexedStack(
            index: globals.payIndex,
            children: const [
              ListPayPending(),
              ListPayPaid(),
              ListPayOver(),
            ],
          )),
    );
  }
}
