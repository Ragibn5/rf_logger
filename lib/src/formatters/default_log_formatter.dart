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
        return "D";
      case LogLevel.info:
        return "I";
      case LogLevel.warning:
        return "W";
      case LogLevel.error:
        return "E";
    }
  }

  @override
  String? formatData(
    data, {
    required bool prettyPrint,
  }) {
    if (!prettyPrint) {
      return data.toString();
    }

    return JsonEncoder.withIndent("  ", (original) => original.toString())
        .convert(data);
  }
}
