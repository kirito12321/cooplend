import 'package:ascoop/services/database/data_service.dart';
import 'package:ascoop/services/database/data_subscription.dart';
import 'package:ascoop/style.dart';
import 'package:flutter/material.dart';

class SubscriptionReq extends StatefulWidget {
  final String coopID;
  final String userID;
  const SubscriptionReq(
      {super.key, required this.coopID, required this.userID});

  @override
  State<SubscriptionReq> createState() => _SubscriptionReqState();
}

class _SubscriptionReqState extends State<SubscriptionReq> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenWidth = size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'King Coop',
          style: dashboardMemberTextStyle,
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
      body: FutureBuilder<DataSubscription?>(
          future: DataService.database()
              .readSubscriptions(coopID: widget.coopID, userID: widget.userID),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(
                  'there is something error! ${snapshot.hasError.toString()}');
            } else if (snapshot.hasData) {
              final subs = snapshot.data!;

              return buildSubscription(subs);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Widget buildSubscription(DataSubscription subs) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Text(
                '${subs.userFirstName} ${subs.userMiddleName} ${subs.userLastName} '),
          ),
        ],
      ),
    );
  }
}
