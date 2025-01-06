import 'dart:convert';

import 'package:rf_logger/src/constants/log_level.dart';
import 'package:rf_logger/src/formatters/log_formatter.dart';

class DefaultLogFormatter extends LogFormatter {
  DefaultLogFormatter({
    required super.stampFormat,
    super.prettyPrint,
  });

  @override
  String formatStamp(DateTime time) {
    return stampFormat.format(time);
  }

  @override
  String formatLevel(LogLevel logLevel) {
    switch (logLevel) {
      case LogLevel.debug:
        return "DEBUG";
      case LogLevel.info:
        return "INFO";
      case LogLevel.warning:
        return "WARNING";
      case LogLevel.error:
        return "ERROR";
    }
  }

  @override
  String? formatData(dynamic data, {required bool prettyPrint}) {
    // Primitives
    if (data == null || data is bool || data is num || data is String) {
      return data.toString();
    }

    // Errors and exceptions
    if (data is Error || data is Exception) {
      return data.toString();
    }

    // Others
    return JsonEncoder.withIndent(
      prettyPrint ? "  " : null,
      (original) => original.toString(),
    ).convert(data);
  }
}
