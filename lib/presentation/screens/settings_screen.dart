import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/localization/localization_extensions.dart';
import '../providers/app_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return ListView(padding: const EdgeInsets.all(16), children: [
      Card(child: ListTile(leading: const Icon(Icons.folder), title: Text(context.l10n.chooseFolder), subtitle: const Text('Select where authorized files are saved'), onTap: () => ref.read(downloadsProvider.notifier).chooseDirectory())),
      Card(child: DropdownButtonFormField<ThemeMode>(value: themeMode, decoration: InputDecoration(labelText: context.l10n.themeMode), items: const [
        DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
        DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
        DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
      ], onChanged: (value) { if (value != null) ref.read(themeModeProvider.notifier).state = value; })),
      Card(child: ListTile(leading: const Icon(Icons.language), title: Text(context.l10n.language), subtitle: const Text('English, Español'))),
    ]);
  }
}
