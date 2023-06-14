import 'package:ascoop/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class LockPage extends StatefulWidget {
  const LockPage({super.key});

  @override
  State<LockPage> createState() => _LockPageState();
}

class _LockPageState extends State<LockPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Feather.x,
                color: Colors.black,
                size: 26,
              ))
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Feather.lock,
              size: 80,
              color: Colors.grey[800],
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            const Text(
              'Prohibit Access',
              style: TextStyle(
                fontFamily: FontNameDefault,
                fontSize: 30,
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 3)),
            Text(
              'Your account cannot access this page.',
              style: TextStyle(
                fontFamily: FontNameDefault,
                fontSize: 20,
                color: Colors.grey[700],
                fontWeight: FontWeight.w200,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.teal[800],
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 400,
                height: 200,
                child: Image.asset('assets/images/logo_full_coop.png'),
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 0)),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: Image.asset('assets/images/welcome_wave.gif'),
                  ),
                  Text(
                    'Welcome to COOPLend'.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: 50,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 50)),
              SizedBox(
                width: 400,
                height: 70,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      Navigator.pushNamed(context, '/dashboard');
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          'Proceed to Dashboard',
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
                        Icon(
                          Feather.arrow_right,
                          size: 25,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
