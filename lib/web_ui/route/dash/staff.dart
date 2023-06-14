import 'package:ascoop/web_ui/route/dash/editstaff.dart';
import 'package:ascoop/web_ui/route/dash/transactions.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class StaffProfile extends StatefulWidget {
  const StaffProfile({super.key});

  @override
  State<StaffProfile> createState() => _StaffProfileState();
}

class _StaffProfileState extends State<StaffProfile> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('staffs')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('Something error...');
        }
        final data = snapshot.data!.data()!;
        return Container(
          padding: const EdgeInsets.all(15),
          //coop
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                  color: Color.fromARGB(255, 174, 171, 171),
                  spreadRadius: 0.5,
                  blurStyle: BlurStyle.normal,
                  blurRadius: 3.0)
            ],
          ),
          child: Column(
            children: [
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(data['profilePic']),
                    fit: BoxFit.cover,
                  ),
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              const Padding(
                  padding: EdgeInsets.symmetric(
                vertical: 4,
              )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '${data['firstname'].toString().toUpperCase()}  ${data['lastname'].toString().toUpperCase()}',
                    style: h3,
                    textAlign: TextAlign.center,
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                  const Text(
                    'My Email:',
                    style: h5,
                  ),
                  Text(
                    data['email'],
                    style: h4,
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                  const Text(
                    'Account Role:',
                    style: h5,
                  ),
                  Text(
                    data['role'].toString().toUpperCase(),
                    style: h4,
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                ],
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 6)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 210,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 3,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          side: const BorderSide(
                            width: 2,
                            color: Color.fromARGB(255, 1, 95, 84),
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Feather.clock,
                              size: 20,
                              color: Colors.teal[900],
                            ),
                            const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4)),
                            Text(
                              'My Transactions',
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.teal[900],
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const TransactBtn();
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 210,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 3,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          side: const BorderSide(
                            width: 2,
                            color: Color.fromARGB(255, 1, 95, 84),
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Feather.edit_3,
                              size: 20,
                              color: Colors.teal[900],
                            ),
                            const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4)),
                            Text(
                              'Update Account',
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.teal[900],
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onPressed: () {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return EditStaffBtn(
                                fname: data['firstname'],
                                lname: data['lastname'],
                                email: data['email'],
                                profile: data['profilePic'],
                                staffId: data['staffID'],
                                coopId: data['coopID'],
                              );
                            },
                          );
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
