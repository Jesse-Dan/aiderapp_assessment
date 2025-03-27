import 'package:flutter/material.dart';

import '../src/configs/asset_config.dart';
import '../src/configs/theme_config.dart';

class FlavorConfig {
  String appTitle;
  String imageLocation;
  ThemeData? themeData;
  ThemeData? darkThemeData;
  bool filterForProvider;

  FlavorConfig(
      {this.appTitle = "Do It Now",
      this.imageLocation = AssetConfig.defaultLogo,
      this.themeData,
      this.darkThemeData,
      this.filterForProvider = false}) {
    themeData = lightTheme;
    darkThemeData = darkTheme;
  }
}
