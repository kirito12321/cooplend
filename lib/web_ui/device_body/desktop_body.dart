
import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/controllers/viewcontroller.dart';
import 'package:flutter/material.dart';

class DesktopDash extends StatefulWidget {
  const DesktopDash({super.key});

  @override
  State<DesktopDash> createState() => _DesktopDashState();
}

class _DesktopDashState extends State<DesktopDash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            myDrawer,
            Expanded(
              child: ScrollConfiguration(
                behavior: MyCustomScrollBehavior(),
                child: const SingleChildScrollView(
                  child: DashView(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DesktopSubs extends StatefulWidget {
  const DesktopSubs({super.key});

  @override
  State<DesktopSubs> createState() => _DesktopSubsState();
}

class _DesktopSubsState extends State<DesktopSubs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            myDrawer,
            const Expanded(
              child: SubView(),
            ),
          ],
        ),
      ),
    );
  }
}

class DesktopLoans extends StatefulWidget {
  const DesktopLoans({super.key});

  @override
  State<DesktopLoans> createState() => _DesktopLoansState();
}

class _DesktopLoansState extends State<DesktopLoans> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            myDrawer,
            const Expanded(
              child: LoanMgtView(),
            ),
          ],
        ),
      ),
    );
  }
}

class DesktopPayments extends StatefulWidget {
  const DesktopPayments({super.key});

  @override
  State<DesktopPayments> createState() => _DesktopPaymentsState();
}

class _DesktopPaymentsState extends State<DesktopPayments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            myDrawer,
            const Expanded(
              child: PaymentMgtView(),
            ),
          ],
        ),
      ),
    );
  }
}

class DesktopStaff extends StatefulWidget {
  const DesktopStaff({super.key});

  @override
  State<DesktopStaff> createState() => _DesktopStaffState();
}

class _DesktopStaffState extends State<DesktopStaff> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            myDrawer,
            const Expanded(
              child: StaffMgtView(),
            ),
          ],
        ),
      ),
    );
  }
}

class DesktopNotif extends StatefulWidget {
  const DesktopNotif({super.key});

  @override
  State<DesktopNotif> createState() => _DesktopNotifState();
}

class _DesktopNotifState extends State<DesktopNotif> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            myDrawer,
            const Expanded(
              child: NotifMgtView(),
            ),
          ],
        ),
      ),
    );
  }
}

class DesktopConfirm extends StatefulWidget {
  const DesktopConfirm({super.key});

  @override
  State<DesktopConfirm> createState() => _DesktopConfirmState();
}

class _DesktopConfirmState extends State<DesktopConfirm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            myDrawer,
            const Expanded(
              child: ConfMgtView(),
            ),
          ],
        ),
      ),
    );
  }
}

class DesktopDeposit extends StatefulWidget {
  const DesktopDeposit({super.key});

  @override
  State<DesktopDeposit> createState() => _DesktopDepositState();
}

class _DesktopDepositState extends State<DesktopDeposit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            myDrawer,
            const Expanded(
              child: DepositMgtView(),
            ),
          ],
        ),
      ),
    );
  }
}

// class DesktopLoanMgt extends StatefulWidget {
//   const DesktopLoanMgt({super.key});

//   @override
//   State<DesktopLoanMgt> createState() => _DesktopLoanMgtState();
// }

// class _DesktopLoanMgtState extends State<DesktopLoanMgt> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Container(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             myDrawer,
//             Expanded(
//               child: Stack(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.only(top: 15, left: 15),
//                     height: double.infinity,
//                     width: MediaQuery.of(context).size.width,
//                     child: const LoanMgtView(),
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class DesktopStaffs extends StatefulWidget {
//   const DesktopStaffs({super.key});

//   @override
//   State<DesktopStaffs> createState() => _DesktopStaffsState();
// }

// class _DesktopStaffsState extends State<DesktopStaffs> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Container(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             myDrawer,
//             Expanded(
//               child: Stack(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.only(top: 15, left: 15),
//                     height: double.infinity,
//                     width: MediaQuery.of(context).size.width,
//                     child: const StaffView(),
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class DesktopPaymentMgt extends StatefulWidget {
//   const DesktopPaymentMgt({super.key});

//   @override
//   State<DesktopPaymentMgt> createState() => _DesktopPaymentMgtState();
// }

// class _DesktopPaymentMgtState extends State<DesktopPaymentMgt> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SizedBox(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             myDrawer,
//             Expanded(
//               child: Stack(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.only(top: 15, left: 15),
//                     height: double.infinity,
//                     width: MediaQuery.of(context).size.width,
//                     child: const PaymentMgtView(),
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class DesktopNotifMgt extends StatefulWidget {
//   const DesktopNotifMgt({super.key});

//   @override
//   State<DesktopNotifMgt> createState() => _DesktopNotifMgtState();
// }

// class _DesktopNotifMgtState extends State<DesktopNotifMgt> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SizedBox(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             myDrawer,
//             Expanded(
//               child: Stack(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.only(top: 15, left: 15),
//                     height: double.infinity,
//                     width: MediaQuery.of(context).size.width,
//                     child: const NotifMgtView(),
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
