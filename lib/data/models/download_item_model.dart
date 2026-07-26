import '../../domain/entities/download_item.dart';

class DownloadItemModel extends DownloadItem {
  const DownloadItemModel({
    required super.id,
    required super.url,
    required super.fileName,
    required super.saveDirectory,
    required super.createdAt,
    super.status,
    super.receivedBytes,
    super.totalBytes,
    super.speedBytesPerSecond,
    super.eta,
    super.errorMessage,
    super.isFavorite,
  });

  factory DownloadItemModel.fromEntity(DownloadItem item) => DownloadItemModel(
        id: item.id,
        url: item.url,
        fileName: item.fileName,
        saveDirectory: item.saveDirectory,
        createdAt: item.createdAt,
        status: item.status,
        receivedBytes: item.receivedBytes,
        totalBytes: item.totalBytes,
        speedBytesPerSecond: item.speedBytesPerSecond,
        eta: item.eta,
        errorMessage: item.errorMessage,
        isFavorite: item.isFavorite,
      );

  factory DownloadItemModel.fromJson(Map<String, Object?> json) => DownloadItemModel(
        id: json['id']! as String,
        url: json['url']! as String,
        fileName: json['fileName']! as String,
        saveDirectory: json['saveDirectory']! as String,
        createdAt: DateTime.parse(json['createdAt']! as String),
        status: DownloadStatus.values.byName(json['status']! as String),
        receivedBytes: (json['receivedBytes'] as num?)?.toInt() ?? 0,
        totalBytes: (json['totalBytes'] as num?)?.toInt() ?? 0,
        speedBytesPerSecond: (json['speedBytesPerSecond'] as num?)?.toDouble() ?? 0,
        eta: json['etaSeconds'] == null ? null : Duration(seconds: (json['etaSeconds']! as num).toInt()),
        errorMessage: json['errorMessage'] as String?,
        isFavorite: json['isFavorite'] as bool? ?? false,
      );

  Map<String, Object?> toJson() => {
        'id': id,
        'url': url,
        'fileName': fileName,
        'saveDirectory': saveDirectory,
        'createdAt': createdAt.toIso8601String(),
        'status': status.name,
        'receivedBytes': receivedBytes,
        'totalBytes': totalBytes,
        'speedBytesPerSecond': speedBytesPerSecond,
        'etaSeconds': eta?.inSeconds,
        'errorMessage': errorMessage,
        'isFavorite': isFavorite,
      };
}
