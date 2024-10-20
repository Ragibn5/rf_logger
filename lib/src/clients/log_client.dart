import 'package:flutter/foundation.dart';
import 'package:rf_logger/rf_logger.dart';

abstract class LogClient {
  final String clientId;
  final LogFormatter _logFormatter;

  LogClient({
    required this.clientId,
    required LogFormatter logFormatter,
  }) : _logFormatter = logFormatter;

  @protected
  LogFormatter get logFormatter => _logFormatter;

  Future<bool> log(LogData logData);
}
