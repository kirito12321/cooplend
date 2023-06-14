import 'package:ascoop/services/auth/auth_exception.dart';
import 'package:ascoop/services/auth/auth_service.dart';
import 'package:ascoop/utilities/show_alert_dialog.dart';
import 'package:ascoop/utilities/show_error_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../style.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool _aggrement = false;
  bool _isObscure = true;
  bool _isObscureC = true;
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _firstName;
  late final TextEditingController _middleName;
  late final TextEditingController _lastName;
  late final TextEditingController _cpassword;
  late final TextEditingController _mobileNo;
  late final TextEditingController _currentAddress;

  final genderSelection = ['Male', 'Female'];
  String? genderValue;
  DateTime _birthdate = DateTime.now();

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _firstName = TextEditingController();
    _middleName = TextEditingController();
    _lastName = TextEditingController();
    _cpassword = TextEditingController();
    _mobileNo = TextEditingController();
    _currentAddress = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _firstName.dispose();
    _middleName.dispose();
    _lastName.dispose();
    _cpassword.dispose();
    _mobileNo.dispose();
    _currentAddress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                    image: AssetImage('assets/images/wallpaper.jpg'),
                    fit: BoxFit.fill),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, screenHeight * 0.1, 0, 0),
                child: Center(
                  child: Container(
                    width: registrationContainer(screenWidth),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 70.0, 0, 60.0),
                          child: Center(
                              child: Text(
                            'CREATE AN ACCOUNT',
                            style: CreateAccountTextStyle,
                          )),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 50, bottom: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'First Name',
                                style: TxtBodyHntTextStyle,
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(50, 0, 50, 20),
                            child: TextField(
                              controller: _firstName,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  prefixIcon: Align(
                                    widthFactor: 1.0,
                                    heightFactor: 1.0,
                                    child: Icon(Icons.person),
                                  ),
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(8)),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 50, bottom: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Middle Name',
                                style: TxtBodyHntTextStyle,
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(50, 0, 50, 20),
                            child: TextField(
                              controller: _middleName,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  prefixIcon: Align(
                                    widthFactor: 1.0,
                                    heightFactor: 1.0,
                                    child: Icon(Icons.person),
                                  ),
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(8)),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 50, bottom: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Last Name',
                                style: TxtBodyHntTextStyle,
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(50, 0, 50, 20),
                            child: TextField(
                              controller: _lastName,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  prefixIcon: Align(
                                    widthFactor: 1.0,
                                    heightFactor: 1.0,
                                    child: Icon(Icons.person),
                                  ),
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(8)),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 50, bottom: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Email Address',
                                style: TxtBodyHntTextStyle,
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(50, 0, 50, 20),
                            child: TextField(
                              controller: _email,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  prefixIcon: Align(
                                    widthFactor: 1.0,
                                    heightFactor: 1.0,
                                    child: Icon(Icons.email),
                                  ),
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(8)),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 50, bottom: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Gender',
                                style: TxtBodyHntTextStyle,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(50, 0, 50, 20),
                          child: SizedBox(
                            height: 55,
                            child: InputDecorator(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    gapPadding: 4,
                                  ),
                                  isDense: true,
                                  prefixIcon: Align(
                                    widthFactor: 1.0,
                                    heightFactor: 1.0,
                                    child: genderValue == 'Male'
                                        ? const Icon(Icons.male_outlined)
                                        : const Icon(Icons.female_outlined),
                                  )),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                    items: genderSelection.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TxtBodyHntTextStyle3,
                                        ),
                                      );
                                    }).toList(),
                                    value: genderValue,
                                    isDense: true,
                                    iconSize: 24,
                                    icon: const Icon(Icons.arrow_drop_down),
                                    isExpanded: true,
                                    onChanged: (value) =>
                                        setState(() => genderValue = value)),
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 50, bottom: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Mobile number',
                                style: TxtBodyHntTextStyle,
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(50, 0, 50, 20),
                            child: TextField(
                              controller: _mobileNo,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  prefixIcon: Align(
                                    widthFactor: 1.0,
                                    heightFactor: 1.0,
                                    child: Icon(Icons.numbers_outlined),
                                  ),
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(8)),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 50, bottom: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Birthdate',
                                style: TxtBodyHntTextStyle,
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(50, 0, 50, 20),
                            child: TextField(
                              keyboardType: TextInputType.datetime,
                              onTap: () async {
                                DateTime? newDate = await showDatePicker(
                                    context: context,
                                    initialDate: Timestamp.now().toDate(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100));

                                if (newDate == null) return;

                                setState(() => _birthdate = newDate);
                              },
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  prefixIcon: const Align(
                                    widthFactor: 1.0,
                                    heightFactor: 1.0,
                                    child: Icon(Icons.calendar_month_outlined),
                                  ),
                                  hintText:
                                      '${_birthdate.month}/${_birthdate.day}/${_birthdate.year}',
                                  isDense: true,
                                  contentPadding: const EdgeInsets.all(8)),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 50, bottom: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Current Address',
                                style: TxtBodyHntTextStyle,
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(50, 0, 50, 20),
                            child: TextField(
                              controller: _currentAddress,
                              keyboardType: TextInputType.multiline,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  prefixIcon: Align(
                                    widthFactor: 1.0,
                                    heightFactor: 1.0,
                                    child: Icon(Icons.person),
                                  ),
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(8)),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 50, bottom: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Password',
                                style: TxtBodyHntTextStyle,
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(50, 0, 50, 20),
                            child: TextField(
                              obscureText: _isObscure,
                              controller: _password,
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  prefixIcon: const Align(
                                    widthFactor: 1.0,
                                    heightFactor: 1.0,
                                    child: Icon(Icons.lock),
                                  ),
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _isObscure = !_isObscure;
                                        });
                                      },
                                      icon: Icon(_isObscure
                                          ? Icons.visibility
                                          : Icons.visibility_off)),
                                  isDense: true,
                                  contentPadding: const EdgeInsets.all(8)),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 50, bottom: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Confirm Password',
                                style: TxtBodyHntTextStyle,
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                            child: TextField(
                              obscureText: _isObscureC,
                              controller: _cpassword,
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  prefixIcon: const Align(
                                    widthFactor: 1.0,
                                    heightFactor: 1.0,
                                    child: Icon(Icons.lock),
                                  ),
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _isObscureC = !_isObscureC;
                                        });
                                      },
                                      icon: Icon(_isObscureC
                                          ? Icons.visibility
                                          : Icons.visibility_off)),
                                  isDense: true,
                                  contentPadding: const EdgeInsets.all(8)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 50.0, bottom: 20.0, top: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                  value: _aggrement,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _aggrement = value!;
                                    });
                                  }),
                              const SizedBox(
                                  width: 250,
                                  child: Text(
                                      "By checking Register, you are agreeing to our Privacy and Term of use."))
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 50.0, right: 50.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 32, 207, 208),
                              textStyle: LoginBtnTextStyle,
                              fixedSize: const Size.fromHeight(50),
                              minimumSize: const Size.fromHeight(45),
                              shape: const StadiumBorder(),
                            ),
                            onPressed: () async {
                              if (_aggrement != true) {
                                showErrorDialog(context,
                                    'Please agree to our terms and condition before registering an acount');
                              } else {
                                final email = _email.text;
                                final password = _password.text;
                                final firstName = _firstName.text;
                                final middleName = _middleName.text;
                                final lastName = _lastName.text;
                                final gender = genderValue ?? 'male';
                                final mobileNo = _mobileNo.text;
                                final birthDate = _birthdate;
                                final currenAddress = _currentAddress.text;
                                try {
                                  await AuthService.firebase().createUser(
                                    email: email,
                                    password: password,
                                    firstName: firstName,
                                    middleName: middleName,
                                    lastName: lastName,
                                    gender: gender,
                                    mobileNo: mobileNo,
                                    birthDate: birthDate,
                                    currentAddress: currenAddress,
                                  );

                                  //after this line we should proceed in verification view instead of login view
                                  AuthService.firebase()
                                      .sendEmailVerification()
                                      .then((value) => ShowAlertDialog(
                                              context: context,
                                              title: 'Registered',
                                              body: 'Succesfully Registered',
                                              btnName: 'Okay')
                                          .showAlertDialog()
                                          .then((value) => Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                                  '/login/',
                                                  (route) => false)));
                                  // ignore: use_build_context_synchronously
                                } on WeakPasswordAuthException {
                                  showErrorDialog(context, 'Weak Password');
                                } on EmailAlreadyInUseAuthException {
                                  showErrorDialog(
                                      context, 'Email already in use');
                                } on InvalidEmailAuthException {
                                  showErrorDialog(context, 'invalid email');
                                } on GenericAuthException {
                                  showErrorDialog(
                                      context, 'Failed to register');
                                }
                              } //else statement
                            },
                            child: const Text('REGISTER'),
                          ),
                        )
                      ],
                    ),
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

double registrationContainer(double screenWidth) {
  if (screenWidth > 480.0) {
    return 480.0;
  } else {
    return screenWidth;
  }
}
