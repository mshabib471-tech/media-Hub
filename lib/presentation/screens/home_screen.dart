import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/localization_extensions.dart';
import '../../core/utils/formatters.dart';
import '../../domain/entities/download_item.dart';
import '../providers/app_providers.dart';
import '../widgets/gradient_header.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _controller = TextEditingController();
  MediaInfo? _info;
  String? _message;
  bool _busy = false;

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  Future<void> _detect() async {
    setState(() { _busy = true; _message = null; });
    try { _info = await ref.read(downloadsProvider.notifier).inspect(_controller.text.trim()); }
    catch (error) { _message = error.toString(); _info = null; }
    finally { if (mounted) setState(() => _busy = false); }
  }

  Future<void> _download() async {
    final info = _info;
    if (info == null) return;
    final directory = await ref.read(downloadsProvider.notifier).defaultDirectory();
    await ref.read(downloadsProvider.notifier).enqueue(info, directory);
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${info.fileName} queued')));
  }

  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(16), children: [
    GradientHeader(title: context.l10n.appTitle, subtitle: context.l10n.authorizedOnly),
    const SizedBox(height: 20),
    TextField(controller: _controller, decoration: InputDecoration(labelText: context.l10n.pasteUrl, prefixIcon: const Icon(Icons.link)), keyboardType: TextInputType.url, onSubmitted: (_) => _detect()),
    const SizedBox(height: 12),
    FilledButton.icon(onPressed: _busy ? null : _detect, icon: _busy ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.manage_search), label: Text(context.l10n.detectMedia)),
    if (_message != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(_message!, style: TextStyle(color: Theme.of(context).colorScheme.error))),
    if (_info != null) Card(margin: const EdgeInsets.only(top: 18), child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(_info!.fileName, style: Theme.of(context).textTheme.titleLarge),
      Text('${_info!.contentType} • ${Formatters.bytes(_info!.sizeBytes)}'),
      const SizedBox(height: 12),
      FilledButton.icon(onPressed: _download, icon: const Icon(Icons.download), label: Text(context.l10n.startDownload)),
    ]))),
  ]);
}
