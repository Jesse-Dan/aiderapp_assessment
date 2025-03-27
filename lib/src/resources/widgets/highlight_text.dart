import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class HighlightedText extends StatelessWidget {
  final String text;
  final Map<String, TextStyle> highlightWords;
  final TextStyle? defaultStyle;
  final bool enableHighlight;
  final Function(String)? onWordClick;
  final TextAlign textAlign;

  const HighlightedText({
    super.key,
    required this.text,
    this.highlightWords = const {},
    this.defaultStyle,
    this.enableHighlight = true,
    this.onWordClick,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    List<TextSpan> spans = [];
    int start = 0;

    // Sort the words by their start position in the text
    List<MapEntry<String, TextStyle>> sortedHighlights = highlightWords.entries
        .toList()
      ..sort((a, b) => text.indexOf(a.key).compareTo(text.indexOf(b.key)));

    for (var entry in sortedHighlights) {
      String word = entry.key;
      TextStyle style = entry.value;

      int index = text.indexOf(word, start);

      // Add the part of the text before the word
      if (index != start) {
        spans.add(TextSpan(
          text: text.substring(start, index),
          style: enableHighlight ? defaultStyle : null,
        ));
      }

      // Add the highlighted word with a clickable gesture
      spans.add(TextSpan(
        text: word,
        style: enableHighlight ? style : defaultStyle,
        recognizer: onWordClick != null
            ? (TapGestureRecognizer()..onTap = () => onWordClick!(word))
            : null,
      ));

      start = index + word.length;
    }

    // Add the remaining part of the text
    if (start < text.length) {
      spans.add(TextSpan(
        text: text.substring(start),
        style: enableHighlight ? defaultStyle : null,
      ));
    }

    return RichText(
      text: TextSpan(
        style: defaultStyle,
        children: spans,
      ),
      textAlign: textAlign,
    );
  }
}
