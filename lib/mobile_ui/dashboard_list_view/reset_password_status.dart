import 'package:ascoop/style.dart';
import 'package:flutter/material.dart';

class ResetPasswordStat extends StatefulWidget {
  const ResetPasswordStat({super.key});

  @override
  State<ResetPasswordStat> createState() => _ResetPasswordStatState();
}

class _ResetPasswordStatState extends State<ResetPasswordStat> {
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
            'Coop Lend',
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
                      color: Colors.white,
                      elevation: 8,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                            // color: Color.fromARGB(153, 237, 241, 242),
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Center(
                              child: Text(
                                'Succesfuly sent reset password link in your email',
                                style: LoginTextStyle,
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * 0.1,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      '/dashboard/', (route) => false);
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal[600],
                                    shape: const StadiumBorder()),
                                child: const Text('Close')),
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
}
