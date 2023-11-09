class TTimeHelpers {
  static DateTime timestampToDateTime(int unixTimestamp) {
    final millisecondsSinceEpoch = unixTimestamp * 1000;
    return DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  }

  static int dateTimeToTimestamp(DateTime timestamp) {
    final utcDateTime = timestamp.toLocal();
    final timestampInSeconds = utcDateTime.millisecondsSinceEpoch ~/ 1000;
    return timestampInSeconds;
  }


  static String dateTimeToString(DateTime timestamp) {
    final formattedDate =
        '${timestamp.day.toString().padLeft(2, '0')}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.year} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    return formattedDate;
  }
  static dateTimeToHourMinute(DateTime timestamp) {
    final formattedDate = "${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}";
    return formattedDate;
  }
}
