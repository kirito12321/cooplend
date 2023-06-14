// ignore_for_file: use_build_context_synchronously

import 'package:ascoop/services/auth/auth_exception.dart';
import 'package:ascoop/services/auth/auth_service.dart';
import 'package:ascoop/services/database/data_service.dart';
import 'package:ascoop/utilities/show_alert_dialog.dart';
import 'package:ascoop/utilities/show_error_dialog.dart';
import 'package:ascoop/web_ui/styles/buttonstyle.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:flutter/material.dart';
import '../style.dart';
// import 'dart:developer' as devtools show log;

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

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
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.teal[500]
            // image: DecorationImage(
            //     // image: AssetImage('assets/images/loginwallpapersecondx.jpg'),
            //     fit: BoxFit.cover)
            ),
        child: Center(
          child: Container(
            height: 500.0,
            width: 350.0,
            padding: const EdgeInsets.all(10.0),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(255, 174, 171, 171),
                      spreadRadius: 0,
                      blurStyle: BlurStyle.normal,
                      blurRadius: 45.0)
                ]),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Center(
                        child: Text(
                      'LOGIN',
                      style: LoginTextStyle,
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _email,
                      decoration: const InputDecoration(
                        hintText: 'Enter your email here.',
                        hintStyle: BodyHntTextStyle,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _password,
                      autocorrect: false,
                      enableSuggestions: false,
                      obscureText: true,
                      decoration: const InputDecoration(
                          hintText: 'Enter your password here.',
                          hintStyle: BodyHntTextStyle),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          // '/coop/loanview/',
                          //  '/coop/loantenureview',
                          '/user/sendverifCode/',
                        );
                      },
                      child: Text(
                        'Forgot Password',
                        style: btnForgotTxtStyle,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(50.0, 80, 50.0, 10.0),
                    child: Center(
                      child: SizedBox(
                        height: 50,
                        width: 200,
                        child: ElevatedButton(
                          style: ForTealButton,
                          onPressed: () async {
                            final email = _email.text;
                            final password = _password.text;
                            try {
                              await AuthService.firebase().login(
                                email: email,
                                password: password,
                              );
                              final data =
                                  await DataService.database().readUserData();

                              if (data == null) {
                                ShowAlertDialog(
                                        context: context,
                                        title: 'Error Login',
                                        body: 'No user found',
                                        btnName: 'okay')
                                    .showAlertDialog()
                                    .then((value) => AuthService.firebase()
                                        .logOut()
                                        .then((value) => Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                                '/login/', (route) => false)));

                                return;
                              }

                              final user = AuthService.firebase().currentUser;
                              if (user?.isEmailVerified ?? false) {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/dashboard/', (route) => false);
                              } else {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/user/sendemailverif/', (route) => false);
                              }
                            } on UserNotFoundAuthException {
                              await showErrorDialog(
                                context,
                                'User not found',
                              );
                            } on WrongPasswordAuthException {
                              await showErrorDialog(
                                context,
                                'Wrong Password',
                              );
                            } on GenericAuthException {
                              await showErrorDialog(
                                context,
                                'Authentication error',
                              );
                            }
                          },
                          child: const Text(
                            'Login',
                            style: LoginBtnTextStyle,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/register/', (route) => false);
                        },
                        child: Text(
                          'Dont have an account?SIGN UP',
                          style: btnForgotTxtStyle,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
