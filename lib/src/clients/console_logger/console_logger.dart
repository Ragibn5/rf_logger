import 'package:flutter/foundation.dart';
import 'package:rf_logger/src/clients/log_client.dart';
import 'package:rf_logger/src/formatters/default_log_formatter.dart';
import 'package:rf_logger/src/models/log_data.dart';

class ConsoleLogger extends LogClient {
  static const ID = "console";

  ConsoleLogger({required DefaultLogFormatter logFormatter})
      : super(clientId: ID, logFormatter: logFormatter);

  @override
  Future<bool> log(LogData logData) async {
    debugPrint(logFormatter.getFormattedLog(logData));
    return true;
  }
}
