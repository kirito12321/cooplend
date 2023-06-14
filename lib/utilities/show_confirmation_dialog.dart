import 'package:flutter/material.dart';

class ShowConfirmationDialog {
  final BuildContext context;
  final String title;
  final String body;
  final String fBtnName;
  final String sBtnName;

  ShowConfirmationDialog({
    required this.context,
    required this.title,
    required this.body,
    required this.fBtnName,
    required this.sBtnName,
  });

  Future<bool?> showConfirmationDialog() {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title),
            const SizedBox(
              height: 12,
            ),
            Text(body),
            const SizedBox(
              height: 12,
            ),
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 32,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text(fBtnName)),
                  const SizedBox(
                    width: 12,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text(sBtnName)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
