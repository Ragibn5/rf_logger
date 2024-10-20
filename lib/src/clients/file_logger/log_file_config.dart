import 'dart:io';

import 'package:intl/intl.dart';

class LogFilConfig {
  final Directory parentDir;
  final String fileNamePrefix;
  final String fileNameSuffix;
  final DateFormat nameDateFormat;

  LogFilConfig({
    required this.parentDir,
    required this.fileNamePrefix,
    required this.fileNameSuffix,
    required this.nameDateFormat,
  });
}
