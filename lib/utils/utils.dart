import 'dart:math';

import 'package:get/get.dart';

class Utils {
  Utils._();
  static String imageThumb(String pattern, String size) {
    // ignore: unnecessary_null_comparison
    if (pattern == null || pattern.isEmpty) return "";

    String url = pattern.replaceAll("\$size\$", size);
    return url;
  }

  static bool isValidUrl(String? url) {
    url ??= "";
    return Uri.tryParse(url)?.hasAbsolutePath ?? false;
  }

  static String pluralizeMany(String string, num number) {
    int count = number.round();
    if (count == 0) {
      return "${string}_zero".tr.replaceFirst("%", count.toString());
    } else if (count == 1) {
      return "${string}_one".tr.replaceFirst("%", count.toString());
    }
    return "${string}_many".tr.replaceFirst("%", count.toString());
  }

  static String timeAgoString(int time) {
    num now = DateTime.now().millisecondsSinceEpoch;
    num elapsed = max(0, now - time);

    final num seconds = elapsed / 1000;
    final num minutes = seconds / 60;
    final num hours = minutes / 60;
    final num days = hours / 24;
    final num months = days / 30;
    final num years = days / 365;

    if (years >= 1) {
      return pluralizeMany("time_years_ago", years);
    }
    if (months >= 1) {
      return pluralizeMany("time_months_ago", months);
    }
    if (days >= 1) {
      return pluralizeMany("time_days_ago", days);
    }
    if (hours >= 1) {
      return pluralizeMany("time_hours_ago", hours);
    }
    if (minutes >= 1) {
      return pluralizeMany("time_minutes_ago", minutes);
    }
    return "Vừa xong";
  }
}

class ParserHelper {
  static int? parseInt(dynamic input) {
    if (input != null) {
      if (input is int) {
        return input;
      }
      if (input is double) {
        return input.toInt();
      }
      if (input is String) {
        return int.tryParse(input);
      }
    }
    return null;
  }

  static double? parseDouble(dynamic input) {
    if (input != null) {
      if (input is int) {
        return input.toDouble();
      }
      if (input is double) {
        return input;
      }
      if (input is String) {
        return double.tryParse(input);
      }
    }
    return null;
  }
}
