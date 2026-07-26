import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/localization/localization_extensions.dart';
import '../providers/app_providers.dart';
import '../widgets/download_card.dart';

class DownloadsScreen extends ConsumerWidget {
  const DownloadsScreen({super.key, this.completedOnly = false, this.favoritesOnly = false});
  final bool completedOnly;
  final bool favoritesOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(searchProvider).toLowerCase();
    return Column(children: [
      Padding(padding: const EdgeInsets.all(16), child: TextField(decoration: InputDecoration(labelText: context.l10n.search, prefixIcon: const Icon(Icons.search)), onChanged: (value) => ref.read(searchProvider.notifier).state = value)),
      Expanded(child: ref.watch(downloadsProvider).when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (items) {
          final filtered = items.where((item) => item.fileName.toLowerCase().contains(query) && (!completedOnly || item.status.name == 'completed') && (!favoritesOnly || item.isFavorite)).toList();
          if (filtered.isEmpty) return Center(child: Text(context.l10n.noDownloads));
          return ListView.builder(padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), itemCount: filtered.length, itemBuilder: (_, index) => DownloadCard(item: filtered[index]));
        },
      )),
    ]);
  }
}
