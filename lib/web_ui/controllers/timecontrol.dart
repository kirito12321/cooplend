import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimestampDisplay extends StatefulWidget {
  DateTime date;
  TimestampDisplay({super.key, required this.date});

  @override
  State<TimestampDisplay> createState() => _TimestampDisplayState();
}

class _TimestampDisplayState extends State<TimestampDisplay> {
  @override
  Widget build(BuildContext context) {
    var notifDate = DateTime.now().difference(widget.date);
    if (notifDate.inSeconds.toDouble() < 60 && notifDate.inMicroseconds > 0) {
      return Text('now', style: btnForgotTxtStyle);
    }
    //minutes
    if (notifDate.inSeconds.toDouble() >= 60 &&
        notifDate.inSeconds.toDouble() < 120) {
      return Text(
          '${NumberFormat('0').format(notifDate.inMinutes.toDouble())} minute ago',
          style: btnForgotTxtStyle);
    }
    if (notifDate.inSeconds.toDouble() >= 120 &&
        notifDate.inSeconds.toDouble() < 3600) {
      return Text(
          '${NumberFormat('0').format(notifDate.inMinutes.toDouble())} minutes ago',
          style: btnForgotTxtStyle);
    }
    //hours
    if (notifDate.inHours.toDouble() == 1) {
      return Text(
          '${NumberFormat('0').format(notifDate.inHours.toDouble())} hour ago',
          style: btnForgotTxtStyle);
    }
    if (notifDate.inHours.toDouble() <= 24 &&
        notifDate.inHours.toDouble() > 1) {
      return Text(
          '${NumberFormat('0').format(notifDate.inHours.toDouble())} hours ago',
          style: btnForgotTxtStyle);
    }
    if (notifDate.inHours.toDouble() != 24 &&
        notifDate.inHours.toDouble() < 168) {
      return Text(
          '${NumberFormat('0').format(notifDate.inHours.toDouble() / 24)} days ago',
          style: btnForgotTxtStyle);
    }
    //weeks
    if (notifDate.inHours.toDouble() >= 168 &&
        notifDate.inHours.toDouble() < 336) {
      return Text(
          '${NumberFormat('0').format(notifDate.inHours.toDouble() / 168)} week ago',
          style: btnForgotTxtStyle);
    }
    if (notifDate.inHours.toDouble() >= 336 &&
        notifDate.inHours.toDouble() <= 672) {
      return Text(
          '${NumberFormat('0').format(notifDate.inHours.toDouble() / 168)} weeks ago',
          style: btnForgotTxtStyle);
    } else {
      return Text(DateFormat('MMM d, yyyy hh:mm a').format(widget.date),
          style: btnForgotTxtStyle);
    }
  }
}
