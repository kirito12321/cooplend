import 'package:ascoop/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class DashboardSettings extends StatefulWidget {
  const DashboardSettings({super.key});

  @override
  State<DashboardSettings> createState() => _DashboardSettingsState();
}

class _DashboardSettingsState extends State<DashboardSettings> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                        // color: Color.fromARGB(153, 237, 241, 242),
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 50,
                          width: 200,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              // backgroundColor:
                              //     const Color.fromARGB(
                              //         255, 32, 207, 208),
                              backgroundColor: Colors.teal[600],
                              shape: const StadiumBorder(),
                            ),
                            onPressed: () async {
                              AuthService.firebase().logOut().then((value) =>
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      '/login/', (route) => false));
                            },
                            child: const Text('Logout'),
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
