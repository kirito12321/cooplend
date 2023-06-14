import 'dart:developer';

import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/route/staff/unblock.dart';
import 'package:ascoop/web_ui/route/subs/header.dart';
import 'package:ascoop/web_ui/styles/inputstyle.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListStaffBlck extends StatefulWidget {
  Function callback;
  ListStaffBlck({
    super.key,
    required this.callback,
  });

  @override
  State<ListStaffBlck> createState() => _ListStaffBlckState();
}

class _ListStaffBlckState extends State<ListStaffBlck> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 480,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        border: Border(
            right: BorderSide(
                width: 1.0, color: Color.fromARGB(255, 203, 203, 203))),
      ),
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: HeaderText(
              Ttl: 'All Blocked Staffs',
              subTtl: 'Blocked Staffs',
            ),
          ),
          Expanded(
            child: StaffList(
              callback: widget.callback,
            ),
          ),
        ],
      ),
    );
  }
}

class StaffList extends StatefulWidget {
  Function callback;
  StaffList({
    super.key,
    required this.callback,
  });

  @override
  State<StaffList> createState() => _StaffListState();
}

class _StaffListState extends State<StaffList> {
  late final TextEditingController _search;
  bool _obscure = true;
  FocusNode myFocusNode = FocusNode();
  String searchStr = "";
  bool isSearch = true;
  @override
  void initState() {
    _search = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
            child: TextFormField(
              style: inputTextStyle,
              keyboardType: TextInputType.emailAddress,
              controller: _search,
              decoration: InputDecoration(
                hintStyle: inputHintTxtStyle,
                focusedBorder: focusSearchBorder,
                border: SearchBorder,
                hintText: "Search Staff's Name",
                prefixIcon: Icon(
                  Feather.search,
                  size: 20,
                  color: Colors.teal[800],
                ),
              ),
              onChanged: (str) {
                setState(() {
                  searchStr = str;
                });
                if (str.isEmpty) {
                  setState(() {
                    isSearch = true;
                  });
                } else {
                  setState(() {
                    isSearch = false;
                  });
                }
              },
            ),
          ),
          Expanded(
            child: StaffBlck(
              searchStr: searchStr,
              callback: widget.callback,
              isSearch: isSearch,
            ),
          ),
        ],
      ),
    );
  }
}

class StaffBlck extends StatefulWidget {
  String searchStr;
  Function callback;
  bool isSearch;
  StaffBlck(
      {this.searchStr = '',
      required this.callback,
      required this.isSearch,
      super.key});

  @override
  State<StaffBlck> createState() => _StaffBlckState();
}

class _StaffBlckState extends State<StaffBlck> {
  late final SharedPreferences prefs;
  late final prefsFuture =
      SharedPreferences.getInstance().then((v) => prefs = v);
  var _controller = ScrollController(keepScrollOffset: true);
  var _staffs = <bool>[];
  int staffCount = 0;
  listStaff(int count) {
    staffCount = count;
    for (int a = 0; a < staffCount; a++) {
      _staffs.add(false);
    }
  }

  selectsub(int num) {
    for (int i = 0; i < staffCount; i++) {
      if (i != num) {
        _staffs[i] = false;
      } else {
        _staffs[i] = true;
      }
    }
  }

