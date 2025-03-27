extension ContextExtension on Exception {
  String get message => toString()
      .replaceAll("Exception:", "")
      .replaceAll("Authentication Error:", "")
      .replaceAll("An error occurred:", "")
      .replaceAll("Error processing response:", "")
      .replaceAll("HTTP error:", "")
      .replaceAll("422", "")
      .replaceAll("FirebaseException:", "")
      .replaceAll("PlatformException:", "")
      .replaceAll("Error:", "")
      .replaceAll("firebase_", "")
      .replaceAll("Firebase ", "")
      .replaceAll(RegExp(r'[\[\]]'), "")
      .replaceAll(RegExp(r'[0-9]+'), "")
      .trim();

  String get errorCode => toString().replaceAll(RegExp(r'[^0-9]+'), "");
}
