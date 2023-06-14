
import 'package:ascoop/web_ui/constants.dart';
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

class AccessibilityBtn extends StatefulWidget {
  String coopId;
  AccessibilityBtn({
    super.key,
    required this.coopId,
  });

  @override
  State<AccessibilityBtn> createState() => _AccessibilityBtnState();
}

class _AccessibilityBtnState extends State<AccessibilityBtn> {
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
  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
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
                Feather.settings,
                size: 30,
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
              Text(
                'Accessibilty',
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
        width: 350,
        height: 480,
        child: StreamBuilder(
            stream: myDb.collection('coops').doc(widget.coopId).snapshots(),
            builder: (context, snapshot) {
              try {
                final coop = snapshot.data!.data()!;
                if (snapshot.hasError) {
                  return Container();
                } else if (snapshot.hasData && coop.isNotEmpty) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return onWait;
                    default:
                      return StreamBuilder(
                          stream: myDb
                              .collection('coops')
                              .doc(widget.coopId)
                              .collection('loanTypes')
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
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Online Payment: '
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    fontFamily: FontNameDefault,
                                                    color: Colors.grey[800],
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 3)),
                                              Switch(
                                                overlayColor: overlayColor,
                                                trackColor: trackColor,
                                                thumbColor:
                                                    const MaterialStatePropertyAll<
                                                            Color>(
                                                        Color.fromRGBO(
                                                            190, 190, 190, 1)),
                                                value: coop['isOnlinePay'],
                                                onChanged: (bool value) async {
                                                  showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            elevation: 0,
                                                            content: onWait),
                                                  );

                                                  await myDb
                                                      .collection('coops')
                                                      .doc(widget.coopId)
                                                      .update({
                                                    'isOnlinePay': value,
                                                  });

                                                  await myDb
                                                      .collection('coopInfo')
                                                      .doc(widget.coopId)
                                                      .update({
                                                    'isOnlinePay': value,
                                                  });

                                                  if (value == true) {
                                                    okDialog(
                                                            context,
                                                            'Changed Successfully',
                                                            'Online Payment is now avaialable online')
                                                        .whenComplete(() =>
                                                            Navigator.pop(
                                                                context));
                                                  } else {
                                                    okDialog(
                                                            context,
                                                            'Changed Successfully',
                                                            'Online Payment is now unavaialable')
                                                        .whenComplete(() =>
                                                            Navigator.pop(
                                                                context));
                                                  }
                                                },
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(6),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color:
                                                              coop['isOnlinePay'] ==
                                                                      true
                                                                  ? teal8
                                                                  : red8),
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Text(
                                                      coop['isOnlinePay'] ==
                                                              true
                                                          ? 'AVAILABLE'
                                                          : 'UNAVAILABLE',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              FontNameDefault,
                                                          color:
                                                              coop['isOnlinePay'] ==
                                                                      true
                                                                  ? teal8
                                                                  : red8,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10)),
                                        const Text(
                                          'LOANS',
                                          style: TextStyle(
                                              fontFamily: FontNameDefault,
                                              color: Colors.black,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: data.length,
                                            itemBuilder: (context, index) {
                                              return SizedBox(
                                                height: 52,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      '${data[index].id.toUpperCase()} LOAN: ',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              FontNameDefault,
                                                          color:
                                                              Colors.grey[800],
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                    const Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 3)),
                                                    Switch(
                                                      overlayColor:
                                                          overlayColor,
                                                      trackColor: trackColor,
                                                      thumbColor:
                                                          const MaterialStatePropertyAll<
                                                                  Color>(
                                                              Color.fromRGBO(
                                                                  190,
                                                                  190,
                                                                  190,
                                                                  1)),
                                                      value: data[index]
                                                                  ['status'] ==
                                                              'available'
                                                          ? true
                                                          : false,
                                                      onChanged:
                                                          (bool value) async {
                                                        String val;
                                                        if (value == true) {
                                                          val = 'available';
                                                        } else {
                                                          val = 'unavailable';
                                                        }
                                                        showDialog(
                                                          barrierDismissible:
                                                              false,
                                                          context: context,
                                                          builder: (context) =>
                                                              AlertDialog(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  elevation: 0,
                                                                  content:
                                                                      onWait),
                                                        );

                                                        await myDb
                                                            .collection('coops')
                                                            .doc(widget.coopId)
                                                            .collection(
                                                                'loanTypes')
                                                            .doc(data[index].id)
                                                            .update({
                                                          'status': val,
                                                        });
                                                        if (value == true) {
                                                          okDialog(
                                                                  context,
                                                                  'Changed Successfully',
                                                                  '${data[index].id.toUpperCase()} LOAN is now avaialable')
                                                              .whenComplete(() =>
                                                                  Navigator.pop(
                                                                      context));
                                                        } else {
                                                          okDialog(
                                                                  context,
                                                                  'Changed Successfully',
                                                                  '${data[index].id.toUpperCase()} LOAN is now unavaialable')
                                                              .whenComplete(() =>
                                                                  Navigator.pop(
                                                                      context));
                                                        }
                                                      },
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(6),
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                color: data[index]['status']
                                                                            .toString() ==
                                                                        'available'
                                                                    ? teal8
                                                                    : red8),
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                          child: Text(
                                                            '${data[index]['status'].toUpperCase()}',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    FontNameDefault,
                                                                color: data[index]['status']
                                                                            .toString() ==
                                                                        'available'
                                                                    ? teal8
                                                                    : red8,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                }
                              }
                            } catch (e) {}
                            return Container();
                          });
                  }
                }
              } catch (e) {}
              return Container();
            }),
      ),
    );
  }
}
