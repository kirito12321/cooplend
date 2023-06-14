// ignore_for_file: use_build_context_synchronously, camel_case_types

import 'dart:developer';

import 'package:ascoop/web_ui/base.dart';
import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/controllers/getInfo.dart';
import 'package:ascoop/web_ui/device_body/desktop_body.dart';
import 'package:ascoop/web_ui/styles/buttonstyle.dart';
import 'package:ascoop/web_ui/styles/inputstyle.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:ascoop/web_ui/utils/alertdialog.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

// import 'dart:developer' as devtools show log;

class WebLoginView extends StatefulWidget {
  const WebLoginView({Key? key}) : super(key: key);

  @override
  State<WebLoginView> createState() => _WebLoginViewState();
}

class _WebLoginViewState extends State<WebLoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool _obscure = true;
  FocusNode myFocusNode = FocusNode();
  String email = "";
  String pass = "";
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser?.uid != null
        ? const ResponsiveBaseLayout(
            mobileScaffold: DesktopDash(),
            tabletScaffold: DesktopDash(),
            desktopScaffold: DesktopDash(),
          )
        : Scaffold(
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Colors.teal[500],
              ),
              child: Center(
                child: Container(
                  height: 400.0,
                  width: 350.0,
                  padding: const EdgeInsets.all(20.0),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromARGB(255, 174, 171, 171),
                            spreadRadius: 0,
                            blurStyle: BlurStyle.normal,
                            blurRadius: 2.0)
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Center(
                        child: Container(
                          height: 120.0,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/logo_full_coop.png'),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                          child: TextFormField(
                            style: inputTextStyle,
                            keyboardType: TextInputType.emailAddress,
                            controller: _email,

                            // ignore: unnecessary_const
                            decoration: InputDecoration(
                              hintStyle: inputHintTxtStyle,
                              focusedBorder: focusOutlineBorder,
                              border: OutlineBorder,
                              hintText: 'Email Address',
                              prefixIcon: Icon(
                                Feather.mail,
                                size: 20,
                                color: Colors.teal[800],
                              ),
                            ),
                            onFieldSubmitted: (value) {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => AlertDialog(
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    content: onWait),
                              );
                              setState(() {
                                email = _email.text.trim();
                                pass = _password.text.trim();
                              });
                              try {
                                if (email.isNotEmpty && pass.isNotEmpty) {
                                  FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                          email: email, password: pass)
                                      .then((data) {
                                    if (FirebaseAuth.instance.currentUser !=
                                        null) {
                                      FirebaseFirestore.instance
                                          .collection('staffs')
                                          .where('staffID',
                                              isEqualTo: FirebaseAuth
                                                  .instance.currentUser!.uid)
                                          .get()
                                          .then((value) {
                                        if (value.docs[0]['isBlock'] != true) {
                                          setState(() {
                                            getStaffCoopInfo();
                                          });
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                                  '/dashboard',
                                                  (route) => false);
                                          Navigator.pop(context);
                                          Navigator.pushNamed(
                                              context, '/coop/home');
                                        } else {
                                          FirebaseAuth.instance.signOut();
                                          okDialog(
                                            context,
                                            "Blocked Account",
                                            "Your account has been disable by the Administrator.",
                                          ).whenComplete(
                                              () => Navigator.pop(context));
                                        }
                                      }, onError: (e) {
                                        log('Login (staffs documentsnapshot) error: ${e.toString()}');
                                        okDialog(
                                          context,
                                          "Wrong Email or Password",
                                          "You entered wrong email or password.",
                                        ).whenComplete(
                                            () => Navigator.pop(context));
                                      });
                                    }
                                  }, onError: (e) {
                                    okDialog(
                                      context,
                                      "Invalid Credintials",
                                      "Invalid email or password.",
                                    ).whenComplete(
                                        () => Navigator.pop(context));
                                  });
                                } else {
                                  okDialog(
                                    context,
                                    "Empty Field",
                                    "Please fill all textfields.",
                                  ).whenComplete(() => Navigator.pop(context));
                                }
                              } catch (e) {
                                log('LOGIN (login.dart) error: ${e.toString()}');
                              }
                            },
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                          child: TextFormField(
                            style: inputTextStyle,
                            obscureText: _obscure,
                            enableSuggestions: false,
                            autocorrect: false,
                            controller: _password,
                            // ignore: unnecessary_const
                            decoration: InputDecoration(
                              hintStyle: inputHintTxtStyle,
                              focusedBorder: focusOutlineBorder,
                              border: OutlineBorder,

                              // ignore: prefer_const_constructors
                              hintText: 'Password',
                              prefixIcon: Icon(
                                Feather.lock,
                                size: 20,
                                color: Colors.teal[800],
                              ),
                              suffixIcon: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _obscure = !_obscure;
                                    });
                                  },
                                  child: Icon(
                                    _obscure ? Feather.eye : Feather.eye_off,
                                    size: 20,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                            ),
                            onFieldSubmitted: (value) {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => AlertDialog(
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    content: onWait),
                              );
                              setState(() {
                                email = _email.text.trim();
                                pass = _password.text.trim();
                              });
                              try {
                                if (email.isNotEmpty && pass.isNotEmpty) {
                                  FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                          email: email, password: pass)
                                      .then((data) {
                                    if (FirebaseAuth.instance.currentUser !=
                                        null) {
                                      FirebaseFirestore.instance
                                          .collection('staffs')
                                          .where('staffID',
                                              isEqualTo: FirebaseAuth
                                                  .instance.currentUser!.uid)
                                          .get()
                                          .then((value) {
                                        if (value.docs[0]['isBlock'] != true) {
                                          setState(() {
                                            getStaffCoopInfo();
                                          });
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                                  '/dashboard',
                                                  (route) => false);
                                          Navigator.pop(context);
                                          Navigator.pushNamed(
                                              context, '/coop/home');
                                        } else {
                                          FirebaseAuth.instance.signOut();
                                          okDialog(
                                            context,
                                            "Blocked Account",
                                            "Your account has been disable by the Administrator.",
                                          ).whenComplete(
                                              () => Navigator.pop(context));
                                        }
                                      }, onError: (e) {
                                        log('Login (staffs documentsnapshot) error: ${e.toString()}');
                                        okDialog(
                                          context,
                                          "Wrong Email or Password",
                                          "You entered wrong email or password.",
                                        ).whenComplete(
                                            () => Navigator.pop(context));
                                      });
                                    }
                                  }, onError: (e) {
                                    okDialog(
                                      context,
                                      "Invalid Credintials",
                                      "Invalid email or password.",
                                    ).whenComplete(
                                        () => Navigator.pop(context));
                                  });
                                } else {
                                  okDialog(
                                    context,
                                    "Empty Field",
                                    "Please fill all textfields.",
                                  ).whenComplete(() => Navigator.pop(context));
                                }
                              } catch (e) {
                                log('LOGIN (login.dart) error: ${e.toString()}');
                              }
                            },
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ForgetBtn()),
                          );
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              'Forgot Password',
                              style: btnForgotTxtStyle,
                            ),
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.symmetric(vertical: 6)),
                      Center(
                        child: SizedBox(
                          height: 50.0,
                          width: 320.0,
                          child: ElevatedButton(
                            style: ForTealButton,
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'LOGIN',
                                style: btnLoginTxtStyle,
                              ),
                            ),
                            onPressed: () async {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => AlertDialog(
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    content: onWait),
                              );
                              setState(() {
                                email = _email.text.trim();
                                pass = _password.text.trim();
                              });
                              try {
                                if (email.isNotEmpty && pass.isNotEmpty) {
                                  FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                          email: email, password: pass)
                                      .then((data) {
                                    if (FirebaseAuth.instance.currentUser !=
                                        null) {
                                      FirebaseFirestore.instance
                                          .collection('staffs')
                                          .where('staffID',
                                              isEqualTo: FirebaseAuth
                                                  .instance.currentUser!.uid)
                                          .get()
                                          .then((value) {
                                        if (value.docs[0]['isBlock'] != true) {
                                          setState(() {
                                            getStaffCoopInfo();
                                          });

                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                                  '/dashboard',
                                                  (route) => false);
                                          Navigator.pop(context);
                                          Navigator.pushNamed(
                                              context, '/coop/home');
                                        } else {
                                          FirebaseAuth.instance.signOut();
                                          okDialog(
                                            context,
                                            "Blocked Account",
                                            "Your account has been disable by the Administrator.",
                                          ).whenComplete(
                                              () => Navigator.pop(context));
                                        }
                                      }, onError: (e) {
                                        log('Login (staffs documentsnapshot) error: ${e.toString()}');
                                        okDialog(
                                          context,
                                          "Wrong Email or Password",
                                          "You entered wrong email or password.",
                                        ).whenComplete(
                                            () => Navigator.pop(context));
                                      });
                                    }
                                  }, onError: (e) {
                                    okDialog(
                                      context,
                                      "Invalid Credintials",
                                      "Invalid email or password.",
                                    ).whenComplete(
                                        () => Navigator.pop(context));
                                  });
                                } else {
                                  okDialog(
                                    context,
                                    "Empty Field",
                                    "Please fill all textfields.",
                                  ).whenComplete(() => Navigator.pop(context));
                                }
                              } catch (e) {
                                log('LOGIN (login.dart) error: ${e.toString()}');
                              }
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}

