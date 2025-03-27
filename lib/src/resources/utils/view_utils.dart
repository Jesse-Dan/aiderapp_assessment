import 'package:flutter/material.dart';

/// Extension on `double` to provide a utility method for view-related calculations.
///
/// This extension adds a getter `vu` to the `double` type, which utilizes the `ViewUtils.r`
/// method to perform some kind of transformation or calculation on the double value.
///
/// Example usage:
/// ```dart
/// double value = 10.0;
/// var result = value.vu;
/// ```
///
/// The exact behavior of `ViewUtils.r` is not detailed here, but it is assumed to be a method
/// that takes a `double` and returns a transformed value.
extension ONObject on Object {
  /// A getter that returns an instance of `ViewUtils` associated with the current object.
  ///
  /// This getter uses the `ViewUtils.r` method to create and return the instance.
  ///
  /// Example usage:
  /// ```dart
  /// var viewUtilsInstance = someObject.vu;
  /// ```
  get vu {
    if (this is int) {
      return ViewUtils.r((this as int).toDouble());
    } else if (this is double) {
      return ViewUtils.r((this as double).toDouble());
    } else {
      throw Exception("Invaid Object: use [int || double]");
    }
  }
}

class ViewUtils extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const ViewUtils({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

// This size work fine on my design, maybe you need some customization depends on your design

  // This isMobile, isTablet, isDesktop help us later
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 850;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1100 &&
      MediaQuery.of(context).size.width >= 850;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    // If our width is more than 1100 then we consider it a desktop
    if (size.width >= 1100) {
      return desktop;
    }
    // If width it less then 1100 and more then 850 we consider it as tablet
    else if (size.width >= 850 && tablet != null) {
      return tablet!;
    }
    // Or less then that we called it mobile
    else {
      return mobile;
    }
  }

  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;

  static late double textMultiplier;
  static late double imageSizeMultiplier;
  static late double paddingMultiplier;
  static late double marginMultiplier;

  // Breakpoints for different screen sizes (adjust as needed)
  static const double smallScreenSize = 600;
  static const double mediumScreenSize = 800;
  static const double largeScreenSize = 1000;

  static void watch(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    _setMultipliers();
  }

  static void _setMultipliers() {
    if (screenWidth < smallScreenSize) {
      // Small screen multipliers
      textMultiplier = blockSizeVertical * 0.8; // Adjust for smaller screens
      imageSizeMultiplier =
          blockSizeHorizontal * 0.8; // Adjust for smaller screens
      paddingMultiplier =
          blockSizeHorizontal * 0.6; // Adjust for smaller screens
      marginMultiplier =
          blockSizeHorizontal * 0.5; // Adjust for smaller screens
    } else if (screenWidth < mediumScreenSize) {
      // Medium screen multipliers
      textMultiplier = blockSizeVertical;
      imageSizeMultiplier = blockSizeHorizontal;
      paddingMultiplier =
          blockSizeHorizontal * 0.7; // Adjust for medium screens
      marginMultiplier = blockSizeHorizontal * 0.6; // Adjust for medium screens
    } else if (screenWidth < largeScreenSize) {
      // Large screen multipliers
      textMultiplier = blockSizeVertical * 1.1; // Adjust for larger screens
      imageSizeMultiplier =
          blockSizeHorizontal * 1.2; // Adjust for larger screens
      paddingMultiplier =
          blockSizeHorizontal * 0.8; // Adjust for larger screens
      marginMultiplier = blockSizeHorizontal * 0.7; // Adjust for larger screens
    } else {
      // Extra large screen multipliers (optional)
      textMultiplier =
          blockSizeVertical * 1.2; // Adjust for extra large screens
      imageSizeMultiplier =
          blockSizeHorizontal * 1.3; // Adjust for extra large screens
      paddingMultiplier = blockSizeHorizontal; // Adjust for extra large screens
      marginMultiplier =
          blockSizeHorizontal * 0.8; // Adjust for extra large screens
    }
  }

  // Responsive Text with customizable size
  static double r(double size) {
    return size * textMultiplier;
  }

  // Responsive Container with customizable width and height
  static BoxConstraints responsiveBox(double width, double height) {
    return BoxConstraints(
      minWidth: width * blockSizeHorizontal,
      maxWidth: width * blockSizeHorizontal,
      minHeight: height * blockSizeVertical,
      maxHeight: height * blockSizeVertical,
    );
  }

  // Responsive Padding with customizable values
  static EdgeInsets responsivePadding(double all) {
    return EdgeInsets.all(all * paddingMultiplier);
  }

  // Responsive Margin with customizable values
  static EdgeInsets responsiveMargin(double all) {
    return EdgeInsets.all(all * marginMultiplier);
  }
}
