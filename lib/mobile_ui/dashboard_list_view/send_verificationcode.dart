import 'package:ascoop/services/auth/auth_exception.dart';
import 'package:ascoop/services/auth/auth_service.dart';
import 'package:ascoop/style.dart';
import 'package:ascoop/utilities/show_error_dialog.dart';
import 'package:flutter/material.dart';

class SendVFCode extends StatefulWidget {
  const SendVFCode({super.key});

  @override
  State<SendVFCode> createState() => _SendVFCodeState();
}

class _SendVFCodeState extends State<SendVFCode> {
  String enteredEmail = '';
  bool checkEmail = false;
  late final TextEditingController _email;

  @override
  void initState() {
    _email = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                            const Center(
                                child: Text('Please enter your email.')),
                            const Padding(
                              padding: EdgeInsets.only(left: 50, bottom: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Email',
                                    style: TxtBodyHntTextStyle,
                                  ),
                                ],
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(50, 0, 50, 20),
                                child: TextFormField(
                                  controller: checkEmail ? _email : null,
                                  initialValue: checkEmail != true &&
                                          arguments['email'] != null
                                      ? arguments['email']
                                      : null,
                                  onTap: () {
                                    setState(() {
                                      checkEmail = true;
                                    });
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      prefixIcon: Align(
                                        widthFactor: 1.0,
                                        heightFactor: 1.0,
                                        child: Icon(Icons.email_outlined),
                                      ),
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(8)),
                                ),
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  if (_email.text.toString() != '') {
                                    setState(() {
                                      enteredEmail = _email.text;
                                    });
                                  } else if (arguments['email'] != null) {
                                    setState(() {
                                      enteredEmail = arguments['email'];
                                    });
                                  } else {
                                    return;
                                  }
                                  try {
                                    await AuthService.firebase()
                                        .sendEmailPasswordResetCode(
                                            email: enteredEmail)
                                        .then((value) =>
                                            Navigator.of(context).pushNamed(
                                              // '/coop/loanview/',
                                              '/user/resetpassawordstatus',
                                            ));
                                  } on InvalidEmailAuthException {
                                    await showErrorDialog(
                                        context, 'Invalid Email');
                                  } on MissingAndroidPkgNameAuthException {
                                    await showErrorDialog(context,
                                        'Missing Android Package Name');
                                  } on MissingContinueUriAuthException {
                                    await showErrorDialog(
                                        context, 'Missing continue uri');
                                  } on MissingIOSBundleIDAuthException {
                                    await showErrorDialog(
                                        context, 'Missing ios bundle ID');
                                  } on InvalidContinueUriAuthException {
                                    await showErrorDialog(
                                        context, 'Invalid Continue URI');
                                  } on UnauthorizedContinueUriAuthException {
                                    await showErrorDialog(
                                        context, 'Unauthorized continue uri');
                                  } on UserNotFoundAuthException {
                                    await showErrorDialog(
                                        context, 'User not found');
                                  } on GenericAuthException {
                                    await showErrorDialog(context,
                                        'Something error with your email');
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal[600],
                                    shape: const StadiumBorder()),
                                child: const Text('Send Code'))
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
}