class ForgetBtn extends StatefulWidget {
  const ForgetBtn({super.key});

  @override
  State<ForgetBtn> createState() => _ForgetBtnState();
}

class _ForgetBtnState extends State<ForgetBtn> {
  var resetEmail = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.teal[500],
        ),
        child: Center(
          child: Container(
            height: 400.0,
            width: 350.0,
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(255, 174, 171, 171),
                      spreadRadius: 0,
                      blurStyle: BlurStyle.normal,
                      blurRadius: 2.0)
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: (() => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const WebLoginView()),
                            )),
                        icon: const Icon(
                          Feather.arrow_left,
                          size: 20,
                          color: Colors.black,
                        )),
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 3)),
                    const Text(
                      'Password Reset',
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: 17,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                Center(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: TextFormField(
                      style: inputTextStyle,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      controller: resetEmail,
                      // ignore: unnecessary_const
                      decoration: InputDecoration(
                        hintStyle: inputHintTxtStyle,
                        focusedBorder: focusOutlineBorder,
                        border: OutlineBorder,

                        // ignore: prefer_const_constructors
                        hintText: 'Enter Email Address',
                        prefixIcon: Icon(
                          Feather.mail,
                          size: 18,
                          color: Colors.teal[800],
                        ),
                      ),
                      onFieldSubmitted: (value) async {
                        var email = resetEmail.text;
                        if (email.isNotEmpty) {
                          final bool emailValid = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(email);
                          if (emailValid == true) {
                            await FirebaseAuth.instance
                                .sendPasswordResetEmail(email: email)
                                .whenComplete(() {
                              okDialog(context, 'Send Successfully',
                                      'We successfully send the RECOVERY in your inbox. Please check your email')
                                  .whenComplete(() => Navigator.pop(context));
                            });
                          } else {
                            okDialog(context, 'Invalid Credintials',
                                'You entered invalid email. Please try again.');
                          }
                        } else {
                          okDialog(context, 'Empty Field',
                              'Please fill out the textfields.');
                        }
                      },
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        var email = resetEmail.text;
                        if (email.isNotEmpty) {
                          final bool emailValid = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(email);
                          if (emailValid == true) {
                            await FirebaseAuth.instance
                                .sendPasswordResetEmail(email: email)
                                .whenComplete(() {
                              okDialog(context, 'Send Successfully',
                                      'We successfully send the RECOVERY in your inbox. Please check your email')
                                  .whenComplete(() => Navigator.pop(context));
                            });
                          } else {
                            okDialog(context, 'Invalid Credintials',
                                'You entered invalid email. Please try again.');
                          }
                        } else {
                          okDialog(context, 'Empty Field',
                              'Please fill out the textfields.');
                        }
                      },
                      style: ForTealButton,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'SEND RECOVERY',
                          style: alertDialogBtn,
                        ),
                      ),
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                Center(
                  child: Container(
                    height: 100.0,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/logo_full_coop.png'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
