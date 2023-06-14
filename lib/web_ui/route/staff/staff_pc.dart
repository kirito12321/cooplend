import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/route/staff/listblock.dart';
import 'package:ascoop/web_ui/route/staff/liststaff.dart';
import 'package:ascoop/web_ui/route/staff/profile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ascoop/web_ui/global_var.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class StaffMgtPc extends StatefulWidget {
  const StaffMgtPc({super.key});

  @override
  State<StaffMgtPc> createState() => _StaffMgtPcState();
}

class _StaffMgtPcState extends State<StaffMgtPc> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ContextHeader(
            title: 'Staff Management',
            icon: FontAwesomeIcons.userShield,
            widget: const StaffMgtHeader(),
          ),
          const Expanded(
            child: StaffContent(),
          ),
        ],
      ),
    );
  }
}

class StaffContent extends StatefulWidget {
  const StaffContent({super.key});

  @override
  State<StaffContent> createState() => _StaffContentState();
}

class _StaffContentState extends State<StaffContent> {
  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: globals.staffIndex,
      children: const [
        StaffAct(),
        StaffBlck(),
      ],
    );
  }
}

class StaffAct extends StatefulWidget {
  const StaffAct({super.key});

  @override
  State<StaffAct> createState() => _StaffActState();
}

class _StaffActState extends State<StaffAct> {
  String staffId = '';
  callback(String staffid) {
    setState(() {
      staffId = staffid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListStaffAct(
            callback: callback,
          ),
          Expanded(
            child: StaffProfile(
              staffId: staffId,
            ),
          ),
        ],
      ),
    );
  }
}

class StaffBlck extends StatefulWidget {
  const StaffBlck({super.key});

  @override
  State<StaffBlck> createState() => _StaffBlckState();
}

class _StaffBlckState extends State<StaffBlck> {
  String staffId = '';
  callback(String staffid) {
    setState(() {
      staffId = staffid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListStaffBlck(
            callback: callback,
          ),
          Expanded(
            child: StaffProfile(
              staffId: staffId,
            ),
          ),
        ],
      ),
    );
  }
}

class StaffMgtHeader extends StatefulWidget {
  const StaffMgtHeader({super.key});

  @override
  State<StaffMgtHeader> createState() => _StaffMgtHeaderState();
}

class _StaffMgtHeaderState extends State<StaffMgtHeader> {
  late final SharedPreferences prefs;
  late final prefsFuture =
      SharedPreferences.getInstance().then((v) => prefs = v);

  void select(int n) {
    for (int i = 0; i < globals.headnavstaff.length; i++) {
      if (i != n) {
        globals.headnavstaff[i] = false;
      } else {
        globals.headnavstaff[i] = true;
      }
    }
  }

  int notifReq = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: ScrollConfiguration(
        behavior: MyCustomScrollBehavior(),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                  hoverColor: Colors.transparent,
                  onTap: () {
                    setState(() {
                      select(0);
                      globals.staffIndex = 0;
                    });
                    Navigator.pushReplacementNamed(context, '/staffs');
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: globals.headnavstaff[0] == true
                          ? Colors.teal[800]
                          : Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromARGB(255, 174, 171, 171),
                            spreadRadius: 0,
                            blurStyle: BlurStyle.normal,
                            blurRadius: 0.9),
                      ],
                    ),
                    child: Text(
                      'Staffs',
                      style: GoogleFonts.montserrat(
                          color: globals.headnavstaff[0] == true
                              ? Colors.white
                              : Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  )),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 3)),
              InkWell(
                  hoverColor: Colors.transparent,
                  onTap: () {
                    setState(() {
                      select(1);
                      globals.staffIndex = 1;
                    });
                    Navigator.pushReplacementNamed(context, '/staffs/blocked');
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: globals.headnavstaff[1] == true
                          ? Colors.red[800]
                          : Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromARGB(255, 174, 171, 171),
                            spreadRadius: 0,
                            blurStyle: BlurStyle.normal,
                            blurRadius: 0.9),
                      ],
                    ),
                    child: Text(
                      'Blocked Staffs',
                      style: GoogleFonts.montserrat(
                          color: globals.headnavstaff[1] == true
                              ? Colors.white
                              : Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
