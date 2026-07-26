import 'package:workmanager/workmanager.dart';

class BackgroundDownloadService {
  static const progressTask = 'mediahub.background.download.progress';

  Future<void> initialize() async {
    await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  }

  Future<void> registerProgressSync() async {
    await Workmanager().registerOneOffTask(progressTask, progressTask, existingWorkPolicy: ExistingWorkPolicy.keep);
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async => true);
}
