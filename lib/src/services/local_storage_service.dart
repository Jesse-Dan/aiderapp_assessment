import 'package:get_storage/get_storage.dart';

class LocalStorageService{
  // The static instance of the class
  static final LocalStorageService instance = LocalStorageService._internal();

  final GetStorage _storage = GetStorage();

  // Private constructor
  LocalStorageService._internal();

  // Initialize GetStorage (This should be called once in main.dart)
  Future<void> init() async {
    await GetStorage.init();
  }

  // Save item in GetStorage
  Future<void> setItem<T>(String key, T value) async {
    if (value is int || value is double || value is bool || value is String || value is List<String>) {
      _storage.write(key, value);
    } else {
      throw Exception("Unsupported type");
    }
  }

  // Retrieve item from GetStorage
  T? getItem<T>(String key) {
    final value = _storage.read(key);

    if (value is T) {
      return value;
    } else {
      return null;
    }
  }

  // Remove item from GetStorage
  Future<void> removeItem(String key) async {
    await _storage.remove(key);
  }

  // Clear all items from GetStorage
  Future<void> clear() async {
    await _storage.erase();
  }
}
