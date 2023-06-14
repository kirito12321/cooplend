import 'dart:developer';

import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/route/staff/addstaff.dart';
import 'package:ascoop/web_ui/route/staff/profile.dart';
import 'package:ascoop/web_ui/route/staff/blocked.dart';
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

class ListStaffAct extends StatefulWidget {
  const ListStaffAct({
    super.key,
  });

  @override
  State<ListStaffAct> createState() => _ListStaffActState();
}

class _ListStaffActState extends State<ListStaffAct> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HeaderText(
                  Ttl: 'All Staffs',
                  subTtl: 'Staffs',
                ),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const AddStaff(),
                    );
                  },
                  child: Text(
                    'Add Staff',
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        color: Colors.teal[800],
                        fontSize: 15,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
          const Expanded(
            child: StaffList(),
          ),
        ],
      ),
    );
  }
}

class StaffList extends StatefulWidget {
  const StaffList({
    super.key,
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
            child: StaffAct(
              searchStr: searchStr,
              isSearch: isSearch,
            ),
          ),
        ],
      ),
    );
  }
}

class StaffAct extends StatefulWidget {
  String searchStr;
  bool isSearch;
  StaffAct({this.searchStr = '', required this.isSearch, super.key});

  @override
  State<StaffAct> createState() => _StaffActState();
}

