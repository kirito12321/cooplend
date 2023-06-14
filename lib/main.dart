import 'package:ascoop/firebase_options.dart';
import 'package:ascoop/mobile_ui/dashboard_list_view/capital_share_view.dart';
import 'package:ascoop/mobile_ui/dashboard_list_view/dashboard_notification_data_view.dart';
import 'package:ascoop/mobile_ui/dashboard_list_view/dashboard_wallet_view.dart';
import 'package:ascoop/mobile_ui/dashboard_list_view/loan_payment_view.dart';
import 'package:ascoop/mobile_ui/dashboard_list_view/profile_pic.dart';
import 'package:ascoop/mobile_ui/dashboard_list_view/reset_password_status.dart';
import 'package:ascoop/mobile_ui/dashboard_list_view/savings_view.dart';
import 'package:ascoop/mobile_ui/dashboard_list_view/send_verificationcode.dart';
import 'package:ascoop/services/auth/auth_service.dart';
import 'package:ascoop/services/database/data_service.dart';
import 'package:ascoop/mobile_ui/dashboard_list_view/dashboard_update_profile_info.dart';
import 'package:ascoop/mobile_ui/dashboard_list_view/dashboard_view.dart';
import 'package:ascoop/mobile_ui/dashboard_list_view/loan_view.dart';
import 'package:ascoop/services/notification_config.dart';
import 'package:ascoop/web_ui/base.dart';
import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/device_body/desktop_body.dart';
import 'package:ascoop/web_ui/device_body/mobile_body.dart';
import 'package:ascoop/web_ui/lockpage.dart';
import 'package:ascoop/web_ui/login.dart';
// import 'package:ascoop/web_ui/web_dashboard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ascoop/mobile_ui/emailverification_view.dart';
import 'package:ascoop/mobile_ui/loginoption_view.dart';
import 'package:ascoop/mobile_ui/login_view.dart';
import 'package:ascoop/mobile_ui/register_view.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import 'package:ascoop/web_ui/global_var.dart' as globals;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

//**************************************************************************************************************************** */

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await setupFlutterNotifications();
  // showFlutterNotification(message);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print('Handling a background message ${message.messageId}');
  if (message.notification != null) {
    //No need for showing Notification manually.
    //For BackgroundMessages: Firebase automatically sends a Notification.
    //If you call the flutterLocalNotificationsPlugin.show()-Methode for
    //example the Notification will be displayed twice.
  }
  return;
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;
//Create a [IOSNotificationChannel] for heads up notifications

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }

  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  AppleNotification? ios = message.notification?.apple;
  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          // TODO add a proper drawable resource to android, for now using
          //      one that already exists in example app.
          icon: 'launch_background',
        ),
      ),
    );
  } else if (notification != null && ios != null) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(iOS: DarwinNotificationDetails()),
    );
  }
}
//------ If this doesn't work we can use notification_config at lib/services/notification_config.dart

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

