enum DownloadStatus { queued, downloading, paused, completed, failed, canceled }

class DownloadItem {
  const DownloadItem({
    required this.id,
    required this.url,
    required this.fileName,
    required this.saveDirectory,
    required this.createdAt,
    this.status = DownloadStatus.queued,
    this.receivedBytes = 0,
    this.totalBytes = 0,
    this.speedBytesPerSecond = 0,
    this.eta,
    this.errorMessage,
    this.isFavorite = false,
  });

  final String id;
  final String url;
  final String fileName;
  final String saveDirectory;
  final DateTime createdAt;
  final DownloadStatus status;
  final int receivedBytes;
  final int totalBytes;
  final double speedBytesPerSecond;
  final Duration? eta;
  final String? errorMessage;
  final bool isFavorite;

  double get progress => totalBytes <= 0 ? 0 : (receivedBytes / totalBytes).clamp(0, 1);
  bool get isActive => status == DownloadStatus.downloading || status == DownloadStatus.queued;

  DownloadItem copyWith({
    String? id,
    String? url,
    String? fileName,
    String? saveDirectory,
    DateTime? createdAt,
    DownloadStatus? status,
    int? receivedBytes,
    int? totalBytes,
    double? speedBytesPerSecond,
    Duration? eta,
    String? errorMessage,
    bool? isFavorite,
  }) => DownloadItem(
        id: id ?? this.id,
        url: url ?? this.url,
        fileName: fileName ?? this.fileName,
        saveDirectory: saveDirectory ?? this.saveDirectory,
        createdAt: createdAt ?? this.createdAt,
        status: status ?? this.status,
        receivedBytes: receivedBytes ?? this.receivedBytes,
        totalBytes: totalBytes ?? this.totalBytes,
        speedBytesPerSecond: speedBytesPerSecond ?? this.speedBytesPerSecond,
        eta: eta ?? this.eta,
        errorMessage: errorMessage,
        isFavorite: isFavorite ?? this.isFavorite,
      );
}

class MediaInfo {
  const MediaInfo({required this.url, required this.fileName, required this.contentType, required this.sizeBytes});

  final String url;
  final String fileName;
  final String contentType;
  final int sizeBytes;
}
