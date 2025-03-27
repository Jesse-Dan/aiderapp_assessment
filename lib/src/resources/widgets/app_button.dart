import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ButtonType { filled, outlined }

class AppButton extends ConsumerWidget {
  final ButtonType buttonType;
  final Color primaryColor;
  final Widget? content;
  final String? text;
  final VoidCallback? onPressed;

  const AppButton({
    super.key,
    this.buttonType = ButtonType.filled,
    this.primaryColor = Colors.black,
    this.content,
    this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
          color: buttonType == ButtonType.filled ? primaryColor : Colors.white,
          border: buttonType == ButtonType.outlined
              ? Border.all(color: primaryColor)
              : null,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: content ??
            Text(
              text ?? "NIL",
              style: TextStyle(
                  color: buttonType == ButtonType.filled
                      ? Colors.white
                      : primaryColor,
                  fontWeight: FontWeight.bold),
            ),
      ),
    );
  }
}
