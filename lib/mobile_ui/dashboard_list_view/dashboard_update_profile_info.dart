import 'package:ascoop/services/database/data_user.dart' as dataUser;
import 'package:ascoop/utilities/show_alert_dialog.dart';
import 'package:ascoop/utilities/show_confirmation_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import '../../services/database/data_service.dart';
import '../../style.dart';

class DashboardProfileInfo extends StatefulWidget {
  const DashboardProfileInfo({
    Key? key,
  }) : super(key: key);

  @override
  State<DashboardProfileInfo> createState() => _DashboardProfileInfoState();
}

class _DashboardProfileInfoState extends State<DashboardProfileInfo> {
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _email;
  late final TextEditingController _contactNo;
  late final TextEditingController _currentAddress;
  bool fnNullChecker = false;
  bool lnNullChecker = false;
  bool emailNullChecker = false;
  bool contactNoNullChecker = false;
  bool birthdateNullChecker = false;
  bool currendAddNullChecker = false;
  List<bool> checkField = [];
  DateTime? _birthdate = DateTime.now();
  @override
  void initState() {
    _firstName = TextEditingController();
    _lastName = TextEditingController();
    _email = TextEditingController();
    _contactNo = TextEditingController();
    _currentAddress = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _contactNo.dispose();
    _currentAddress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder<dataUser.UserInfo?>(
      future: DataService.database().readUserData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final user = snapshot.data;

          return user == null
              ? const Text('No Data')
              : buildUserProfile(user, size);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget buildUserProfile(dataUser.UserInfo userInfo, Size size) {
    double screenHeight = size.height;
    double screenWidth = size.width;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.black,
        ),
        title: const Text(
          'Profile Info',
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
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text('First Name: '),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller:
                                  fnNullChecker == true ? _firstName : null,
                              initialValue: fnNullChecker == true
                                  ? null
                                  : userInfo.firstName,
                              onTap: () => setState(() {
                                fnNullChecker = true;
                                checkField.insert(0, true);
                              }),
                              textAlign: TextAlign.right,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  prefixIcon: Align(
                                    widthFactor: 1.0,
                                    heightFactor: 1.0,
                                    child: Icon(Icons.password_sharp),
                                  ),
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(8)),
                            ),
                            const Text('Last Name: '),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller:
                                  lnNullChecker == true ? _lastName : null,
                              initialValue: lnNullChecker == true
                                  ? null
                                  : userInfo.lastName,
                              onTap: () => setState(() {
                                lnNullChecker = true;
                                checkField.insert(1, true);
                              }),
                              textAlign: TextAlign.right,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  prefixIcon: Align(
                                    widthFactor: 1.0,
                                    heightFactor: 1.0,
                                    child: Icon(Icons.password_sharp),
                                  ),
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(8)),
                            ),
                            const Text('Email Address: '),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller:
                                  emailNullChecker == true ? _email : null,
                              initialValue: emailNullChecker == true
                                  ? null
                                  : userInfo.email,
                              onTap: () => setState(() {
                                emailNullChecker = true;
                                checkField.insert(2, true);
                              }),
                              textAlign: TextAlign.right,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  prefixIcon: Align(
                                    widthFactor: 1.0,
                                    heightFactor: 1.0,
                                    child: Icon(Icons.password_sharp),
                                  ),
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(8)),
                            ),
                            const Text('Contact Number: '),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: contactNoNullChecker == true
                                  ? _contactNo
                                  : null,
                              initialValue: contactNoNullChecker == true
                                  ? null
                                  : userInfo.mobileNo,
                              onTap: () => setState(() {
                                contactNoNullChecker = true;
                                checkField.insert(3, true);
                              }),
                              textAlign: TextAlign.right,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  prefixIcon: Align(
                                    widthFactor: 1.0,
                                    heightFactor: 1.0,
                                    child: Icon(Icons.password_sharp),
                                  ),
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(8)),
                            ),
                            const Text('Birthdate: '),
                            const SizedBox(
                              height: 10,
                            ),
                            TextField(
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
                                      '${userInfo.birthDate.month}/${userInfo.birthDate.day}/${userInfo.birthDate.year}',
                                  isDense: true,
                                  contentPadding: const EdgeInsets.all(8)),
                            ),
                            const Text('Address: '),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: currendAddNullChecker == true
                                  ? _currentAddress
                                  : null,
                              initialValue: currendAddNullChecker == true
                                  ? null
                                  : userInfo.currentAddress,
                              onTap: () => setState(() {
                                currendAddNullChecker = true;
                                checkField.insert(5, true);
                              }),
                              textAlign: TextAlign.right,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  prefixIcon: Align(
                                    widthFactor: 1.0,
                                    heightFactor: 1.0,
                                    child: Icon(Icons.password_sharp),
                                  ),
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(8)),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 50,
                                  width: 100,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: checkField
                                              .where(
                                                  (element) => element == true)
                                              .isNotEmpty
                                          ? Colors.teal[600]
                                          : const Color.fromARGB(
                                              255, 85, 86, 86),
                                      shape: const StadiumBorder(),
                                    ),
                                    onPressed: () async {
                                      if (checkField
                                          .where((element) => element == true)
                                          .isNotEmpty) {
                                        final userUpdate = dataUser.UserInfo(
                                            userUID: userInfo.userUID,
                                            firstName: _firstName.text,
                                            middleName: userInfo.middleName,
                                            lastName: userInfo.lastName,
                                            gender: userInfo.gender,
                                            email: userInfo.email,
                                            mobileNo: userInfo.mobileNo,
                                            birthDate: _birthdate ??
                                                userInfo.birthDate,
                                            currentAddress:
                                                userInfo.currentAddress);

                                        // showErrorDialog(context,
                                        //         'Changes successfuly saved')
                                        //     .then((value) => Navigator.of(context)
                                        //         .pushNamedAndRemoveUntil(
                                        //             '/dashboard/',
                                        //             (route) => false));

                                        ShowConfirmationDialog(
                                                context: context,
                                                title: 'Save Changes',
                                                body:
                                                    'Are you sure you want to save it?',
                                                fBtnName: 'Yes',
                                                sBtnName: 'No')
                                            .showConfirmationDialog()
                                            .then((value) {
                                          if (value == true) {
                                            DataService.database()
                                                .updateInfo(user: userUpdate)
                                                .then((value) => Navigator.of(
                                                        context)
                                                    .pushNamedAndRemoveUntil(
                                                        '/dashboard/',
                                                        (route) => false));
                                          }
                                        });
                                      } else {
                                        ShowAlertDialog(
                                                context: context,
                                                title: 'Error....',
                                                body:
                                                    'No changes has been made.',
                                                btnName: 'Close')
                                            .showAlertDialog();
                                        return;
                                      }
                                    },
                                    child: const Text('Save'),
                                  ),
                                ),
                                const SizedBox(
                                  width: 40,
                                ),
                                SizedBox(
                                  height: 50,
                                  width: 100,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.teal[600],
                                      shape: const StadiumBorder(),
                                    ),
                                    onPressed: () async {
                                      //Do something...
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
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