class _StaffActState extends State<StaffAct> {
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
                      .where('isBlock', isEqualTo: false)
                      .where('staffID',
                          isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
                                      '${NumberFormat('###,###,###').format(data.length.toInt())} Staffs',
                                      style: TextStyle(
                                        fontFamily: FontNameDefault,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[900],
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
                                            int sel = index;
                                            setState(() {
                                              selectsub(sel);
                                            });
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfileStaffMob(
                                                  name:
                                                      '${data[sel]['firstname']} ${data[sel]['lastname']}',
                                                  staffId: data[sel]['staffID'],
                                                ),
                                              ),
                                            );
                                          },
                                          hoverColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
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
                                                color: Colors.transparent,
                                                width: 2,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: grey4,
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
                                                              Builder(builder:
                                                                  (context) {
                                                                if (data[index][
                                                                            'role']
                                                                        .toString()
                                                                        .toLowerCase() ==
                                                                    'administrator') {
                                                                  return Text(
                                                                    data[index][
                                                                        'role'],
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            FontNameDefault,
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        color: Colors.teal[
                                                                            800],
                                                                        letterSpacing:
                                                                            1.5),
                                                                  );
                                                                } else if (data[index]
                                                                            [
                                                                            'role']
                                                                        .toString()
                                                                        .toLowerCase() ==
                                                                    'cashier') {
                                                                  return Text(
                                                                    data[index][
                                                                        'role'],
                                                                    style: const TextStyle(
                                                                        fontFamily:
                                                                            FontNameDefault,
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        color: Colors
                                                                            .black,
                                                                        letterSpacing:
                                                                            1.5),
                                                                  );
                                                                } else {
                                                                  return Text(
                                                                    data[index][
                                                                        'role'],
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            FontNameDefault,
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        color: Colors.orange[
                                                                            800],
                                                                        letterSpacing:
                                                                            1.5),
                                                                  );
                                                                }
                                                              }),
                                                            ],
                                                          ),
                                                        ),
                                                        Positioned(
                                                          right: 0,
                                                          bottom: 35,
                                                          child: BlockedStaff(
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
                        return EmptyData(ttl: 'No Staffs Yet');
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

class ProfileStaffMob extends StatefulWidget {
  String name, staffId;
  ProfileStaffMob({
    super.key,
    required this.name,
    required this.staffId,
  });

  @override
  State<ProfileStaffMob> createState() => _ProfileStaffMobState();
}

class _ProfileStaffMobState extends State<ProfileStaffMob> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.7,
        title: Text(
          widget.name,
          style: const TextStyle(
            fontFamily: FontNameDefault,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        leading: InkWell(
          hoverColor: Colors.white,
          splashColor: Colors.white,
          highlightColor: Colors.white,
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            FontAwesomeIcons.arrowLeft,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: StreamBuilder(
          stream: myDb
              .collection('staffs')
              .where('staffID', isEqualTo: widget.staffId)
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
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(15),
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 200,
                                    height: 200,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            data[index]['profilePic'],
                                          ),
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                  Expanded(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.all(10),
                                      margin: const EdgeInsets.only(left: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${data[index]['firstname']} ${data[index]['lastname']}",
                                            style: h3,
                                          ),
                                          const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 1)),
                                          Text(
                                            data[index]['email'],
                                            style: h5,
                                          ),
                                          const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 3)),
                                          Text(
                                            '${data[index]['role']} Since ${DateFormat('MMMM d, yyyy').format(data[index]['timestamp'].toDate())}',
                                            style: TextStyle(
                                              color: Colors.grey[800],
                                              fontFamily: FontNameDefault,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10)),
                                          Builder(
                                            builder: (context) {
                                              if (data[index]['isBlock'] ==
                                                  false) {
                                                switch (data[index]['role']
                                                    .toString()
                                                    .toLowerCase()) {
                                                  case 'administrator':
                                                    return Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 10),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .teal[800],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6)),
                                                          child: Row(
                                                            children: const [
                                                              Text(
                                                                'Administrator',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        FontNameDefault,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: Colors
                                                                        .white,
                                                                    letterSpacing:
                                                                        0.5),
                                                              ),
                                                              Padding(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              5)),
                                                              Icon(
                                                                FontAwesomeIcons
                                                                    .star,
                                                                color: Colors
                                                                    .white,
                                                                size: 18,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  case 'bookkeeper':
                                                    return Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 10),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .orange[800],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6)),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: const [
                                                              Text(
                                                                'Bookkeeper',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        FontNameDefault,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: Colors
                                                                        .white,
                                                                    letterSpacing:
                                                                        0.5),
                                                              ),
                                                              Padding(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              5)),
                                                              Icon(
                                                                FontAwesomeIcons
                                                                    .calculator,
                                                                color: Colors
                                                                    .white,
                                                                size: 18,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        BlockedStaff(
                                                          coopId: data[index]
                                                              ['coopID'],
                                                          firstname: data[index]
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
                                                            Feather.settings,
                                                            size: 20,
                                                            color: Colors
                                                                .grey[800],
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  default:
                                                    return Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 10),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.black,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6)),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: const [
                                                              Text(
                                                                'Cashier',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        FontNameDefault,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: Colors
                                                                        .white,
                                                                    letterSpacing:
                                                                        0.5),
                                                              ),
                                                              Padding(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              5)),
                                                              Icon(
                                                                FontAwesomeIcons
                                                                    .cashRegister,
                                                                color: Colors
                                                                    .white,
                                                                size: 18,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        BlockedStaff(
                                                          coopId: data[index]
                                                              ['coopID'],
                                                          firstname: data[index]
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
                                                            Feather.settings,
                                                            size: 20,
                                                            color: Colors
                                                                .grey[800],
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                }
                                              } else {
                                                return Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 10),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Colors.red[800],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6)),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: const [
                                                          Text(
                                                            'Blocked Staff',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    FontNameDefault,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Colors
                                                                    .white,
                                                                letterSpacing:
                                                                    0.5),
                                                          ),
                                                          Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          5)),
                                                          Icon(
                                                            Feather.slash,
                                                            color: Colors.white,
                                                            size: 18,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    UnblockedStaff(
                                                      coopId: data[index]
                                                          ['coopID'],
                                                      firstname: data[index]
                                                          ['firstname'],
                                                      fullname:
                                                          "${data[index]['firstname']} ${data[index]['lastname']}",
                                                      email: data[index]
                                                          ['email'],
                                                      index: index,
                                                      staffId: data[index]
                                                          ['staffID'],
                                                      role: data[index]['role'],
                                                      icon: Icon(
                                                        Feather.settings,
                                                        size: 20,
                                                        color: Colors.grey[800],
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const StaffProfHeader(),
                                  Expanded(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: grey4,
                                            spreadRadius: 0.2,
                                            blurStyle: BlurStyle.normal,
                                            blurRadius: 0.6,
                                          ),
                                        ],
                                        color: Colors.white,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                      ),
                                      child: IndexedStack(
                                        index: staffprofIndex,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: StreamBuilder(
                                              stream: myDb
                                                  .collection('staffs')
                                                  .doc(widget.staffId)
                                                  .collection('transactions')
                                                  .orderBy('timestamp',
                                                      descending: true)
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                try {
                                                  final data =
                                                      snapshot.data!.docs;
                                                  if (snapshot.hasError) {
                                                    log('snapshot.hasError (coopdash): ${snapshot.error}');
                                                    return Container();
                                                  } else if (snapshot.hasData &&
                                                      data.isNotEmpty) {
                                                    switch (snapshot
                                                        .connectionState) {
                                                      case ConnectionState
                                                          .waiting:
                                                        return onWait;
                                                      default:
                                                        return ListView.builder(
                                                          shrinkWrap: true,
                                                          itemCount: snapshot
                                                              .data!
                                                              .docs
                                                              .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return Container(
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                  boxShadow: const [
                                                                    BoxShadow(
                                                                        // color: Color.fromARGB(
                                                                        //     255, 156, 156, 156),
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            156,
                                                                            156,
                                                                            156),
                                                                        spreadRadius:
                                                                            0.8,
                                                                        blurStyle:
                                                                            BlurStyle
                                                                                .normal,
                                                                        blurRadius:
                                                                            0.8),
                                                                  ]),
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(8),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          '${data[index]['title']}',
                                                                          style:
                                                                              const TextStyle(
                                                                            fontFamily:
                                                                                FontNameDefault,
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.w800,
                                                                            letterSpacing:
                                                                                1,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                        const Padding(
                                                                            padding:
                                                                                EdgeInsets.symmetric(vertical: 2)),
                                                                        Text(
                                                                          data[index]['content']
                                                                              .toString()
                                                                              .substring(4),
                                                                          style:
                                                                              const TextStyle(
                                                                            fontFamily:
                                                                                FontNameDefault,
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            letterSpacing:
                                                                                1,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Container(
                                                                        padding:
                                                                            const EdgeInsets.all(4),
                                                                        child:
                                                                            Text(
                                                                          DateFormat('MMM d, yyyy  hh:mm a')
                                                                              .format(data[index]['timestamp'].toDate())
                                                                              .toUpperCase(),
                                                                          style:
                                                                              const TextStyle(
                                                                            fontFamily:
                                                                                FontNameDefault,
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            letterSpacing:
                                                                                1,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
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
                                                  } else if (data.isEmpty) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 50.0),
                                                      child: EmptyData(
                                                          ttl:
                                                              'No Transactions History Yet'),
                                                    );
                                                  }
                                                } catch (e) {
                                                  log(e.toString());
                                                }
                                                return Container();
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                }
              } else if (data.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/click_showprof.gif',
                      color: Colors.black,
                      scale: 3,
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                    const Text(
                      "Select staff's name to view their profile",
                      style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: 25,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                );
              }
            } catch (e) {
              log('profile.dart error (stream): ${e}');
            }
            return Container();
          },
        ),
      ),
    );
  }
}

class StaffProfHeader extends StatefulWidget {
  const StaffProfHeader({super.key});

  @override
  State<StaffProfHeader> createState() => _StaffProfHeaderState();
}

class _StaffProfHeaderState extends State<StaffProfHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 30, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              color: Colors.teal[800],
              boxShadow: const [
                BoxShadow(
                    color: Color.fromARGB(255, 174, 171, 171),
                    spreadRadius: 0,
                    blurStyle: BlurStyle.normal,
                    blurRadius: 0.9),
              ],
            ),
            child: const Text(
              'Transaction History',
              style: TextStyle(
                  fontFamily: FontNameDefault,
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
