import 'package:ascoop/mobile_ui/dashboard_list_view/dashboard_settings_view.dart';
import 'package:ascoop/services/auth/auth_service.dart';
import 'package:ascoop/services/database/data_service.dart';
import 'package:ascoop/services/database/data_user_notification.dart';
import 'package:ascoop/style.dart';
import 'package:ascoop/mobile_ui/dashboard_list_view/dashboard_cooppage_view.dart';
import 'package:ascoop/mobile_ui/dashboard_list_view/dashboard_homepage_view.dart';
import 'package:ascoop/mobile_ui/dashboard_list_view/dashboard_loanpage_view.dart';
import 'package:ascoop/utilities/show_confirmation_dialog.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';

import 'dashboard_notificationpage_view.dart';
// import 'dart:developer' as devtools show log;

enum MenuAction { logout }

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentTab = 0;
  int? numNotif = 0;
  var screens = [
    const DashboardHome(),
    const LoanPage(),
    const DashboardNotification(),
    const DashboardSettings(),
    const DashboardCoop(),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Widget currentScreen = DashboardHome();
    const selectedColor = Color.fromRGBO(29, 204, 246, 1);
    const unSelectedColor = Colors.white;
    return Scaffold(
      // backgroundColor: const Color.fromARGB(255, 27, 138, 115),
      appBar: AppBar(
        elevation: 8,
        title: const Text(
          'Member Dashboard',
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
      body: screens[currentTab],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            // currentScreen = const DashboardCoop();
            currentTab = 4;
          });
        },
        child: const Image(
          image: AssetImage('assets/images/cooperative.ico'),
          fit: BoxFit.fill,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.teal[600],
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Transform.scale(
                scale: 0.9,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          // currentScreen = const DashboardHome();
                          currentTab = 0;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.home_outlined,
                            color: currentTab == 0
                                ? selectedColor
                                : unSelectedColor,
                          ),
                          Text(
                            'Dashboard',
                            style: TextStyle(
                                color: currentTab == 0
                                    ? selectedColor
                                    : unSelectedColor),
                          )
                        ],
                      ),
                    ),
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          // currentScreen = const LoanPage();
                          currentTab = 1;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.list_alt_outlined,
                            color: currentTab == 1
                                ? selectedColor
                                : unSelectedColor,
                          ),
                          Text(
                            'Loans',
                            style: TextStyle(
                                color: currentTab == 1
                                    ? selectedColor
                                    : unSelectedColor),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Transform.scale(
                scale: 0.9,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          // currentScreen = const DashboardNotification();
                          currentTab = 2;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          StreamBuilder<List<DataUserNotification>>(
                            stream:
                                DataService.database().checkUserUnreadNotif(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final notif = snapshot.data!;
                                return notif.isNotEmpty
                                    ? badges.Badge(
                                        position: badges.BadgePosition.topEnd(),
                                        badgeAnimation:
                                            const badges.BadgeAnimation.fade(
                                                animationDuration: Duration(
                                                    milliseconds: 5000),
                                                loopAnimation: false),
                                        badgeContent: notif.length > 10
                                            ? const Text(
                                                '10+',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            : Text(
                                                notif.length.toString(),
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                        child: Icon(
                                          Icons.notifications_outlined,
                                          color: currentTab == 2
                                              ? selectedColor
                                              : unSelectedColor,
                                        ),
                                      )
                                    : Icon(
                                        Icons.notifications_outlined,
                                        color: currentTab == 2
                                            ? selectedColor
                                            : unSelectedColor,
                                      );
                              } else if (snapshot.hasError) {
                                return Text(
                                    'there is something error! ${snapshot.hasError.toString()}');
                              } else {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          ),
                          // numNotif != null && numNotif != 0
                          //     ? Badge(
                          //         position: BadgePosition.topEnd(),
                          //         animationDuration:
                          //             const Duration(milliseconds: 5000),
                          //         animationType: BadgeAnimationType.slide,
                          //         badgeContent: Text(
                          //           numNotif.toString(),
                          //           style: const TextStyle(color: Colors.white),
                          //         ),
                          //         child: Icon(
                          //           Icons.notifications_outlined,
                          //           color: currentTab == 2
                          //               ? selectedColor
                          //               : unSelectedColor,
                          //         ),
                          //       )
                          //     : Icon(
                          //         Icons.notifications_outlined,
                          //         color: currentTab == 2
                          //             ? selectedColor
                          //             : unSelectedColor,
                          //       ),
                          Text(
                            'Notifications',
                            style: TextStyle(
                                color: currentTab == 2
                                    ? selectedColor
                                    : unSelectedColor),
                          )
                        ],
                      ),
                    ),
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        ShowConfirmationDialog(
                                context: context,
                                title: 'Logout Confirmation',
                                body: 'Are you sure you want to logout?',
                                fBtnName: 'Yes',
                                sBtnName: 'No')
                            .showConfirmationDialog()
                            .then((value) {
                          if (value!) {
                            AuthService.firebase().logOut().then((value) =>
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/login/', (route) => false));
                          }
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout_outlined,
                              color: currentTab == 3
                                  ? selectedColor
                                  : unSelectedColor),
                          Text(
                            'Logout',
                            style: TextStyle(
                                color: currentTab == 3
                                    ? selectedColor
                                    : unSelectedColor),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
