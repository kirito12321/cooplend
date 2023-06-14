import 'package:flutter/material.dart';

class ShowAlertDialog {
  final BuildContext context;
  final String title;
  final String body;
  final String btnName;

  ShowAlertDialog(
      {required this.context,
      required this.title,
      required this.body,
      required this.btnName});

  Future<bool?> showAlertDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          OutlinedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(btnName))
        ],
      ),
    );
  }
}
