import 'package:flutter/cupertino.dart';

class NotifPreview extends StatefulWidget {
  const NotifPreview({super.key});

  @override
  State<NotifPreview> createState() => _NotifPreviewState();
}

class _NotifPreviewState extends State<NotifPreview> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Container(),
    );
  }
}