//**************************************************************************************************************************** */
Future<void> main() async {
  bool isMobile = (defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.android);
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {
    // TODO: If necessary send token to application server.

    // Note: This callback is fired at each app startup and whenever a new
    // token is generated.
    if (AuthService.firebase().currentUser != null) {
      await DataService.database().updateFCMToken(token: fcmToken);
    }
  }).onError((err) {
    // Error getting token.
  });

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    // showFlutterNotification(message);
    NotificationApi.showNotification(
        title: message.notification!.title, body: message.notification!.body);
    // print('Got a message whilst in the foreground!');
    // print('Message data: ${message.data}');

    // if (message.notification != null) {
    //   print(
    //       'Message also contained a notification: ${message.notification!.title}');
    // }
  });
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  isMobile && !kIsWeb
      ? runApp(MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const _HomeView(),
          debugShowCheckedModeBanner: false,
          routes: {
            //mobile routes
            '/login/': (context) => const LoginView(),
            '/register/': (context) => const RegisterView(),
            '/loginoption/': (context) => const LoginOption(),
            '/dashboard/': (context) => const Dashboard(),
            '/homeview/': (context) => const _HomeView(),
            '/coop/loanview/': (context) => const LoanView(),
            '/coop/loantenureview': (context) => const LoanTenureView(),
            '/user/notificationview/': (context) =>
                const DashboardNotifDataView(),
            '/user/profileinfo/': (context) => const DashboardProfileInfo(),
            '/user/profilepicset/': (context) => const ProfilePicSet(),
            '/user/sendverifCode/': (context) => const SendVFCode(),
            '/user/resetpassawordstatus': (context) =>
                const ResetPasswordStat(),
            '/user/wallet/': (context) => const DashboardWallet(),
            '/user/capitalsharehistory/': (context) =>
                const CapitalShareHistory(),
            '/user/savingshistory/': (context) => const SavingsView(),
            '/user/sendemailverif/': (context) => const EmailVerification()
          },
        ))
      : runApp(MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const _HomeView(),
          debugShowCheckedModeBanner: false,
          routes: {
            //Web Logs
            '/coop/login': (context) => const WebLoginView(),
            '/coop/home': (context) => const ResponsiveBaseLayout(
                  mobileScaffold: WelcomePage(),
                  tabletScaffold: WelcomePage(),
                  desktopScaffold: WelcomePage(),
                ),
            '/dashboard': (context) {
              globals.sidenavsel = [
                true,
                false,
                false,
                false,
                false,
                false,
                false,
                false
              ];
              return const ResponsiveBaseLayout(
                mobileScaffold: MobileDash(),
                tabletScaffold: MobileDash(),
                desktopScaffold: DesktopDash(),
              );
            }, //intro

            //subs
            '/subscribers/active': (context) {
              globals.sidenavsel = [
                false,
                true,
                false,
                false,
                false,
                false,
                false,
                false
              ];
              globals.headnavselsub = [true, false, false];
              globals.subIndex = 0;
              return const ResponsiveBaseLayout(
                  mobileScaffold: MobileSub(),
                  tabletScaffold: MobileSub(),
                  desktopScaffold: DesktopSubs());
            },

            '/subscribers/request': (context) {
              globals.sidenavsel = [
                false,
                true,
                false,
                false,
                false,
                false,
                false,
                false
              ];
              globals.headnavselsub = [false, true, false];
              globals.subIndex = 1;

              late final SharedPreferences prefs;
              late final prefsFuture =
                  SharedPreferences.getInstance().then((v) => prefs = v);
              return FutureBuilder(
                future: prefsFuture,
                builder: (context, pref) {
                  if (pref.hasError) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    switch (pref.connectionState) {
                      case ConnectionState.waiting:
                        return onWait;
                      default:
                        if (pref.data!
                                .getString('myRole')
                                .toString()
                                .toLowerCase() !=
                            'cashier') {
                          return const ResponsiveBaseLayout(
                              mobileScaffold: MobileSub(),
                              tabletScaffold: MobileSub(),
                              desktopScaffold: DesktopSubs());
                        } else {
                          return const LockPage();
                        }
                    }
                  }
                },
              );
            },

            '/subscribers/blocked': (context) {
              globals.sidenavsel = [
                false,
                true,
                false,
                false,
                false,
                false,
                false,
                false
              ];
              globals.headnavselsub = [false, false, true];
              globals.subIndex = 2;

              late final SharedPreferences prefs;
              late final prefsFuture =
                  SharedPreferences.getInstance().then((v) => prefs = v);
              return FutureBuilder(
                future: prefsFuture,
                builder: (context, pref) {
                  if (pref.hasError) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    switch (pref.connectionState) {
                      case ConnectionState.waiting:
                        return onWait;
                      default:
                        if (pref.data!
                                .getString('myRole')
                                .toString()
                                .toLowerCase() !=
                            'cashier') {
                          return const ResponsiveBaseLayout(
                              mobileScaffold: MobileSub(),
                              tabletScaffold: MobileSub(),
                              desktopScaffold: DesktopSubs());
                        } else {
                          return const LockPage();
                        }
                    }
                  }
                },
              );
            },

            '/loans/active': (context) {
              globals.sidenavsel = [
                false,
                false,
                true,
                false,
                false,
                false,
                false,
                false
              ];
              globals.headnavselloan = [true, false, false];
              globals.loanIndex = 0;
              return const ResponsiveBaseLayout(
                  mobileScaffold: MobileLoanMgt(),
                  tabletScaffold: MobileLoanMgt(),
                  desktopScaffold: DesktopLoans());
            },

            '/loans/request': (context) {
              globals.sidenavsel = [
                false,
                false,
                true,
                false,
                false,
                false,
                false,
                false
              ];
              globals.headnavselloan = [false, true, false];
              globals.loanIndex = 1;

              late final SharedPreferences prefs;
              late final prefsFuture =
                  SharedPreferences.getInstance().then((v) => prefs = v);
              return FutureBuilder(
                future: prefsFuture,
                builder: (context, pref) {
                  if (pref.hasError) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    switch (pref.connectionState) {
                      case ConnectionState.waiting:
                        return onWait;
                      default:
                        if (pref.data!
                                .getString('myRole')
                                .toString()
                                .toLowerCase() !=
                            'cashier') {
                          return const ResponsiveBaseLayout(
                              mobileScaffold: MobileLoanMgt(),
                              tabletScaffold: MobileLoanMgt(),
                              desktopScaffold: DesktopLoans());
                        } else {
                          return const LockPage();
                        }
                    }
                  }
                },
              );
            },

            '/loans/complete': (context) {
              globals.sidenavsel = [
                false,
                false,
                true,
                false,
                false,
                false,
                false,
                false
              ];
              globals.headnavselloan = [false, false, true];
              globals.loanIndex = 2;
              return const ResponsiveBaseLayout(
                  mobileScaffold: MobileLoanMgt(),
                  tabletScaffold: MobileLoanMgt(),
                  desktopScaffold: DesktopLoans());
            },

            '/payments/pending': (context) {
              globals.sidenavsel = [
                false,
                false,
                false,
                true,
                false,
                false,
                false,
                false
              ];
              globals.headnavselpay = [true, false, false];
              globals.payIndex = 0;

              late final SharedPreferences prefs;
              late final prefsFuture =
                  SharedPreferences.getInstance().then((v) => prefs = v);
              return FutureBuilder(
                future: prefsFuture,
                builder: (context, pref) {
                  if (pref.hasError) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    switch (pref.connectionState) {
                      case ConnectionState.waiting:
                        return onWait;
                      default:
                        if (pref.data!
                                .getString('myRole')
                                .toString()
                                .toLowerCase() !=
                            'bookkeeper') {
                          return const ResponsiveBaseLayout(
                              mobileScaffold: MobilePayMgt(),
                              tabletScaffold: MobilePayMgt(),
                              desktopScaffold: DesktopPayments());
                        } else {
                          return const LockPage();
                        }
                    }
                  }
                },
              );
            },

            '/payments/paid': (context) {
              globals.sidenavsel = [
                false,
                false,
                false,
                true,
                false,
                false,
                false,
                false
              ];
              globals.headnavselpay = [false, true, false];
              globals.payIndex = 1;
              return const ResponsiveBaseLayout(
                  mobileScaffold: MobilePayMgt(),
                  tabletScaffold: MobilePayMgt(),
                  desktopScaffold: DesktopPayments());
            },

            '/payments/overdue': (context) {
              globals.sidenavsel = [
                false,
                false,
                false,
                true,
                false,
                false,
                false,
                false
              ];
              globals.headnavselpay = [false, false, true];
              globals.payIndex = 2;

              late final SharedPreferences prefs;
              late final prefsFuture =
                  SharedPreferences.getInstance().then((v) => prefs = v);
              return FutureBuilder(
                future: prefsFuture,
                builder: (context, pref) {
                  if (pref.hasError) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    switch (pref.connectionState) {
                      case ConnectionState.waiting:
                        return onWait;
                      default:
                        if (pref.data!
                                .getString('myRole')
                                .toString()
                                .toLowerCase() !=
                            'bookkeeper') {
                          return const ResponsiveBaseLayout(
                              mobileScaffold: MobilePayMgt(),
                              tabletScaffold: MobilePayMgt(),
                              desktopScaffold: DesktopPayments());
                        } else {
                          return const LockPage();
                        }
                    }
                  }
                },
              );
            },

            '/staffs': (context) {
              globals.sidenavsel = [
                false,
                false,
                false,
                false,
                true,
                false,
                false,
                false
              ];
              globals.headnavstaff = [true, false];
              globals.staffIndex = 0;

              late final SharedPreferences prefs;
              late final prefsFuture =
                  SharedPreferences.getInstance().then((v) => prefs = v);
              return FutureBuilder(
                future: prefsFuture,
                builder: (context, pref) {
                  if (pref.hasError) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    switch (pref.connectionState) {
                      case ConnectionState.waiting:
                        return onWait;
                      default:
                        if (pref.data!
                                .getString('myRole')
                                .toString()
                                .toLowerCase() ==
                            'administrator') {
                          return const ResponsiveBaseLayout(
                              mobileScaffold: MobileStaffMgt(),
                              tabletScaffold: MobileStaffMgt(),
                              desktopScaffold: DesktopStaff());
                        } else {
                          return const LockPage();
                        }
                    }
                  }
                },
              );
            },

            '/staffs/blocked': (context) {
              globals.sidenavsel = [
                false,
                false,
                false,
                false,
                true,
                false,
                false,
                false
              ];
              globals.headnavstaff = [false, true];
              globals.staffIndex = 1;

              late final SharedPreferences prefs;
              late final prefsFuture =
                  SharedPreferences.getInstance().then((v) => prefs = v);
              return FutureBuilder(
                future: prefsFuture,
                builder: (context, pref) {
                  if (pref.hasError) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    switch (pref.connectionState) {
                      case ConnectionState.waiting:
                        return onWait;
                      default:
                        if (pref.data!
                                .getString('myRole')
                                .toString()
                                .toLowerCase() ==
                            'administrator') {
                          return const ResponsiveBaseLayout(
                              mobileScaffold: MobileStaffMgt(),
                              tabletScaffold: MobileStaffMgt(),
                              desktopScaffold: DesktopStaff());
                        } else {
                          return const LockPage();
                        }
                    }
                  }
                },
              );
            },

            '/notifications': (context) {
              globals.sidenavsel = [
                false,
                false,
                false,
                false,
                false,
                false,
                true,
                false
              ];
              globals.headnavselnotif = [true, false];
              globals.notifIndex = 0;
              return const ResponsiveBaseLayout(
                  mobileScaffold: MobileNotifMgt(),
                  tabletScaffold: MobileNotifMgt(),
                  desktopScaffold: DesktopNotif());
            },

            '/notifications/confirmation': (context) {
              globals.sidenavsel = [
                false,
                false,
                false,
                false,
                false,
                false,
                true,
                false
              ];
              globals.headnavselnotif = [false, true];
              globals.notifIndex = 1;

              late final SharedPreferences prefs;
              late final prefsFuture =
                  SharedPreferences.getInstance().then((v) => prefs = v);
              return FutureBuilder(
                future: prefsFuture,
                builder: (context, pref) {
                  if (pref.hasError) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    switch (pref.connectionState) {
                      case ConnectionState.waiting:
                        return onWait;
                      default:
                        if (pref.data!
                                .getString('myRole')
                                .toString()
                                .toLowerCase() ==
                            'administrator') {
                          return const ResponsiveBaseLayout(
                              mobileScaffold: MobileConfMgt(),
                              tabletScaffold: MobileConfMgt(),
                              desktopScaffold: DesktopConfirm());
                        } else {
                          return const LockPage();
                        }
                    }
                  }
                },
              );
            },

            '/deposit/capitalshare': (context) {
              globals.sidenavsel = [
                false,
                false,
                false,
                false,
                false,
                false,
                false,
                true,
              ];
              globals.headnavseldeposit = [true, false];
              globals.depIndex = 0;
              return const ResponsiveBaseLayout(
                  mobileScaffold: MobileDepositMgt(),
                  tabletScaffold: MobileDepositMgt(),
                  desktopScaffold: DesktopDeposit());
            },

            '/deposit/savings': (context) {
              globals.sidenavsel = [
                false,
                false,
                false,
                false,
                false,
                false,
                false,
                true,
              ];
              globals.headnavseldeposit = [false, true];
              globals.depIndex = 1;
              return const ResponsiveBaseLayout(
                  mobileScaffold: MobileDepositMgt(),
                  tabletScaffold: MobileDepositMgt(),
                  desktopScaffold: DesktopDeposit());
            },
          },
        ));
}

