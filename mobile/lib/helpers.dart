final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

String getMonth(DateTime date) {
  switch (date.month) {
    case DateTime.january:
      return 'Jan';
    case DateTime.february:
      return 'Feb';
    case DateTime.march:
      return 'Mar';
    case DateTime.april:
      return 'Apr';
    case DateTime.may:
      return 'May';
    case DateTime.june:
      return 'Jun';
    case DateTime.july:
      return 'Jul';
    case DateTime.august:
      return 'Aug';
    case DateTime.september:
      return 'Sep';
    case DateTime.october:
      return 'Oct';
    case DateTime.november:
      return 'Nov';
    case DateTime.december:
      return 'Dec';
    default:
      return 'None';
  }
}

String makeReadableDateTimeString(DateTime date) {
  return '${days[date.weekday]} ${date.day} ${getMonth(date)} ${date.year}, ${date.hour}:${date.minute}:${date.second} ${date.timeZoneName}';
}

String makeReadableDateString(DateTime date) {
  return '${days[date.weekday]} ${date.day} ${getMonth(date)} ${date.year}';
}

String makeDateString(DateTime date) {
  String m = (date.month) < 10 ? '0${date.month}' : '${date.month}';
  String d = (date.day) < 10 ? '0${date.day}' : '${date.day}';

  return '${date.year}-${m}-${d}';
}
