import 'dart:async';

import 'package:do_it_now/src/providers/auth_provider.dart';
import 'package:do_it_now/src/providers/task_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';

import '../../firebase_options.dart';
import '../../mains/common.dart';
import '../../mains/flavour_config.dart';
import '../providers/utils_provider.dart';
import 'cloudinary/cloudinary_service.dart';
import 'local_storage_service.dart';

final initProvider = Provider((ref) {
  return Initializer();
});

class Initializer {
  static Future<void> bootstrapDoItNowApp(FlavorConfig config) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await GetStorage.init();

    flavorConfigProvider = StateProvider((ref) => config);
    CloudinaryService.initialize();

    AuthProvider.initialize();
    TaskProvider.initialize();
    UtilsProvider.initialize();
  }

  Future<void> pullUserData() async {
    TaskProvider.instance.getTasks();
  }

  Future<void> clearData() async {
    await LocalStorageService.instance.clear();
  }

  Future<void> clearDataAndSignOut() async {
    await LocalStorageService.instance.clear();
  }
}
