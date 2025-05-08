import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeUtils {
  static String formatTimestamp(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

    String month = getMonth(dateTime.month);
    String day = dateTime.day.toString().padLeft(2, '0');
    String hour = (dateTime.hour % 12).toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    String amPm = dateTime.hour < 12 ? 'AM' : 'PM';

    return '$month $day $hour:$minute $amPm';
  }

  static String getMonth(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }

  // static String formatTimeWeekly(int timestamp) {
  //   DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
  //   String formattedDate = DateFormat('E d.MMM').format(dateTime);
  //   return formattedDate;
  // }
  static String formatTimeWeekly(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    // String formattedDate = DateFormat('MMM dd hh:mm a').format(dateTime);
    String formattedDate = DateFormat('yyyy MMM dd hh:mm').format(dateTime);
    return formattedDate;
  }

  static String getHoursMinutesFromMilliseconds(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String formattedDate = DateFormat('hh:mm a').format(dateTime);
    return formattedDate;
  }
}

Color getColorFromInt(int colorInt) {
  switch (colorInt) {
    case 0:
      return Colors.black;
    case 1:
      return Colors.orange;
    case 2:
      return Colors.red;
    case 3:
      return Colors.pink;
    case 4:
      return Colors.green;
    default:
      return Colors.blue;
  }
}
