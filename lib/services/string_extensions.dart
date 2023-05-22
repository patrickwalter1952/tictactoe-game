
extension StringExtensions on String {

  String capitalize() => '${this[0].toUpperCase()}${substring(1)}';

  //nothing works with regex
  //so .. just validate that @ is there and not the first or last char
  bool isValidEmail() {
    // return EmailValidator.validate(this);

    return (contains("@") && !containsWhitespace() &&
            lastIndexOf("@") < length - 1 && lastIndexOf("@") > 0) ? true : false;
  }

  bool isWhitespace() => trim().isEmpty;

  bool containsWhitespace() => contains(' ');

  bool isValidDouble() => double.tryParse(this) != null;

  bool isValidInt() => int.tryParse(this) != null;
  bool isValidPositiveInt() => int.tryParse(this) != null && (int.parse(this) >= 0);
  bool isValidIntGreaterZero() => int.tryParse(this) != null && (int.parse(this) > 0);

  ///
  /// Check validity of date field
  ///
  bool isValidDate() {
    if (!RegExp(r'[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|1[0-9]|2[0-9]|3[0-1])').hasMatch(this)) {
      return false;
    }

    //passed general date format
    //Check year is not in future
    int yyyy = int.parse(substring(0, 4));
    int mm = int.parse(substring(5, 7));
    int dd = int.parse(substring(8));

    if (yyyy > (DateTime.now().year)) {
      return false;
    }

    //check April, June, September, and November for max 30 days
    //(January, March, May, July, August, October, and December have max 31 days)
    if ([4, 6, 9, 11].contains(mm) && dd > 30) {
      return false;
    }

    //for February check if leap year then max days is 29, else 28
    if (mm == 2) {
      return isLeapYear(yyyy) ? dd <= 29 : dd <= 28;
    }

    return true;
  }

  ///
  /// a leap year is a year with an extra day—February 29
  /// If a year is multiple of 400, then it is a leap year
  /// If a year is multiple of 4,  then it is a leap year
  /// If a year is multiple of 100, then it is not a leap year
  ///
  bool isLeapYear(int year)
  {
    if (year % 400 == 0 ||
        year % 100 != 0 &&
        year % 4 == 0) {
      return true;
    }
    return false;
  }

  ///
  /// XXXXXXXXXX : 10 digit mobile number validation.
  /// +91 XXXXXXXXXX :  Country code + 10 digit phone number.
  /// (XXX) XXX XXXX : Phone number with brackets separator.
  /// (XXX) XXX-XXXX : Number with brackets & dash separator.
  /// XXX-XXX-XXXX :  Phone Number with dash separator.
  ///
  bool isValidPhoneNumber() {
    if (isEmpty) {
      return false;
    }
    RegExp regex =
      RegExp(r'^(\+\d{1,2}\s?)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$');
    return regex.hasMatch(this);
  }
}