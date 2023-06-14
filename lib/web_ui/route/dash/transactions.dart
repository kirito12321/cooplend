
import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactBtn extends StatefulWidget {
  const TransactBtn({
    super.key,
  });

  @override
  State<TransactBtn> createState() => _TransactBtnState();
}

class _TransactBtnState extends State<TransactBtn> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        clipBehavior: Clip.hardEdge,
        width: 500,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(
                      FontAwesomeIcons.clockRotateLeft,
                      size: 20,
                    ),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
                    Text(
                      'Transaction History',
                      style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                          fontSize: 18,
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
                    child: StreamBuilder(
                  stream: myDb
                      .collection('staffs')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('transactions')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    try {
                      final data = snapshot.data!.docs;
                      if (snapshot.hasError) {
                        return Container();
                      } else if (snapshot.hasData && data.isNotEmpty) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return onWait;
                          default:
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                switch (data[index]['context']
                                    .toString()
                                    .toLowerCase()) {
                                  case 'update':
                                    return InkWell(
                                      hoverColor: Colors.white,
                                      splashColor: Colors.white,
                                      highlightColor: Colors.white,
                                      onTap: () {},
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: const EdgeInsets.all(8),
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                                color: grey4,
                                                spreadRadius: 0.8,
                                                blurStyle: BlurStyle.normal,
                                                blurRadius: 0.8),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data[index]['title'],
                                              style: const TextStyle(
                                                  fontFamily: FontNameDefault,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black),
                                            ),
                                            const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 2)),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  DateFormat(
                                                          'MMM d, yyyy hh:mm a')
                                                      .format(data[index]
                                                              ['timestamp']
                                                          .toDate()),
                                                  style: const TextStyle(
                                                    fontFamily: FontNameDefault,
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  default:
                                    return InkWell(
                                      hoverColor: Colors.white,
                                      splashColor: Colors.white,
                                      highlightColor: Colors.white,
                                      onTap: () {},
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: const EdgeInsets.all(8),
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                                color: grey4,
                                                spreadRadius: 0.8,
                                                blurStyle: BlurStyle.normal,
                                                blurRadius: 0.8),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data[index]['title'],
                                              style: const TextStyle(
                                                  fontFamily: FontNameDefault,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 1)),
                                            Text(
                                              data[index]['content'],
                                              style: const TextStyle(
                                                  fontFamily: FontNameDefault,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black),
                                            ),
                                            const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 3)),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  DateFormat(
                                                          'MMM d, yyyy hh:mm a')
                                                      .format(data[index]
                                                              ['timestamp']
                                                          .toDate()),
                                                  style: const TextStyle(
                                                    fontFamily: FontNameDefault,
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                }
                              },
                            );
                        }
                      } else if (data.isEmpty) {
                        return EmptyData(ttl: 'No Transactions Yet');
                      }
                    } catch (e) {}
                    return EmptyData(ttl: 'No Transactions Yet');
                  },
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
