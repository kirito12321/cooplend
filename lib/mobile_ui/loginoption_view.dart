

import 'package:ascoop/style.dart';
import 'package:flutter/material.dart';


class LoginOption extends StatefulWidget {
  const LoginOption({Key? key}) : super(key: key);

  @override
  State<LoginOption> createState() => _LoginOptionState();
}

class _LoginOptionState extends State<LoginOption> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 104, 102, 102),
          image: DecorationImage(image: AssetImage('assets/images/wallpaper.jpg'),
          fit: BoxFit.cover)
        ),
        child: Center(
          child: Container(
              height: 400.0,
              width: 350.0,
              padding: const EdgeInsets.all(10.0),
              decoration:const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [BoxShadow(color: Color.fromARGB(255, 174, 171, 171), spreadRadius: 0, blurStyle: BlurStyle.normal, blurRadius: 45.0)]
              ),child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20,70,20,5),
                    child: Center(
                      child: Container(
                        height: 50.0,
                        width: 230.0,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 29, 206, 240),
                          borderRadius:  BorderRadius.all(Radius.circular(20))
                        ),
                        child: TextButton(onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil('/login/', (route) => false);
                        }, child: const Text('Cooperative', style: LoginOptionBtnTextStyle,)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0,5,20.0,5),
                    child: Center(
                      child: Container(
                        height: 50.0,
                          width: 230.0,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 29, 206, 240),
                            borderRadius:  BorderRadius.all(Radius.circular(20))
                          ),
                        child: TextButton(onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil('/login/', (route) => false);
                        }, child: const Text('Member', style: LoginOptionBtnTextStyle,)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,40,0,0),
                    child: Center(
                      child: Container(
                        height: 100.0,
                        width: 230.0,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
                          image: DecorationImage(image: AssetImage('assets/images/cooplendlogo.png'),
                          fit: BoxFit.cover)
                        ),
                      ),
                    ),
                  )
                ],
              ),
          ),
        ),
        

      ),
    );
  }
}