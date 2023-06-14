import 'package:ascoop/web_ui/styles/buttonstyle.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:flutter/material.dart';

Future<void> okDialog(
  BuildContext context,
  String title,
  String content,
) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: alertDialogTtl,
          ),
          content: Text(
            content,
            style: alertDialogContent,
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ForTealButton,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'OK',
                    style: alertDialogBtn,
                  ),
                )),
          ],
        );
      });
}
