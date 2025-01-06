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
    if (data == null || data is String) {
      return data;
    }

    return JsonEncoder.withIndent(
      prettyPrint ? "  " : null,
      (original) => original.toString(),
    ).convert(data);
  }
}
