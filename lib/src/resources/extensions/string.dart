import "package:flutter/foundation.dart";
import "package:intl/intl.dart";

extension StringExtension on String {
  String get getInitials {
    var firstLetter = substring(0, 1);
    if (!contains(" ")) return firstLetter;

    var lastLetter = split(" ").last.substring(0, 1);
    return "$firstLetter$lastLetter";
  }

  String get encryptEmail {
    if (!contains("@")) return this;

    String encrytingChars = "******";
    int charBeforeAt = indexOf("@") - 1;
    String firstPart = substring(0, 3);
    String lastPart = substring(charBeforeAt);

    return "$firstPart$encrytingChars$lastPart";
  }

  String get capitalizeFirstLetter {
    var firstLetter = substring(0, 1).toUpperCase();
    var remainingText = substring(1, length);
    return firstLetter + remainingText;
  }

  List<String?> processAndRemoveHashtags() {
    if (isEmpty) {
      return [null, null];
    }

    List<String> words = split(" ");

    List<String> filteredWords = [];
    List<String> hashtags = [];

    for (final String word in words) {
      if (word.startsWith("#")) {
        hashtags.add(word);
      } else {
        filteredWords.add(word);
      }
    }

    String filteredString = filteredWords.join(" ").trim();
    String hashtagsString = hashtags.join(" ").trim();

    if (filteredString.isEmpty && hashtagsString.isEmpty) {
      return [null, null];
    }

    return [
      if (filteredString.isEmpty) null else filteredString,
      if (hashtagsString.isEmpty) null else hashtagsString
    ];
  }

  String toValidDtoDate() {
    try {
      DateTime dateTime = DateFormat("MMMM dd, yyyy").parse(this);
      return DateFormat("yyyy-MM-dd").format(dateTime);
    } catch (e) {
      if (kDebugMode) {
        print("Error parsing date: $e");
      }
      return this;
    }
  }

  String concat(String other) => '$this$other';

  String addSpace(String other) => '$this $other';

  String addComma(String other) => '$this, $other';

  String truncateWithEllipsis(int cutoffLength, {String? suffix}) {
    if (length <= cutoffLength) {
      return this;
    } else {
      return '${substring(0, cutoffLength)}${suffix ?? "..."}';
    }
  }

  int toKoboOrPesewas(String currency) {
    if (currency.toUpperCase() == 'NGN') {
      // Convert to kobo
      return (double.parse(this) * 100).toInt();
    } else if (currency.toUpperCase() == 'GHS') {
      // Convert to pesewas
      return (double.parse(this) * 100).toInt();
    } else {
      throw Exception('Unsupported currency');
    }
  }

  String formatAmount() {
    // Handle "0" explicitly
    if (this == "0") {
      return "0.00";
    }

    // Remove any non-numeric characters except the decimal point
    String cleanedString = replaceAll(RegExp(r'[^0-9.]'), '');

    // If the string is empty or invalid after cleaning, return "0.00"
    if (cleanedString.isEmpty) {
      return "0.00";
    }

    // Split into whole and decimal parts
    List<String> parts = cleanedString.split('.');
    String wholePart = parts[0].isEmpty ? "0" : parts[0];

    // Format decimal part to always have 2 digits
    String decimalPart = parts.length > 1
        ? parts[1]
            .padRight(2, '0')
            .substring(0, 2) // Pad or truncate to 2 digits
        : "00"; // Default to "00" if no decimal part

    // Add commas as thousand separators to whole part
    String formattedWholePart = '';
    int length = wholePart.length;
    for (int i = 0; i < length; i++) {
      if ((length - i) % 3 == 0 && i != 0) {
        formattedWholePart += ',';
      }
      formattedWholePart += wholePart[i];
    }

    // Combine with decimal part, ensuring 2 decimal places
    return "$formattedWholePart.$decimalPart";
  }

  String obscureAccountNumber({int visibleDigits = 4, String maskChar = '*'}) {
    if (isEmpty || length <= visibleDigits) {
      return this; // Return as-is if too short to obscure
    }

    // Extract the last [visibleDigits] characters
    final visiblePart =
        length > visibleDigits ? substring(length - visibleDigits) : this;
    // Create a mask for the hidden part
    final obscuredPart = maskChar * (length - visibleDigits);
    return obscuredPart + visiblePart;
  }

  /// Obscures an account name, showing only the first character of each word.
  String obscureAccountName({String maskChar = '*'}) {
    if (isEmpty) {
      return this; // Return empty string
    }

    // Split by spaces to handle multi-word names
    final words = split(RegExp(r'\s+'));
    final obscuredWords = words.map((word) {
      if (word.isEmpty) return word;
      // Keep first character, obscure the rest
      return word[0] + maskChar * (word.length - 1);
    });

    return obscuredWords.join(' ');
  }
}
