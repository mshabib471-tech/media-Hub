import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'core/logging/app_logger.dart';
import 'core/theme/app_theme.dart';
import 'presentation/providers/app_providers.dart';
import 'presentation/screens/downloads_screen.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/settings_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLogger.configure();
  runApp(const ProviderScope(child: MediaHubApp()));
}

class MediaHubApp extends ConsumerWidget {
  const MediaHubApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp(
    title: 'MediaHub Downloader',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light(),
    darkTheme: AppTheme.dark(),
    themeMode: ref.watch(themeModeProvider),
    localizationsDelegates: const [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate, GlobalWidgetsLocalizations.delegate],
    supportedLocales: const [Locale('en'), Locale('es')],
    home: const ShellScreen(),
  );
}

class ShellScreen extends ConsumerStatefulWidget {
  const ShellScreen({super.key});
  @override
  ConsumerState<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends ConsumerState<ShellScreen> {
  var _index = 0;
  final _screens = const [HomeScreen(), DownloadsScreen(), DownloadsScreen(completedOnly: true), DownloadsScreen(favoritesOnly: true), SettingsScreen()];

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref.read(notificationProvider).initialize();
      await ref.read(backgroundDownloadProvider).initialize();
      await ref.read(downloadsProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('MediaHub Downloader')),
    body: AnimatedSwitcher(duration: const Duration(milliseconds: 250), child: _screens[_index]),
    bottomNavigationBar: NavigationBar(selectedIndex: _index, onDestinationSelected: (value) => setState(() => _index = value), destinations: const [
      NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
      NavigationDestination(icon: Icon(Icons.downloading_outlined), selectedIcon: Icon(Icons.downloading), label: 'Downloads'),
      NavigationDestination(icon: Icon(Icons.history_outlined), selectedIcon: Icon(Icons.history), label: 'History'),
      NavigationDestination(icon: Icon(Icons.favorite_outline), selectedIcon: Icon(Icons.favorite), label: 'Favorites'),
      NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Settings'),
    ]),
  );
}
