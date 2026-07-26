import 'package:logging/logging.dart';

class AppLogger {
  static final Logger downloads = Logger('downloads');

  static void configure() {
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen((record) {
      // Centralized logging hook. In production this can forward to Crashlytics or Sentry.
      // ignore: avoid_print
      print('[${record.level.name}] ${record.loggerName}: ${record.message}');
    });
  }
}
