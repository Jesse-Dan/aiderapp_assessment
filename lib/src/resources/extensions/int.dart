extension IntExtension on int {
  String get nameOfMonth {
    switch (this) {
      case 1:
        return "January";
      case 2:
        return "February";
      case 3:
        return "March";
      case 4:
        return "April";
      case 5:
        return "May";
      case 6:
        return "June";
      case 7:
        return "July";
      case 8:
        return "August";
      case 9:
        return "September";
      case 10:
        return "October";
      case 11:
        return "November";
      case 12:
        return "December";
      default:
        return "Unknown";
    }
  }

  String toFormattedString() {
    if (this < 0) {
      return "-${(-this).toFormattedString()}";
    }

    if (this == 0) return "0";

    const thresholds = [
      {"threshold": 1000000000000, "suffix": "T"},
      {"threshold": 1000000000, "suffix": "B"},
      {"threshold": 1000000, "suffix": "M"},
      {"threshold": 1000, "suffix": "k"},
      {"threshold": 100, "suffix": ""},
      {"threshold": 10, "suffix": ""},
    ];

    for (final entry in thresholds) {
      if (this >= (entry["threshold"]! as num)) {
        final value = this / (entry["threshold"]! as num);
        return '${value.toStringAsFixed(1)}${entry['suffix']}';
      }
    }

    return toString();
  }
}
