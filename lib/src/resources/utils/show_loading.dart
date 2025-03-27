import "package:bot_toast/bot_toast.dart";

import "../widgets/app_loading_indicator.dart";




void showLoading([String? text]) {
  cancelLoading();
  BotToast.showCustomLoading(
    toastBuilder: (cancelFunc) => AppLoadingIndicator(text: text),
  );
}

void cancelLoading() {
  BotToast.closeAllLoading();
}
