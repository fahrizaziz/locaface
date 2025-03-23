const List<String> _dayNames = [
  'Sunday',
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
];

const List<String> _monthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

extension DateTimeExt on DateTime {
  String toFormattedDate() {
    String dayName = _dayNames[weekday - 1];
    String day = this.day.toString();
    String month = _monthNames[this.month - 1];
    String year = this.year.toString();

    return '$dayName, $day $month $year';
  }

  String toFormattedTime() {
    String hour = this.hour.toString().padLeft(2, '0');
    String minute = this.minute.toString().padLeft(2, '0');

    return '$hour:$minute WIB';
  }
}
