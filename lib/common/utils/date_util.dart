import 'package:intl/intl.dart';

class DateUtil {
  static String timeAgoSinceDate(DateTime date, {bool numericDates = true}) {
    final Duration difference = DateTime.now().difference(date);

    if (difference.inSeconds < 60) {
      return difference.inSeconds == 1
          ? '1 second ago'
          : '${difference.inSeconds} seconds ago';
    } else if (difference.inMinutes < 60) {
      return difference.inMinutes == 1
          ? '1 minute ago'
          : '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return difference.inHours == 1
          ? '1 hour ago'
          : '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return difference.inDays == 1
          ? '1 day ago'
          : '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final int weeks = (difference.inDays / 7).floor();
      return weeks == 1 ? '1 week ago' : '$weeks weeks ago';
    } else if (difference.inDays < 365) {
      final int months = (difference.inDays / 30).floor();
      return months == 1 ? '1 month ago' : '$months months ago';
    } else {
      final int years = (difference.inDays / 365).floor();
      return years == 1 ? '1 year ago' : '$years years ago';
    }
  }

  static String dateTimeToString(DateTime dateTime) {
    DateTime localDate = dateTime.toLocal();
    return DateFormat("dd MMM yyyy • HH.mm").format(localDate);
  }
}
