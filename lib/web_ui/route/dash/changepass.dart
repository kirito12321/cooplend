import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:ascoop/web_ui/utils/alertdialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChangePassBtn extends StatefulWidget {
  String email;
  ChangePassBtn({super.key, required this.email});

  @override
  State<ChangePassBtn> createState() => _ChangePassBtnState();
}

class _ChangePassBtnState extends State<ChangePassBtn> {
  var org, npass, cpass;
  @override
  void initState() {
    org = TextEditingController();
    npass = TextEditingController();
    cpass = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    org;
    npass;
    cpass;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        clipBehavior: Clip.hardEdge,
        width: 400,
        height: 350,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Icon(
                  FontAwesomeIcons.unlockKeyhole,
                  size: 20,
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
                Text(
                  'Change Password',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                      fontSize: 18,
                      color: Colors.black),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Divider(
                thickness: 0.3,
                color: grey4,
              ),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: MyCustomScrollBehavior(),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: org,
                        obscureText: true,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 0, 105, 92),
                                width: 2.0,
                              ),
                            ),
                            labelText: 'Current Password',
                            labelStyle: TextStyle(
                                fontFamily: FontNameDefault,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Colors.grey[700],
                                letterSpacing: 1)),
                        style: const TextStyle(
                            fontFamily: FontNameDefault,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.black,
                            letterSpacing: 1),
                      ),
                      const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10)),
                      TextFormField(
                        controller: npass,
                        obscureText: true,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 0, 105, 92),
                                width: 2.0,
                              ),
                            ),
                            labelText: 'New Password',
                            labelStyle: TextStyle(
                                fontFamily: FontNameDefault,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Colors.grey[700],
                                letterSpacing: 1)),
                        style: const TextStyle(
                            fontFamily: FontNameDefault,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.black,
                            letterSpacing: 1),
                      ),
                      const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10)),
                      TextFormField(
                        controller: cpass,
                        obscureText: true,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 0, 105, 92),
                                width: 2.0,
                              ),
                            ),
                            labelText: 'Confirm New Password',
                            labelStyle: TextStyle(
                                fontFamily: FontNameDefault,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Colors.grey[700],
                                letterSpacing: 1)),
                        style: const TextStyle(
                            fontFamily: FontNameDefault,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.black,
                            letterSpacing: 1),
                      ),
                      const Padding(
                          padding: EdgeInsets.symmetric(vertical: 15)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[800],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                            child: const Center(
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  'CANCEL',
                                  style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8)),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal[800],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                            child: const Center(
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  'CONFIRM',
                                  style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                            onPressed: () {
                              late String pass, conpass, newpass;
                              pass = org.text.trim();
                              conpass = cpass.text.trim();
                              newpass = npass.text.trim();
                              if (pass.isNotEmpty &&
                                  conpass.isNotEmpty &&
                                  newpass.isNotEmpty) {
                                if (conpass == newpass) {
                                  FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                          email: widget.email, password: pass)
                                      .then((value) {
                                    FirebaseAuth.instance.currentUser!
                                        .updatePassword(conpass)
                                        .whenComplete(() {
                                      okDialog(
                                        context,
                                        "Change Password Successfully",
                                        "You've successfully changed password.",
                                      ).whenComplete(() {
                                        FirebaseAuth.instance.signOut();
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            '/coop/login',
                                            (route) => false);
                                      });
                                    });
                                  }, onError: (e) {
                                    okDialog(
                                      context,
                                      "Wrong Current Password",
                                      "You entered wrong password.",
                                    );
                                  });
                                } else if (newpass == pass) {
                                  okDialog(
                                    context,
                                    "Repeated Password",
                                    "Your new password is exactly the same as current password.",
                                  );
                                } else {
                                  okDialog(
                                    context,
                                    "Password Not Match",
                                    "Your new password doesn't match with confirm password.",
                                  );
                                }
                              } else {
                                okDialog(
                                  context,
                                  "Empty Field",
                                  "Please fill all textfields.",
                                );
                              }
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
