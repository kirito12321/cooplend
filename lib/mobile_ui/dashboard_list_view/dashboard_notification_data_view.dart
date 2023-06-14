import 'package:ascoop/style.dart';
import 'package:flutter/material.dart';

class DashboardNotifDataView extends StatefulWidget {
  const DashboardNotifDataView({super.key});

  @override
  State<DashboardNotifDataView> createState() => _DashboardNotifDataViewState();
}

class _DashboardNotifDataViewState extends State<DashboardNotifDataView> {
  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double screenWidth = size.width;
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.black,
          ),
          title: Wrap(
            children: [
              Text(
                arguments['notifTitle'],
                style: dashboardMemberTextStyle,
              ),
            ],
          ),
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Image(
                  image: AssetImage('assets/images/cooplendlogo.png')),
              padding: const EdgeInsets.all(2.0),
              iconSize: screenWidth * 0.4,
              onPressed: () {},
            )
          ],
        ),
        body: Column(
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Wrap(
                            children: [
                              const CircleAvatar(),
                              Text(
                                arguments['notifTitle'] ?? 'no Title',
                                style: DashboardNormalTextStyle,
                              ),
                            ],
                          ),
                          SizedBox(
                              height: 20,
                              width: 60,
                              child: Wrap(
                                children: [
                                  Text(
                                    arguments['notifText'] ?? 'No Text',
                                    style: DashboardNormalTextStyle,
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
