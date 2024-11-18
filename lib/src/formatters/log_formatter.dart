import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:rf_logger/src/constants/log_level.dart';
import 'package:rf_logger/src/constants/platform_constants.dart';
import 'package:rf_logger/src/extensions/string_extensions.dart';
import 'package:rf_logger/src/models/log_data.dart';

abstract class LogFormatter {
  final bool prettyPrint;
  final DateFormat stampFormat;

  LogFormatter({
    this.prettyPrint = true,
    required this.stampFormat,
  });

  @protected
  String formatStamp(DateTime time);

  @protected
  String formatLevel(LogLevel logLevel);

  @protected
  String? formatData(Object? data, {required bool prettyPrint});

  String getFormattedLog(LogData logData) {
    final ls = PlatformConstants.newLine;

    final msg = logData.message.trim().nullOnEmptyOrBlank ?? '';
    final stackTrace = logData.stackTrace?.toString().trim().nullOnEmptyOrBlank;
    final data = formatData(logData.data, prettyPrint: prettyPrint)
        ?.trim()
        .nullOnEmptyOrBlank;

    return "\n[${formatStamp(logData.time)}] - [${formatLevel(logData.level)}] ➜"
        "${msg.contains(ls) ? '$ls$msg$ls' : ' $msg$ls'}"
        "${data != null ? ('[Data]: ${data.contains(ls) ? '$ls$data$ls' : '$data$ls'}') : ''}"
        "${stackTrace != null ? ('[StackTrace]: ${stackTrace.contains(ls) ? '$ls$stackTrace$ls' : '$stackTrace$ls'}') : ''}";
  }
}
