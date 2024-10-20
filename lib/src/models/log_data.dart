import 'package:rf_logger/src/constants/log_level.dart';

class LogData {
  final DateTime time;
  final LogLevel level;
  final String message;
  final dynamic data;

  LogData({
    required this.time,
    required this.level,
    required this.message,
    this.data,
  });
}
