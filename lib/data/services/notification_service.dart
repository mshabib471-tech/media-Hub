import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _plugin.initialize(settings);
  }

  Future<void> showProgress({required int id, required String title, required int progress}) async {
    final android = AndroidNotificationDetails(
      'downloads',
      'Downloads',
      channelDescription: 'Download progress notifications',
      importance: Importance.low,
      priority: Priority.low,
      showProgress: true,
      maxProgress: 100,
      progress: progress.clamp(0, 100),
      onlyAlertOnce: true,
    );
    await _plugin.show(id, title, '$progress% complete', NotificationDetails(android: android));
  }

  Future<void> showComplete({required int id, required String title}) async {
    const android = AndroidNotificationDetails('downloads', 'Downloads', importance: Importance.defaultImportance);
    await _plugin.show(id, title, 'Download complete', const NotificationDetails(android: android));
  }
}
