import '../entities/download_item.dart';

abstract class DownloadRepository {
  Stream<List<DownloadItem>> watchDownloads();
  Future<List<DownloadItem>> loadDownloads();
  Future<MediaInfo> inspectUrl(String url);
  Future<void> enqueue(MediaInfo info, String saveDirectory);
  Future<void> pause(String id);
  Future<void> resume(String id);
  Future<void> cancel(String id);
  Future<void> retry(String id);
  Future<void> toggleFavorite(String id);
  Future<void> chooseSaveDirectory(String path);
  Future<String?> loadSaveDirectory();
}
