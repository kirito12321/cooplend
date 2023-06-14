import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/route/staff/listblock_mob.dart';
import 'package:ascoop/web_ui/route/staff/liststaff_mob.dart';
import 'package:ascoop/web_ui/route/staff/staff_pc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ascoop/web_ui/global_var.dart' as globals;

class StaffMgtMobile extends StatefulWidget {
  const StaffMgtMobile({super.key});

  @override
  State<StaffMgtMobile> createState() => _StaffMgtMobileState();
}

class _StaffMgtMobileState extends State<StaffMgtMobile> {
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
            align: MainAxisAlignment.center,
            widget: const Align(
              alignment: Alignment.center,
              child: StaffMgtHeader(),
            ),
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
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: IndexedStack(
            index: globals.staffIndex,
            children: const [
              ListStaffAct(),
              ListStaffBlck(),
            ],
          )),
    );
  }
}
