import 'package:ascoop/services/database/data_coop.dart';
import 'package:ascoop/services/database/data_service.dart';
import 'package:ascoop/services/database/data_subscription.dart';
import 'package:ascoop/style.dart';
import 'package:ascoop/utilities/view_wallet_options.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardWallet extends StatefulWidget {
  const DashboardWallet({super.key});

  @override
  State<DashboardWallet> createState() => _DashboardWalletState();
}

class _DashboardWalletState extends State<DashboardWallet> {
  final ocCy =
      NumberFormat.currency(decimalDigits: 2, customPattern: '#,###,###.00');
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double screenWidth = size.width;
    return Scaffold(
        appBar: AppBar(
          elevation: 8,
          leading: const BackButton(
            color: Colors.black,
          ),
          title: const Text(
            'Wallet',
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
        body: SafeArea(
          child: Column(
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
                      color: Colors.teal[600]!,
                      elevation: 8,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            // color: Color.fromARGB(153, 237, 241, 242),
                            color: Colors.teal[600],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                child: StreamBuilder<List<DataSubscription>>(
                                  stream: DataService.database().readAllSubs(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                            ConnectionState.active &&
                                        snapshot.hasData) {
                                      final subs = snapshot.data!;
                                      return ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemCount: subs.length,
                                          itemBuilder: (context, index) =>
                                              GestureDetector(
                                                  onTap: () {
                                                    ShowWalletViewOption(
                                                            context: context,
                                                            coopId: subs[index]
                                                                .coopId,
                                                            userId: subs[index]
                                                                .userId)
                                                        .showOptionDialog();
                                                  },
                                                  child: buildWallet(
                                                      size, subs[index])));
                                    } else if (snapshot.hasError &&
                                        snapshot.connectionState ==
                                            ConnectionState.active) {
                                      return Text(
                                          'No data to display ${snapshot.error.toString()}');
                                    } else {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget buildWallet(Size size, DataSubscription subs) {
    double screenHeight = size.height;
    // double screenWidth =size.width;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: PhysicalModel(
        color: Colors.white,
        elevation: 8,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Container(
          height: screenHeight * 0.15,
          margin: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
              // color: Color.fromARGB(153, 237, 241, 242),
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FutureBuilder<CoopInfo?>(
                  future:
                      DataService.database().readCoopData(coopID: subs.coopId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final coop = snapshot.data;
                      return coop == null
                          ? const Text('No Data')
                          : buildCapData(coop, subs);
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCapData(CoopInfo coop, DataSubscription subs) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: coop.profilePic,
              fit: BoxFit.fill,
              width: 60.0,
              height: 60.0,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          const SizedBox(
            width: 30,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Coop Name:',
                style: DashboardNormalTextStyle,
              ),
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  makeFewWords(coop.coopName),
                ),
              ),
              const Text(
                'Capital Share:',
                style: DashboardNormalTextStyle,
              ),
              FutureBuilder<double>(
                future: DataService.database()
                    .getCapitalShare(coopId: coop.coopID, userId: subs.userId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final accData = snapshot.data!;

                    // return SizedBox(
                    //     height: size.height * 0.5,
                    //     width: size.width,
                    //     child: ListView.builder(
                    //       scrollDirection: Axis.vertical,
                    //       itemCount: notif.length,
                    //       itemBuilder: (context, index) =>
                    //           paymentSchedule(notif[index]),
                    //     ));

                    return Center(
                      child: Text('Php${ocCy.format(accData.toDouble())}'),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Php${ocCy.format(0.0)}');
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
              const Text(
                'Savings:',
                style: DashboardNormalTextStyle,
              ),
              FutureBuilder<double>(
                future: DataService.database()
                    .getSavings(coopId: coop.coopID, userId: subs.userId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final accData = snapshot.data!;

                    // return SizedBox(
                    //     height: size.height * 0.5,
                    //     width: size.width,
                    //     child: ListView.builder(
                    //       scrollDirection: Axis.vertical,
                    //       itemCount: notif.length,
                    //       itemBuilder: (context, index) =>
                    //           paymentSchedule(notif[index]),
                    //     ));

                    return Center(
                      child: Text('Php${ocCy.format(accData.toDouble())}'),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Php${ocCy.format(0.0)}');
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ],
          )
        ],
      );

  String makeFewWords(String text) {
    final splitted = text.split(' ');

    return '${splitted.first} Coop';
  }
}
