import "dart:developer";
import "package:bot_toast/bot_toast.dart";

void showText(String text, {Duration? duration}) {
  log(text, name: 'showText');
  BotToast.showText(
      text: text, duration: duration ?? const Duration(seconds: 6));
}
