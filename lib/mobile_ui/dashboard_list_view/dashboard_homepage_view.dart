import 'package:ascoop/services/database/data_user.dart' as dataUser;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modal;

import '../../services/database/data_service.dart';
import '../../style.dart';

class DashboardHome extends StatefulWidget {
  const DashboardHome({
    Key? key,
  }) : super(key: key);

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder<dataUser.UserInfo?>(
      future: DataService.database().readUserData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final user = snapshot.data;

          return user == null
              ? const Text('No Data')
              : buildUserProfile(user, size);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget buildUserProfile(dataUser.UserInfo userInfo, Size size) {
    double screenHeight = size.height;
    double screenWidth = size.width;
    return SafeArea(
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
                  color: Colors.white,
                  elevation: 8,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  // padding: EdgeInsets.all(screenHeight * 0.02),
                  // margin: const EdgeInsets.all(20),
                  // decoration: const BoxDecoration(
                  //     borderRadius: BorderRadius.all(Radius.circular(20)),
                  //     boxShadow: [
                  //       BoxShadow(
                  //           color: Colors.grey,
                  //           blurRadius: 0,
                  //           offset: Offset(-10, -10))
                  //     ]),
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                        // color: Color.fromARGB(153, 237, 241, 242),
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: screenHeight * 0.4,
                          child: Flexible(
                            flex: 1,
                            fit: FlexFit.loose,
                            child: SizedBox(
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 15, 20, 8),
                                            child: SizedBox(
                                              height: 100,
                                              width: 100,
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context)
                                                      .pushNamed(
                                                          '/user/profilepicset/',
                                                          arguments: {
                                                        'userId':
                                                            userInfo.userUID
                                                      });
                                                },
                                                child: ClipOval(
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        userInfo.profilePicUrl!,
                                                    fit: BoxFit.fill,
                                                    width: 60.0,
                                                    height: 60.0,
                                                    placeholder: (context,
                                                            url) =>
                                                        const Center(
                                                            child:
                                                                CircularProgressIndicator()),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                  ),
                                                ),
                                              ),
                                            )),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                userInfo.firstName,
                                                style:
                                                    DashboardUserNameTextStyle,
                                              ), //User Full Name
                                              const Text(
                                                'Email Address:',
                                                style: DashboardNormalTextStyle,
                                              ),
                                              Text((FirebaseAuth.instance
                                                      .currentUser?.email) ??
                                                  'no data'), //User Email Address
                                              const Text('Contact Number:',
                                                  style:
                                                      DashboardNormalTextStyle),
                                              Text(userInfo
                                                  .mobileNo), //User Contact Number
                                              const Text('Birthdate:',
                                                  style:
                                                      DashboardNormalTextStyle),
                                              Text(userInfo.birthDate
                                                  .toString()),
                                              const Text('Address:',
                                                  style:
                                                      DashboardNormalTextStyle),
                                              Text(userInfo.currentAddress),
                                              const SizedBox(
                                                height: 10,
                                              ), //User Birthdate
                                              SizedBox(
                                                height: 50,
                                                width: 200,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    // backgroundColor:
                                                    //     const Color.fromARGB(
                                                    //         255, 32, 207, 208),
                                                    backgroundColor:
                                                        Colors.teal[600],
                                                    shape:
                                                        const StadiumBorder(),
                                                  ),
                                                  onPressed: () async {
                                                    Navigator.of(context)
                                                        .pushNamed(
                                                      '/user/profileinfo/',
                                                    );
                                                  },
                                                  child: const Text('Update'),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),

                                              const SizedBox(
                                                height: 10,
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.loose,
                          child: SizedBox(
                            child: SingleChildScrollView(
                              child: Column(children: [
                                const SizedBox(height: 10),
                                const Divider(
                                  color: Color.fromARGB(
                                      255, 19, 13, 13), //color of divider
                                  height: 0, //height spacing of divider
                                  thickness: 1, //thickness of divier line
                                  indent: 0, //spacing at the start of divider
                                  endIndent: 0, //spacing at the end of divider
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        // '/coop/loanview/',
                                        //  '/coop/loantenureview',
                                        '/user/sendverifCode/',
                                        arguments: {'email': userInfo.email});
                                  },
                                  child: SizedBox(
                                    height: screenHeight * 0.1,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: SizedBox(
                                            height: screenHeight * 0.15,
                                            child: Icon(
                                              Icons.lock_outline,
                                              size: screenHeight * 0.05,
                                            ),
                                          ),
                                        ),
                                        const Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('Login and Security'),
                                              Text('Change Password')
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Divider(
                                  color: Color.fromARGB(
                                      255, 19, 13, 13), //color of divider
                                  height: 0, //height spacing of divider
                                  thickness: 1, //thickness of divier line
                                  indent: 0, //spacing at the start of divider
                                  endIndent: 0, //spacing at the end of divider
                                ),
                                SizedBox(
                                  height: screenHeight * 0.1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: SizedBox(
                                          height: screenHeight * 0.15,
                                          child: Icon(
                                            Icons.notifications_outlined,
                                            size: screenHeight * 0.05,
                                          ),
                                        ),
                                      ),
                                      const Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Notification'),
                                            Text(
                                                'Managing notification sent to you')
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  color: Color.fromARGB(
                                      255, 19, 13, 13), //color of divider
                                  height: 0, //height spacing of divider
                                  thickness: 1, //thickness of divier line
                                  indent: 0, //spacing at the start of divider
                                  endIndent: 0, //spacing at the end of divider
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                      // '/coop/loanview/',
                                      //  '/coop/loantenureview',
                                      '/user/wallet/',
                                    );
                                  },
                                  child: SizedBox(
                                    height: screenHeight * 0.1,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: SizedBox(
                                            height: screenHeight * 0.15,
                                            child: Icon(
                                              Icons.wallet_outlined,
                                              size: screenHeight * 0.05,
                                            ),
                                          ),
                                        ),
                                        const Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('Wallet'),
                                              Text(
                                                  'Check capital share balance')
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
