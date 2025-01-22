import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../localizations/common.dart';

class DateUtil {
  static String timeAgoSinceDate(BuildContext context, DateTime date,
      {bool numericDates = true}) {
    final Duration difference = DateTime.now().difference(date);

    if (difference.inSeconds < 60) {
      return difference.inSeconds == 1
          ? AppLocalizations.of(context)!.timeSecondAgo
          : AppLocalizations.of(context)!.timeSecondsAgo(difference.inSeconds);
    } else if (difference.inMinutes < 60) {
      return difference.inMinutes == 1
          ? AppLocalizations.of(context)!.timeMinuteAgo
          : AppLocalizations.of(context)!.timeMinutesAgo(difference.inMinutes);
    } else if (difference.inHours < 24) {
      return difference.inHours == 1
          ? AppLocalizations.of(context)!.timeHourAgo
          : AppLocalizations.of(context)!.timeHoursAgo(difference.inHours);
    } else if (difference.inDays < 7) {
      return difference.inDays == 1
          ? AppLocalizations.of(context)!.timeDayAgo
          : AppLocalizations.of(context)!.timeDaysAgo(difference.inDays);
    } else if (difference.inDays < 30) {
      final int weeks = (difference.inDays / 7).floor();
      return weeks == 1
          ? AppLocalizations.of(context)!.timeWeekAgo
          : AppLocalizations.of(context)!.timeWeeksAgo(weeks);
    } else if (difference.inDays < 365) {
      final int months = (difference.inDays / 30).floor();
      return months == 1
          ? AppLocalizations.of(context)!.timeMonthAgo
          : AppLocalizations.of(context)!.timeMonthsAgo(months);
    } else {
      final int years = (difference.inDays / 365).floor();
      return years == 1
          ? AppLocalizations.of(context)!.timeYearAgo
          : AppLocalizations.of(context)!.timeYearsAgo(years);
    }
  }

  static String dateTimeToString(BuildContext context, DateTime dateTime) {
    DateTime localDate = dateTime.toLocal();
    // Example: Use localization for date format (optional).
    return DateFormat(AppLocalizations.of(context)!.dateTimeFormat)
        .format(localDate);
  }
}
