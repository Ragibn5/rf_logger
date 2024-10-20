import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:rf_logger/src/clients/file_logger/log_file_config.dart';
import 'package:rf_logger/src/clients/log_client.dart';
import 'package:rf_logger/src/constants/platform_constants.dart';
import 'package:rf_logger/src/formatters/log_formatter.dart';
import 'package:rf_logger/src/models/log_data.dart';

class FileLogger extends LogClient {
  static const ID = "file";

  final LogFilConfig _logFileConfig;

  FileLogger({
    required LogFormatter formatter,
    required LogFilConfig fileConfig,
  })  : _logFileConfig = fileConfig,
        super(clientId: ID, logFormatter: formatter);

  @override
  Future<bool> log(LogData logData) {
    return _logInternal(logData);
  }

  Future<bool> _logInternal(LogData newLogData) async {
    final logFile = await _createLogFile(newLogData.time);
    return logFile != null &&
        await _appendToLogFile(
          logFile,
          logFormatter.getFormattedLog(newLogData),
        );
  }

  /// Append the current log to the log file.
  /// The log will be appended by a platform specific line separator.
  Future<bool> _appendToLogFile(File logFile, String content) async {
    bool success = true;
    try {
      await logFile.writeAsString(
        mode: FileMode.append,
        "$content${PlatformConstants.newLine}",
      );
    } catch (e, st) {
      success = false;
      debugPrintStack(label: e.toString(), stackTrace: st);
    }
    return success;
  }

  /// Get the log file reference.
  /// If does not exist, will be created and returned.
  Future<File?> _createLogFile(DateTime time) async {
    File? logFile;
    try {
      logFile = await File(_getLogFilePath(time)).create(recursive: true);
    } catch (e, st) {
      debugPrintStack(label: e.toString(), stackTrace: st);
    }
    return logFile;
  }

  String _getLogFilePath(DateTime time) {
    return "${_logFileConfig.parentDir.path}"
        "${Platform.pathSeparator}"
        "${_getLogFileName(time)}";
  }

  String _getLogFileName(DateTime time) {
    return "${_logFileConfig.fileNamePrefix}"
        "${_logFileConfig.nameDateFormat.format(time)}"
        "${_logFileConfig.fileNameSuffix}";
  }
}
