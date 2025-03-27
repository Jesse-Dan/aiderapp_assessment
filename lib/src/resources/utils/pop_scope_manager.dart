import "package:flutter_riverpod/flutter_riverpod.dart";

import "show_text.dart";


final popScopeProvider = StateNotifierProvider<PopScopeManager, bool>(
  (ref) {
    return PopScopeManager(false);
  },
);

class PopScopeManager extends StateNotifier<bool> {
  PopScopeManager(super._state);

  /// this is used from the loginProvider for when the login screen 
  /// is reused as a means to refresh the token.
  /// the toast shouldn't appear when pop is invoked
  bool showMessage = true;

  void onPopInvoked(bool canPop) {
    state = true;
    Future.delayed(const Duration(seconds: 2), () => state = false);
    if (showMessage) showText("press back again to exit");
    showMessage = true;
  }
}
