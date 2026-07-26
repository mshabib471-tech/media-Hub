import 'package:dio/dio.dart';

import '../../domain/entities/download_item.dart';

class MediaDetectionService {
  MediaDetectionService(this._dio);
  final Dio _dio;

  Future<MediaInfo> inspect(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme || !(uri.scheme == 'http' || uri.scheme == 'https')) {
      throw ArgumentError('Enter a valid http or https URL.');
    }

    final response = await _dio.headUri(uri, options: Options(followRedirects: true, validateStatus: (code) => code != null && code < 500));
    if ((response.statusCode ?? 500) >= 400) {
      throw StateError('The server rejected this URL with status ${response.statusCode}.');
    }
    final type = response.headers.value('content-type') ?? 'application/octet-stream';
    final length = int.tryParse(response.headers.value('content-length') ?? '') ?? 0;
    final segmentName = uri.pathSegments.where((segment) => segment.trim().isNotEmpty).lastOrNull;
    final fileName = segmentName == null ? 'download-${DateTime.now().millisecondsSinceEpoch}' : Uri.decodeComponent(segmentName);
    return MediaInfo(url: url, fileName: fileName, contentType: type, sizeBytes: length);
  }
}
