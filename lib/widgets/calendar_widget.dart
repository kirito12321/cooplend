import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarWidget extends StatelessWidget {
  final DateTime initialDate;
  const CalendarWidget({required this.initialDate, super.key});

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      blackoutDates: blackList(initialDate),
      blackoutDatesTextStyle: const TextStyle(
          fontStyle: FontStyle.normal, fontSize: 13, color: Colors.grey),
      todayHighlightColor: Colors.transparent,
      todayTextStyle: const TextStyle(
          fontStyle: FontStyle.normal, fontSize: 13, color: Colors.black),
      backgroundColor: Colors.white54,
      selectionDecoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
            color: const Color.fromARGB(255, 68, 140, 255), width: 5),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        shape: BoxShape.rectangle,
      ),
      view: CalendarView.month,
      initialSelectedDate: initialDate,
      minDate: DateTime(initialDate.year, initialDate.month),
      maxDate: DateTime(initialDate.year, initialDate.month + 1),
      headerStyle: const CalendarHeaderStyle(
          textAlign: TextAlign.center,
          backgroundColor: Color.fromARGB(255, 32, 207, 208),
          textStyle: TextStyle(color: Colors.white)),
    );
  }

  List<DateTime> blackList(DateTime data) {
    List<DateTime> blackDates = [];

    var countDay = getDaysInMonth(data.year, data.month);

    for (var i = 0; i <= countDay; i++) {
      if (i != data.day) {
        blackDates.add(DateTime(data.year, data.month, i));
      }
    }
    return blackDates;
  }

  static int getDaysInMonth(int year, int month) {
    if (month == DateTime.february) {
      final bool isLeapYear =
          (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
      return isLeapYear ? 29 : 28;
    }
    const List<int> daysInMonth = <int>[
      31,
      -1,
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31
    ];
    print(daysInMonth[month - 1]);
    return daysInMonth[month - 1];
  }
}
