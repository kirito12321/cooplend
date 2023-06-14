import 'package:ascoop/services/database/data_coop.dart';
import 'package:ascoop/services/database/data_service.dart';
import 'package:ascoop/mobile_ui/dashboard_list_view/coop_profile_page.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';

class DashboardCoop extends StatefulWidget {
  const DashboardCoop({super.key});

  @override
  State<DashboardCoop> createState() => _DashboardCoopState();
}

class _DashboardCoopState extends State<DashboardCoop> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double screenWidth = size.width;
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.04,
                  bottom: screenHeight * 0.04,
                  left: screenWidth * 0.06,
                  right: screenWidth * 0.06),
              child: PhysicalModel(
                color: Colors.white,
                elevation: 8,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: Container(
                  margin: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(

                      // color: Color.fromARGB(153, 237, 241, 242),
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Center(
                      child: StreamBuilder<List<CoopInfo>>(
                    stream: DataService.database().readCoopsData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final coops = snapshot.data!;
                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: coops.length,
                            itemBuilder: (context, index) =>
                                buildCoop(coops[index]));
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  )),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCoop(CoopInfo coopInfo) => Column(
        children: [
          ListTile(
            leading: ClipOval(
              child: CachedNetworkImage(
                imageUrl: coopInfo.profilePic,
                width: 60.0,
                height: 60.0,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            title: Text(coopInfo.coopName),
            subtitle: Text(coopInfo.coopAddress),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CoopProfile(coopID: coopInfo.coopID)));
            },
          ),
          const Divider(
            color: Color.fromARGB(255, 19, 13, 13), //color of divider
            height: 20, //height spacing of divider
            thickness: 1, //thickness of divier line
            indent: 0, //spacing at the start of divider
            endIndent: 0, //spacing at the end of divider
          ),
        ],
      );
}
