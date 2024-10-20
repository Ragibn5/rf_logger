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
  String? formatData(dynamic data, {required bool prettyPrint});

  String getFormattedLog(LogData logData) {
    final ls = PlatformConstants.newLine;

    var msg = logData.message.trim();
    msg = (msg.isNotEmpty ? msg : "N/A");

    final extra =
        formatData(logData.data, prettyPrint: prettyPrint)?.nullOnEmptyOrBlank;

    return "[${formatStamp(logData.time)}] - "
        "[${formatLevel(logData.level)}] ➜ "
        "${msg.contains(ls) ? '$ls$msg$ls' : '$msg$ls'}"
        "${extra != null ? '$extra$ls' : ''}";
  }
}
