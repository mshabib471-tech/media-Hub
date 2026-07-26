import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

import '../../core/logging/app_logger.dart';
import '../../domain/entities/download_item.dart';
import '../../domain/repositories/download_repository.dart';
import '../models/download_item_model.dart';
import '../services/media_detection_service.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart';

class DownloadRepositoryImpl implements DownloadRepository {
  DownloadRepositoryImpl(this._dio, this._storage, this._detector, this._notifications);

  final Dio _dio;
  final StorageService _storage;
  final MediaDetectionService _detector;
  final NotificationService _notifications;
  final _controller = StreamController<List<DownloadItem>>.broadcast();
  final _items = <DownloadItemModel>[];
  final _tokens = <String, CancelToken>{};

  @override
  Stream<List<DownloadItem>> watchDownloads() => _controller.stream;

  @override
  Future<List<DownloadItem>> loadDownloads() async {
    _items
      ..clear()
      ..addAll(await _storage.loadDownloads());
    _emit();
    return List.unmodifiable(_items);
  }

  @override
  Future<MediaInfo> inspectUrl(String url) => _detector.inspect(url);

  @override
  Future<void> enqueue(MediaInfo info, String saveDirectory) async {
    final item = DownloadItemModel(id: const Uuid().v4(), url: info.url, fileName: info.fileName, saveDirectory: saveDirectory, createdAt: DateTime.now(), totalBytes: info.sizeBytes);
    _items.insert(0, item);
    await _persist();
    unawaited(_download(item.id));
  }

  Future<void> _download(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    if (index < 0) return;
    var item = _items[index];
    final file = File('${item.saveDirectory}/${item.fileName}');
    await file.parent.create(recursive: true);
    final token = CancelToken();
    _tokens[id] = token;
    final started = DateTime.now();
    _replace(item.copyWith(status: DownloadStatus.downloading, errorMessage: null));
    try {
      await _dio.download(item.url, file.path, cancelToken: token, deleteOnError: false, onReceiveProgress: (received, total) {
        final elapsed = DateTime.now().difference(started).inMilliseconds / 1000;
        final speed = elapsed <= 0 ? 0.0 : received / elapsed;
        final remaining = total > received && speed > 0 ? Duration(seconds: ((total - received) / speed).round()) : null;
        item = DownloadItemModel.fromEntity(_items[index].copyWith(receivedBytes: received, totalBytes: total > 0 ? total : item.totalBytes, speedBytesPerSecond: speed, eta: remaining));
        _replace(item);
        _notifications.showProgress(id: id.hashCode, title: item.fileName, progress: (item.progress * 100).round());
      });
      _replace(item.copyWith(status: DownloadStatus.completed, receivedBytes: item.totalBytes, speedBytesPerSecond: 0, eta: Duration.zero));
      await _notifications.showComplete(id: id.hashCode, title: item.fileName);
    } on DioException catch (error, stackTrace) {
      if (CancelToken.isCancel(error)) return;
      AppLogger.downloads.warning('Download failed for ${item.url}', error, stackTrace);
      _replace(item.copyWith(status: DownloadStatus.failed, errorMessage: error.message));
    } finally {
      _tokens.remove(id);
      await _persist();
    }
  }

  @override
  Future<void> pause(String id) async {
    _tokens[id]?.cancel('Paused by user');
    final item = _items.firstWhere((item) => item.id == id);
    _replace(item.copyWith(status: DownloadStatus.paused, speedBytesPerSecond: 0));
    await _persist();
  }

  @override
  Future<void> resume(String id) async => retry(id);

  @override
  Future<void> cancel(String id) async {
    _tokens[id]?.cancel('Canceled by user');
    final item = _items.firstWhere((item) => item.id == id);
    _replace(item.copyWith(status: DownloadStatus.canceled, speedBytesPerSecond: 0));
    await _persist();
  }

  @override
  Future<void> retry(String id) async {
    unawaited(_download(id));
  }

  @override
  Future<void> toggleFavorite(String id) async {
    final item = _items.firstWhere((item) => item.id == id);
    _replace(item.copyWith(isFavorite: !item.isFavorite));
    await _persist();
  }

  @override
  Future<void> chooseSaveDirectory(String path) => _storage.saveFolder(path);
  @override
  Future<String?> loadSaveDirectory() => _storage.loadFolder();

  void _replace(DownloadItem item) {
    final index = _items.indexWhere((candidate) => candidate.id == item.id);
    if (index >= 0) _items[index] = DownloadItemModel.fromEntity(item);
    _emit();
  }

  void _emit() => _controller.add(List.unmodifiable(_items));
  Future<void> _persist() => _storage.saveDownloads(_items);
}
