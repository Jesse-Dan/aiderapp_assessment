mixin ValidatorMixin {
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
    if (!emailValid) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateTag(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a whales_tag';
    }
    if (value.length < 3) {
      return 'Digitwhale tag must be at least 3 characters';
    }
    return null;
  }

  String? validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter $fieldName';
    }
    return null;
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    }
    bool phoneValid = RegExp(r"^\+?[0-9]{10,15}$").hasMatch(value);
    if (!phoneValid) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  String? validateURL(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a URL';
    }
    bool urlValid =
        RegExp(r"^(https?|ftp)://[^\s/$.?#].[^\s]*$").hasMatch(value);
    if (!urlValid) {
      return 'Please enter a valid URL';
    }
    return null;
  }

  String? validateNumeric(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter $fieldName';
    }
    bool numericValid = RegExp(r"^-?[0-9]+$").hasMatch(value);
    if (!numericValid) {
      return 'Please enter a valid number';
    }
    return null;
  }

  String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a date';
    }
    try {
      DateTime.parse(value);
    } catch (e) {
      return 'Please enter a valid date (YYYY-MM-DD)';
    }
    return null;
  }

  String? validateLength(
      String? value, int minLength, int maxLength, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter $fieldName';
    }
    if (value.length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }
    if (value.length > maxLength) {
      return '$fieldName must be less than $maxLength characters';
    }
    return null;
  }
}
