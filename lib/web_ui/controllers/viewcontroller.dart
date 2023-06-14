import 'package:ascoop/web_ui/route/dash/dash_mobile.dart';
import 'package:ascoop/web_ui/route/dash/dash_pc.dart';
import 'package:ascoop/web_ui/route/deposit/deposit_mobile.dart';
import 'package:ascoop/web_ui/route/deposit/deposit_pc.dart';
import 'package:ascoop/web_ui/route/loans/loans_mobile.dart';
import 'package:ascoop/web_ui/route/loans/loans_pc.dart';
import 'package:ascoop/web_ui/route/notifications/confirmation_mobile.dart';
import 'package:ascoop/web_ui/route/notifications/confirmation_pc.dart';
import 'package:ascoop/web_ui/route/notifications/notif_mobile.dart';
import 'package:ascoop/web_ui/route/notifications/notif_pc.dart';
import 'package:ascoop/web_ui/route/payment/payment_mobile.dart';
import 'package:ascoop/web_ui/route/payment/payment_pc.dart';
import 'package:ascoop/web_ui/route/staff/staff_mob.dart';
import 'package:ascoop/web_ui/route/staff/staff_pc.dart';
import 'package:ascoop/web_ui/route/subs/subs_mobile.dart';
import 'package:ascoop/web_ui/route/subs/subs_pc.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashView extends StatefulWidget {
  const DashView({super.key});

  @override
  State<DashView> createState() => _DashViewState();
}

class _DashViewState extends State<DashView> {
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;

    if (size < 1150) {
      return const DashMobile();
    } else {
      return const DashPc();
    }
  }
}

class SubView extends StatefulWidget {
  const SubView({super.key});

  @override
  State<SubView> createState() => _SubViewState();
}

class _SubViewState extends State<SubView> {
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;

    if (size < 1150) {
      return const SubMobile();
    } else {
      return const SubsPc();
    }
  }
}

class LoanMgtView extends StatefulWidget {
  const LoanMgtView({super.key});

  @override
  State<LoanMgtView> createState() => _LoanMgtViewState();
}

class _LoanMgtViewState extends State<LoanMgtView> {
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;

    if (size < 1150) {
      return const LoanMgtMobile();
    } else {
      return const LoanMgtPc();
    }
  }
}

class PaymentMgtView extends StatefulWidget {
  const PaymentMgtView({super.key});

  @override
  State<PaymentMgtView> createState() => _PaymentMgtViewState();
}

class _PaymentMgtViewState extends State<PaymentMgtView> {
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;

    if (size < 1150) {
      return const PaymentMgtMobile();
    } else {
      return const PaymentMgtPc();
    }
  }
}

class StaffMgtView extends StatefulWidget {
  const StaffMgtView({super.key});

  @override
  State<StaffMgtView> createState() => _StaffMgtViewState();
}

class _StaffMgtViewState extends State<StaffMgtView> {
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;

    if (size < 1150) {
      return const StaffMgtMobile();
    } else {
      return const StaffMgtPc();
    }
  }
}

class NotifMgtView extends StatefulWidget {
  const NotifMgtView({super.key});

  @override
  State<NotifMgtView> createState() => _NotifMgtViewState();
}

class _NotifMgtViewState extends State<NotifMgtView> {
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;

    if (size < 1150) {
      return const NotifMgtMobile();
    } else {
      return const NotifMgtPc();
    }
  }
}

class ConfMgtView extends StatefulWidget {
  const ConfMgtView({super.key});

  @override
  State<ConfMgtView> createState() => _ConfMgtViewState();
}

class _ConfMgtViewState extends State<ConfMgtView> {
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;

    if (size < 1150) {
      return const ConfMgtMobile();
    } else {
      return const ConfirmMgtPc();
    }
  }
}

class DepositMgtView extends StatefulWidget {
  const DepositMgtView({super.key});

  @override
  State<DepositMgtView> createState() => _DepositMgtViewState();
}

class _DepositMgtViewState extends State<DepositMgtView> {
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;

    if (size < 1150) {
      return const DepositMgtMobile();
    } else {
      return const DepositMgtPc();
    }
  }
}
