import 'dart:developer';

import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/route/subs/header.dart';
import 'package:ascoop/web_ui/styles/inputstyle.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListSavings extends StatefulWidget {
  Function callback;
  ListSavings({
    super.key,
    required this.callback,
  });

  @override
  State<ListSavings> createState() => _ListSavingsState();
}

class _ListSavingsState extends State<ListSavings> {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderText(
            Ttl: 'All Active Subscribers',
            subTtl: 'Active Subscribers',
          ),
          Expanded(
            child: SubList(
              callback: widget.callback,
            ),
          ),
        ],
      ),
    );
  }
}

class SubList extends StatefulWidget {
  Function callback;
  SubList({
    super.key,
    required this.callback,
  });

  @override
  State<SubList> createState() => _SubListState();
}

class _SubListState extends State<SubList> {
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
                hintText: "Search Subscriber's Name",
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
            child: SubActiveList(
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

class SubActiveList extends StatefulWidget {
  String searchStr;
  Function callback;
  bool isSearch;
  SubActiveList(
      {this.searchStr = '',
      required this.callback,
      required this.isSearch,
      super.key});

  @override
  State<SubActiveList> createState() => _SubActiveListState();
}

class _SubActiveListState extends State<SubActiveList> {
  late final SharedPreferences prefs;
  late final prefsFuture =
      SharedPreferences.getInstance().then((v) => prefs = v);
  var _controller = ScrollController(keepScrollOffset: true);
  var _subs = <bool>[];
  int subCount = 0;
  listSubs(int count) {
    subCount = count;
    for (int a = 0; a < subCount; a++) {
      _subs.add(false);
    }
  }

  selectsub(int num) {
    for (int i = 0; i < subCount; i++) {
      if (i != num) {
        _subs[i] = false;
      } else {
        _subs[i] = true;
      }
    }
  }

  @override
  void dispose() {
    _subs;
    widget.searchStr;
    subCount;
    _controller;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                      .collection('subscribers')
                      .where('coopId',
                          isEqualTo: prefs.data!.getString('coopId'))
                      .where('status', isEqualTo: 'verified')
                      .orderBy('timestamp', descending: true)
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
                            listSubs(
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
                                      '${NumberFormat('###,###,###').format(data.length.toInt())} Active Subscribers',
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
                                        var subLists = InkWell(
                                          onTap: () {
                                            int selectIndex = index;
                                            setState(() {
                                              selectsub(selectIndex);
                                              widget.callback(
                                                  data[index]['userId']);
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
                                                color: _subs[index] == true
                                                    ? teal8
                                                    : Colors.transparent,
                                                width: 2,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: _subs[index] == true
                                                      ? teal8
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
                                                            data[index][
                                                                'profilePicUrl'],
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
                                                                "${data[index]['userFirstName']} ${data[index]['userMiddleName']} ${data[index]['userLastName']}",
                                                                style: h4,
                                                              ),
                                                              const Padding(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              2)),
                                                              Text(
                                                                data[index][
                                                                        'userEmail'] ??
                                                                    data[index][
                                                                        'userMobileNo'],
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
                                                            ],
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
                                          return subLists;
                                        }
                                        if ('${data[index]['userFirstName']} ${data[index]['userMiddleName']} ${data[index]['userLastName']}'
                                            .trim()
                                            .toLowerCase()
                                            .startsWith(widget.searchStr
                                                .trim()
                                                .toString()
                                                .toLowerCase())) {
                                          return subLists;
                                        }
                                        if ('${data[index]['userFirstName']} ${data[index]['userLastName']} ${data[index]['userMiddleName']}'
                                            .trim()
                                            .toLowerCase()
                                            .startsWith(widget.searchStr
                                                .trim()
                                                .toString()
                                                .toLowerCase())) {
                                          return subLists;
                                        }
                                        if ('${data[index]['userMiddleName']} ${data[index]['userFirstName']} ${data[index]['userLastName']}'
                                            .trim()
                                            .toLowerCase()
                                            .startsWith(widget.searchStr
                                                .trim()
                                                .toString()
                                                .toLowerCase())) {
                                          return subLists;
                                        }
                                        if ('${data[index]['userMiddleName']} ${data[index]['userLastName']} ${data[index]['userFirstName']}'
                                            .trim()
                                            .toLowerCase()
                                            .startsWith(widget.searchStr
                                                .trim()
                                                .toString()
                                                .toLowerCase())) {
                                          return subLists;
                                        }
                                        if ('${data[index]['userLastName']} ${data[index]['userMiddleName']} ${data[index]['userFirstName']}'
                                            .trim()
                                            .toLowerCase()
                                            .startsWith(widget.searchStr
                                                .trim()
                                                .toString()
                                                .toLowerCase())) {
                                          return subLists;
                                        }
                                        if ('${data[index]['userLastName']} ${data[index]['userFirstName']} ${data[index]['userMiddleName']}'
                                            .trim()
                                            .toLowerCase()
                                            .startsWith(widget.searchStr
                                                .trim()
                                                .toString()
                                                .toLowerCase())) {
                                          return subLists;
                                        }

                                        //reciprocal
                                        if ('${data[index]['userFirstName']} ${data[index]['userMiddleName']} ${data[index]['userLastName']}'
                                            .trim()
                                            .toUpperCase()
                                            .startsWith(widget.searchStr
                                                .trim()
                                                .toString()
                                                .toUpperCase())) {
                                          return subLists;
                                        }
                                        if ('${data[index]['userFirstName']} ${data[index]['userLastName']} ${data[index]['userMiddleName']}'
                                            .trim()
                                            .toUpperCase()
                                            .startsWith(widget.searchStr
                                                .trim()
                                                .toString()
                                                .toUpperCase())) {
                                          return subLists;
                                        }
                                        if ('${data[index]['userMiddleName']} ${data[index]['userFirstName']} ${data[index]['userLastName']}'
                                            .trim()
                                            .toUpperCase()
                                            .startsWith(widget.searchStr
                                                .trim()
                                                .toString()
                                                .toUpperCase())) {
                                          return subLists;
                                        }
                                        if ('${data[index]['userMiddleName']} ${data[index]['userLastName']} ${data[index]['userFirstName']}'
                                            .trim()
                                            .toUpperCase()
                                            .startsWith(widget.searchStr
                                                .trim()
                                                .toString()
                                                .toUpperCase())) {
                                          return subLists;
                                        }
                                        if ('${data[index]['userLastName']} ${data[index]['userMiddleName']} ${data[index]['userFirstName']}'
                                            .trim()
                                            .toUpperCase()
                                            .startsWith(widget.searchStr
                                                .trim()
                                                .toString()
                                                .toUpperCase())) {
                                          return subLists;
                                        }
                                        if ('${data[index]['userLastName']} ${data[index]['userFirstName']} ${data[index]['userMiddleName']}'
                                            .trim()
                                            .toUpperCase()
                                            .startsWith(widget.searchStr
                                                .trim()
                                                .toString()
                                                .toUpperCase())) {
                                          return subLists;
                                        }

                                        //email
                                        if (data[index]['userEmail']
                                            .toString()
                                            .trim()
                                            .toLowerCase()
                                            .startsWith(widget.searchStr
                                                .trim()
                                                .toString()
                                                .toLowerCase())) {
                                          return subLists;
                                        }
                                        if (data[index]['userEmail']
                                            .toString()
                                            .trim()
                                            .toUpperCase()
                                            .startsWith(widget.searchStr
                                                .trim()
                                                .toString()
                                                .toUpperCase())) {
                                          return subLists;
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
                        return EmptyData(ttl: 'No Active Subscriber Yet');
                      }
                    } catch (e) {
                      log('listsubs.dart error (stream): ${e.toString()}');
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
