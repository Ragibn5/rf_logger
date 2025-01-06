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
    if (!isJsonType(data)) {
      return data.toString();
    }

    return JsonEncoder.withIndent(
      prettyPrint ? "  " : null,
      (original) => original.toString(),
    ).convert(data);
  }

  bool isJsonType(dynamic data) {
    if (data == null || data is bool || data is num || data is String) {
      return true;
    }

    if (data is List) {
      return data.every(isJsonType);
    }

    if (data is Map<String, dynamic>) {
      return data.values.every(isJsonType);
    }

    return false;
  }
}
