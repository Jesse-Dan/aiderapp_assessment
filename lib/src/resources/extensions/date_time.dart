import "int.dart";

extension DateTimeExtension on DateTime {
  String get formatDateForUser {
    var month = this.month;
    var day = this.day;
    var year = this.year;

    return "${month.nameOfMonth} $day, $year";
  }

  String get formatDateForServer {
    var month = "${this.month}".padLeft(2, "0");
    var day = "${this.day}".padLeft(2, "0");
    var year = this.year;

    return "$year-$month-$day";
  }

 
}

 String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good morning";
    } else if (hour < 17) {
      return "Good afternoon";
    } else {
      return "Good evening";
    }
  }