  @override
  void dispose() {
    _staffs;
    widget.searchStr;
    staffCount;
    _controller;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: FutureBuilder(
        future: prefsFuture,
        builder: (context, prefs) {
          if (prefs.hasError) {
            return const Center(child: CircularProgressIndicator());
          } else {
            switch (prefs.connectionState) {
              case ConnectionState.waiting:
                return onWait;
              default:
                return StreamBuilder(
                  stream: myDb
                      .collection('staffs')
                      .where('coopID',
                          isEqualTo: prefs.data!.getString('coopId'))
                      .where('isBlock', isEqualTo: true)
                      .orderBy('blockedAt', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    try {
                      final data = snapshot.data!.docs;
                      if (snapshot.hasError) {
                        log('snapshot.hasError (coopdash): ${snapshot.error}');
                        return Container();
                      } else if (snapshot.hasData && data.isNotEmpty) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return onWait;
                          default:
                            listStaff(
                                data.length); //get all subs to array of bool
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Visibility(
                                  visible: widget.isSearch,
                                  child: Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(15, 5, 10, 0),
                                    child: Text(
                                      '${NumberFormat('###,###,###').format(data.length.toInt())} Blocked Staffs',
                                      style: TextStyle(
                                        fontFamily: FontNameDefault,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.red[900],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      controller: _controller,
                                      itemCount: data.length,
                                      itemBuilder: (context, index) {
                                        var StaffLists = InkWell(
                                          onTap: () {
                                            int selectIndex = index;
                                            setState(() {
                                              selectsub(selectIndex);
                                              widget.callback(
                                                data[index]['staffID'],
                                              );
                                            });
                                          },
                                          hoverColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 110,
                                            margin: const EdgeInsets.fromLTRB(
                                                15, 8, 15, 8),
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 8, 0, 8),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                color: _staffs[index] == true
                                                    ? red8
                                                    : Colors.transparent,
                                                width: 2,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: _staffs[index] == true
                                                      ? red8
                                                      : grey4,
                                                  spreadRadius: 0.2,
                                                  blurStyle: BlurStyle.normal,
                                                  blurRadius: 1.6,
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      height: 90,
                                                      width: 90,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                            data[index]
                                                                ['profilePic'],
                                                          ),
                                                          fit: BoxFit.cover,
                                                        ),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 6)),
                                                Expanded(
                                                  child: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height,
                                                    child: Stack(
                                                      children: [
                                                        SizedBox(
                                                          width: 310,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "${data[index]['firstname']} ${data[index]['lastname']}",
                                                                style: h4,
                                                              ),
                                                              const Padding(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              1)),
                                                              Text(
                                                                data[index]
                                                                    ['email'],
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        FontNameMed,
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                            .grey[
                                                                        800],
                                                                    letterSpacing:
                                                                        1.5),
                                                              ),
                                                              const Padding(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              3)),
                                                              Text(
                                                                'Blocked Since ${DateFormat('MMM d, yyyy').format(data[index]['blockedAt'].toDate())}',
                                                                style: const TextStyle(
                                                                    fontFamily:
                                                                        FontNameMed,
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                    color: Colors
                                                                        .black,
                                                                    letterSpacing:
                                                                        1.5),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Positioned(
                                                          right: 0,
                                                          bottom: 35,
                                                          child: UnblockedStaff(
                                                            coopId: prefs.data!
                                                                .getString(
                                                                    'coopId')
                                                                .toString(),
                                                            firstname: data[
                                                                    index]
                                                                ['firstname'],
                                                            fullname:
                                                                "${data[index]['firstname']} ${data[index]['lastname']}",
                                                            email: data[index]
                                                                ['email'],
                                                            index: index,
                                                            staffId: data[index]
                                                                ['staffID'],
                                                            role: data[index]
                                                                ['role'],
                                                            icon: Icon(
                                                              FontAwesomeIcons
                                                                  .ellipsisVertical,
                                                              size: 20,
                                                              color: Colors
                                                                  .grey[800],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );

                                        if (widget.searchStr.trim().isEmpty) {
                                          return StaffLists;
                                        }
                                        if ('${data[index]['firstname']} ${data[index]['lastname']}'
                                            .trim()
                                            .toLowerCase()
                                            .startsWith(widget.searchStr
                                                .trim()
                                                .toString()
                                                .toLowerCase())) {
                                          return StaffLists;
                                        }
                                        if ('${data[index]['firstname']} ${data[index]['lastname']}  '
                                            .trim()
                                            .toUpperCase()
                                            .startsWith(widget.searchStr
                                                .trim()
                                                .toString()
                                                .toLowerCase())) {
                                          return StaffLists;
                                        }
                                        if ('${data[index]['lastname']} ${data[index]['firstname']}'
                                            .trim()
                                            .toLowerCase()
                                            .startsWith(widget.searchStr
                                                .trim()
                                                .toString()
                                                .toLowerCase())) {
                                          return StaffLists;
                                        }
                                        if ('${data[index]['lastname']} ${data[index]['firstname']}'
                                            .trim()
                                            .toUpperCase()
                                            .startsWith(widget.searchStr
                                                .trim()
                                                .toString()
                                                .toLowerCase())) {
                                          return StaffLists;
                                        }

                                        //email
                                        if (data[index]['email']
                                            .toString()
                                            .trim()
                                            .toLowerCase()
                                            .startsWith(widget.searchStr
                                                .trim()
                                                .toString()
                                                .toLowerCase())) {
                                          return StaffLists;
                                        }
                                        if (data[index]['email']
                                            .toString()
                                            .trim()
                                            .toUpperCase()
                                            .startsWith(widget.searchStr
                                                .trim()
                                                .toString()
                                                .toUpperCase())) {
                                          return StaffLists;
                                        }

                                        //role
                                        if (data[index]['role']
                                            .toString()
                                            .trim()
                                            .toUpperCase()
                                            .startsWith(widget.searchStr
                                                .trim()
                                                .toString()
                                                .toUpperCase())) {
                                          return StaffLists;
                                        }
                                        if (data[index]['role']
                                            .toString()
                                            .trim()
                                            .toLowerCase()
                                            .startsWith(widget.searchStr
                                                .trim()
                                                .toString()
                                                .toUpperCase())) {
                                          return StaffLists;
                                        }
                                        return Container();
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            );
                        }
                      } else if (data.isEmpty) {
                        return EmptyData(ttl: 'No Blocked Staffs Yet');
                      }
                    } catch (e) {
                      log('listStaff.dart error (stream): ${e.toString()}');
                    }
                    return Container(/** if null */);
                  },
                );
            }
          }
        },
      ),
    );
  }
}
