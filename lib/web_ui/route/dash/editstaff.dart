
import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/route/dash/changepass.dart';
import 'package:ascoop/web_ui/styles/buttonstyle.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:ascoop/web_ui/utils/alertdialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditStaffBtn extends StatefulWidget {
  var fname, lname, email, profile, staffId, coopId;
  EditStaffBtn({
    super.key,
    required this.fname,
    required this.lname,
    required this.email,
    required this.profile,
    required this.staffId,
    required this.coopId,
  });

  @override
  State<EditStaffBtn> createState() => _EditStaffBtnState();
}

class _EditStaffBtnState extends State<EditStaffBtn> {
  var _fname, _lname, _email;

  @override
  void initState() {
    _fname = TextEditingController(text: widget.fname);
    _lname = TextEditingController(text: widget.lname);
    _email = TextEditingController(text: widget.email);
    super.initState();
  }

  bool isEdit = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Icon(
                Feather.edit,
                size: 30,
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
              Text(
                'Edit Profile',
                style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                    fontSize: 20,
                    color: Colors.black),
              ),
            ],
          ),
          InkWell(
            hoverColor: Colors.white,
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Feather.x,
              size: 25,
              color: Colors.grey[800],
            ),
          )
        ],
      ),
      content: SizedBox(
        width: 500,
        child: ScrollConfiguration(
          behavior: MyCustomScrollBehavior(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 250,
                          height: 250,
                          clipBehavior: Clip.none,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: grey4,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: NetworkImage(widget.profile),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        TextButton(
                            onPressed: () async {
                              try {
                                WriteBatch batch =
                                    FirebaseFirestore.instance.batch();
                                var profile =
                                    await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['jpg', 'png', 'jpeg'],
                                );
                                print(profile!.files.first.extension
                                            .toString() ==
                                        'jpg' ||
                                    profile.files.first.extension.toString() ==
                                        'png' ||
                                    profile.files.first.extension.toString() ==
                                        'jpeg');
                                if (profile.files.first.extension.toString() == 'jpg' ||
                                    profile.files.first.extension.toString() ==
                                        'png' ||
                                    profile.files.first.extension.toString() ==
                                        'jpeg') {
                                  if (profile != null) {
                                    final data = FirebaseStorage.instance
                                        .ref()
                                        .child('staff')
                                        .child(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .child('profilePic')
                                        .child(profile.files.single.name);

                                    try {
                                      data.putData(profile.files.single.bytes!);
                                      String profUrl =
                                          await data.getDownloadURL();

                                      //batch write
                                      batch.update(
                                          myDb.collection('staffs').doc(
                                              FirebaseAuth
                                                  .instance.currentUser!.uid),
                                          {
                                            'profilePic': profUrl,
                                          });

                                      //commit
                                      batch.commit().then((value) {
                                        myDb
                                            .collection('staffs')
                                            .where('coopID',
                                                isEqualTo: widget.coopId)
                                            .where('staffID',
                                                isNotEqualTo: FirebaseAuth
                                                    .instance.currentUser!.uid)
                                            .get()
                                            .then((data) async {
                                          if (data.size > 0) {
                                            for (int a = 0;
                                                a < data.size;
                                                a++) {
                                              await myDb
                                                  .collection('notifications')
                                                  .doc(widget.coopId)
                                                  .collection(
                                                      data.docs[a]['staffID'])
                                                  .doc(DateFormat(
                                                          'yyyyMMddHHmmss')
                                                      .format(DateTime.now()))
                                                  .set({
                                                'context': 'updateProfile',
                                                'coopId': widget.coopId,
                                                'title':
                                                    'Update Profile Picture',
                                                'content':
                                                    '${widget.fname.toString().toUpperCase()} ${widget.lname.toString().toUpperCase()} has updated Profile Picture.',
                                                'notifBy': FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                'notifId': data.docs[a]
                                                    ['staffID'],
                                                'timestamp': DateTime.now(),
                                                'status': 'unread',
                                              });
                                            }
                                          }
                                        });
                                        myDb
                                            .collection('staffs')
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .collection('transactions')
                                            .doc(DateFormat('yyyyMMddHHmmss')
                                                .format(DateTime.now()))
                                            .set({
                                          'timestamp': DateTime.now(),
                                          'context': 'Update',
                                          'title': 'Profile Picture Update',
                                          'staffId': FirebaseAuth
                                              .instance.currentUser!.uid,
                                        });

                                        okDialog(context, 'Update Successfully',
                                                'Profile has updated successfully')
                                            .whenComplete(() {
                                          Navigator.pop(context);
                                          setState(() {
                                            widget.profile = profUrl;
                                          });
                                        });
                                      }, onError: (e) {
                                        okDialog(context, 'An Error Occured',
                                            'Please try again. Later!');
                                      });
                                    } catch (e) {}
                                  }
                                } else {
                                  okDialog(context, 'An error occured',
                                      'You selected invalid format file. Please try again.');
                                }
                              } catch (e) {
                                print(e.toString());
                              }
                            },
                            child: Text(
                              'Change Profile Picture',
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[900],
                              ),
                            ))
                      ],
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Visibility(
                          visible: isEdit == false ? true : false,
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  isEdit = true;
                                  _fname.clear();
                                  _lname.clear();
                                });
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Feather.edit_3,
                                    size: 12,
                                    color: Colors.grey[900],
                                  ),
                                  const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 3)),
                                  Text(
                                    'Edit Profile',
                                    style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: 13,
                                      color: Colors.grey[800],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              )),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        TextFormField(
                          controller: _fname,
                          enabled: isEdit,
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
                              labelText: 'Firstname',
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
                          onTap: () {
                            _fname.clear();
                          },
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10)),
                        TextFormField(
                          enabled: isEdit,
                          controller: _lname,
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
                              labelText: 'Lastname',
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
                          onTap: () {
                            _lname.clear();
                          },
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10)),
                        TextFormField(
                          enabled: false,
                          controller: _email,
                          decoration: InputDecoration(
                              suffix: PopupMenuButton(
                                tooltip:
                                    'You cannot change email address at this moment.',
                                itemBuilder: (context) => [
                                  PopupMenuItem(child: Container()),
                                ],
                                child: Icon(
                                  FontAwesomeIcons.info,
                                  size: 14,
                                  color: Colors.grey[800],
                                ),
                              ),
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
                              labelText: 'Email Address',
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
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                showDialog(
                                  context: context,
                                  builder: (context) => ChangePassBtn(
                                    email: widget.email,
                                  ),
                                );
                              });
                            },
                            child: Text(
                              'Change Password',
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[800],
                              ),
                            ))
                      ],
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Visibility(
                      visible: isEdit,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal[800],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
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
                          WriteBatch batch = FirebaseFirestore.instance.batch();
                          late String fname, lname;
                          fname = _fname.text.trim();
                          lname = _lname.text.trim();
                          if (lname.isNotEmpty && fname.isNotEmpty) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(
                                      'Update Confirmation',
                                      style: alertDialogTtl,
                                    ),
                                    content: Text(
                                      'Are you sure you want to update your profile?',
                                      style: alertDialogContent,
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        style: ForRedButton,
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'No',
                                            style: alertDialogBtn,
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                backgroundColor:
                                                    Colors.transparent,
                                                elevation: 0,
                                                content: onWait),
                                          );
                                          //batch write
                                          batch.update(
                                              myDb
                                                  .collection('staffs')
                                                  .doc(widget.staffId),
                                              {
                                                'firstname': fname,
                                                'lastname': lname,
                                              });

                                          //commit
                                          batch.commit().then((value) {
                                            //apply notifications to all staff
                                            myDb
                                                .collection('staffs')
                                                .where('coopID',
                                                    isEqualTo: widget.coopId)
                                                .where('staffID',
                                                    isNotEqualTo: FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid)
                                                .get()
                                                .then((data) async {
                                              if (data.size > 0) {
                                                for (int a = 0;
                                                    a < data.size;
                                                    a++) {
                                                  await myDb
                                                      .collection(
                                                          'notifications')
                                                      .doc(widget.coopId)
                                                      .collection(data.docs[a]
                                                          ['staffID'])
                                                      .doc(DateFormat(
                                                              'yyyyMMddHHmmss')
                                                          .format(
                                                              DateTime.now()))
                                                      .set({
                                                    'context': 'updateProfile',
                                                    'coopId': widget.coopId,
                                                    'title':
                                                        'Update Profile Information',
                                                    'content':
                                                        '${widget.fname.toString().toUpperCase()} ${widget.lname.toString().toUpperCase()} has updated Profile Information.',
                                                    'notifBy': FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid,
                                                    'notifId': data.docs[a]
                                                        ['staffID'],
                                                    'timestamp': DateTime.now(),
                                                    'status': 'unread',
                                                  });
                                                }
                                              }
                                            });
                                            myDb
                                                .collection('staffs')
                                                .doc(FirebaseAuth
                                                    .instance.currentUser!.uid)
                                                .collection('transactions')
                                                .doc(
                                                    DateFormat('yyyyMMddHHmmss')
                                                        .format(DateTime.now()))
                                                .set({
                                              'timestamp': DateTime.now(),
                                              'context': 'Update',
                                              'title':
                                                  'Profile Information Update',
                                              'staffId': FirebaseAuth
                                                  .instance.currentUser!.uid,
                                            });

                                            okDialog(
                                                    context,
                                                    'Update Successfully',
                                                    'Profile has updated successfully')
                                                .whenComplete(() {
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            });
                                          }, onError: (e) {
                                            okDialog(
                                                    context,
                                                    'An Error Occured',
                                                    'Please try again. Later!')
                                                .whenComplete(() =>
                                                    Navigator.pop(context));
                                          });
                                        },
                                        style: ForTealButton,
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'Yes',
                                            style: alertDialogBtn,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          } else {
                            okDialog(
                              context,
                              "Empty Field",
                              "Please fill all textfields.",
                            ).whenComplete(() => Navigator.pop(context));
                          }
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
