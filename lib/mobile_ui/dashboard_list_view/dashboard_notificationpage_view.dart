import 'package:ascoop/services/database/data_service.dart';
import 'package:ascoop/services/database/data_user_notification.dart';
import 'package:flutter/material.dart';

class DashboardNotification extends StatefulWidget {
  const DashboardNotification({super.key});

  @override
  State<DashboardNotification> createState() => _DashboardNotificationState();
}

class _DashboardNotificationState extends State<DashboardNotification> {
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
                      child: StreamBuilder<List<DataUserNotification>>(
                    stream: DataService.database().readUserNotifications(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final notif = snapshot.data!;
                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: notif.length,
                            itemBuilder: (context, index) =>
                                buildNotifListTile(notif[index]));
                      } else if (snapshot.hasError) {
                        return Text(
                            'there is something error! ${snapshot.hasError.toString()}');
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

  Widget buildNotifListTile(DataUserNotification notif) => Column(
        children: [
          GestureDetector(
            onTap: () {
              DataService.database()
                  .updateNotifStatus(notifID: notif.notifID)
                  .then((value) => Navigator.of(context).pushNamed(
                        '/user/notificationview/',
                        arguments: {
                          'notifImageUrl': notif.notifImageUrl,
                          'notifTitle': notif.notifTitle ?? 'No Title',
                          'notifText': notif.notifText ?? 'No Subtitle'
                        },
                      ));
            },
            child: ListTile(
              leading: CircleAvatar(
                  backgroundColor: Colors.white30,
                  backgroundImage: notif.notifImageUrl != null
                      ? NetworkImage(notif.iconUrl!)
                      : null),
              title: Text(notif.notifTitle ?? "no title"),
              subtitle: Text(notif.notifText ?? "no subtitle"),
            ),
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
