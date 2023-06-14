import 'package:ascoop/style.dart';
import 'package:ascoop/utilities/show_alert_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({Key? key}) : super(key: key);

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: Column(
    //       children:  [
    //        const Text('Please verify your email.'),
    //        TextButton(onPressed: () async {
    //          final user = FirebaseAuth.instance.currentUser;
    //          user?.sendEmailVerification();
    //        },child: const Text('Send email verification'),),
    //        TextButton(onPressed: () {
    //          Navigator.of(context).pushNamedAndRemoveUntil('/login/', (_) => false);
    //        }, child: const Text('Back'))
    //       ],
    //     ),
    // );
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double screenWidth = size.width;
    return Scaffold(
        appBar: AppBar(
          elevation: 8,
          leading: const BackButton(
            color: Colors.black,
          ),
          title: const Text(
            'Send Verification Code',
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 50,
                          width: 200,
                          child: ElevatedButton(
                              onPressed: () async {
                                try {
                                  final user =
                                      FirebaseAuth.instance.currentUser;
                                  user?.sendEmailVerification().then((value) =>
                                      ShowAlertDialog(
                                              context: context,
                                              title: 'Email Verification',
                                              body:
                                                  'Email verification has been sent',
                                              btnName: 'Okay')
                                          .showAlertDialog()
                                          .then((value) => Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                                  '/login/', (_) => false)));
                                } catch (e) {
                                  print(e.toString());
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal[600],
                                  shape: const StadiumBorder()),
                              child: const Text('Send Verification Code')),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        SizedBox(
                          height: 50,
                          width: 200,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/login/', (_) => false);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal[600],
                                  shape: const StadiumBorder()),
                              child: const Text('Back')),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
