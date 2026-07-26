import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/repositories/download_repository_impl.dart';
import '../../data/services/background_download_service.dart';
import '../../data/services/media_detection_service.dart';
import '../../data/services/notification_service.dart';
import '../../data/services/storage_service.dart';
import '../../domain/entities/download_item.dart';
import '../../domain/repositories/download_repository.dart';

final dioProvider = Provider((ref) => Dio(BaseOptions(connectTimeout: const Duration(seconds: 15), receiveTimeout: const Duration(minutes: 10))));
final storageProvider = Provider((ref) => StorageService());
final notificationProvider = Provider((ref) => NotificationService());
final backgroundDownloadProvider = Provider((ref) => BackgroundDownloadService());
final detectorProvider = Provider((ref) => MediaDetectionService(ref.watch(dioProvider)));
final repositoryProvider = Provider<DownloadRepository>((ref) => DownloadRepositoryImpl(ref.watch(dioProvider), ref.watch(storageProvider), ref.watch(detectorProvider), ref.watch(notificationProvider)));

final downloadsProvider = StateNotifierProvider<DownloadsNotifier, AsyncValue<List<DownloadItem>>>((ref) => DownloadsNotifier(ref.watch(repositoryProvider))..load());
final searchProvider = StateProvider<String>((ref) => '');
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

class DownloadsNotifier extends StateNotifier<AsyncValue<List<DownloadItem>>> {
  DownloadsNotifier(this._repository) : super(const AsyncValue.loading()) {
    _repository.watchDownloads().listen((items) => state = AsyncValue.data(items));
  }
  final DownloadRepository _repository;

  Future<void> load() async => state = AsyncValue.data(await _repository.loadDownloads());
  Future<MediaInfo> inspect(String url) => _repository.inspectUrl(url);
  Future<String> defaultDirectory() async => await _repository.loadSaveDirectory() ?? (await getApplicationDocumentsDirectory()).path;
  Future<void> chooseDirectory() async {
    final path = await FilePicker.platform.getDirectoryPath();
    if (path != null) await _repository.chooseSaveDirectory(path);
  }
  Future<void> enqueue(MediaInfo info, String directory) => _repository.enqueue(info, directory);
  Future<void> pause(String id) => _repository.pause(id);
  Future<void> resume(String id) => _repository.resume(id);
  Future<void> cancel(String id) => _repository.cancel(id);
  Future<void> retry(String id) => _repository.retry(id);
  Future<void> toggleFavorite(String id) => _repository.toggleFavorite(id);
}
