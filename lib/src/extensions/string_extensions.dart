import 'package:rf_logger/src/constants/platform_constants.dart';

extension NullableStringExtension on String? {
  bool get isNullOrEmptyOrBlank => this == null || this!.isEmptyOrBlank;

  String? get nullOnEmptyOrBlank {
    return isNullOrEmptyOrBlank ? null : this!;
  }
}

extension NonNullStringExtension on String {
  bool get isEmptyOrBlank => trim().isEmpty;

  bool get isMultiline => contains(PlatformConstants.newLine);

  bool containsIgnoreCase(String another) =>
      toUpperCase().contains(another.toUpperCase());

  int compareToIgnoreCase(String another) =>
      toUpperCase().compareTo(another.toUpperCase());

  String getFirstLine() {
    return getFirstNLine(lineCount: 1);
  }

  String getFirstNLine({int lineCount = 2 << 10}) {
    final splits = split(PlatformConstants.newLine);
    final takenLines = splits.take(lineCount);
    return takenLines.isNotEmpty
        ? takenLines.join(PlatformConstants.newLine)
        : this;
  }

  String get capFirstChar {
    return replaceRange(0, 1, this[0].toUpperCase());
  }

  String get capAllWordFirstChar {
    final splits = split(RegExp(r'\s+'));

    final buffer = StringBuffer();
    for (var i = 0; i < splits.length; ++i) {
      if (!splits[i].isEmptyOrBlank) {
        buffer.write(splits[i].capFirstChar);
      }
      if (i < (splits.length - 1)) {
        buffer.write(' ');
      }
    }

    return buffer.toString();
  }
}
