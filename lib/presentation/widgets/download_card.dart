import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/formatters.dart';
import '../../domain/entities/download_item.dart';
import '../providers/app_providers.dart';

class DownloadCard extends ConsumerWidget {
  const DownloadCard({required this.item, super.key});
  final DownloadItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(downloadsProvider.notifier);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(item.fileName, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700))),
            IconButton(onPressed: () => notifier.toggleFavorite(item.id), icon: Icon(item.isFavorite ? Icons.favorite : Icons.favorite_border)),
          ]),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: item.status == DownloadStatus.downloading ? item.progress : item.status == DownloadStatus.completed ? 1 : item.progress),
          const SizedBox(height: 10),
          Text('${item.status.name.toUpperCase()} • ${Formatters.bytes(item.receivedBytes)} / ${Formatters.bytes(item.totalBytes)} • ${Formatters.bytes(item.speedBytesPerSecond)}/s • ETA ${Formatters.duration(item.eta)}'),
          if (item.errorMessage != null) Text(item.errorMessage!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
          Wrap(spacing: 8, children: [
            if (item.status == DownloadStatus.downloading) FilledButton.tonalIcon(onPressed: () => notifier.pause(item.id), icon: const Icon(Icons.pause), label: const Text('Pause')),
            if (item.status == DownloadStatus.paused) FilledButton.tonalIcon(onPressed: () => notifier.resume(item.id), icon: const Icon(Icons.play_arrow), label: const Text('Resume')),
            if (item.status == DownloadStatus.failed || item.status == DownloadStatus.canceled) FilledButton.tonalIcon(onPressed: () => notifier.retry(item.id), icon: const Icon(Icons.refresh), label: const Text('Retry')),
            if (item.status != DownloadStatus.completed && item.status != DownloadStatus.canceled) TextButton.icon(onPressed: () => notifier.cancel(item.id), icon: const Icon(Icons.close), label: const Text('Cancel')),
          ]),
        ]),
      ),
    );
  }
}
