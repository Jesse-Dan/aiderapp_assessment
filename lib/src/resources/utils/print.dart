// ignore_for_file: public_member_api_docs, sort_constructors_first, constant_identifier_names
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

enum Tag {
  DEBUG,
  ERROR,
  WARNING,
  INFO,
  SERVICE_ACTION,
  PERSON_SUCCESS,
  LOADING,
  SUCCESS
}

class Print {
  final Tag tag;
  final String message;
  final dynamic error;
  final StackTrace? stackTrace;

  Print({
    required this.tag,
    required this.message,
    this.error,
    this.stackTrace,
  }) {
    _logMessage();
  }

  void _logMessage() {
    final tagString = _tagToString(tag);
    final logPrefix = '[📢 ${DateTime.now()}] ${_tagSymbol(tagString)}';

    developer.log(
      '$logPrefix $message',
      error: error,
      stackTrace: stackTrace,
      name: _tagToString(tag),
      time: DateTime.now(),
    );
  }

  String _tagToString(Tag tag) {
    return tag.toString().split('.').last.toUpperCase();
  }

  String _tagSymbol(String tagString) {
    switch (tagString) {
      case 'INFO':
        return '✨';
      case 'ERROR':
        return '❌';
      case 'WARNING':
        return '⚠️';
      case 'DEBUG':
        return '🐞';
      default:
        return '🔧';
    }
  }

  static void log(
    String message, {
    Tag tag = Tag.DEBUG,
    dynamic error,
    StackTrace? stackTrace,
    bool usePrint = true,
  }) {
    if (usePrint) {
      if (kDebugMode) {
        print(
          Print(
            tag: tag,
            message: message,
            error: error,
            stackTrace: stackTrace,
          ).toString(),
        );
      }
    } else {
      Print(
        tag: tag,
        message: message,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  String toString() {
    return 'Logger(tag: $tag, message: $message, error: $error, stackTrace: $stackTrace)';
  }
}
