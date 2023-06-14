import 'dart:math';

import 'package:ascoop/services/database/data_coop.dart';
import 'package:ascoop/services/database/data_service.dart';
import 'package:ascoop/services/database/data_subscription.dart';
import 'package:ascoop/services/database/data_user.dart';
import 'package:ascoop/style.dart';
import 'package:ascoop/mobile_ui/dashboard_list_view/create_loan_view.dart';
import 'package:ascoop/mobile_ui/dashboard_list_view/dashboard_subscription_step.dart';
import 'package:flutter/material.dart';

class CoopProfile extends StatefulWidget {
  final String coopID;
  const CoopProfile({required this.coopID, super.key});

  @override
  State<CoopProfile> createState() => _CoopProfileState();
}

class _CoopProfileState extends State<CoopProfile> {
  bool isSuccess = false;
  String sendLoanCode = '';

  @override
  void initState() {
    loanCodeGenerator(5);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder<CoopInfo?>(
      future: DataService.database().readCoopData(coopID: widget.coopID),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final coop = snapshot.data;
          return coop == null
              ? const Text('No Data')
              : buildCoopProf(coop, size);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget buildCoopProf(CoopInfo coop, Size size) {
    double screenHeight = size.height;
    double screenWidth = size.width;
    return Scaffold(
        appBar: AppBar(
          elevation: 8,
          leading: const BackButton(
            color: Colors.black,
          ),
          title: Text(
            coop.coopName,
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(coop.profilePic),
                                  backgroundColor: Colors.transparent,
                                  radius: 50,
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        coop.coopName,
                                        style: TitleTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text(
                                        'Email Address',
                                        style: DashboardNormalTextStyle,
                                      ),
                                      Text(coop.email),
                                      const Text(
                                        'Current Address',
                                        style: DashboardNormalTextStyle,
                                      ),
                                      Text(coop.coopAddress),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      FutureBuilder<UserInfo?>(
                                        future: DataService.database()
                                            .readUserData(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            final user = snapshot.data;

                                            return user == null
                                                ? const Text('No Data')
                                                : checkingSubs(coop, user);
                                          } else {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
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

  Widget checkingSubs(CoopInfo coop, UserInfo user) {
    return FutureBuilder<DataSubscription?>(
        future: DataService.database()
            .readSubscriptions(coopID: coop.coopID, userID: user.userUID),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.status == 'verified') {
            return coopProfileBtn(
                coop,
                user,
                'loan',
                CreateLoan(
                  coop: coop,
                  user: user,
                  loanCode: sendLoanCode,
                ),
                snapshot.data!.status);
          } else if (snapshot.data?.status == 'pending') {
            return coopProfileBtn(
                coop,
                user,
                'applied',
                CoopSubscriptionStep(user: user, coop: coop),
                snapshot.data?.status);
          } else if (snapshot.hasData != true) {
            print(snapshot.error.toString());
            return coopProfileBtn(
                coop,
                user,
                'apply',
                CoopSubscriptionStep(user: user, coop: coop),
                snapshot.data?.status);
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Widget coopProfileBtn(CoopInfo coop, UserInfo user, String text,
          dynamic object, String? status) =>
      SizedBox(
        height: 50,
        width: 200,
        child: Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  status == 'verified' || status != null || isSuccess == true
                      // ? const Color.fromARGB(115, 115, 115, 115)
                      ? const Color.fromARGB(255, 32, 207, 208)
                      : const Color.fromARGB(255, 32, 207, 208),
              shape: const StadiumBorder(),
            ),
            onPressed:
                status == 'verified' || status == null || isSuccess == false
                    ? () async {
                        final data = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => object),
                        );

                        setState(() {
                          isSuccess = data ?? false;
                        });
                      }
                    : () {},
            child: Text(text),
          ),
        ),
      );

  void loanCodeGenerator(int length) async {
    String loanId = '';

    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();

    String getRandomString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
    loanId = getRandomString(length);

    // bool check = await DataService.database().checkLoanCode(loanId: loanId);
    // if (check) {
    //   return loanId;
    // } else {
    bool check = await DataService.database().checkLoanCode(loanId: loanId);
    print(check);
    if (check) {
      return loanCodeGenerator(5);
    } else {
      setState(() {
        sendLoanCode = loanId;
        print(sendLoanCode);
      });
    }

    // }
  }
}
