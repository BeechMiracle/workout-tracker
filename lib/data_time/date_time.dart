// return today's date
String todaysDate() {
  // tody's date
  DateTime dateTime = DateTime.now();

  // year format
  String year = dateTime.year.toString();

  // month format
  String month = dateTime.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }

  // day format
  String day = dateTime.day.toString();
  if (day.length == 1) {
    day = '0$day';
  }

  // date format
  String yyyymmdd = year + month + day;

  return yyyymmdd;
}

// convert date string to dateTime object
DateTime createDateTime(String date) {
  int yyyy = int.parse(date.substring(0, 4));
  int mm = int.parse(date.substring(4, 6));
  int dd = int.parse(date.substring(6, 8));

  DateTime dateTime = DateTime(yyyy, mm, dd);

  return dateTime;
}

// convert DateTime object to a String
String convertDateTime(DateTime dateTime) {
  // year format
  String year = dateTime.year.toString();

  // month format
  String month = dateTime.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }

  // day format
  String day = dateTime.day.toString();
  if (day.length == 1) {
    day = '0$day';
  }

  // date format
  String yyyymmdd = year + month + day;

  return yyyymmdd;
}
