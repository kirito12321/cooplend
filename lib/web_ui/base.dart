
import 'package:ascoop/web_ui/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResponsiveBaseLayout extends StatefulWidget {
  final Widget mobileScaffold;
  final Widget tabletScaffold;
  final Widget desktopScaffold;
  const ResponsiveBaseLayout(
      {required this.mobileScaffold,
      required this.tabletScaffold,
      required this.desktopScaffold,
      super.key});

  @override
  State<ResponsiveBaseLayout> createState() => _ResponsiveBaseLayoutState();
}

class _ResponsiveBaseLayoutState extends State<ResponsiveBaseLayout> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (FirebaseAuth.instance.currentUser != null) {
        if (constraints.maxWidth < 1150) {
          return widget.tabletScaffold;
        } else {
          return widget.desktopScaffold;
        }
      } else {
        return const WebLoginView();
      }
    });
  }
}

// class ResponsiveBaseLayout extends StatelessWidget {
//   final Widget mobileScaffold;
//   final Widget tabletScaffold;
//   final Widget desktopScaffold;

//   const ResponsiveBaseLayout({
//     super.key,
//     required this.mobileScaffold,
//     required this.tabletScaffold,
//     required this.desktopScaffold,
//   });
  
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(builder: (context, constraints) {
//       if (FirebaseAuth.instance.currentUser != null) {
//         if (constraints.maxWidth < 700) {
//           return mobileScaffold;
//         } else if (constraints.maxWidth < 1100) {
//           return tabletScaffold;
//         } else {
//           return desktopScaffold;
//         }
//       } else {
//         return const WebLoginView();
//       }
//     });
//   }
// }
