import 'package:async_task_queue/async_task_queue.dart';
import 'package:rf_logger/src/clients/log_client.dart';
import 'package:rf_logger/src/constants/log_level.dart';
import 'package:rf_logger/src/models/log_data.dart';

export 'src/clients/console_logger/console_logger.dart';
export 'src/clients/file_logger/file_logger.dart';
export 'src/clients/file_logger/log_file_config.dart';
export 'src/clients/log_client.dart';
export 'src/constants/log_level.dart';
export 'src/formatters/default_log_formatter.dart';
export 'src/formatters/log_formatter.dart';
export 'src/models/log_data.dart';

/// ###### A composite logger that writes logs to multiple log clients.
/// It maintains a strongly sequential logging order and you do not have to
/// implement any queuing logic in your custom clients to maintain the order.
/// Just implement [LogClient] and attach it, and you are good to go.
///
/// The library ships with two ready-made log client, [ConsoleLogger] and
/// [FileLogger]. You may also create new clients by extending [LogClient].
///
/// You can customize the log format by extending the [LogFormatter] class,
/// but the library also ships with a ready-made one - [DefaultLogFormatter].
class RfLogger with AsyncTaskQueue {
  final Map<String, LogClient> _clientMap;
  final Map<LogLevel, bool> _enabledLevelsMap;

  RfLogger({
    required List<LogClient> clients,
    List<LogLevel> logLevels = const [
      LogLevel.debug,
      LogLevel.info,
      LogLevel.warning,
      LogLevel.error,
    ],
  })  : _clientMap = _buildLoggerMap(clients),
        _enabledLevelsMap = _buildLevelMap(logLevels);

  void logDebug(String message, {dynamic data}) {
    log(LogLevel.debug, message: message, data: data);
  }

  void logInfo(String message, {dynamic data}) {
    log(LogLevel.info, message: message, data: data);
  }

  void logWarning(String message, {dynamic data}) {
    log(LogLevel.warning, message: message, data: data);
  }

  /// ###### Log error, with optional data and stacktrace
  /// Pass `errorDataLineLimit <= 0` to allow the errorData
  /// (string representation) as large as possible.
  void logError(
    String message, {
    dynamic errorData,
    StackTrace? stackTrace,
  }) {
    log(
      LogLevel.error,
      message: message,
      data: errorData,
      stackTrace: stackTrace,
    );
  }

  /// ###### Writes the log on all the currently available log clients
  /// The log may not be written if the supplied level is NOT within the
  /// current level configuration.
  /// If you want to enable or disable certain log levels, use [setRuntimeLevels].
  void log(
    LogLevel logLevel, {
    required String message,
    dynamic data,
    StackTrace? stackTrace,
  }) {
    if (_enabledLevelsMap[logLevel] == false) {
      return;
    }

    final timeStamp = DateTime.now();
    addTask(
      AsyncTask(
        task: () async {
          for (final client in _clientMap.values) {
            await client.log(
              LogData(
                time: timeStamp,
                level: logLevel,
                message: message,
                stackTrace: stackTrace,
                data: data,
              ),
            );
          }
        },
        errorCallback: (e, st) {
          print(
            '\n*** RF-LOGGER ***'
            '\nFailed to log.'
            '\n$st',
          );
        },
      ),
    );
  }

  /// ###### Adds the client to the list of clients of this instance.
  ///
  /// This operation replaces any existing client with the same client-id,
  /// even the build-in ones. See the client-id of the default clients to
  /// avoid overwriting the clients. (See [ConsoleLogger.ID] & [FileLogger.ID]).
  ///
  /// It is your responsibility to dispose any resources held by a client
  /// before replacing or removing them. Failing to do so may cause memory
  /// leaks and other consequences.
  void addLogger(LogClient client) {
    _clientMap[client.clientId] = client;
  }

  /// ###### Removes the client with the given client-id.
  /// If there are multiple clients with the same ID, all will be removed.
  /// And if no match found, none will be removed.
  ///
  /// It is your responsibility to dispose any resources held by a client
  /// before replacing or removing them.
  /// Failing to do so may cause memory leaks and other consequences.
  void removeLogger(String clientId) {
    _clientMap.removeWhere((key, value) => key == clientId);
  }

  /// ###### Get the client with the given client-id
  /// Returns null if no match was found,
  /// i.e., there are no clients with the given id.
  LogClient? getLoggerForId(String clientId) {
    return _clientMap[clientId];
  }

  /// ###### Get all the currently active clients.
  List<LogClient> getAllLoggers() {
    return _clientMap.values.toList();
  }

  /// ###### Set runtime level configuration
  /// After calling this, any previous filters will be overwritten.
  void setRuntimeLevels(List<LogLevel> newLevels) {
    _enabledLevelsMap.clear();
    for (final element in newLevels) {
      _enabledLevelsMap[element] = true;
    }
  }

  static _buildLoggerMap(List<LogClient> logClients) {
    Map<String, LogClient> clientMap = {};
    for (final current in logClients) {
      clientMap[current.clientId] = current;
    }
    return clientMap;
  }

  static _buildLevelMap(List<LogLevel> logLevels) {
    Map<LogLevel, bool> enabledLevelMap = {};
    for (final element in logLevels) {
      enabledLevelMap[element] = true;
    }
    return enabledLevelMap;
  }
}
