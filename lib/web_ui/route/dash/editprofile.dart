// ignore_for_file: use_build_context_synchronously

import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/styles/buttonstyle.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:ascoop/web_ui/utils/alertdialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditCoopBtn extends StatefulWidget {
  String email, name, profile, add, coopId;
  bool isOnline;
  EditCoopBtn({
    super.key,
    required this.email,
    required this.name,
    required this.profile,
    required this.add,
    required this.isOnline,
    required this.coopId,
  });

  @override
  State<EditCoopBtn> createState() => _EditCoopBtnState();
}

class _EditCoopBtnState extends State<EditCoopBtn> {
  var _name, _add, _email;
  List<bool> roles = <bool>[true, false];
  late bool dropdownValue;
  @override
  void initState() {
    _name = TextEditingController(text: widget.name);
    _add = TextEditingController(text: widget.add);
    _email = TextEditingController(text: widget.email);
    dropdownValue = widget.isOnline;
    super.initState();
  }

  @override
  void dispose() {
    _name;
    _add;
    _email;
    super.dispose();
  }

  //for switch animation
  final MaterialStateProperty<Color?> trackColor =
      MaterialStateProperty.resolveWith<Color?>(
    (Set<MaterialState> states) {
      // Track color when the switch is selected.
      if (states.contains(MaterialState.selected)) {
        return Colors.teal[800];
      }
      // Otherwise return null to set default track color
      // for remaining states such as when the switch is
      // hovered, focused, or disabled.
      return null;
    },
  );
  final MaterialStateProperty<Color?> overlayColor =
      MaterialStateProperty.resolveWith<Color?>(
    (Set<MaterialState> states) {
      // Material color when switch is selected.
      if (states.contains(MaterialState.selected)) {
        return const Color.fromRGBO(0, 105, 92, 1).withOpacity(0.54);
      }
      // Material color when switch is disabled.
      if (states.contains(MaterialState.disabled)) {
        return Colors.grey.shade400;
      }
      // Otherwise return null to set default material color
      // for remaining states such as when the switch is
      // hovered, or focused.
      return null;
    },
  );

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
                'Edit Coop Profile',
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
        width: 600,
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
                                if (profile!.files.first.extension.toString() ==
                                        'jpg' ||
                                    profile.files.first.extension.toString() ==
                                        'png' ||
                                    profile.files.first.extension.toString() ==
                                        'jpeg') {
                                  if (profile != null) {
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) => AlertDialog(
                                          backgroundColor: Colors.transparent,
                                          elevation: 0,
                                          content: onWait),
                                    );
                                    final data = FirebaseStorage.instance
                                        .ref()
                                        .child('coops')
                                        .child(widget.coopId)
                                        .child('profilePic')
                                        .child(profile.files.single.name);

                                    try {
                                      data.putData(profile.files.single.bytes!);
                                      String profUrl =
                                          await data.getDownloadURL();

                                      //batch write
                                      batch.update(
                                          myDb
                                              .collection('coops')
                                              .doc(widget.coopId),
                                          {
                                            'profilePic': profUrl,
                                          });
                                      batch.update(
                                          myDb
                                              .collection('coopInfo')
                                              .doc(widget.coopId),
                                          {
                                            'profilePic': profUrl,
                                          });
                                      //commit
                                      batch.commit().then((value) async {
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
                                                'context': 'update',
                                                'coopId': widget.coopId,
                                                'title':
                                                    'Update Coop Profile Picture',
                                                'content':
                                                    'The Administrator has updated the Cooperative Profile Picture.',
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
                                        await myDb
                                            .collection('staffs')
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .collection('transactions')
                                            .doc(DateFormat('yyyyMMddHHmmss')
                                                .format(DateTime.now()))
                                            .set({
                                          'timestamp': DateTime.now(),
                                          'context': 'Update',
                                          'title':
                                              'Coop Profile Picture Update',
                                          'staffId': FirebaseAuth
                                              .instance.currentUser!.uid,
                                        }).whenComplete(() {
                                          okDialog(
                                                  context,
                                                  'Update Successfully',
                                                  'Coop Profile has updated successfully')
                                              .whenComplete(() {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            setState(() {
                                              widget.profile = profUrl;
                                            });
                                          });
                                        });
                                      }, onError: (e) {
                                        okDialog(context, 'An Error Occured',
                                                'Please try again. Later!')
                                            .whenComplete(
                                                () => Navigator.pop(context));
                                      });
                                    } catch (e) {}
                                  }
                                } else {
                                  okDialog(context, 'An error occured',
                                      'You selected invalid format file. Please try again.');
                                }
                              } catch (e) {}
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
                    Column(
                      children: [
                        TextFormField(
                          controller: _name,
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
                              labelText: 'Coop Name',
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
                            _name.clear();
                          },
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10)),
                        TextFormField(
                          controller: _add,
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
                              labelText: 'Coop Address',
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
                            _add.clear();
                          },
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10)),
                        TextFormField(
                          controller: _email,
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
                              labelText: 'Coop Email',
                              labelStyle: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                  letterSpacing: 1)),
                          style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: Colors.grey[900],
                              letterSpacing: 1),
                          onTap: () {
                            _email.clear();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
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
                        late String name, add, email;
                        name = _name.text.trim();
                        add = _add.text.trim();
                        email = _email.text.trim();
                        if (name.isNotEmpty &&
                            add.isNotEmpty &&
                            email.isNotEmpty) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text(
                                    'Update Confirmation',
                                    style: alertDialogTtl,
                                  ),
                                  content: Text(
                                    'Are you sure you want to update Coop Information?',
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
                                                .collection('coops')
                                                .doc(widget.coopId),
                                            {
                                              'coopName': name,
                                              'coopAddress': add,
                                              'email': email,
                                            });
                                        batch.update(
                                            myDb
                                                .collection('coopInfo')
                                                .doc(widget.coopId),
                                            {
                                              'coopName': name,
                                              'coopAddress': add,
                                              'email': email,
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
                                                    .collection('notifications')
                                                    .doc(widget.coopId)
                                                    .collection(
                                                        data.docs[a]['staffID'])
                                                    .doc(DateFormat(
                                                            'yyyyMMddHHmmss')
                                                        .format(DateTime.now()))
                                                    .set({
                                                  'context': 'update',
                                                  'coopId': widget.coopId,
                                                  'title':
                                                      'Update Coop Information',
                                                  'content':
                                                      'The Administrator has updated the Cooperative Information.',
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
                                              .doc(DateFormat('yyyyMMddHHmmss')
                                                  .format(DateTime.now()))
                                              .set({
                                            'timestamp': DateTime.now(),
                                            'context': 'Update',
                                            'title': 'Coop Information Update',
                                            'staffId': FirebaseAuth
                                                .instance.currentUser!.uid,
                                          });

                                          okDialog(
                                                  context,
                                                  'Update Successfully',
                                                  'Coop information has updated successfully')
                                              .whenComplete(() {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          });
                                        }, onError: (e) {
                                          okDialog(context, 'An Error Occured',
                                                  'Please try again. Later!')
                                              .whenComplete(
                                                  () => Navigator.pop(context));
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
