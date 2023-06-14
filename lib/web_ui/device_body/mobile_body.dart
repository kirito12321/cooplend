import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/controllers/viewcontroller.dart';
import 'package:flutter/material.dart';

class MobileDash extends StatefulWidget {
  const MobileDash({super.key});

  @override
  State<MobileDash> createState() => _MobileDashState();
}

class _MobileDashState extends State<MobileDash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppbar,
      drawer: myDrawer,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const DashView(),
      ),
    );
  }
}

class MobileSub extends StatefulWidget {
  const MobileSub({super.key});

  @override
  State<MobileSub> createState() => _MobileSubState();
}

class _MobileSubState extends State<MobileSub> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppbar,
      drawer: myDrawer,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const SubView(),
      ),
    );
  }
}

class MobileLoanMgt extends StatefulWidget {
  const MobileLoanMgt({super.key});

  @override
  State<MobileLoanMgt> createState() => _MobileLoanMgtState();
}

class _MobileLoanMgtState extends State<MobileLoanMgt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppbar,
      drawer: myDrawer,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const LoanMgtView(),
      ),
    );
  }
}

class MobilePayMgt extends StatefulWidget {
  const MobilePayMgt({super.key});

  @override
  State<MobilePayMgt> createState() => _MobilePayMgtState();
}

class _MobilePayMgtState extends State<MobilePayMgt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppbar,
      drawer: myDrawer,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const PaymentMgtView(),
      ),
    );
  }
}

class MobileStaffMgt extends StatefulWidget {
  const MobileStaffMgt({super.key});

  @override
  State<MobileStaffMgt> createState() => _MobileStaffMgtState();
}

class _MobileStaffMgtState extends State<MobileStaffMgt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppbar,
      drawer: myDrawer,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const StaffMgtView(),
      ),
    );
  }
}

class MobileNotifMgt extends StatefulWidget {
  const MobileNotifMgt({super.key});

  @override
  State<MobileNotifMgt> createState() => _MobileNotifMgtState();
}

class _MobileNotifMgtState extends State<MobileNotifMgt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppbar,
      drawer: myDrawer,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const NotifMgtView(),
      ),
    );
  }
}

class MobileConfMgt extends StatefulWidget {
  const MobileConfMgt({super.key});

  @override
  State<MobileConfMgt> createState() => _MobileConfMgtState();
}

class _MobileConfMgtState extends State<MobileConfMgt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppbar,
      drawer: myDrawer,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const ConfMgtView(),
      ),
    );
  }
}

class MobileDepositMgt extends StatefulWidget {
  const MobileDepositMgt({super.key});

  @override
  State<MobileDepositMgt> createState() => _MobileDepositMgtState();
}

class _MobileDepositMgtState extends State<MobileDepositMgt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppbar,
      drawer: myDrawer,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const DepositMgtView(),
      ),
    );
  }
}
