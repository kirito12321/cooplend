import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/route/subs/listsubblck_mob.dart';
import 'package:ascoop/web_ui/route/subs/listsubreq_mob.dart';
import 'package:ascoop/web_ui/route/subs/listsubs_mob.dart';
import 'package:ascoop/web_ui/route/subs/subs_pc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ascoop/web_ui/global_var.dart' as globals;

class SubMobile extends StatefulWidget {
  const SubMobile({super.key});

  @override
  State<SubMobile> createState() => _SubMobileState();
}

class _SubMobileState extends State<SubMobile> {
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
            title: 'Subscriber Management',
            icon: Feather.users,
            align: MainAxisAlignment.center,
            widget: const Align(
              alignment: Alignment.center,
              child: SubHeader(),
            ),
          ),
          const Expanded(
            child: SubContent(),
          ),
        ],
      ),
    );
  }
}

class SubContent extends StatefulWidget {
  const SubContent({super.key});

  @override
  State<SubContent> createState() => _SubContentState();
}

class _SubContentState extends State<SubContent> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: IndexedStack(
            index: globals.subIndex,
            children: [
              ListSubsAct(),
              ListSubsReq(),
              ListSubBlock(),
            ],
          )),
    );
  }
}