class _HomeView extends StatefulWidget {
  const _HomeView({Key? key}) : super(key: key);

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  // String? _token;
  String? initialMessage;
  // bool _resolved = false;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();

    FirebaseMessaging.instance.getInitialMessage().then(
          (value) => setState(
            () {
              // _resolved = true;
              initialMessage = value?.data.toString();
            },
          ),
        );

    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {

    // });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
          'A new onMessageOpenedApp event was published!: ${message.data['notifID']}');
      // Navigator.pushNamed(
      //   context,
      //   '/message',
      //   arguments: MessageArguments(message, true),
      // );
      if (message.data['notifID'] != null) {
        DataService.database()
            .updateNotifStatus(notifID: message.data['notifID'])
            .then((value) => Navigator.of(context).pushNamed(
                  '/user/notificationview/',
                  arguments: {
                    'notifImageUrl': '',
                    'notifTitle': message.notification!.title ?? 'No Title',
                    'notifText': message.notification!.body ?? 'No Subtitle'
                  },
                ));
      } else {
        return;
      }
    });
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // bool isDesktop = (defaultTargetPlatform == TargetPlatform.linux ||
    //     defaultTargetPlatform == TargetPlatform.macOS ||
    //     defaultTargetPlatform == TargetPlatform.windows);
    bool isMobile = (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android);
    return isMobile && !kIsWeb ? mobileUI() : desktopUI();
  }

  void sendFCMtoken() async {
    final token = await FirebaseMessaging.instance.getToken();

    if (token != null) {
      await DataService.database().checkFCMToken(token: token);
    }
  }

  Widget mobileUI() => FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = AuthService.firebase().currentUser;

              if (user != null) {
                FlutterNativeSplash.remove();
                // sendFCMtoken();
                if (user.isEmailVerified) {
                  //for user notification ID

                  //for splash to remove
                  sendFCMtoken();
                  return const Dashboard();
                } else {
                  FlutterNativeSplash.remove();
                  return const EmailVerification();
                }
              } else {
                FlutterNativeSplash.remove();
                return const LoginView();
              }

            default:
              return const CircularProgressIndicator();
          }
        },
      );

  Widget desktopUI() => FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = AuthService.firebase().currentUser;

              if (user != null) {
                //for splash to remove
                FlutterNativeSplash.remove();
                return const WebLoginView();
              } else {
                //for splash to remove
                FlutterNativeSplash.remove();
                return const ResponsiveBaseLayout(
                  mobileScaffold: DesktopDash(),
                  tabletScaffold: DesktopDash(),
                  desktopScaffold: DesktopDash(),
                );
              }

            default:
              return const CircularProgressIndicator();
          }
        },
      );
}
