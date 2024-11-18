import 'package:rf_logger/src/constants/log_level.dart';

class LogData {
  final DateTime time;
  final LogLevel level;
  final String message;
  final StackTrace? stackTrace;

  final dynamic data;

  LogData({
    required this.time,
    required this.level,
    required this.message,
    this.stackTrace,
    this.data,
  });

  LogData copyWith({
    DateTime? time,
    LogLevel? level,
    String? message,
    StackTrace? stackTrace,
    dynamic data,
  }) {
    return LogData(
      time: time ?? this.time,
      level: level ?? this.level,
      message: message ?? this.message,
      stackTrace: stackTrace ?? this.stackTrace,
      data: data ?? this.data,
    );
  }
}
