import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

void setPreferredOrientation() {
  if (kIsWeb) {
    // Web-specific orientation settings can be added here if needed
  } else {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
