import 'dart:io';

class PlatformConstants {
  PlatformConstants._();

  static String newLine = Platform.isWindows ? "\n\r" : "\n";
}
