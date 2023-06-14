
import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/sidenavs/accountant.dart';
import 'package:ascoop/web_ui/sidenavs/admin.dart';
import 'package:ascoop/web_ui/sidenavs/cashier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainNavs extends StatefulWidget {
  const MainNavs({super.key});

  @override
  State<MainNavs> createState() => _MainNavsState();
}

class _MainNavsState extends State<MainNavs> {
  late final SharedPreferences prefs;
  late final prefsFuture =
      SharedPreferences.getInstance().then((v) => prefs = v);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: prefsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: CircularProgressIndicator());
        } else {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return onWait;
            default:
              switch (
                  snapshot.data!.getString('myRole').toString().toLowerCase()) {
                case "administrator":
                  return const AdminNavs();
                case "cashier":
                  return const CashierNavs();
                case "bookkeeper":
                  return const BookNavs();
                default:
                  return Container();
              }
          }
        }
      },
    );
  }
}
