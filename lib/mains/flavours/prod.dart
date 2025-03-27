import 'package:flutter/material.dart';

import '../../src/configs/asset_config.dart';
import '../common.dart';
import '../flavour_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  mainCommon(FlavorConfig()
    ..appTitle = "Digitwhale Dev"
    ..imageLocation = AssetConfig.whiteWhale);
}
