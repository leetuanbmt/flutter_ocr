import 'dart:developer' as developer;

class Logger {
  static void log(Object? message, {String tag = 'OcrApp'}) {
    developer.log(
      message.toString(),
      name: tag,
    );
  }
}
